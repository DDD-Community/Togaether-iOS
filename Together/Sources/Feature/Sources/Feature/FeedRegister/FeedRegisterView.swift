//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/12.
//

import UIKit
import Combine

import TogetherCore
import TogetherFoundation
import TogetherUI
import ThirdParty

import SwiftLayout
import ComposableArchitecture

final class FeedRegisterView: UIView {
    
    private let store: StoreOf<FeedRegister>
    private let viewStore: ViewStoreOf<FeedRegister>
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let textViewPlaceHolder: String = "우리아이 사진에 대한 이야기를\n같이 적어주세요🙌"
    
    private let scrollView: UIScrollView = .init().config {
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    private let contentStackView: UIStackView = .init().config {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let titleLabel: UILabel = .init().config {
        $0.font = .display1
        $0.textColor = .blueGray900
        $0.text = "사진을 등록하고\n내용을 작성해주세요."
        $0.numberOfLines = 2
    }
    
    private let emptyImageView: UIImageView = .init(image: .init(named: "ic_regist_photo")).config {
        $0.isUserInteractionEnabled = false
    }
    private let photoImageView: UIImageView = .init().config {
        $0.backgroundColor = .backgroundGray
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleAspectFit
    }
    
    private let contentTitleLabel: UILabel = .init().config {
        $0.font = .subhead3
        $0.textColor = .blueGray700
        $0.text = "내용(200자)"
    }
    
    private lazy var contentTextView: UITextView = .init().config {
        $0.font = .body2
        $0.textColor = .blueGray400
        $0.text = self.textViewPlaceHolder
        $0.delegate = self
    }
    
    @LayoutBuilder var layout: some SwiftLayout.Layout {
        photoImageView
            .sublayout { 
                emptyImageView.anchors { Anchors.center() }
            }
            .anchors { 
                Anchors.height.equalTo(constant: 400)
            }
        
        self
            .config { view in
                view.keyboardLayoutGuide.followsUndockedKeyboard = true
                view.backgroundColor = .backgroundWhite
            }
            .sublayout {
                scrollView
                    .anchors { 
                        Anchors.top.equalTo(safeAreaLayoutGuide.topAnchor)
                        Anchors.horizontal(offset: 24)
                        Anchors.bottom.equalTo(keyboardLayoutGuide.topAnchor)
                    }
                
                contentStackView
                    .config {
                        $0.addArrangedSubview(titleLabel)
                        $0.setCustomSpacing(32, after: titleLabel)
                        $0.addArrangedSubview(photoImageView)
                        $0.setCustomSpacing(32, after: photoImageView)
                        $0.addArrangedSubview(contentTitleLabel)
                        $0.setCustomSpacing(8, after: contentTitleLabel)
                        $0.addArrangedSubview(contentTextView)
                    }
                    .anchors { 
                        Anchors.top.equalTo(scrollView, constant: 32)
                        Anchors.horizontal(scrollView)
                        Anchors.bottom.equalTo(scrollView)
                        Anchors.width.equalTo(scrollView.widthAnchor)
                    }
            }
    }
    
    init(store: StoreOf<FeedRegister>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(frame: .zero)
        layout.finalActive()
        bindAction()
        bindState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindAction() {
        photoImageView
            .throttleTapGesture
            .sink { [weak self] _ in
                self?.viewStore.send(.didTapPhotoImageView)
            }
            .store(in: &cancellables)
    }
    
    private func bindState() {
        viewStore.publisher.selectedImage
            .assign(to: \.image, onWeak: photoImageView)
            .store(in: &cancellables)
        
        viewStore.publisher.selectedImage
            .map(\.isNotNil)
            .assign(to: \.isHidden, onWeak: emptyImageView)
            .store(in: &cancellables)
    }
}

extension FeedRegisterView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .blueGray900
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewStore.send(.set(\.$text, textView.text))
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .blueGray400
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct FeedRegister_Previews: PreviewProvider {
    static var previews: some View {
        let store: StoreOf<FeedRegister> = .init(
            initialState: .init(), 
            reducer: FeedRegister()
        )
        return FeedRegisterView(store: store)
            .showPrieview()
    }
}
#endif

