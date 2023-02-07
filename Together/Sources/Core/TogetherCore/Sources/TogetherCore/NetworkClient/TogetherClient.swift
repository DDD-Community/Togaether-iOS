//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/28.
//

import Foundation
import TogetherNetwork

public struct NetworkClient {
    private static let errorInterceptor: NetworkInterceptor = ErrorInterceptor()
    private static let headerInterceptor: NetworkInterceptor = HeaderInterceptor()
    private static let tokenInterceptor: NetworkInterceptor = TokenInterceptor()
    
    public static let together: NetworkSession = .init(
        session: .shared, 
        interceptors: [
            headerInterceptor,
            errorInterceptor,
            tokenInterceptor
        ]
    )
    
    public static let account: NetworkSession = .init(
        session: .shared,
        interceptors: [
            errorInterceptor,
            headerInterceptor
        ]
    )

    public static let pet: NetworkSession = .init(
        session: .shared,
        interceptors: [
            errorInterceptor,
            headerInterceptor
        ]
    )
    
    init() { }
}
