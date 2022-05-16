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
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1
        layer.masksToBounds = false

    }
    
    func addRadius(amount: CGFloat, withBorderAmount borderWidthAmount: CGFloat, andColor borderColor: UIColor) {
                clipsToBounds = true
            self.layer.cornerRadius = amount
            self.layer.borderWidth = borderWidthAmount
            self.layer.borderColor = borderColor.cgColor
            self.layer.masksToBounds = true

        }
    
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.cornerRadius = frame.height / 2
        gradient.borderWidth = 2
        gradient.borderColor = UIColor.systemOrange.cgColor
        gradient.colors = [UIColor.systemGreen.cgColor, UIColor.systemOrange.cgColor]
        layer.insertSublayer(gradient, at: 0)
    }
}