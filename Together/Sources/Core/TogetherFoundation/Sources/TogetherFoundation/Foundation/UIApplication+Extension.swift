//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/30.
//

import UIKit

public extension UIApplication {
    var appKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter(\.isKeyWindow)
            .first
    }
}
