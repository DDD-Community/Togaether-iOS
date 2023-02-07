//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/26.
//

import Foundation

public protocol DataRepresentable {
    func toData() -> Data?
    static func fromData<ReturnType>(_ data: Data) -> ReturnType?
}
