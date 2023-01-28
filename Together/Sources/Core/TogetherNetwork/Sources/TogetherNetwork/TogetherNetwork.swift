
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
}
