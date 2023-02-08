//
//  MyPageViewController.swift
//  
//
//  Created by denny on 2023/01/19.
//

import Combine
import ComposableArchitecture
import SwiftLayout
import TogetherCore
import TogetherUI
import ThirdParty
import UIKit

final class MyPageViewController: UIViewController, Layoutable {
    var activation: Activation?

    private let store: StoreOf<MyPage>
    private let viewStore: ViewStoreOf<MyPage>

    private var cancellables: Set<AnyCancellable> = .init()
    private var alertController: UIAlertController?

    private var createBarButton: UIBarButtonItem {
        UIBarButtonItem(image: UIImage(named: "ic_appbar_write"), style: .plain, target: self, action: #selector(onClickCreate))
    }

    private var settingBarButton: UIBarButtonItem {
        UIBarButtonItem(image: UIImage(named: "ic_appbar_settings"), style: .plain, target: self, action: #selector(onClickSetting))
    }

    private let headerView: ProfileHeaderView = ProfileHeaderView().config { view in
        view.backgroundColor = .backgroundWhite
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.5
        view.layer.shadowColor = UIColor.blueGray150.cgColor
    }

    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MyPageCollectionViewCell.self, forCellWithReuseIdentifier: MyPageCollectionViewCell.identifier)
        return collectionView
    }()

    @LayoutBuilder var layout: some Layout {
        view.config { view in
            view.backgroundColor = .backgroundWhite
        }.sublayout {
            headerView.anchors {
                Anchors.top.equalToSuper()
                Anchors.leading.trailing.equalToSuper()
            }
            imageCollectionView.anchors {
                Anchors.top.equalTo(headerView, attribute: .bottom, constant: 0)
                Anchors.leading.trailing.equalToSuper()
                Anchors.bottom.equalTo(view.safeAreaLayoutGuide.bottomAnchor)
            }
        }
    }

    init(store: StoreOf<MyPage>) {
        self.store = store
        self.viewStore = ViewStore(store)

        super.init(nibName: nil, bundle: nil)
        self.bindNavigation()
        self.bindState()
        sl.updateLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // MARK: API Test
        print("View Did Appear --> fetch API List")
        viewStore.send(.fetchMyPetList)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navBar = navigationController?.navigationBar as? TogetherNavigationBar {
            navBar.setBackgroundImage(UIImage(color: .blueGray0), for: .default)
        }

        navigationItem.setRightBarButtonItems7([settingBarButton, createBarButton])
        navigationItem.title = "MY"
    }

    private func bindNavigation() {
        store
            .scope(state: \.feedRegister, action: MyPage.Action.feedRegister)
            .ifLet { [weak self] feedRegister in
                let feedRegisterViewController: OnboardingFeedRegisterViewController = .init(store: feedRegister, canSkip: false)
                feedRegisterViewController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(
                    feedRegisterViewController, 
                    animated: true
                )
            }
            .store(in: &cancellables)
        
        store
            .scope(state: \.myPageSetting, action: MyPage.Action.myPageSetting)
            .ifLet { [weak self] setting in
                guard let self = self else { return }
                self.navigationController?.pushViewController(
                    SettingViewController(store: self.store, settingStore: setting),
                    animated: true
                )
            }
            .store(in: &cancellables)

        store
            .scope(state: \.postDetail, action: MyPage.Action.postDetail)
            .ifLet { [weak self] postDetail in
                let postDetailVC = PostDetailViewController(store: postDetail)
                self?.navigationController?.pushViewController(
                    postDetailVC,
                    animated: true
                )
            }
            .store(in: &cancellables)
    }

    private func bindState() {
        viewStore.publisher.alert
            .delay(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [weak self] alert in
                if let alert = alert {
                    let alertController = UIAlertController(state: alert) {
                        self?.viewStore.send($0)
                    }
                    self?.present(alertController, animated: true, completion: nil)
                    self?.alertController = alertController
                } else {
                    self?.alertController?.dismiss(animated: true, completion: nil)
                    self?.alertController = nil
                }
            }
            .store(in: &cancellables)
    }

    @objc
    private func onClickCreate(_ sender: UIBarButtonItem) {
        viewStore.send(.didTapCreate)
    }

    @objc
    private func onClickSetting(_ sender: UIBarButtonItem) {
        viewStore.send(.didTapSetting)
    }
}

extension MyPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 1
        let width = (UIScreen.main.bounds.width - (spacing * 2)) / 3
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30 // TODO: 임시 값
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageCollectionViewCell.identifier, for: indexPath) as? MyPageCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.image = UIImage(named: "Sample1") // TODO: Sample
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewStore.send(.didTapPost)
    }
}
