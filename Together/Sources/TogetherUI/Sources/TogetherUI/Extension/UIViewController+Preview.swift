//
//  File.swift
//  
//
//  Created by 한상진 on 2023/01/01.
//

import UIKit
import SwiftUI

extension UIViewController {
    public struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        public func makeUIViewController(context: Context) -> some UIViewController { viewController }
        public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    }
    
    @ViewBuilder
    public func showPrieview(deviceName: String? = nil) -> some View {
        if let deviceName {
            let device = PreviewDevice(rawValue: deviceName)
            Preview(viewController: self).previewDevice(device)
        } else {
            Preview(viewController: self)
        }
    }
}

extension UIView {
    public struct Preview: UIViewRepresentable {
        let view: UIView
        
        public func makeUIView(context: Context) -> some UIView { view }
        public func updateUIView(_ uiView: UIViewType, context: Context) { }
    }
    
    @ViewBuilder
    public func showPrieview(deviceName: String? = nil) -> some View {
        if let deviceName {
            let device = PreviewDevice(rawValue: deviceName)
            Preview(view: self).previewDevice(device)
        } else {
            Preview(view: self)
        }
    }
}


