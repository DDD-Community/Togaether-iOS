//
//  PuppyContentView.swift
//  
//
//  Created by denny on 2023/01/02.
//

import SwiftLayout
import TogetherFoundation
import TogetherUI
import UIKit

class PuppyContentView: UIView, Layoutable {
    var activation: Activation?

    var model: PuppyModel? {
        didSet {
            imageView.image = model?.image
            categoryView.text = model?.category
            genderView.text = model?.gender
            nameLabel.text = model?.name
            descriptionLabel.text = model?.description
        }
    }

    private let contentView: UIView = UIView()
    private lazy var likeButton: UIButton = UIButton().config { button in
        button.setImage(UIImage(named: "likeImage"), for: .normal)
        button.setBackgroundImage(UIImage(color: .primary500), for: .normal)
        button.addTarget(self, action: #selector(onClickLikeButton), for: .touchUpInside)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
    }

    private let imageView: UIImageView = UIImageView()
    private lazy var overlayView: GradientView = GradientView().config { gradientView in
        gradientView.topColor = .clear
        gradientView.bottomColor = .black
        gradientView.startPointX = 0.5
        gradientView.startPointY = 0
        gradientView.endPointX = 0.5
        gradientView.endPointY = 1
    }

    private let tagStackView: UIStackView = UIStackView().config { stackView in
        stackView.axis = .horizontal
        stackView.spacing = 8
    }

    private let categoryView: CategoryView = CategoryView()
    private let genderView: GenderView = GenderView()

    private let nameLabel: UILabel = UILabel().config { label in
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 1
    }

    private let descriptionLabel: UILabel = UILabel().config { label in
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 2
    }

    @LayoutBuilder var layout: some SwiftLayout.Layout {
        self.sublayout {
            contentView.anchors {
                Anchors.allSides()
            }.sublayout {
                imageView.anchors {
                    Anchors.allSides()
                }
                overlayView.anchors {
                    Anchors.allSides()
                }

                descriptionLabel.anchors {
                    Anchors.leading.equalToSuper(inwardOffset: 20)
                    Anchors.bottom.equalToSuper(inwardOffset: 30)
                }
                nameLabel.anchors {
                    Anchors.leading.trailing.equalToSuper(inwardOffset: 20)
                    Anchors.bottom.equalTo(descriptionLabel, attribute: .top, constant: -10)
                }
                tagStackView.anchors {
                    Anchors.leading.trailing.equalToSuper(inwardOffset: 20)
                    Anchors.bottom.equalTo(nameLabel, attribute: .top, constant: -10)
                }.sublayout {
                    categoryView
                    genderView
                    UIView()
                }
                likeButton.anchors {
                    Anchors.size(width: 60, height: 60)
                    Anchors.leading.equalTo(descriptionLabel, attribute: .trailing, constant: 20)
                    Anchors.trailing.equalToSuper(inwardOffset: 20)
                    Anchors.bottom.equalToSuper(inwardOffset: 26)
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

    private func setOverlayGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [CGColor(red: 0, green: 0, blue: 0, alpha: 0), CGColor(red: 0, green: 0, blue: 0, alpha: 1)]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = overlayView.bounds
        overlayView.layer.addSublayer(gradient)
    }

    @objc
    private func onClickLikeButton(_ sender: Any?) {

    }
}
