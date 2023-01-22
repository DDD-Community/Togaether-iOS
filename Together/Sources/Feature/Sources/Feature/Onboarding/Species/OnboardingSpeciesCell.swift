//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/14.
//

import UIKit
import Combine

import TogetherCore
import TogetherUI
import ThirdParty

import SwiftLayout

final class OnboardingSpeciesCell: UITableViewCell, Layoutable {
    var activation: Activation?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectedImageView.isHidden = !selected
    }
    
    private let nameLabel: UILabel = .init().config { label in
        label.font = .body2
        label.textColor = .blueGray900
        label.numberOfLines = 1
    }
    private let selectedImageView: UIImageView = .init(image: .init(named: "ic_input_success")).config {
        $0.isHidden = true
    }
    private let bottomSeparator: UIView = UIView().config { view in
        view.backgroundColor = .blueGray900.withAlphaComponent(0.1)
    }
    
    @LayoutBuilder var layout: some SwiftLayout.Layout {
        contentView
            .config { cell in
                cell.backgroundColor = .backgroundWhite
            }
            .anchors { 
                Anchors.height.equalTo(constant: 52)
            }
            .sublayout { 
                nameLabel.anchors { 
                    Anchors.leading.equalToSuper(inwardOffset: 24)
                    Anchors.centerY.equalToSuper()
                }
                
                selectedImageView.anchors { 
                    Anchors.trailing.equalToSuper(inwardOffset: 24)
                    Anchors.centerY.equalToSuper()
                }
                
                bottomSeparator.anchors {
                    Anchors.height.equalTo(constant: 1)
                    Anchors.bottom.equalToSuper()
                    Anchors.leading.trailing.equalToSuper(inwardOffset: 24)
                }
            }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        sl.updateLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name: String) {
        nameLabel.text = name
    }
}

class OnboardingSpeciesHeaderView: UITableViewHeaderFooterView, Layoutable {
    var activation: Activation?
    
    private let titleLabel: UILabel = .init().config {
        $0.textColor = .primary600
        $0.font = .headline
    }
    
    @LayoutBuilder var layout: some SwiftLayout.Layout {
        self.contentView
            .config {
                $0.backgroundColor = .backgroundWhite
            }
            .sublayout { 
                titleLabel.anchors { 
                    Anchors.leading.equalToSuper(inwardOffset: 24)
                    Anchors.bottom.equalToSuper()
                }
            }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        sl.updateLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name: String?) {
        titleLabel.text = name
    }
}
