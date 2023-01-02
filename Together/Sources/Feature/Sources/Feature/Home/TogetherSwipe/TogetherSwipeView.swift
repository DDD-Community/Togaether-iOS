//
//  TogetherSwipeView.swift
//  
//
//  Created by denny on 2023/01/02.
//

import TogetherCore
import TogetherFoundation
import TogetherUI
import SwiftLayout
import UIKit

public protocol TogetherSwipeViewDelegate: AnyObject {
    func swipeGuideAnimationFinish()
    func currentCardStatus(card: TogetherCard, distance: CGFloat)
    func didCancelMove(model: PuppyModel)
    func didSelectCard(model: PuppyModel)
    func didMoveToLeft(model: PuppyModel)
    func didMoveToRight(model: PuppyModel)
    func undoCurrentCard(model: PuppyModel)
    func didReachLastCard()
}

public class TogetherSwipeView: UIView {
    private let inset: CGFloat = 16

    var cardBufferSize: Int = 3 {
        didSet {
            cardBufferSize = cardBufferSize > 3 ? 3 : cardBufferSize
        }
    }
    public var seperatorSpacing: CGFloat = 8
    var index = 0

    private var allCards = [PuppyModel]()
    private var loadedCards = [TogetherCard]()
    private var currentCard: TogetherCard!

    public weak var delegate: TogetherSwipeViewDelegate?
    private let contentView: ContentView?

    public typealias ContentView = (_ index: Int, _ frame: CGRect, _ element: PuppyModel) -> (UIView)

    public init(frame: CGRect,
                contentView: @escaping ContentView, cardBufferSize : Int = 3) {
        self.contentView = contentView
        self.cardBufferSize = cardBufferSize
        super.init(frame: frame)
    }

    override private init(frame: CGRect) {
        fatalError("Please use init(frame:,overlayGenerator)")
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("Please use init(frame:,overlayGenerator)")
    }

    public func showTogetherCards(with elements: [PuppyModel] ,isDummyShow: Bool = true) {
        if elements.isEmpty {
            return
        }

        allCards.append(contentsOf: elements)

        for (index, element) in elements.enumerated() {
            if loadedCards.count < cardBufferSize {
                let cardView = self.createTogetherCard(index: index, element: element)
                if loadedCards.isEmpty {
                    self.addSubview(cardView)
                } else {
                    self.insertSubview(cardView, belowSubview: loadedCards.last!)
                }
                loadedCards.append(cardView)
            }
        }

        animateCardAfterSwiping()

        if isDummyShow{
            perform(#selector(loadAnimation), with: nil, afterDelay: 1.0)
        }
    }

    private func createTogetherCard(index: Int, element: PuppyModel) -> TogetherCard {
        let card = TogetherCard(frame: CGRect(x: inset, y: inset + (CGFloat(loadedCards.count) * self.seperatorSpacing), width: bounds.width - (inset * 2), height: bounds.height - (CGFloat(cardBufferSize) * seperatorSpacing) - (inset * 2) ))
        card.delegate = self
        card.model = element
        card.addContentView(view: (self.contentView?(index, card.bounds, element)))
        return card
    }

    private func animateCardAfterSwiping() {
        if loadedCards.isEmpty{
            self.delegate?.didReachLastCard()
            return
        }

        for (index, card) in loadedCards.enumerated() {
            UIView.animate(withDuration: 0.5, animations: {
                card.isUserInteractionEnabled = index == 0 ? true : false
                var frame = card.frame
                frame.origin.y = self.inset + (CGFloat(index) * self.seperatorSpacing)
                card.frame = frame
            })
        }
    }

    @objc
    private func loadAnimation() {
        guard let dummyCard = loadedCards.first else {
            return
        }

        dummyCard.shakeAnimationCard(completion: { (_) in
            self.delegate?.swipeGuideAnimationFinish()
        })
    }

    private func removeCardAndAddNewCard() {
        index += 1
        let card = loadedCards.first!
        card.index = index
        loadedCards.remove(at: 0)

        if (index + loadedCards.count) < allCards.count {
            let tinderCard = createTogetherCard(index: index + loadedCards.count, element: allCards[index + loadedCards.count])
            self.insertSubview(tinderCard, belowSubview: loadedCards.last!)
            loadedCards.append(tinderCard)
        }

        animateCardAfterSwiping()
    }
}

extension TogetherSwipeView: TogetherCardDelegate {
    func didSelectCard(card: TogetherCard) {
        self.delegate?.didSelectCard(model: card.model!)
    }

    func didCancelMove(card: TogetherCard) {
        self.delegate?.didCancelMove(model: card.model!)
    }

    func didMoveToRight(card: TogetherCard) {
        removeCardAndAddNewCard()
        self.delegate?.didMoveToRight(model: card.model!)
    }

    func didMoveToLeft(card: TogetherCard) {
        removeCardAndAddNewCard()
        self.delegate?.didMoveToLeft(model: card.model!)
    }

    func currentCardStatus(card: TogetherCard, distance: CGFloat) {
        self.delegate?.currentCardStatus(card: card, distance: distance)
    }
}
