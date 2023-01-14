
import UIKit
import ThirdParty
import SwiftLayout

public final class TogetherInputFieldView: UIView {
    
    private var title: String {
        willSet {
            titleLabel.text = newValue
        }
    }
    private var placeholder: String {
        willSet {
            inputTextField.placeholder = newValue
        }
    }
    
    public var isValid: Bool? {
        willSet {
            switch newValue {
            case .none:
                isValidIconImageView.image = .none
                
            case .some(true):
                isValidIconImageView.image = validIconImage
                
            case .some(false):
                isValidIconImageView.image = invalidIconImage
            }
        }
    }
    
    public let titleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .body1
        label.textColor = .blueGray500
        return label
    }()
    
    public let inputTextField: UITextField = {
        let textField: UITextField = .init()
        textField.attributedPlaceholder = .init(string: "", attributes: [
            .foregroundColor: UIColor.blueGray300,
            .font: UIFont.body2 as Any
        ])
        textField.borderWidth = 1
        textField.borderColor = .borderPrimary
        textField.cornerRadius = 8
        textField.addLeftPadding(inset: 20)
        textField.addRightPadding(inset: 46)
        return textField
    }()
    
    private let validIconImage: UIImage? = .init(named: "ic_input_success")
    private let invalidIconImage: UIImage? = .init(named: "ic_input_fail")
    
    private let isValidIconImageView: UIImageView = {
        let imageView: UIImageView = .init()
        return imageView
    }()
    
    @LayoutBuilder var layout: some Layout {
        self.sublayout {
            titleLabel
                .config { label in 
                    label.text = title
                }
                .anchors { 
                    Anchors.top.equalToSuper()
                    Anchors.horizontal()
                }
            
            inputTextField
                .config { textField in
                    textField.placeholder = placeholder
                }
                .sublayout { 
                    isValidIconImageView
                        .anchors { 
                            Anchors.centerY.equalToSuper()
                            Anchors.trailing.equalToSuper(constant: -16)
                        }
                }
                .anchors { 
                    Anchors.horizontal()
                    Anchors.top.equalTo(titleLabel, attribute: .bottom, constant: 6)
                    Anchors.height.equalTo(constant: 48)
                    Anchors.bottom.equalToSuper()
                }
        }
    }
    
    public init(
        title: String, 
        placeholder: String,
        keyboardType: UIKeyboardType = .default,
        isValid: Bool? = .none
    ) {
        self.title = title
        self.placeholder = placeholder
        self.isValid = isValid
        super.init(frame: .zero)
        inputTextField.delegate = self
        inputTextField.keyboardType = keyboardType
        layout.finalActive()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TogetherInputFieldView: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.borderColor = .primary500
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.borderColor = .borderPrimary
    }
}
