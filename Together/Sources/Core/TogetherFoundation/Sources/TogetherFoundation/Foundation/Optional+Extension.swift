//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/13.
//

import Foundation

public extension Optional {
    var isNotNil: Bool {
        return self != nil
    }
}

public extension Optional where Wrapped == Bool {
    var isTrue: Bool {
        switch self {
        case .some(let wrapped): return wrapped
        case .none: return false
        }
    }
}

public extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        guard let collection = self else { return true }
        return collection.isEmpty
    }
}
