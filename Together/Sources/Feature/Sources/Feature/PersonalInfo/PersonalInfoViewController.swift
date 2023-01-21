//
//  PersonalInfoViewController.swift
//  
//
//  Created by denny on 2023/01/22.
//

import ComposableArchitecture
import SwiftLayout
import TogetherCore
import TogetherUI
import ThirdParty
import UIKit

final class PersonalInfoViewController: UIViewController, Layoutable {
    var activation: Activation?

    private let store: StoreOf<Setting>
    private let viewStore: ViewStoreOf<Setting>
    private let tempViewStore: ViewStoreOf<PersonalInfo>

    @LayoutBuilder var layout: some Layout {
        view.config { view in
            view.backgroundColor = .backgroundWhite
        }.sublayout {
            UIView().anchors {
                Anchors.allSides()
            }
        }
    }

    init(store: StoreOf<Setting>, personalInfoStore: StoreOf<PersonalInfo>) {
        self.store = store
        self.viewStore = ViewStore(store)
        self.tempViewStore = ViewStore(personalInfoStore)
        super.init(nibName: nil, bundle: nil)
        sl.updateLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navBar = navigationController?.navigationBar as? TogetherNavigationBar {
            navBar.setBackgroundImage(UIImage(color: .blueGray0), for: .default)
        }

        navigationItem.setLeftBarButtonItem7(.backButtonItem(target: self, action: #selector(onClickBackButton)))
        navigationItem.title = "개인정보 처리방침"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @objc
    private func onClickBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        viewStore.send(.settingPersonalInfo(.detachChild))
    }
}
