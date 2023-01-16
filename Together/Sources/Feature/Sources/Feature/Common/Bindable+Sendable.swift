//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/16.
//

import Foundation
import ThirdParty
import ComposableArchitecture

extension BindableState: @unchecked Sendable where Value: Sendable { }
extension BindingAction: @unchecked Sendable where Root: Sendable { }

