//
//  File.swift
//  
//
//  Created by 한상진 on 2023/02/02.
//

import Foundation

public enum Host {
    private static var prefix: String {
        #if DEBUG
        return "" // sandbox-
        #else
        return ""
        #endif
    }
    
    public static let together: String = "http://\(prefix)bnjjng.iptime.org:8080"
}
