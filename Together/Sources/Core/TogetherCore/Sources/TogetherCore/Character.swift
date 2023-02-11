//
//  Character.swift
//  
//
//  Created by denny on 2023/02/11.
//

import Foundation

public struct CharacterRows: Decodable, Equatable, Sendable {
    public let rows: [Character]

    private enum CodingKeys: String, CodingKey {
        case rows = "rows"
    }
}

public struct Character: Decodable, Equatable, Sendable {
    public let codeName: String
    public let koreanName: String

    private enum CodingKeys: String, CodingKey {
        case codeName = "code_name"
        case koreanName = "kor_name"
    }
}

public class CharacterProvider {
    public static let shared: CharacterProvider = .init()
    private init() { }

    public func getCharacters() -> [Character]? {
        if let character = try? JSONDecoder().decode(CharacterRows.self, from: characterString.data(using: .utf8)!) {
            return character.rows
        }
        return nil
    }

    public let characterString = "{\"rows\":[{\"code_name\":\"LITTLE_TIMID\",\"kor_name\":\"조금 소심한\"},{\"code_name\":\"FRIENDLY\",\"kor_name\":\"다정 다감한\"},{\"code_name\":\"TEACHABLE\",\"kor_name\":\"잘 배우는\"},{\"code_name\":\"CURIOUS\",\"kor_name\":\"호기심 많은\"},{\"code_name\":\"CALM\",\"kor_name\":\"조용한게 좋은\"},{\"code_name\":\"SOCIABLE\",\"kor_name\":\"친화력이 좋은\"},{\"code_name\":\"SENSITIVE\",\"kor_name\":\"살짝 예민한\"},{\"code_name\":\"ENERGETIC\",\"kor_name\":\"에너자이저\"},{\"code_name\":\"LOYALTY\",\"kor_name\":\"주인 바라기\"},{\"code_name\":\"RELAXED\",\"kor_name\":\"느긋한\"},{\"code_name\":\"LIKE_ATTENTION\",\"kor_name\":\"관심 받는 것을 좋아 하는\"},{\"code_name\":\"APPETITE\",\"kor_name\":\"먹는 것을 좋아 하는\"},{\"code_name\":\"WELL_TRAINED\",\"kor_name\":\"훈련 잘되는 강아지\"}]}"


}



