//
//  TogetherImageButton.swift
//  
//
//  Created by denny on 2023/01/18.
//

import Foundation
import SwiftLayout
import UIKit

public class TogetherImageButton: UIButton, Layoutable {
    public var activation: Activation?

    private let newBadgeView: UIView = UIView().config { view in
        view.backgroundColor = .error
        view.layer.cornerRadius = 1.75
    }

    @LayoutBuilder public var layout: some SwiftLayout.Layout {
        self.anchors {
            Anchors.size(width: 32, height: 32)
        }.sublayout {
            newBadgeView.anchors {
                Anchors.size(width: 3.5, height: 3.5)
                Anchors.top.equalToSuper(inwardOffset: 2)
                Anchors.trailing.equalToSuper(inwardOffset: 3)
            }
        }
    }

    public init(image: UIImage?) {
        super.init(frame: .zero)
        setImage(image, for: .normal)
        sl.updateLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setNewBadge(isHidden: Bool) {
        newBadgeView.isHidden = isHidden
    }
}
