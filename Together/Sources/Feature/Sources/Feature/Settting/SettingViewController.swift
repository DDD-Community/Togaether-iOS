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

final class SettingViewController: UIViewController {
    
    private let store: StoreOf<Setting>
    private let viewStore: ViewStoreOf<Setting>
    
    @LayoutBuilder var layout: some Layout {
        view.sublayout {
            UIView().anchors { 
                Anchors.allSides()
            }
        }
    }
    
    init(store: StoreOf<Setting>) {
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

