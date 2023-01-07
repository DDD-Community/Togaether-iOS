//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/07.
//

import UIKit

public class TogetherNavigation: UINavigationController {
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configure()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        // TODO: 이코드 동작 안함 ㅋ 나중에 수정
        let backImage = UIImage(named: "ic_navigationbar_back")

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)

        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}
