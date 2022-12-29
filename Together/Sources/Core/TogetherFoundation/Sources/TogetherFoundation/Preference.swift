//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/26.
//

import Foundation

#if DEBUG
private let groupIdentifier: String = "group.com.together.sandbox"
#else
private let groupIdentifier: String = "group.com.together"
#endif

public class UserDefaultStorage<T> {
    let uniqueKey: String
    let defaultValue: T
    
    init(uniqueKey: String, defaultValue: T) {
        self.uniqueKey = uniqueKey
        self.defaultValue = defaultValue
    }
}

@propertyWrapper
public final class ValueProperty<T>: UserDefaultStorage<T> {
    public var projectedValue: ValueProperty<T> { return self }
    
    private let group: UserDefaults = .init(suiteName: groupIdentifier) ?? .init()
    
    public var wrappedValue: T {
        get {
            group.value(forKey: uniqueKey) as? T ?? defaultValue
        }
        
        set {
            group.set(newValue, forKey: uniqueKey)
        }
    }
}

public final class Preferences {
    public static let shared: Preferences = .init()
    
    private init() { }
    
    @ValueProperty(uniqueKey: "Preferences::onboardingFinished", defaultValue: false)
    public var onboardingFinished: Bool
}
