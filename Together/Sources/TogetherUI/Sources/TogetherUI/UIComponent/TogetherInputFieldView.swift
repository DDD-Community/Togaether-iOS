
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
    
    public let titleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .caption
        label.textColor = .hex("1A1A1A")
        return label
    }()
    
    public let inputTextField: UITextField = {
        let textField: UITextField = .init()
        textField.attributedPlaceholder = .init(string: "", attributes: [
            .foregroundColor: UIColor.backgroundGray,
            .font: UIFont.body1 as Any
        ])
        textField.borderWidth = 1
        textField.borderColor = .blueGray200
        textField.cornerRadius = 8
        textField.addLeftPadding(inset: 20)
        return textField
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
                .anchors { 
                    Anchors.horizontal()
                    Anchors.top.equalTo(titleLabel, attribute: .bottom, constant: 8)
                    Anchors.height.equalTo(constant: 48)
                    Anchors.bottom.equalToSuper()
                }
        }
    }
    
    public init(title: String, placeholder: String) {
        self.title = title
        self.placeholder = placeholder
        super.init(frame: .zero)
        layout.finalActive()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
