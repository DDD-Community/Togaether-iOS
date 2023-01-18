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

final class HomeViewController: UIViewController, Layoutable {
    public var activation: Activation?

    private let store: StoreOf<Home>
    private let viewStore: ViewStoreOf<Home>

    private let titleLabel: UILabel = UILabel().config { label in
        label.numberOfLines = 2
        label.font = .display1
        label.text = "댕댕이 자랑\n해보는건 어때요?"
        label.textColor = .blueGray900
    }

    private let notificationButton: TogetherImageButton = TogetherImageButton(image: UIImage(named: "ic_notification"))

    private let viewContainer: UIView = UIView()
    private var swipeView: TogetherSwipeView! {
        didSet{
            self.swipeView.delegate = self
        }
    }

    private lazy var guideAnimationView: UIView = UIView().config { view in
        view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        view.cornerRadius = 20
        view.clipsToBounds = true
        view.addBlurEffect()
    }

    private let guideLabel: UILabel = UILabel().config { label in
        label.font = .subhead1
        label.textColor = .blueGray0
        label.text = "우측으로 스와이프 하고\n마음에 드는 강아지를 팔로우 하세요"
        label.textAlignment = .center
        label.numberOfLines = 2
    }
    
    @LayoutBuilder var layout: some SwiftLayout.Layout {
        self.view.config { view in
            view.backgroundColor = .backgroundWhite
        }.sublayout {
            viewContainer.anchors {
                Anchors.leading.trailing.equalToSuper()
                Anchors.centerX.equalToSuper()
                Anchors.top.equalTo(titleLabel, attribute: .bottom, inwardOffset: 50)
                Anchors.bottom.equalTo(view.safeAreaLayoutGuide.bottomAnchor, inwardOffset: 14)
            }

            guideAnimationView.anchors {
                Anchors.size(width: 250, height: 250)
                Anchors.centerX.equalToSuper()
                Anchors.centerY.equalToSuper()
            }.sublayout {
                guideLabel.anchors {
                    Anchors.centerX.equalToSuper()
                    Anchors.leading.trailing.equalToSuper(inwardOffset: 5)
                    Anchors.bottom.equalToSuper(inwardOffset: 35)
                }
            }

            titleLabel.anchors {
                Anchors.top.equalTo(view.safeAreaLayoutGuide.topAnchor, inwardOffset: 26)
                Anchors.leading.equalToSuper(inwardOffset: 25)
            }

            notificationButton.anchors {
                Anchors.top.equalTo(view.safeAreaLayoutGuide.topAnchor, inwardOffset: 26)
                Anchors.trailing.equalToSuper(inwardOffset: 22)
            }
        }
    }

    let puppyModels : [PuppyModel] =  {
        let categories: [String] = ["골든리트리버", "시츄", "치와와", "진돗개", "풍산개", "보더콜리", "요크셔테리어", "푸들", "말티즈", "사모예드"]
        var model : [PuppyModel] = []
        for n in 0..<10 {
            let tempModel = PuppyModel(image: UIImage(named: "puppySample"),
                                       name: "샘플이름\(n)",
                                       category: categories[n % categories.count],
                                       gender: n % 2 == 0 ? "수컷" : "암컷",
                                       description: "얼마전에 주인이랑 길을 가는데 주인이 글쎄 갑자기이걸 가져와보라고 하더라고 마음에 드는 물건인지 확인해보려고 살펴보는데 내가 원하는 물건이 아니라 가져갈까말까 고민이 매우 깊어졌지만 그래도 주인이니까 가져갔다")
            model.append(tempModel)
        }
        return model
    }()
    
    init(store: StoreOf<Home>) {
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
        
        let contentView: (Int, CGRect, PuppyModel) -> (PuppyContentView) = { (index: Int ,frame: CGRect , puppyModel: PuppyModel) -> (PuppyContentView) in
            let customView = PuppyContentView(frame: frame)
            customView.model = puppyModel
            return customView
        }

        let scenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = scenes?.windows.first

        let swipeFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.frame.height - UIApplication.shared.statusBarFrame.size.height - (window?.safeAreaInsets.top ?? 0) - (window?.safeAreaInsets.bottom ?? 0) - 108 - 14)
        swipeView = TogetherSwipeView(inset: 0, frame: swipeFrame, contentView: contentView)
        viewContainer.addSubview(swipeView)
        swipeView.showTogetherCards(with: puppyModels, isDummyShow: true)
    }
}

extension HomeViewController: TogetherSwipeViewDelegate {
    func swipeGuideAnimationFinish() {
        
    }

    func currentCardStatus(card: TogetherCard, distance: CGFloat) {

    }

    func didCancelMove(model: PuppyModel) {

    }

    func didSelectCard(model: PuppyModel) {

    }

    func didMoveToLeft(model: PuppyModel) {

    }

    func didMoveToRight(model: PuppyModel) {

    }

    func undoCurrentCard(model: PuppyModel) {

    }

    func didReachLastCard() {

    }
}
