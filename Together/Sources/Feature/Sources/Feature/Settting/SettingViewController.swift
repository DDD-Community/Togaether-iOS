//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/30.
//

import Combine
import ComposableArchitecture
import SwiftLayout
import TogetherCore
import TogetherUI
import ThirdParty
import UIKit

final class SettingViewController: UIViewController, Layoutable {
    typealias DataSource = UITableViewDiffableDataSource<Section, Setting.SettingItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Setting.SettingItem>

    enum Section: CaseIterable {
        case main
    }

    var activation: Activation?

    private let store: StoreOf<MyPage>
    private let viewStore: ViewStoreOf<MyPage>

    private let tempStore: StoreOf<Setting>
    private let tempViewStore: ViewStoreOf<Setting>

    private var cancellables: Set<AnyCancellable> = .init()
    private var alertController: UIAlertController?

    var settingDataSource: DataSource!

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

            settingTableView.anchors {
                Anchors.top.equalTo(view.safeAreaLayoutGuide.topAnchor, inwardOffset: 14)
                Anchors.bottom.equalTo(view.safeAreaLayoutGuide.bottomAnchor, inwardOffset: 0)
                Anchors.leading.trailing.equalToSuper()
            }
        }
    }
    
    init(store: StoreOf<MyPage>, settingStore: StoreOf<Setting>) {
        self.store = store
        self.viewStore = ViewStore(store)
        self.tempStore = settingStore
        self.tempViewStore = ViewStore(settingStore)

        super.init(nibName: nil, bundle: nil)

        self.setupSettingDataSource()
        self.bindNavigation()
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

            cell.settingItem = self.tempViewStore.settingItems[indexPath.row]
            cell.selectionStyle = .none

            if self.tempViewStore.settingItems[indexPath.row] == .version {
                cell.subText = "1.0.0"
            }

            return cell
        })

        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(tempViewStore.settingItems)
        settingDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let navBar = navigationController?.navigationBar as? TogetherNavigationBar {
            navBar.setBackgroundImage(UIImage(color: .blueGray0), for: .default)
        }

        navigationItem.setLeftBarButtonItem7(.backButtonItem(target: self, action: #selector(onClickBackButton)))
        navigationItem.title = "설정"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @objc
    private func onClickBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        tempViewStore.send(.detachChild)
    }

    private func bindNavigation() {
        tempViewStore.publisher.alert
            .sink { [weak self] alert in
                if let alert = alert {
                    let alertController = UIAlertController(state: alert) {
                        self?.tempViewStore.send($0)
                    }
                    self?.present(alertController, animated: true, completion: nil)
                    self?.alertController = alertController
                } else {
                    self?.alertController?.dismiss(animated: true, completion: nil)
                    self?.alertController = nil
                }
            }
            .store(in: &cancellables)
        
        tempViewStore.publisher.isLoggedOut
            .sink { loggedOut in
                guard loggedOut else { return }
                let store: StoreOf<Login> = .init(initialState: .init(), reducer: Login())
                let loginViewController = LoginViewController(store: store)
                let navigationController = TogetherNavigation(rootViewController: loginViewController)
                UIApplication.shared.appKeyWindow?.rootViewController = navigationController
            }
            .store(in: &cancellables)
        
        tempStore
            .scope(state: \.onboarding, action: Setting.Action.onboarding)
            .ifLet(then: { [weak self] store in
                guard let self = self else { return }
                let navi = OnboardingNavigationViewController(store: store)
                self.present(navi, animated: true)
            }, else: { [weak self] in
                self?.dismiss(animated: true)
            })
            .store(in: &cancellables)

        tempStore
            .scope(state: \.settingAgreement, action: Setting.Action.settingAgreement)
            .ifLet { [weak self] agreement in
                guard let self = self else { return }
                self.navigationController?.pushViewController(
                    PolicyViewController(store: agreement),
                    animated: true
                )
            }
            .store(in: &cancellables)

        tempStore
            .scope(state: \.settingPersonalInfo, action: Setting.Action.settingPersonalInfo)
            .ifLet { [weak self] personalInfo in
                guard let self = self else { return }
                self.navigationController?.pushViewController(
                    PolicyViewController(store: personalInfo),
                    animated: true
                )
            }
            .store(in: &cancellables)
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = tempViewStore.settingItems[indexPath.row]
        switch item {
        case .petInfo:
            tempViewStore.send(.didTapPetInfo)
        case .agreement:
            tempViewStore.send(.didTapAgreement)
        case .personalInfo:
            tempViewStore.send(.didTapPersonalInfo)
        case .version:
            tempViewStore.send(.didTapVersion)
        case .logout:
            tempViewStore.send(.didTapLogout)
        case .withdraw:
            tempViewStore.send(.didTapWithdraw)
        }
    }
}
