//
//  Extension+UiView.swift
//  PhotoLibrary
//
//  Created by Dima on 16.05.22.
//

import Foundation
import UIKit

extension UIView {
    
    func addShadow() {
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 7
        layer.shadowOpacity = 0.7
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.masksToBounds = false
    }
    
    func addRadius(amount: CGFloat, withBorderAmount borderWidthAmount: CGFloat, andColor borderColor: UIColor) {
        clipsToBounds = true
        self.layer.cornerRadius = amount
        self.layer.borderWidth = borderWidthAmount
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = true
    }
    
    func addGradient(customArray:CGColor) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.cornerRadius = frame.height / 2
        gradient.borderWidth = 2
        gradient.borderColor = UIColor.systemOrange.cgColor
        gradient.colors = customArray as! [Any]
        layer.insertSublayer(gradient, at: 0)
    }
}
