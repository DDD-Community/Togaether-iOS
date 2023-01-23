//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/23.
//

import Foundation
import TogetherFoundation
import ComposableArchitecture

actor Storage {
    private let preferences: Preferences = .shared
    private let decoder: JSONDecoder = {
        let decoder: JSONDecoder = .init()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }()
    
    func store(credential: TogetherCredential) {
        Preferences.shared.credential = credential.toJson
    }
    
    func load() -> TogetherCredential? {
        let json = Preferences.shared.credential
        guard let data = json?.data(using: .utf8) else { return nil }
        let credential = try? decoder.decode(TogetherCredential.self, from: data)
        return credential
    }
    
    func clear() {
        Preferences.shared.credential = nil
    }
}

extension DependencyValues {
    var tokenStorage: Storage {
        get { self[Storage.self] }
        set { self[Storage.self] = newValue }
    }
}

extension Storage: DependencyKey {
    static let liveValue: Storage = .init()
    static let testValue: Storage = .init()
}
