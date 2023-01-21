//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/07.
//

import UIKit

public class TogetherNavigation: UINavigationController {
    public override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: TogetherNavigationBar.self, toolbarClass: nil)
        self.viewControllers = [rootViewController]
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
