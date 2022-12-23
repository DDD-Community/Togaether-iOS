//
//  File.swift
//  
//
//  Created by 한상진 on 2022/11/26.
//

import UIKit

import TogetherCore
import TogetherUI
import ThirdParty

import SwiftLayout
import ComposableArchitecture

public final class LoginViewController: UIViewController {
    
    private let store: StoreOf<Login>
    
    private let subView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .red
        return view
    }()
    
    @LayoutBuilder var layout: some Layout {
      view.sublayout {
          subView.anchors { 
              Anchors.centerX.centerY.equalToSuper()
              Anchors.width.height.equalTo(constant: 100)
          }
      }
    }
    
    public init(store: StoreOf<Login>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        layout.finalActive()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}
