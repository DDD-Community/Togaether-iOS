
import Foundation

public struct NetworkSession {
    
    private let session: URLSession
    private var interceptors: [NetworkInterceptor]
    
    public init(
        session: URLSession,
        interceptors: [NetworkInterceptor]
    ) {
        self.session = session
        self.interceptors = interceptors
    }
    
    public func request(
        convertible: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        encoding: ParameterEncodable,
        headers: Headers? = nil,
        interceptor: NetworkInterceptor? = nil
    ) -> DataRequest {
        let convertible = DataRequestConvertor(
            url: convertible,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
        
        var interceptors = self.interceptors
        
        if let interceptor = interceptor {
            interceptors.append(interceptor)
        }
        
        return DataRequest(
            using: session,
            convertible: convertible,
            interceptors: interceptors.reversed()
        )
    }
    
    public func upload(
        convertible: URLConvertible,
        values: [MultiPartValue],
        parameters: Parameters? = nil,
        headers: Headers? = nil,
        interceptor: NetworkInterceptor? = nil
    ) -> UploadRequest {
        let convertible = UploadRequestConvertor(
            url: convertible, 
            values: values, 
            parameters: parameters, 
            headers: headers
        )
        
        var interceptors = self.interceptors
        if let interceptor { interceptors.append(interceptor) }
        
        let uploadData = convertible.build()
        return UploadRequest(
            using: session, 
            convertible: convertible, 
            data: uploadData, 
            interceptors: interceptors
        )
    }
}

public struct UploadRequestConvertor: URLRequestConvertible {
    let url: URLConvertible
    let values:  [MultiPartValue]
    let parameters: Parameters?
    let headers: Headers?
    let boundary = "Boundary-\(UUID().uuidString)"
    
    public func asURLRequest() throws -> URLRequest {
        var request = try URLRequest(url: url.asURL())
        request.allHTTPHeaderFields = headers?.dictionary
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    internal func build() -> Data? {
        var body = Data()
        let prefixBoundary = "\r\n--\(boundary)\r\n".data(using: .utf8)
        let suffixBoundary = "\r\n--\(boundary)--\r\n".data(using: .utf8)
        
        if let parameters = parameters {
            body.append(prefixBoundary)
            parameters.forEach {
                let paramsContentDisposition = "Content-Disposition: form-data; name=\"\($0.key)\"\r\n\r\n"
                let valueDataBody = "\($0.value)\r\n"
                
                body.append(prefixBoundary)
                body.append(paramsContentDisposition, encoding: .utf8)
                body.append(valueDataBody, encoding: .utf8)
            }
        }
        values.forEach { value in
            let contentDisposition = "Content-Disposition: form-data; name=\"\(value.name)\"; filename=\"\(value.fileName)\"\r\n"
            let contentType = "Content-Type: \(value.mime)\r\n\r\n"
            
            body.append(prefixBoundary)
            body.append(contentDisposition, encoding: .utf8)
            body.append(contentType, encoding: .utf8)
            body.append(value.data)
        }
        body.append(suffixBoundary)
        return body
    }
}

public struct MultiPartValue {
    var name: String
    var fileName: String
    var mime: String
    var data: Data?
}

fileprivate extension Data {
    mutating func append(_ string: String, encoding: String.Encoding) {
        if let data = string.data(using: encoding, allowLossyConversion: false) {
            self.append(data)
        }
    }
    
    mutating func append(_ data: Data?) {
        if let data { self.append(data) }
    }
}

//$ curl 'http://localhost:8080/pet/with-image' -i -X POST \
//    -H 'Content-Type: multipart/form-data' \
//    -H 'Authorization: Bearer {{token}}' \
//    -F 'main_image=@Retriever.png;type=image/png' \
//    -F 'pet_upload=@{"name":"동력이","species":"GOLDEN_RETRIEVER","pet_character":"ENERGETIC","gender":"MALE","birth":"2020-01-20","description":"꼬리로 하늘을 날수 있음.","etc":""};type=application/json'
