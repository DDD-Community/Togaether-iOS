//
//  File.swift
//  
//
//  Created by denny on 2023/01/02.
//

import UIKit

public class GradientView: UIView {
    private var gradientLayer: CAGradientLayer!

    public var topColor: UIColor = .red {
        didSet {
            setNeedsLayout()
        }
    }

    public var bottomColor: UIColor = .yellow {
        didSet {
            setNeedsLayout()
        }
    }

    public var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    public var startPointY: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }

    public var endPointX: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }

    public var endPointY: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }

    public override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    public override func layoutSubviews() {
        self.gradientLayer = self.layer as? CAGradientLayer
        self.gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        self.gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        self.gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        self.layer.cornerRadius = cornerRadius

    }
}
