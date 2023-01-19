//
//  MyPageViewController.swift
//  
//
//  Created by denny on 2023/01/19.
//

import Combine
import ComposableArchitecture
import SwiftLayout
import TogetherCore
import TogetherUI
import ThirdParty
import UIKit

final class MyPageViewController: UIViewController, Layoutable {
    var activation: Activation?

    private let store: StoreOf<MyPage>
    private let viewStore: ViewStoreOf<MyPage>

    private var cancellables: Set<AnyCancellable> = .init()

    private var createBarButton: UIBarButtonItem {
        UIBarButtonItem(image: UIImage(named: "ic_appbar_write"), style: .plain, target: self, action: #selector(onClickCreate))
    }

    private var settingBarButton: UIBarButtonItem {
        UIBarButtonItem(image: UIImage(named: "ic_appbar_settings"), style: .plain, target: self, action: #selector(onClickSetting))
    }

    @LayoutBuilder var layout: some Layout {
        view.config { view in
            view.backgroundColor = .backgroundWhite
        }.sublayout {
            UIView().anchors {
                Anchors.allSides()
            }
        }
    }

    init(store: StoreOf<MyPage>) {
        self.store = store
        self.viewStore = ViewStore(store)

        super.init(nibName: nil, bundle: nil)
        self.bindNavigation()
        sl.updateLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navBar = navigationController?.navigationBar as? TogetherNavigationBar {
            navBar.setBackgroundImage(UIImage(color: .blueGray0), for: .default)
        }

        navigationItem.setRightBarButtonItems7([settingBarButton, createBarButton])
        navigationItem.title = "MY"
    }

    private func bindNavigation() {
        store
            .scope(state: \.myPageSetting, action: MyPage.Action.myPageSetting)
            .ifLet { [weak self] setting in
                guard let self = self else { return }
                self.navigationController?.pushViewController(
                    SettingViewController(store: self.store, settingStore: setting),
                    animated: true
                )
            }
            .store(in: &cancellables)
    }

    @objc
    private func onClickCreate(_ sender: UIBarButtonItem) {
        print("Create")
    }

    @objc
    private func onClickSetting(_ sender: UIBarButtonItem) {
        viewStore.send(.didTapSetting)
    }
}
