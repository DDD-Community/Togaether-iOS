//
//  SwiftUIView.swift
//  
//
//  Created by 한상진 on 2023/02/05.
//

import UIKit
import Combine

import TogetherCore
import TogetherUI
import ThirdParty

import SwiftLayout
import ComposableArchitecture

final class PolicyViewController: UIViewController {
    
    private let store: StoreOf<Policy>
    private let viewStore: ViewStoreOf<Policy>
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let scrollView: UIScrollView = .init().config {
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = true
    }
    
    private let content: UITextView = .init().config {
        $0.textAlignment = .center
    }
    
    @LayoutBuilder var layout: some SwiftLayout.Layout {
        view
            .config {
                $0.backgroundColor = .backgroundWhite
            }
            .sublayout {
                scrollView
                    .anchors { 
                        Anchors.allSides()
                    }
                    .sublayout { 
                        content
                            .config {
                                $0.text = viewStore.state.content
                            }
                            .anchors { 
                                Anchors.allSides()
                                Anchors.width.equalToSuper()
                            }
                    }
            }
    }
    
    init(store: StoreOf<Policy>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
        layout.finalActive()
        configureNavigation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
    }
    
    private func configureNavigation() {
        if let navBar = navigationController?.navigationBar as? TogetherNavigationBar {
            navBar.setBackgroundImage(UIImage(color: .blueGray0), for: .default)
        }
        navigationItem.setLeftBarButtonItem7(.backButtonItem(target: self, action: #selector(onClickBackButton)))
        navigationItem.title = viewStore.state.title
    }
    
    @objc
    private func onClickBackButton() {
        navigationController?.popViewController(animated: true)
        viewStore.send(.backButtonTapped)
    }
}
