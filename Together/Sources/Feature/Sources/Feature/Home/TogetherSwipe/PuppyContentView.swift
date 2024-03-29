//
//  PuppyContentView.swift
//  
//
//  Created by denny on 2023/01/02.
//

import ComposableArchitecture
import Kingfisher
import SwiftLayout
import TogetherCore
import TogetherFoundation
import TogetherNetwork
import TogetherUI
import UIKit

public class PuppyContentView: UIView, Layoutable {
    @Dependency(\.togetherAccount) var togetherAccount
    
    public var activation: Activation?
    public var likeHandler: (() -> Void)?

    public var model: PuppyModel? {
        didSet {
            Task(priority: .medium) {
                try await showMainImage(url: model?.image)
            }
            categoryView.text = model?.category
            genderView.text = model?.gender
            nameLabel.text = model?.name
            descriptionLabel.text = model?.description
        }
    }

    private var statusImageView : UIImageView = UIImageView().config { imageView in
        imageView.image = UIImage(named: "bg_splash_dog")
    }

    private var overlayImageView : UIImageView = UIImageView().config { imageView in
        imageView.alpha = 0
        imageView.image = UIImage(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.7))
    }

    private func showMainImage(url: String?) async throws {
        guard let urlString = url else { return }
        let credential = try await togetherAccount.token()
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue("Bearer \(credential.xAuth)", forHTTPHeaderField: "Authorization")
            return requestBody
        }

        imageView.kf.setImage(with: URL(string: urlString), options: [.requestModifier(imageDownloadRequest)])
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
        label.font = .body2
        label.textColor = .white
        label.numberOfLines = 2
    }

    @LayoutBuilder public var layout: some SwiftLayout.Layout {
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
                overlayImageView.anchors {
                    Anchors.allSides()
                }.sublayout {
                    statusImageView.anchors {
                        Anchors.trailing.bottom.equalToSuper()
                        Anchors.size(width: 192, height: 320)
                    }
                }
            }
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        sl.updateLayout()
    }

    public required init?(coder: NSCoder) {
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
        likeHandler?()
    }

    public func updateOverlayAlpha(alpha: CGFloat) {
        overlayImageView.alpha = alpha
    }
}
