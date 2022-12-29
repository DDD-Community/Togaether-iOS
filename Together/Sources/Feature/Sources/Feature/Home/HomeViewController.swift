//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/30.
//

import UIKit

import TogetherCore
import TogetherUI
import ThirdParty

import SwiftLayout
import ComposableArchitecture

final class HomeViewController: UIViewController {
    
    private let store: StoreOf<Home>
    private let viewStore: ViewStoreOf<Home>
    
    @LayoutBuilder var layout: some Layout {
        view.sublayout {
            UIView().anchors { 
                Anchors.allSides()
            }
        }
    }
    
    init(store: StoreOf<Home>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
        layout.finalActive()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

