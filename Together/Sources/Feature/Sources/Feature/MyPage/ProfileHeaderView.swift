//
//  ProfileHeaderView.swift
//  
//
//  Created by denny on 2023/01/21.
//

import Foundation
import SwiftLayout
import TogetherUI
import UIKit

final class CountView: UIView, Layoutable {
    var activation: Activation?

    private let countLabel: UILabel = UILabel().config { label in
        label.numberOfLines = 1
        label.font = .subhead3
        label.textColor = .blueGray900
        label.textAlignment = .center
    }

    private let titleLabel: UILabel = UILabel().config { label in
        label.numberOfLines = 1
        label.font = .body1
        label.textColor = .blueGray900
        label.textAlignment = .center
    }

    private let stackView: UIStackView = .init().config { stackView in
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
    }

    public var countValue: Int = 0 {
        didSet {
            countLabel.text = "\(countValue)"
        }
    }

    @LayoutBuilder var layout: some SwiftLayout.Layout {
        self.sublayout {
            stackView.sublayout {
                countLabel
                titleLabel
            }.anchors {
                Anchors.leading.trailing.equalToSuper()
                Anchors.centerY.equalToSuper()
            }
        }
    }

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        countLabel.text = "\(countValue)"
        countLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        sl.updateLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ProfileHeaderView: UIView, Layoutable {
    var activation: Activation?

    private let titleLabel: UILabel = UILabel().config { label in
        label.numberOfLines = 2
        label.font = .display1
        label.text = "안녕하세요\n모찌두부몽3입니다"
        label.textColor = .blueGray900
    }

    private let descriptionLabel: UILabel = UILabel().config { label in
        label.numberOfLines = 1
        label.font = .body1
        label.text = "저는 말티즈, 수컷이에요"
        label.textColor = .blueGray900
    }

    private let modifyButton: TogetherRegularButton = {
        let button: TogetherRegularButton = .init(
            title: "강아지 정보 수정",
            titleColor: .blueGray900,
            backgroundColor: .blueGray150,
            disabledBackgroundColor: .blueGray150,
            borderColor: .blueGray150,
            borderWidth: 0,
            height: 40,
            cornerRadius: 8
        )
        return button
    }()

    private let stackView: UIStackView = .init().config { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
    }

    private let postCountView: CountView = .init(title: "게시물")
    private let followerCountView: CountView = .init(title: "하트팔로워")

    private let separatorContainerView: UIView = .init()
    private let separator: UIView = .init().config { view in
        view.backgroundColor = .blueGray150
    }

    public var followerCount: Int = 0 {
        didSet {
            followerCountView.countValue = followerCount
        }
    }

    public var postCount: Int = 0 {
        didSet {
            postCountView.countValue = postCount
        }
    }

    @LayoutBuilder var layout: some SwiftLayout.Layout {
        self.sublayout {
            titleLabel.anchors {
                Anchors.top.equalTo(self.safeAreaLayoutGuide.topAnchor, inwardOffset: 32)
                Anchors.leading.trailing.equalToSuper(inwardOffset: 24)
            }
            descriptionLabel.anchors {
                Anchors.top.equalTo(titleLabel, attribute: .bottom, constant: 8)
                Anchors.leading.trailing.equalToSuper(inwardOffset: 24)
            }
            modifyButton.anchors {
                Anchors.top.equalTo(descriptionLabel, attribute: .bottom, constant: 30)
                Anchors.leading.trailing.equalToSuper(inwardOffset: 24)
            }
            stackView.anchors {
                Anchors.top.equalTo(modifyButton, attribute: .bottom, constant: 14)
                Anchors.bottom.equalToSuper(inwardOffset: 14)
                Anchors.height.equalTo(constant: 66)
                Anchors.centerX.equalToSuper()
            }.sublayout {
                postCountView.anchors {
                    Anchors.top.bottom.equalToSuper()
                    Anchors.width.equalTo(constant: 150)
                }
                separatorContainerView.anchors {
                    Anchors.width.equalTo(constant: 2).priority(.init(999))
                }.sublayout {
                    separator.anchors {
                        Anchors.centerY.equalToSuper()
                        Anchors.leading.trailing.equalToSuper()
                        Anchors.height.equalTo(constant: 32)
                    }
                }
                followerCountView.anchors {
                    Anchors.top.bottom.equalToSuper()
                    Anchors.width.equalTo(constant: 150)
                }
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
