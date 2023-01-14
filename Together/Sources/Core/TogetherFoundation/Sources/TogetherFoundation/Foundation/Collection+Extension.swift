//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/13.
//

import Foundation

public extension Collection {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

