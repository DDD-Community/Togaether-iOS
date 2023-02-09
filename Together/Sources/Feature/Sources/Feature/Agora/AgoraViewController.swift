//
//  AgoraViewController.swift
//  
//
//  Created by denny on 2023/01/18.
//

import Combine
import ComposableArchitecture
import SwiftLayout
import TogetherCore
import TogetherUI
import ThirdParty
import UIKit

final class AgoraViewController: UIViewController, Layoutable {
    var activation: Activation?

    private var alertController: UIAlertController?
    private var petList: [PetResponse]? {
        didSet {
            guard let list = petList else { return }
            print("Agora list: \(list)")
        }
    }

    private let store: StoreOf<Agora>
    private let viewStore: ViewStoreOf<Agora>

    private var cancellables: Set<AnyCancellable> = .init()

    private let titleLabel: UILabel = UILabel().config { label in
        label.numberOfLines = 2
        label.font = .display1
        label.text = "내가 팔로잉하고 있는\n강아지들을 모아보세요"
        label.textColor = .blueGray900
    }

    private lazy var agoraCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AgoraCollectionViewCell.self, forCellWithReuseIdentifier: AgoraCollectionViewCell.identifier)
        return collectionView
    }()

    @LayoutBuilder var layout: some Layout {
        view.config { view in
            view.backgroundColor = .backgroundWhite
        }.sublayout {
            titleLabel.anchors {
                Anchors.top.equalTo(view.safeAreaLayoutGuide.topAnchor, inwardOffset: 26)
                Anchors.leading.equalToSuper(inwardOffset: 25)
            }

            agoraCollectionView.anchors {
                Anchors.top.equalTo(titleLabel, attribute: .bottom, inwardOffset: 26)
                Anchors.leading.trailing.equalToSuper(inwardOffset: 24)
                Anchors.bottom.equalTo(view.safeAreaLayoutGuide.bottomAnchor, inwardOffset: 0)
            }
        }
    }

    init(store: StoreOf<Agora>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
        sl.updateLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindNavigation()
        bindState()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // MARK: Fetch Pet List
        viewStore.send(.fetchPetList)
    }

    private func bindState() {
        viewStore.publisher.petList.sink(receiveValue: { [weak self] petList in
            self?.petList = petList
        }).store(in: &cancellables)

        viewStore.publisher.alert
            .delay(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [weak self] alert in
                if let alert = alert {
                    let alertController = UIAlertController(state: alert) { action in
                        guard let action else { return }
                        self?.viewStore.send(action)
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

    private func bindNavigation() {
        store
            .scope(state: \.userPage, action: Agora.Action.userPage)
            .ifLet { [weak self] userPage in
                guard let self = self else { return }
                self.navigationController?.pushViewController(
                    UserPageViewController(store: userPage),
                    animated: true
                )
            }
            .store(in: &cancellables)
    }
}

extension AgoraViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 8
        let width = (UIScreen.main.bounds.width - spacing - 24 - 24) / 2
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30 // TODO: 임시 값
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AgoraCollectionViewCell.identifier, for: indexPath) as? AgoraCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.petImage = UIImage(named: "puppySample")
        cell.content = "샘플 (\(indexPath.row))타이틀입니다 샘플 타이틀입니다"
        cell.category = "카테고리"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewStore.send(.didTapAgoraItem)
    }
}
