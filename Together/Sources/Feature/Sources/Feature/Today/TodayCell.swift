//
//  TodayCell.swift
//  
//
//  Created by denny on 2023/02/08.
//

import SwiftLayout
import TogetherCore
import TogetherUI
import UIKit

final class TodayCell: UITableViewCell, Layoutable {
    var activation: Activation?

    static var identifier: String {
        return String(describing: self)
    }

    var isFollowing: Bool = false {
        didSet {
            followButton.setTitle(isFollowing ? "핫팔중" : "핫팔하기", for: .normal)
            followButton.setBackgroundImage(.init(color: isFollowing ? .primary100 : .primary500), for: .normal)
            followButton.setImage(UIImage(named: isFollowing ? "ic_follow_on" : "ic_follow_off"), for: .normal)
            followButton.setTitleColor(isFollowing ? UIColor.primary500 : UIColor.blueGray0, for: .normal)
        }
    }

    public var model: PuppyModel? {
        didSet {
            categoryView.text = model?.category
            genderView.text = model?.gender
            descriptionLabel.text = model?.description
        }
    }

    public var followerCount: Int = 0 {
        didSet {
            followerLabel.text = "핫팔 0"
        }
    }

    @LayoutBuilder var layout: some SwiftLayout.Layout {
        contentView.config { view in
            view.backgroundColor = .clear
        }.sublayout {
            containerView.config { view in
                view.backgroundColor = .white
            }.anchors {
                Anchors.top.bottom.equalToSuper(inwardOffset: 10)
                Anchors.leading.trailing.equalToSuper()
            }.sublayout {
                petImageView.anchors {
                    Anchors.top.leading.trailing.equalToSuper()
                    Anchors.height.equalTo(petImageView, attribute: .width)
                }
                rankImageView.anchors {
                    Anchors.top.equalToSuper(inwardOffset: 18)
                    Anchors.leading.equalToSuper(inwardOffset: 14)
                    Anchors.size(width: 40, height: 40)
                }
                tagStackView.anchors {
                    Anchors.leading.trailing.equalToSuper(inwardOffset: 18)
                    Anchors.top.equalTo(petImageView, attribute: .bottom, constant: 18)
                }.sublayout {
                    categoryView
                    genderView
                    UIView()
                }
                followerLabel.anchors {
                    Anchors.trailing.equalToSuper(inwardOffset: 18)
                    Anchors.centerY.equalTo(tagStackView, attribute: .centerY)
                }
                descriptionLabel.anchors {
                    Anchors.top.equalTo(tagStackView, attribute: .bottom, constant: 6)
                    Anchors.leading.trailing.equalToSuper(inwardOffset: 18)
                }
                followButton.anchors {
                    Anchors.top.equalTo(descriptionLabel, attribute: .bottom, constant: 24)
                    Anchors.leading.trailing.equalToSuper(inwardOffset: 18)
                    Anchors.bottom.equalToSuper(inwardOffset: 20)
                }
            }
        }
    }

    public var rank: Int = 0 {
        didSet {
            switch rank {
            case 0:
                rankImageView.image = UIImage(named: "img_1st")
                rankImageView.isHidden = false
                break
            case 1:
                rankImageView.image = UIImage(named: "img_2nd")
                rankImageView.isHidden = false
                break
            case 2:
                rankImageView.image = UIImage(named: "img_3rd")
                rankImageView.isHidden = false
                break
            default:
                rankImageView.isHidden = true
                break
            }
        }
    }

    private lazy var followButton: TogetherRegularButton = {
        let button: TogetherRegularButton = .init(
            title: "핫팔하기",
            titleColor: .blueGray900,
            backgroundColor: .blueGray150,
            disabledBackgroundColor: .blueGray150,
            borderColor: .blueGray150,
            borderWidth: 0,
            height: 40,
            cornerRadius: 8
        )

        button.setTitle(isFollowing ? "핫팔중" : "핫팔하기", for: .normal)
        button.setBackgroundImage(.init(color: isFollowing ? .primary100 : .primary500), for: .normal)
        button.setImage(UIImage(named: isFollowing ? "ic_follow_on" : "ic_follow_off"), for: .normal)
        button.setTitleColor(isFollowing ? UIColor.primary500 : UIColor.blueGray0, for: .normal)

        button.addTarget(self, action: #selector(onClickFollowButton), for: .touchUpInside)
        return button
    }()

    private let containerView: UIView = UIView().config { view in
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.clipsToBounds = true

        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0.5, height: 3)
        view.layer.shadowColor = UIColor.darkGray.cgColor
    }
    private let rankImageView: UIImageView = UIImageView().config { imageView in
        imageView.contentMode = .scaleAspectFit
    }

    private let petImageView: UIImageView = UIImageView().config { imageView in
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Sample1") // TODO: 수정해야함
    }

    private let tagStackView: UIStackView = UIStackView().config { stackView in
        stackView.axis = .horizontal
        stackView.spacing = 8
    }

    private let categoryView: TodayCategoryView = TodayCategoryView()
    private let genderView: TodayGenderView = TodayGenderView()

    private let followerLabel: UILabel = UILabel().config { label in
        label.font = .caption
        label.textColor = .blueGray400
        label.numberOfLines = 1
    }

    private let descriptionLabel: UILabel = UILabel().config { label in
        label.font = .headline
        label.textColor = .blueGray800
        label.numberOfLines = 1
        label.text = "열자제한열자제한열자" // TODO: 임시 값
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        sl.updateLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func onClickFollowButton(_ sender: Any?) {
        isFollowing = !isFollowing
    }
}
