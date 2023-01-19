//
//  File.swift
//  
//
//  Created by denny on 2023/01/19.
//

import Foundation
import UIKit

public extension UIBarButtonItem {
    static func backButtonItem(target: Any?, action: Selector?) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: "ic_navigationbar_back"), style: .plain, target: target, action: action)
    }
}

public extension UINavigationItem {
    func setRightBarButtonItem7(_ item: UIBarButtonItem?) {
        guard let item = item else {
            rightBarButtonItem = nil
            rightBarButtonItems = nil
            return
        }

        item.tintColor = .blueGray900
        setRightBarButton(item, animated: false)
    }

    func setRightBarButtonItems7(_ items: [UIBarButtonItem]?) {
        guard let items = items else {
            rightBarButtonItem = nil
            rightBarButtonItems = nil
            return
        }

        var buttonItems: [UIBarButtonItem] = items
        buttonItems.forEach { item in
            item.tintColor = .blueGray900
        }

        setRightBarButtonItems(buttonItems, animated: false)
    }

    var rightBarButtonItem7: UIBarButtonItem? {
        if rightBarButtonItems != nil && rightBarButtonItems!.count > 0 {
            return rightBarButtonItems?.last
        }
        if rightBarButtonItem != nil {
            return rightBarButtonItem
        }
        return nil
    }

    var rightBarButtonItems7: [UIBarButtonItem]? {
        if rightBarButtonItems != nil {
            return rightBarButtonItems
        }
        if rightBarButtonItem != nil {
            return [rightBarButtonItem!]
        }
        return nil
    }

    func setRightBarButtonItemEnabled(_ enabled: Bool) {
        rightBarButtonItem7?.isEnabled = enabled
    }

    func setLeftBarButtonItem7(_ item: UIBarButtonItem?) {
        guard let item = item else {
            setLeftBarButton(nil, animated: false)
            setLeftBarButtonItems(nil, animated: false)
            return
        }

        item.tintColor = .blueGray900
        setLeftBarButton(item, animated: false)
    }
}

public class TogetherNavigationBar: UINavigationBar {
    public var backgroundImage: UIImage? = UIImage(color: .blueGray0)

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleTextAttributes = [NSAttributedString.Key.font: UIFont.headline!, NSAttributedString.Key.foregroundColor: UIColor.blueGray900]
        backgroundColor = .blueGray0
        barTintColor = .blueGray900
        refreshAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
    }

    public override func setBackgroundImage(_ backgroundImage: UIImage?, for barMetrics: UIBarMetrics) {
        super.setBackgroundImage(backgroundImage, for: barMetrics)
        self.backgroundImage = backgroundImage
        refreshAppearance()
    }

    private func refreshAppearance() {
        let appearance = UINavigationBarAppearance()

        if isTranslucent {
            appearance.configureWithTransparentBackground()
        }

        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.headline!, NSAttributedString.Key.foregroundColor: UIColor.blueGray900]
        appearance.backgroundImage = backgroundImage
        appearance.shadowImage = nil
        scrollEdgeAppearance = appearance
        standardAppearance = appearance
    }
}
