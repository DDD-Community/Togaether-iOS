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

final class SettingViewController: UIViewController, Layoutable {
    typealias DataSource = UITableViewDiffableDataSource<Section, Setting.SettingItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Setting.SettingItem>

    enum Section: CaseIterable {
        case main
    }

    var activation: Activation?

    private let store: StoreOf<Setting>
    private let viewStore: ViewStoreOf<Setting>

    var settingDataSource: DataSource!

    private let titleLabel: UILabel = UILabel().config { label in
        label.numberOfLines = 2
        label.font = .display1
        label.text = "설정"
        label.textColor = .blueGray900
    }

    private lazy var settingTableView: UITableView = UITableView().config { tableView in
        tableView.backgroundColor = .blueGray100
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.delegate = self
        tableView.separatorStyle = .none
    }

    @LayoutBuilder var layout: some SwiftLayout.Layout {
        view.config { view in
            view.backgroundColor = .backgroundWhite
        }.sublayout {
            UIView().anchors {
                Anchors.allSides()
            }

            titleLabel.anchors {
                Anchors.top.equalTo(view.safeAreaLayoutGuide.topAnchor, inwardOffset: 26)
                Anchors.leading.equalToSuper(inwardOffset: 25)
            }

            settingTableView.anchors {
                Anchors.top.equalTo(titleLabel, attribute: .bottom, inwardOffset: 26)
                Anchors.bottom.equalTo(view.safeAreaLayoutGuide.bottomAnchor, inwardOffset: 0)
                Anchors.leading.trailing.equalToSuper()
            }
        }
    }
    
    init(store: StoreOf<Setting>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)

        self.setupSettingDataSource()
        sl.updateLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSettingDataSource() {
        settingDataSource = DataSource(tableView: settingTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else {
                return UITableViewCell()
            }

            cell.settingItem = self.viewStore.settingItems[indexPath.row]
            cell.selectionStyle = .none

            if self.viewStore.settingItems[indexPath.row] == .version {
                cell.subText = "1.0.0"
            }

            return cell
        })

        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewStore.settingItems)
        settingDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewStore.settingItems[indexPath.row]
        switch item {
        case .myInfo:
            viewStore.send(.didTapMyInfo)
        case .petInfo:
            viewStore.send(.didTapPetInfo)
        case .agreement:
            viewStore.send(.didTapAgreement)
        case .personalInfo:
            viewStore.send(.didTapPersonalInfo)
        case .version:
            viewStore.send(.didTapVersion)
        case .logout:
            viewStore.send(.didTapLogout)
        }
    }
}
