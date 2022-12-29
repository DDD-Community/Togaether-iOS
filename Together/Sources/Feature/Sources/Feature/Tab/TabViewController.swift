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

public final class TabViewController: UIViewController {
    
    private let store: StoreOf<Tab>
    private let viewStore: ViewStoreOf<Tab>
    
    @LayoutBuilder var layout: some Layout {
      view.sublayout {
          UIView().anchors { 
              Anchors.allSides()
          }
      }
    }
    
    public init(store: StoreOf<Tab>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
        layout.finalActive()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
    }
}
