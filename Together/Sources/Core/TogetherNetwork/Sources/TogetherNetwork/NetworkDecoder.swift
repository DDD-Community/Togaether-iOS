//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/26.
//

import Foundation

public class NetworkDecoder: JSONDecoder {
    override public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        if T.self == Data.self {
            return data as! T
        } else if T.self == String.self {
            return (String(bytes: data, encoding: .utf8) ?? "") as! T
        }
        
        return try super.decode(T.self, from: data)
    }
}
