//
//  TogetherCard.swift
//  
//
//  Created by denny on 2023/01/02.
//

import Foundation
import SwiftLayout
import TogetherCore
import TogetherUI
import ThirdParty
import UIKit

protocol TogetherCardDelegate: AnyObject {
    func didSelectCard(card: TogetherCard)
    func didMoveToRight(card: TogetherCard)
    func didMoveToLeft(card: TogetherCard)
    func currentCardStatus(card: TogetherCard, distance: CGFloat)
    func didCancelMove(card: TogetherCard)
}

public class TogetherCard: UIView {
    private let theresoldMargin = (UIScreen.main.bounds.size.width / 2) * 0.75
    private let stength : CGFloat = 4
    private let range : CGFloat = 0.90

    public var index: Int?
    public var isFirstCard: Bool = false

    private var overlay: PuppyContentView?
    private var containerView : UIView!
    weak var delegate: TogetherCardDelegate?

    private var centerOfX: CGFloat = 0.0
    private var centerOfY: CGFloat = 0.0
    private var originalPoint = CGPoint.zero

    private var isLiked = false
    public var model : PuppyModel?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.cornerRadius = 24
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0.5, height: 3)
        layer.shadowColor = UIColor.darkGray.cgColor
        clipsToBounds = true
        backgroundColor = .white
        originalPoint = center

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)

        containerView = UIView(frame: bounds)
        containerView.backgroundColor = .clear
    }

    func updateContentsFrame() {
        UIView.animate(withDuration: 0.5, animations: {
            self.overlay?.frame = self.bounds
            self.containerView.frame = self.bounds

            print("self.isFirstCard: \(self.isFirstCard)")
            if self.isFirstCard {
                self.overlay?.layoutIfNeeded()
            }
        })
    }

    func addContentView(view: PuppyContentView?) {
        if let strongView = view {
            self.overlay = strongView
            strongView.likeHandler = {
                self.moveToRight()
            }
            self.insertSubview(strongView, belowSubview: containerView)
        }
    }

    func didMoveToRight() {
        delegate?.didMoveToRight(card: self)
        let finishPoint = CGPoint(x: frame.size.width * 2, y: 2 * centerOfY + originalPoint.y)
        UIView.animate(withDuration: 0.5, animations: {
            self.center = finishPoint
        }, completion: {(_) in
            self.removeFromSuperview()
        })
        isLiked = true
    }

    func didMoveToLeft() {
        delegate?.didMoveToLeft(card: self)
        let finishPoint = CGPoint(x: -frame.size.width * 2, y: 2 * centerOfY + originalPoint.y)
        UIView.animate(withDuration: 0.5, animations: {
            self.center = finishPoint
        }, completion: {(_) in
            self.removeFromSuperview()
        })
        isLiked = false
    }

    func moveToRight() {
        let finishPoint = CGPoint(x: frame.size.width * 2, y: 2 * centerOfY + originalPoint.y)

        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.overlay?.updateOverlayAlpha(alpha: 1.0)
            self.animateCard(to: finishPoint, angle: 1)
        }, completion: {(_ complete: Bool) -> Void in
            self.removeFromSuperview()
        })
        isLiked = true
        delegate?.didMoveToRight(card: self)
    }

    func shakeAnimationCard(completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5,
                       animations: {() -> Void in
            let finishPoint = CGPoint(x: self.center.x - (self.frame.size.width / 2),
                                      y: self.center.y)
            self.animateCard(to: finishPoint, angle: -0.2)
        }, completion: {(_) -> Void in
            UIView.animate(withDuration: 0.5,
                           animations: {() -> Void in
                self.animateCard(to: self.originalPoint)
            }, completion: {(_ complete: Bool) -> Void in
                UIView.animate(withDuration: 0.5,
                               animations: {() -> Void in
                    let finishPoint = CGPoint(x: self.center.x + (self.frame.size.width / 2) ,y: self.center.y)
                    self.overlay?.updateOverlayAlpha(alpha: 1.0)
                    self.animateCard(to: finishPoint , angle: 0.2)
                }, completion: {(_ complete: Bool) -> Void in
                    UIView.animate(withDuration: 0.5,
                                   animations: {() -> Void in
                        self.overlay?.updateOverlayAlpha(alpha: 0.0)
                        self.animateCard(to: self.originalPoint)
                    }, completion: {(_ complete: Bool) -> Void in
                        completion(true)
                    })
                })
            })
        })
    }

    private func animateCard(to center: CGPoint, angle: CGFloat = 0) {
        self.center = center
        self.transform = CGAffineTransform(rotationAngle: angle)
    }
}

extension TogetherCard: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc
    private func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        centerOfX = gestureRecognizer.translation(in: self).x
        centerOfY = gestureRecognizer.translation(in: self).y

        switch gestureRecognizer.state {
        case .began:
            originalPoint = self.center;
            addSubview(containerView)
            self.delegate?.didSelectCard(card: self)
            break

        case .changed:
            let rotationStrength = min(centerOfX / UIScreen.main.bounds.size.width, 1)
            let rotationAngel = .pi/8 * rotationStrength
            let scale = max(1 - abs(rotationStrength) / stength, range)
            center = CGPoint(x: originalPoint.x + centerOfX, y: originalPoint.y + centerOfY)
            let transforms = CGAffineTransform(rotationAngle: rotationAngel)
            let scaleTransform: CGAffineTransform = transforms.scaledBy(x: scale, y: scale)
            self.transform = scaleTransform
            updateOverlay(centerOfX)
            break

        case .ended:
            containerView.removeFromSuperview()
            afterSwipeAction()
            break

        case .possible, .cancelled, .failed:
            break
        default:
            fatalError()
        }
    }

    private func afterSwipeAction() {
        if centerOfX > theresoldMargin {
            didMoveToRight()
        } else if centerOfX < -theresoldMargin {
            didMoveToLeft()
        } else {
            self.delegate?.didCancelMove(card: self)
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 1.0,
                           options: [],
                           animations: {
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
                self.overlay?.updateOverlayAlpha(alpha: 0)
            })
        }
    }

    private func updateOverlay(_ distance: CGFloat) {
        if distance > 0 {
            self.overlay?.updateOverlayAlpha(alpha: min(abs(distance) / 100, 0.8))
        } else {
            self.overlay?.updateOverlayAlpha(alpha: 0)
        }
        delegate?.currentCardStatus(card: self, distance: distance)
    }
}
