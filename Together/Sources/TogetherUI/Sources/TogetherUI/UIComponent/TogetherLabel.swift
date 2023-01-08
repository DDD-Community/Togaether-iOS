//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/08.
//

import UIKit

open class TogetherLabel: UILabel {
    public init(text: String?, font: UIFont?, textColor: UIColor) {
        super.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = textColor
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
