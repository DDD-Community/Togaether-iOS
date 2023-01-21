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
    
    private let titleLabel: UILabel = .init().then {
        $0.font = .display1
        $0.textColor = .blueGray900
        $0.text = "사진을 등록하고\n내용을 작성해주세요."
        $0.numberOfLines = 2
    }
    
    private let emptyImageView: UIImageView = .init(image: .init(named: "ic_regist_photo")).config {
        $0.isUserInteractionEnabled = false
    }
    private let photoImageView: UIImageView = .init().then {
        $0.backgroundColor = .backgroundGray
        $0.isUserInteractionEnabled = true
    }
    
    private let contentTitleLabel: UILabel = .init().then {
        $0.font = .subhead3
        $0.textColor = .blueGray700
        $0.text = "내용(200자)"
    }
    
    private lazy var contentTextView: UITextView = .init().then {
        $0.font = .body2
        $0.textColor = .blueGray400
        $0.text = self.textViewPlaceHolder
        $0.delegate = self
    }
    
    @LayoutBuilder var layout: some SwiftLayout.Layout {
        self
            .config { view in
                view.keyboardLayoutGuide.followsUndockedKeyboard = true
                view.backgroundColor = .backgroundWhite
            }
            .sublayout {
                titleLabel
                    .anchors { 
                        Anchors.top.equalTo(self.safeAreaLayoutGuide.topAnchor, constant: 32)
                        Anchors.leading.equalToSuper(constant: 24)
                    }
                
                photoImageView
                    .sublayout { 
                        emptyImageView
                            .anchors { 
                                Anchors.center()
                            }
                    }
                    .anchors { 
                        Anchors.top.equalTo(titleLabel.bottomAnchor, constant: 32)
                        Anchors.horizontal()
                        Anchors.height.equalTo(constant: 450)
                    }
                
                contentTitleLabel
                    .anchors { 
                        Anchors.top.equalTo(photoImageView.bottomAnchor, constant: 32)
                        Anchors.leading.equalToSuper(constant: 24)
                    }
                
                contentTextView
                    .anchors { 
                        Anchors.top.equalTo(contentTitleLabel.bottomAnchor, constant: 8)
                        Anchors.horizontal(offset: 24)
                        Anchors.bottom.equalTo(self.keyboardLayoutGuide.topAnchor)
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
        bindNavigation()
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
    
    private func bindNavigation() {
        
    }
}

extension FeedRegisterView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .blueGray500 // 없어서 달라해야함
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

