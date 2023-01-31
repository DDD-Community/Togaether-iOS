//
//  UserProfileHeaderView.swift
//  
//
//  Created by denny on 2023/01/31.
//

import Foundation
import SwiftLayout
import TogetherUI
import UIKit

final class UserProfileHeaderView: UIView, Layoutable {
    var activation: Activation?

    var isFollowing: Bool = false {
        didSet {
            updateFollowButton()
        }
    }

    var didTapFollowButton: ((Bool) -> Void)?

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

    private lazy var followButton: TogetherRegularButton = {
        let button: TogetherRegularButton = .init(
            title: "맞팔하기",
            titleColor: .blueGray900,
            backgroundColor: .blueGray150,
            disabledBackgroundColor: .blueGray150,
            borderColor: .blueGray150,
            borderWidth: 0,
            height: 40,
            cornerRadius: 8
        )

        button.addTarget(self, action: #selector(onClickFollowButton), for: .touchUpInside)
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
            followButton.anchors {
                Anchors.top.equalTo(descriptionLabel, attribute: .bottom, constant: 30)
                Anchors.leading.trailing.equalToSuper(inwardOffset: 24)
            }
            stackView.anchors {
                Anchors.top.equalTo(followButton, attribute: .bottom, constant: 14)
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

    init(isFollowing: Bool = false) {
        super.init(frame: .zero)
        self.isFollowing = isFollowing
        sl.updateLayout()
        updateFollowButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateFollowButton() {
        followButton.setTitle(isFollowing ? "핫팔중" : "핫팔하기", for: .normal)
        followButton.setBackgroundImage(.init(color: isFollowing ? .primary100 : .primary500), for: .normal)
        followButton.setImage(UIImage(named: isFollowing ? "ic_follow_on" : "ic_follow_off"), for: .normal)
        followButton.setTitleColor(isFollowing ? UIColor.primary500 : UIColor.blueGray0, for: .normal)
    }

    @objc
    private func onClickFollowButton(_ sender: Any?) {
        isFollowing = !isFollowing
        didTapFollowButton?(isFollowing)
    }
}
