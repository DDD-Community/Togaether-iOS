//
//  File.swift
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

final class MyInfoViewController: UIViewController, Layoutable {
    var activation: Activation?

    private let store: StoreOf<Setting>
    private let viewStore: ViewStoreOf<Setting>
    private let tempViewStore: ViewStoreOf<MyInfo>

    @LayoutBuilder var layout: some Layout {
        view.config { view in
            view.backgroundColor = .backgroundWhite
        }.sublayout {
            UIView().anchors {
                Anchors.allSides()
            }
        }
    }

    init(store: StoreOf<Setting>, myInfoStore: StoreOf<MyInfo>) {
        self.store = store
        self.viewStore = ViewStore(store)
        self.tempViewStore = ViewStore(myInfoStore)
        super.init(nibName: nil, bundle: nil)
        sl.updateLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "내 정보 설정"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !isMovingToParent {
            viewStore.send(.settingMyInfo(.detachChild))
        }
    }
}
