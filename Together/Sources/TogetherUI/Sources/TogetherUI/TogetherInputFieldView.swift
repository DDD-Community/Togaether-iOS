
import UIKit
import ThirdParty
import SwiftLayout

public final class TogetherInputFieldView: UIView {
    
    public let titleLabel: TogetherLabel = {
        let label: TogetherLabel = .init()
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
            titleLabel.anchors { 
                Anchors.top.equalToSuper()
                Anchors.horizontal()
            }
            
            inputTextField.anchors { 
                Anchors.horizontal()
                Anchors.top.equalTo(titleLabel, attribute: .bottom, constant: 8)
                Anchors.height.equalTo(constant: 48)
                Anchors.bottom.equalToSuper()
            }
        }
    }
    
    public init() {
        super.init(frame: .zero)
        layout.finalActive()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
