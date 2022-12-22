//
//  RootViewController.swift
//  
//
//  Created by 한상진 on 2022/12/22.
//

import UIKit
import Combine

import TogetherCore
import TogetherUI
import ThirdParty

import SwiftLayout
import ComposableArchitecture

final class RootViewController: UIViewController {
    
    private let viewStore: ViewStoreOf<Root>
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let launchScreenImageView: UIImageView = .init()
    
    @LayoutBuilder var layout: some Layout {
      view.sublayout {
          launchScreenImageView.anchors { 
              Anchors.allSides()
          }
          launchScreenImageView.config { view in
              view.backgroundColor = .yellow
          }
      }
    }
    
    init(store: StoreOf<Root>) {
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
        layout.finalActive()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        bindState()
    }
    
    private func bindAction() {
        viewStore.send(.viewDidLoad)
    }
    
    private func bindState() {
        
    }
}
