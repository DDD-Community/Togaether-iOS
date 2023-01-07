//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/31.
//

import UIKit

public extension UITextField {
    func addLeftPadding(inset: CGFloat) {
        let frame = CGRect(x: .zero, y: .zero, width: inset, height: self.frame.height)
        let paddingView = UIView(frame: frame)
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addRightPadding(inset: CGFloat) {
        let frame = CGRect(x: .zero, y: .zero, width: inset, height: self.frame.height)
        let paddingView = UIView(frame: frame)
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
}
