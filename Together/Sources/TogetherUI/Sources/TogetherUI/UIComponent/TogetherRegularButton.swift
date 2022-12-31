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
        cornerRadius: CGFloat = 8
    ) {
        super.init(frame: .zero)
        self.setTitle(title, for: .init())
        self.setTitleColor(titleColor, for: .init())
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
} 
