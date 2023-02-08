//
//  TodayCategoryView.swift
//  
//
//  Created by denny on 2023/02/08.
//

import SwiftLayout
import TogetherFoundation
import TogetherUI
import UIKit

class TodayCategoryView: UIView, Layoutable {
    var activation: Activation?

    private let contentView: UIView = UIView()

    private let titleLabel: UILabel = UILabel().config { label in
        label.font = .subhead1
        label.textColor = .blueGray400
    }

    public var text: String? {
        didSet {
            titleLabel.text = text
        }
    }

    @LayoutBuilder var layout: some SwiftLayout.Layout {
        self.config { view in
            view.backgroundColor = .blueGray150
            view.layer.cornerRadius = 12
            view.layer.borderWidth = 2
            view.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
            view.clipsToBounds = true
        }.anchors {
            Anchors.height.equalTo(constant: 26)
        }.sublayout {
            titleLabel.anchors {
                Anchors.centerX.equalToSuper()
                Anchors.centerY.equalToSuper()
                Anchors.leading.trailing.equalToSuper(inwardOffset: 8)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        sl.updateLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class TodayGenderView: UIView, Layoutable {
    var activation: Activation?

    private let contentView: UIView = UIView()

    private let titleLabel: UILabel = UILabel().config { label in
        label.font = .subhead1
        label.textColor = .blueGray400
    }

    public var text: String? {
        didSet {
            titleLabel.text = text
        }
    }

    @LayoutBuilder var layout: some SwiftLayout.Layout {
        self.config { view in
            view.backgroundColor = .blueGray150
            view.layer.cornerRadius = 12
            view.layer.borderWidth = 2
            view.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
            view.clipsToBounds = true
        }.anchors {
            Anchors.height.equalTo(constant: 26)
        }.sublayout {
            titleLabel.anchors {
                Anchors.centerX.equalToSuper()
                Anchors.centerY.equalToSuper()
                Anchors.leading.trailing.equalToSuper(inwardOffset: 8)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        sl.updateLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
