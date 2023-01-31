//
//  UserPageCollectionViewCell.swift
//  
//
//  Created by denny on 2023/01/31.
//

import Foundation
import SwiftLayout
import TogetherUI
import UIKit

final class UserPageCollectionViewCell: UICollectionViewCell, Layoutable {
    var activation: Activation?

    private let imageView: UIImageView = .init().config { imageView in
        imageView.contentMode = .scaleAspectFit
    }

    public var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    @LayoutBuilder var layout: some SwiftLayout.Layout {
        contentView.sublayout {
            imageView.anchors {
                Anchors.allSides()
            }
        }
    }

    static var identifier: String {
        String(describing: self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        sl.updateLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
