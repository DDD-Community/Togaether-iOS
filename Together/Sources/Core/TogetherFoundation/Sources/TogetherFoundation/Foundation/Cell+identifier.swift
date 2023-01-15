//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/14.
//

import UIKit

public protocol ReusableIdentifier: AnyObject {
    static var identifier: String { get }
}

public extension ReusableIdentifier where Self: UIView {
    static var identifier: String { return String(describing: self) }
}

extension UITableViewCell: ReusableIdentifier { }
extension UICollectionViewCell: ReusableIdentifier { }
