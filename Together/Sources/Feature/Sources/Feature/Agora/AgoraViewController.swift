//
//  AgoraViewController.swift
//  
//
//  Created by denny on 2023/01/18.
//

import ComposableArchitecture
import SwiftLayout
import TogetherCore
import TogetherUI
import ThirdParty
import UIKit

final class AgoraViewController: UIViewController, Layoutable {
    var activation: Activation?

    private let store: StoreOf<Agora>
    private let viewStore: ViewStoreOf<Agora>

    private let titleLabel: UILabel = UILabel().config { label in
        label.numberOfLines = 2
        label.font = .display1
        label.text = "내가 팔로잉하고 있는\n강아지들을 모아보세요"
        label.textColor = .blueGray900
    }

    @LayoutBuilder var layout: some Layout {
        view.config { view in
            view.backgroundColor = .backgroundWhite
        }.sublayout {
            UIView().anchors {
                Anchors.allSides()
            }

            titleLabel.anchors {
                Anchors.top.equalTo(view.safeAreaLayoutGuide.topAnchor, inwardOffset: 26)
                Anchors.leading.equalToSuper(inwardOffset: 25)
            }
        }
    }

    init(store: StoreOf<Agora>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
        sl.updateLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

