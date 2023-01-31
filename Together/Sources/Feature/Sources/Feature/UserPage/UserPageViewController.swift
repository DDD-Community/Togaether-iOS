//
//  UserPageViewController.swift
//  
//
//  Created by denny on 2023/01/31.
//

import Combine
import ComposableArchitecture
import SwiftLayout
import TogetherCore
import TogetherUI
import ThirdParty
import UIKit

final class UserPageViewController: UIViewController, Layoutable {
    var activation: Activation?

    private let store: StoreOf<UserPage>
    private let viewStore: ViewStoreOf<UserPage>

    private var cancellables: Set<AnyCancellable> = .init()

    private lazy var headerView: UserProfileHeaderView = UserProfileHeaderView().config { view in
        view.backgroundColor = .backgroundWhite
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.5
        view.layer.shadowColor = UIColor.blueGray150.cgColor
//        view.isFollowing = true
        view.didTapFollowButton = {
            print("Change isFollowing ==> \($0)")
        }
    }

    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UserPageCollectionViewCell.self, forCellWithReuseIdentifier: UserPageCollectionViewCell.identifier)
        return collectionView
    }()

    @LayoutBuilder var layout: some SwiftLayout.Layout {
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

    init(store: StoreOf<UserPage>) {
        self.store = store
        self.viewStore = ViewStore(store)

        super.init(nibName: nil, bundle: nil)
        self.bindNavigation()
        sl.updateLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navBar = navigationController?.navigationBar as? TogetherNavigationBar {
            navBar.setBackgroundImage(UIImage(color: .blueGray0), for: .default)
        }

        navigationItem.setLeftBarButtonItem7(.backButtonItem(target: self, action: #selector(onClickBackButton)))

        navigationItem.title = "유저이름 노출 필요"
    }

    @objc
    private func onClickBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        viewStore.send(.detachChild)
    }

    private func bindNavigation() {
        store
            .scope(state: \.postDetail, action: UserPage.Action.postDetail)
            .ifLet { [weak self] postDetail in
                let postDetailVC = PostDetailViewController(store: postDetail)
                self?.navigationController?.pushViewController(
                    postDetailVC,
                    animated: true
                )
            }
            .store(in: &cancellables)
    }
}

extension UserPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPageCollectionViewCell.identifier, for: indexPath) as? UserPageCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.image = UIImage(named: "Sample1") // TODO: Sample
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewStore.send(.didTapPost)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct UserPage_Previews: PreviewProvider {
    static var previews: some View {
        let store: StoreOf<UserPage> = .init(initialState: .init(), reducer: UserPage())
        return UserPageViewController(store: store)
            .showPrieview()
    }
}
#endif
