//
//  SceneDelegate.swift
//  Together
//
//  Created by 한상진 on 2022/11/26.
//

import UIKit

import TogetherCore
import ThirdParty

import ComposableArchitecture

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene, 
        willConnectTo session: UISceneSession, 
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let rootStore: StoreOf<Root> = .init(initialState: .root, reducer: Root())
        window?.rootViewController = RootViewController(store: rootStore)
        window?.makeKeyAndVisible()
    }
}
