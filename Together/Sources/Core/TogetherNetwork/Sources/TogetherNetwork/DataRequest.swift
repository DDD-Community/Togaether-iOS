//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/26.
//

import Foundation

public class DataRequest: Request {
    
    override internal func response() async -> NetworkResponse {
        do {
            let initialRequest = try convertible.asURLRequest()
            let urlRequest = try await adapt(initialRequest)
            
            #if DEBUG
            print("url", urlRequest.url)
            print("method", urlRequest.httpMethod)
            print("allHTTPHeaderFields", urlRequest.allHTTPHeaderFields)
            print("httpBody", urlRequest.httpBody)
            #endif
            
            let response = try await dataTask(with: urlRequest)
            return response
        } catch {
            return NetworkResponse(data: nil, response: nil, error: error)
        }
    }
    
    private func dataTask(with urlRequest: URLRequest) async throws -> NetworkResponse {
        return try await withCheckedThrowingContinuation { continuation in
            task = session.dataTask(with: urlRequest) { data, response, error in
                continuation.resume(returning: NetworkResponse(data: data, response: response, error: error))
            }
            self.task?.resume()
        }
    }
    
    @MainActor
    public func responseAsync<Success: Decodable>(decoder: JSONDecoder = NetworkDecoder()) async throws -> Success {
        let result: Result<Success, Error> = await self.perform(decoder)
        switch result {
        case .success(let success):
            return success
        case .failure(let error):
            throw error
        }
    }
    
    @MainActor
    public func responseAsync() async throws -> Void {
        let result: Result<Void, Error> = await self.perform()
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}

public class UploadRequest: Request {
    public var data: Data?
    
    public convenience init(
        using session: URLSession, 
        convertible: URLRequestConvertible,
        data: Data?,
        interceptors: [NetworkInterceptor]
    ) {
        self.init(using: session, convertible: convertible, interceptors: interceptors)
        self.data = data
    }
    
    override func response() async -> NetworkResponse {
        do {
            let initialRequest = try convertible.asURLRequest()
            let urlRequest = try await adapt(initialRequest)
            let response: NetworkResponse = try await withCheckedThrowingContinuation { continuation in
                task = session.uploadTask(with: urlRequest, from: data) { data, response, error in
                    continuation.resume(returning: NetworkResponse(data: data, response: response, error: error))
                }
                self.task?.resume()
            }
            return response
        }
        catch {
            return .init(data: nil, response: nil, error: error)
        }
    }
}

public class Request {
    
    var session: URLSession
    var convertible: URLRequestConvertible
    var options: NetworkRequestOptions = .all
    var interceptors: [NetworkInterceptor]
    var task: URLSessionTask?
    
    var retryLimit: Int = 1
    var retryCount: Int = 0
    
    public init(
        using session: URLSession,
        convertible: URLRequestConvertible,
        interceptors: [NetworkInterceptor]
    ) {
        self.session = session
        self.convertible = convertible
        self.interceptors = interceptors
    }
    
    public func options(_ options: NetworkRequestOptions) -> Self {
        self.options = options
        return self
    }
    
    @discardableResult
    public func cancel() -> Self {
        task?.cancel()
        return self
    }
    
    internal func adapt(_ urlRequest: URLRequest) async throws -> URLRequest {
        var urlRequest = urlRequest
        
        for interceptor in interceptors {
            urlRequest = try await interceptor.adapt(urlRequest: urlRequest, options: options)
        }
        
        return urlRequest
    }
    
    internal func retry(_ urlRequest: URLRequest,
                        response: URLResponse?,
                        data: Data?,
                        with error: Error) async -> (URLRequest, RetryResult){
        var urlRequest = urlRequest
        var retryResult = RetryResult.doNotRetry(with: error)
        
        for interceptor in interceptors {
            if case RetryResult.doNotRetry(let error) = retryResult {
                (urlRequest, retryResult) = await interceptor.retry(
                    urlRequest: urlRequest, 
                    response: response, 
                    data: data, 
                    with: error, 
                    options: options
                )
            } else {
                return (urlRequest, RetryResult.retry)
            }
        }
        return (urlRequest, retryResult)
    }
    
