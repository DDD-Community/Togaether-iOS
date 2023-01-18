//
//  SettingTableViewCell.swift
//  
//
//  Created by denny on 2023/01/18.
//

import Foundation
import TogetherUI
import SwiftLayout
import UIKit

final class SettingTableViewCell: UITableViewCell, Layoutable {
    var activation: Activation?
    
    static var identifier: String {
        return String(describing: self)
    }

    static let cellHeight: CGFloat = 52

    var settingItem: Setting.SettingItem? {
        didSet {
            titleLabel.text = settingItem?.rawValue
        }
    }

    var subText: String? {
        didSet {
            subTitleLabel.text = subText
        }
    }

    @LayoutBuilder var layout: some SwiftLayout.Layout {
        contentView.sublayout {
            titleLabel.anchors {
                Anchors.leading.equalToSuper(inwardOffset: 24)
                Anchors.centerY.equalToSuper()
            }
            arrowImageView.anchors {
                Anchors.trailing.equalToSuper(inwardOffset: 24)
                Anchors.centerY.equalToSuper()
                Anchors.size(width: 16, height: 16)
            }
            subTitleLabel.anchors {
                Anchors.trailing.equalTo(arrowImageView, attribute: .leading, inwardOffset: 14)
                Anchors.centerY.equalToSuper()
            }
            bottomSeparator.anchors {
                Anchors.bottom.equalToSuper()
                Anchors.leading.trailing.equalToSuper(inwardOffset: 24)
            }
        }
    }

    private let titleLabel: UILabel = UILabel().config { label in
        label.font = .body2
        label.textColor = .blueGray900
        label.numberOfLines = 1
    }

    private let subTitleLabel: UILabel = UILabel().config { label in
        label.font = .body1
        label.textColor = .primary500
        label.numberOfLines = 1
    }

    private let arrowImageView: UIImageView = UIImageView().config { imageView in
        imageView.image = UIImage(named: "ic_arrow_right")
    }

    private let bottomSeparator: UIView = UIView().config { view in
        view.backgroundColor = .blueGray900.withAlphaComponent(0.1)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        sl.updateLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
