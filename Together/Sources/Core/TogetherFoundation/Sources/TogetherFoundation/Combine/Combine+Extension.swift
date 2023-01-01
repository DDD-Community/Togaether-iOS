//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/01.
//

import Foundation
import Combine

public extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<Root, Output>,
        onWeak object: Root
    ) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
