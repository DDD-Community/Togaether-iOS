//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/04.
//

import Foundation
import ThirdParty
import SwiftLayout
import ComposableArchitecture

actor Network {
    static func temp() -> TogetherCredential {
        return .init(accessToken: nil, accessTokenExpiresAt: .init(), refreshToken: nil, refreshTokenExpiresAt: .init())
    }
}
