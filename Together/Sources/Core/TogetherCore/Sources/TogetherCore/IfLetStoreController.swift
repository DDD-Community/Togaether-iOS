//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/30.
//

import UIKit
import Combine

import ThirdParty
import ComposableArchitecture

public final class IfLetStoreController<State, Action>: UIViewController {
    let store: Store<State?, Action>
    let ifDestination: (Store<State, Action>) -> UIViewController
    let elseDestination: () -> UIViewController
    
    private var cancellables: Set<AnyCancellable> = []
    private var viewController = UIViewController() {
        willSet {
            self.viewController.willMove(toParent: nil)
            self.viewController.view.removeFromSuperview()
            self.viewController.removeFromParent()
            self.addChild(newValue)
            self.view.addSubview(newValue.view)
            newValue.didMove(toParent: self)
        }
    }
    
    public init(
        store: Store<State?, Action>,
        then ifDestination: @escaping (Store<State, Action>) -> UIViewController,
        else elseDestination: @escaping () -> UIViewController
    ) {
        self.store = store
        self.ifDestination = ifDestination
        self.elseDestination = elseDestination
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.store.ifLet(
            then: { [weak self] store in
                guard let self = self else { return }
                self.viewController = self.ifDestination(store)
            },
            else: { [weak self] in
                guard let self = self else { return }
                self.viewController = self.elseDestination()
            }
        )
        .store(in: &self.cancellables)
    }
}
