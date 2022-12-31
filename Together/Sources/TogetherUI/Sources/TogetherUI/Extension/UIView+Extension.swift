//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/31.
//

import UIKit

public extension UIView {
    
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    var shadowColor: UIColor? {
        get {
            guard let cgColor = layer.shadowColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    var allowDarkMode: Bool {
        get { return self.overrideUserInterfaceStyle != .light }
        set { self.overrideUserInterfaceStyle = newValue ? .unspecified : .light }
    }
}