    internal func decode<SuccessType: Decodable>(_ decoder: JSONDecoder, response: NetworkResponse) throws -> SuccessType{
        if let data = response.data {
            print("receive raw data\n\(String(data: data, encoding: .utf8) ?? "")")
            if let success = try? decoder.decode(SuccessType.self, from: data) {
                return success
            } else {
                throw NetworkError.decodingFailed
            }
        } else {
            throw NetworkError.dataIsNil
        }
    }
    
    internal func decode<SuccessType: DataRepresentable>(response: NetworkResponse) throws -> SuccessType {
        if let data = response.data,
           let success: SuccessType = SuccessType.fromData(data) {
            return success
        } else {
            throw NetworkError.dataIsNil
        }
    }
    
    internal func perform<SuccessType: Decodable>(_ decoder: JSONDecoder) async -> Result<SuccessType, Error> {
        let response = await response()
        do {
            try self.validate(response: response)
            let result: SuccessType = try self.decode(decoder, response: response)
            return .success(result)
        }
        catch {
            guard self.retryCount < self.retryLimit, let initialRequest = try? self.convertible.asURLRequest() else {
                return .failure(error)
            }
            self.retryCount += 1
            let (urlRequest, retryResult) = await self.retry(initialRequest, response: response.response, data: response.data, with: error)
            
            switch retryResult {
            case .retry:
                self.convertible = urlRequest
                return await self.perform(decoder)
            case .doNotRetry(let retryError):
                return .failure(retryError)
            }
        }
    }
    
    internal func perform<SuccessType: DataRepresentable>() async -> Result<SuccessType, Error> {
        let response = await response()
        do {
            try self.validate(response: response)
            let result: SuccessType = try self.decode(response: response)
            return .success(result)
        }
        catch {
            guard self.retryCount < self.retryLimit, let initialRequest = try? self.convertible.asURLRequest() else {
                return .failure(error)
            }
            self.retryCount += 1
            let (urlRequest, retryResult) = await self.retry(initialRequest, response: response.response, data: response.data, with: error)
            
            switch retryResult {
            case .retry:
                self.convertible = urlRequest
                return await self.perform()
            case .doNotRetry(let retryError):
                return .failure(retryError)
            }
        }
    }
    
    internal func perform() async -> Result<Void, Error> {
        let response = await response()
        do {
            try self.validate(response: response)
            return .success(())
        }
        catch {
            guard self.retryCount < self.retryLimit, let initialRequest = try? self.convertible.asURLRequest() else {
                return .failure(error)
            }
            self.retryCount += 1
            let (urlRequest, retryResult) = await self.retry(initialRequest, response: response.response, data: response.data, with: error)
            
            switch retryResult {
            case .retry:
                self.convertible = urlRequest
                return await self.perform()
            case .doNotRetry(let retryError):
                return .failure(retryError)
            }
        }
    }
    
    internal func response() async -> NetworkResponse {
        return NetworkResponse(data: nil, response: nil, error: NetworkError.haveToOverride)
    }
    
    private func validate(response: NetworkResponse) throws {
        guard let httpResponse = response.response as? HTTPURLResponse else {
            guard let error = response.error,
                  NetworkError.isNetworkError(error) else {
                throw NetworkError.unhandled(rawValue: response.error)
            }
            
            throw NetworkError.network(code: (error as NSError).code)
        }
        
        guard httpResponse.isValidateStatus() else {
            throw NetworkError.invalidStatusCode(code: httpResponse.statusCode)
        }
    }
}

extension HTTPURLResponse {
    fileprivate func isValidateStatus() -> Bool {
        return (200..<300).contains(statusCode)
    }
}
