//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/01.
//

import Foundation

import ThirdParty

import ComposableArchitecture
import XCTestDynamicOverlay

public struct Validator {
    public var validateEmail: (String) -> Bool?
    public var validatePassword: (String) -> Bool?
    public var validateBirth: (String) -> Bool?
    public var validatePhoneNumber: (String) -> Bool?
}

public extension DependencyValues {
    var validator: Validator {
        get { self[Validator.self] }
        set { self[Validator.self] = newValue }
    }
}

extension Validator: DependencyKey {
    public static let liveValue: Validator = .init(
        validateEmail: { email in
            guard !email.isEmpty else { return nil }
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }, 
        validatePassword: { password in
            guard !password.isEmpty else { return nil }
            let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}" // 8자리 ~ 50자리 영어+숫자+특수문자
            let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
            return passwordPredicate.evaluate(with: password)
        },
        validateBirth: { birth in
            guard !birth.isEmpty else { return nil }
            let birthRegex: String = "^[1-2]{1}[0-9]{3}[0-1]{1}[0-9]{1}[0-3]{1}[0-9]{1}$" // 19960103
            let birthPredicate = NSPredicate(format:"SELF MATCHES %@", birthRegex)
            return birthPredicate.evaluate(with: birth)
        },
        validatePhoneNumber: { phoneNumber in
            guard !phoneNumber.isEmpty else { return nil }
            let phoneNumberRegex: String = "^010[0-9]{4}[0-9]{4}"
            let phoneNumberPredicate = NSPredicate(format:"SELF MATCHES %@", phoneNumberRegex)
            return phoneNumberPredicate.evaluate(with: phoneNumber)
        }
    )
    
    public static let testValue: Validator = .init(
        validateEmail: unimplemented("\(Self.self).validateEmail"), 
        validatePassword: unimplemented("\(Self.self).validatePassword"),
        validateBirth: unimplemented("\(Self.self).validateBirth"),
        validatePhoneNumber: unimplemented("\(Self.self).validatePhoneNumber")
    )
}
