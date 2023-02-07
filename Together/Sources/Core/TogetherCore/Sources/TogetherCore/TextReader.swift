//
//  File.swift
//  
//
//  Created by denny on 2023/02/07.
//

import Foundation

public class TextReader {
    public let termsOfService: String = ""

    public static func loadContentIntoString(name: String) -> String {
        do {
            guard let fileUrl = Bundle.main.url(forResource: name, withExtension: "txt") else { return "" }
            let text = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8)
            return text
        } catch {
            print(error.localizedDescription)
        }
        return ""
    }

    public static func getCurrentVersionInfo() -> String? {
        guard let dictionary = Bundle.main.infoDictionary,
           let version = dictionary["CFBundleShortVersionString"] as? String,
           let build = dictionary["CFBundleVersion"] as? String else {
            return nil
        }

        let versionAndBuild: String = "vserion: \(version), build: \(build)"
        print("Version : \(versionAndBuild)")
        return version
    }
}
