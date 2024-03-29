//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/15.
//

import UIKit

import TogetherCore
import TogetherUI
import ThirdParty

import SwiftLayout

struct SpeciesSection: Identifiable, Hashable {
    var id: String
    var names: [String]
}

typealias SpeciesSnapshot = NSDiffableDataSourceSnapshot<String, String>

final class OnboardingSpeciesTableView: UITableView {
    init() {
        super.init(frame: .zero, style: .plain)
        registerCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func registerCell() {
        self.register(OnboardingSpeciesCell.self, forCellReuseIdentifier: OnboardingSpeciesCell.identifier)
    }
}

final class OnboardingSpeciesDataSource: UITableViewDiffableDataSource<String, String> { }
