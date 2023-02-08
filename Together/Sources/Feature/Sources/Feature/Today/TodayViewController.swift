//
//  TodayViewController.swift
//  
//
//  Created by denny on 2023/01/18.
//

import ComposableArchitecture
import SwiftLayout
import TogetherCore
import TogetherUI
import ThirdParty
import UIKit

final class TodayViewController: UIViewController, Layoutable {
    var activation: Activation?

    private let store: StoreOf<Today>
    private let viewStore: ViewStoreOf<Today>

    private let titleLabel: UILabel = UILabel().config { label in
        label.numberOfLines = 2
        label.font = .display1
        label.text = "지금 가장 인기있는\n댕댕이들이에요"
        label.textColor = .blueGray900
    }

    private lazy var todayTableView: UITableView = UITableView().config { tableView in
        tableView.register(TodayCell.self, forCellReuseIdentifier: TodayCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .blueGray100
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
    }

    @LayoutBuilder var layout: some Layout {
        view.config { view in
            view.backgroundColor = .blueGray100
        }.sublayout {
            titleLabel.anchors {
                Anchors.top.equalTo(view.safeAreaLayoutGuide.topAnchor, inwardOffset: 26)
                Anchors.leading.equalToSuper(inwardOffset: 25)
            }

            todayTableView.anchors {
                Anchors.top.equalTo(titleLabel, attribute: .bottom, constant: 30)
                Anchors.leading.trailing.equalToSuper(inwardOffset: 24)
                Anchors.bottom.equalTo(view.safeAreaLayoutGuide.bottomAnchor, inwardOffset: 26)
            }
        }
    }

    init(store: StoreOf<Today>) {
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

        sl.updateLayout()
    }
}

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20 // TODO: Temp Value
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodayCell.identifier, for: indexPath) as? TodayCell else {
            return UITableViewCell()
        }

        cell.selectionStyle = .none
        cell.rank = indexPath.row
        cell.followerCount = 9999 // TODO: TEMP Value
        cell.model = PuppyModel(name: "TEST NAME \(indexPath.row)", category: "골든 리트리버", gender: "수컷", description: "열자내용열자내용임다")

        return cell
    }

}
