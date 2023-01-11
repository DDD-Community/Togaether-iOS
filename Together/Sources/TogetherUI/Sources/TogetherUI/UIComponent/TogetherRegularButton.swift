//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/30.
//

import UIKit

open class TogetherRegularButton: UIButton {
    public init(
        title: String, 
        titleColor: UIColor = .backgroundWhite,
        backgroundColor: UIColor = .primary500,
        disabledBackgroundColor: UIColor = .blueGray300,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat? = nil,
        height: CGFloat = 52,
        cornerRadius: CGFloat = 26
    ) {
        super.init(frame: .zero)
        self.setTitle(title, for: .init())
        self.setTitleColor(titleColor, for: .init())
        self.setBackgroundImage(.init(color: disabledBackgroundColor), for: .disabled)
        self.setBackgroundImage(.init(color: backgroundColor), for: .normal)
        self.cornerRadius = cornerRadius
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: height)
        ])
        
        if let borderColor { self.borderColor = borderColor }
        if let borderWidth { self.borderWidth = borderWidth }
        
        self.layer.masksToBounds = true
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
} 
