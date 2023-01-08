//
//  File.swift
//  
//
//  Created by 한상진 on 2022/12/30.
//

import UIKit
import Combine

public extension UIControl {
    
    class InteractionSubscription<S: Subscriber>: Subscription where S.Input == Void {
        
        private let subscriber: S?
        private let control: UIControl
        private let event: UIControl.Event
        
        init(subscriber: S,
             control: UIControl,
             event: UIControl.Event) {
            
            self.subscriber = subscriber
            self.control = control
            self.event = event
            
            self.control.addTarget(self, action: #selector(handleEvent), for: event)
        }
        
        @objc func handleEvent(_ sender: UIControl) {
            _ = self.subscriber?.receive(())
        }
        
        public func request(_ demand: Subscribers.Demand) {}
        
        public func cancel() {}
    }
    
    struct InteractionPublisher: Publisher {
        
        public typealias Output = Void
        public typealias Failure = Never
        
        private let control: UIControl
        private let event: UIControl.Event
        
        init(control: UIControl, event: UIControl.Event) {
            self.control = control
            self.event = event
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Void == S.Input {
            
            let subscription = InteractionSubscription(
                subscriber: subscriber,
                control: control,
                event: event
            )
            
            subscriber.receive(subscription: subscription)
        }
    }
    
    func publisher(for event: UIControl.Event) -> UIControl.InteractionPublisher {
        
        return InteractionPublisher(control: self, event: event)
    }
    
}

extension UIButton {
    public var tapPublisher: InteractionPublisher {
        return publisher(for: .touchUpInside)
    }
    
    public var throttleTap: AnyPublisher<(), Never> {
        return publisher(for: .touchUpInside)
            .throttle(for: .seconds(0.3), scheduler: RunLoop.main, latest: false)
            .eraseToAnyPublisher()
    }
}

extension UITapGestureRecognizer {
    public struct GesturePublisher<TapRecognizer: UITapGestureRecognizer>: Publisher {
        public typealias Output = TapRecognizer
        public typealias Failure = Never
        
        private let recognizer: TapRecognizer
        private let view: UIView
        
        public init(recognizer: TapRecognizer, view: UIView) {
            self.recognizer = recognizer
            self.view = view
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, TapRecognizer == S.Input {
            let subscription = GestureSubscription(
                subscriber: subscriber,
                recognizer: recognizer,
                view: view
            )
            subscriber.receive(subscription: subscription)
        }
    }
}

extension UITapGestureRecognizer {
  final class GestureSubscription<S: Subscriber, TapRecognizer: UITapGestureRecognizer>: Subscription
  where S.Input == TapRecognizer {
    private var subscriber: S?
    private let recognizer: TapRecognizer
    
    init(subscriber: S, recognizer: TapRecognizer, view: UIView) {
      self.subscriber = subscriber
      self.recognizer = recognizer
      recognizer.addTarget(self, action: #selector(eventHandler))
      view.addGestureRecognizer(recognizer)
    }
    
    func request(_ demand: Subscribers.Demand) {}
    
    func cancel() {
      subscriber = nil
    }
    
    @objc func eventHandler() {
      _ = subscriber?.receive(recognizer)
    }
  }
}

extension UIView {
    public var throttleTapGesture: Publishers.Throttle<UITapGestureRecognizer.GesturePublisher<UITapGestureRecognizer>, RunLoop> {
        return UITapGestureRecognizer.GesturePublisher(recognizer: .init(), view: self)
            .throttle(
                for: .seconds(1),
                scheduler: RunLoop.main,
                latest: false
            )
    }
}
