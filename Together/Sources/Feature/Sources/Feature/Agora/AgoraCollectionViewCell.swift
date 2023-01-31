//
//  File.swift
//  
//
//  Created by denny on 2023/01/18.
//

import Foundation
import TogetherUI
import SwiftLayout
import UIKit

final class AgoraCollectionViewCell: UICollectionViewCell, Layoutable {
    var activation: Activation?

    static var identifier: String {
        return String(describing: self)
    }

    var content: String? {
        didSet {
            titleLabel.text = content
        }
    }

    var category: String? {
        didSet {
            subTitleLabel.text = category
        }
    }

    var petImage: UIImage? {
        didSet {
            petImageView.image = petImage
        }
    }

    @LayoutBuilder var layout: some SwiftLayout.Layout {
        contentView.sublayout {
            petImageView.anchors {
                Anchors.allSides()
            }

            titleContentView.anchors {
                Anchors.height.equalTo(constant: 60)
                Anchors.leading.trailing.bottom.equalToSuper()
            }.sublayout {
                subTitleLabel.anchors {
                    Anchors.top.equalToSuper(inwardOffset: 9)
                    Anchors.leading.trailing.equalToSuper(inwardOffset: 14)
                }
                titleLabel.anchors {
//                    Anchors.top.equalTo(subTitleLabel, attribute: .bottom, constant: 8)
                    Anchors.leading.trailing.equalToSuper(inwardOffset: 14)
                    Anchors.bottom.equalToSuper(inwardOffset: 11)
                }
            }
        }
    }

    private let titleContentView: UIView = UIView().config { view in
        view.backgroundColor = .backgroundWhite
    }
    private let subTitleLabel: UILabel = UILabel().config { label in
        label.font = .caption
        label.textColor = .blueGray400
        label.numberOfLines = 1
    }

    private let titleLabel: UILabel = UILabel().config { label in
        label.font = .subhead2
        label.textColor = .blueGray900
        label.numberOfLines = 1
    }

    private let petImageView: UIImageView = UIImageView().config { imageView in
        imageView.contentMode = .scaleAspectFill
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.blueGray150.cgColor
        contentView.clipsToBounds = true

        sl.updateLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
