//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/23.
//

import Foundation
import ThirdParty

public struct TogetherCredential: Codable, Sendable, Equatable {
    private var accessToken: String?
    private let accessTokenExpiresAt: Date
    private var refreshToken: String?
    private let refreshTokenExpiresAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case accessTokenExpiresAt
        case refreshToken = "refresh_token"
        case refreshTokenExpiresAt
    }
    
    public init(
        accessToken: String?,
        accessTokenExpiresAt: Date,    
        refreshToken: String?,
        refreshTokenExpiresAt: Date
    ) {
        self.accessToken = accessToken
        self.accessTokenExpiresAt = accessTokenExpiresAt
        self.refreshToken = refreshToken
        self.refreshTokenExpiresAt = refreshTokenExpiresAt
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 토큰 갱신 == 무조건 1년으로 되어있음 ㅜㅜ
        accessToken = try? container.decode(String.self, forKey: .accessToken)
//        accessTokenExpiresAt = try container.decode(Date.self, forKey: .accessTokenExpiresAt)
        accessTokenExpiresAt = Date().adding(year: 1)
        
        refreshToken = try? container.decode(String.self, forKey: .refreshToken)
//        refreshTokenExpiresAt = try container.decode(Date.self, forKey: .refreshTokenExpiresAt)
        refreshTokenExpiresAt = Date().adding(year: 1)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(accessTokenExpiresAt, forKey: .accessTokenExpiresAt)
        try container.encode(refreshToken, forKey: .refreshToken)
        try container.encode(refreshTokenExpiresAt, forKey: .refreshTokenExpiresAt)
    }
}

public extension TogetherCredential {
    var xAuth: String {
        return self.accessToken ?? ""
    }
    
    var toJson: String? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        guard 
            let jsonData = try? encoder.encode(self),
            let json = String(data: jsonData, encoding: .utf8) 
        else { return nil }
        return json
    }
    
    var info: String {
        let accessTokenExpiredInfo: String = DateFormatter.localizedString(from: accessTokenExpiresAt, dateStyle: .short, timeStyle: .short)
        let refreshTokenExpiredInfo: String = DateFormatter.localizedString(from: refreshTokenExpiresAt, dateStyle: .short, timeStyle: .short)
        return """
            Access Token: \(accessToken ?? "nil")
            Refresh token: \(refreshToken ?? "nil")
            Access Token Expired: \(accessTokenExpiredInfo)
            Refresh Token Expired: \(refreshTokenExpiredInfo)
            """
    }
}

public extension TogetherCredential {
    /// Access Token이 만료된 경우
    private var isAccessTokenExpired: Bool { Date() > accessTokenExpiresAt }
    
    /// Access Token이 만료되거나 없는 경우
    var isAccessTokenInvalid: Bool { accessToken == nil || accessToken == "" || isAccessTokenExpired }
    
    /// Refresh Token이 만료된 경우
    private var isRefreshTokenExpired: Bool { Date() > refreshTokenExpiresAt }
    
    /// Refresh Token이 만료되거나 없는 경우
    var isRefreshTokenInvalid: Bool { refreshToken == nil || refreshToken == "" || isRefreshTokenExpired  }
}

private extension Date {
    func adding(
        _ calendar: Calendar = .current, 
        year: Int = 0,
        month: Int = 0,
        day: Int = 0
    ) -> Date {
        let currentYear = calendar.component(.year, from: self)
        let currentMonth = calendar.component(.month, from: self)
        let currentDay = calendar.component(.day, from: self)
        
        let components = DateComponents(
            calendar: calendar,
            year: currentYear + year,
            month: currentMonth + month,
            day: currentDay + day
        )
        
        return calendar.date(from: components)!
    }
}
