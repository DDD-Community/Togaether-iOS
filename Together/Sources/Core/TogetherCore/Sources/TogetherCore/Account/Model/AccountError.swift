//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/23.
//

import Foundation

public enum AccountError: Error, Sendable {
    case invalidToken
    case emptyCredential
    case unhandled
}
