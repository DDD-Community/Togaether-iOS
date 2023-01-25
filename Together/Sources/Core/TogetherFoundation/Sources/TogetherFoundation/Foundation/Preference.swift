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

public class UserDefaultStorage<T: Codable> {
    let uniqueKey: String
    let defaultValue: T
    
    init(uniqueKey: String, defaultValue: T) {
        self.uniqueKey = uniqueKey
        self.defaultValue = defaultValue
    }
}

@propertyWrapper
public final class ValueProperty<T>: UserDefaultStorage<T> where T: Codable {
    public var projectedValue: ValueProperty<T> { return self }
    
    private let group: UserDefaults = .init(suiteName: groupIdentifier) ?? .init()
    
    public var wrappedValue: T {
        get {
            group.value(forKey: uniqueKey) as? T ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                group.removeObject(forKey: uniqueKey)
            } else {
                group.setValue(newValue, forKey: uniqueKey)
            }
        }
    }
}

public final class Preferences {
    public static let shared: Preferences = .init()
    
    private init() { }
    
    @ValueProperty(uniqueKey: "Preferences::onboardingFinished", defaultValue: false)
    public var onboardingFinished: Bool
    
    @ValueProperty(uniqueKey: "Preferences::credential", defaultValue: nil)
    public var credential: String?
}

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}
