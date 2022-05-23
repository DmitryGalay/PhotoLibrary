//
//  UIColor+Extension.swift
//  PhotoLibrary
//
//  Created by Dima on 23.05.22.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init?(hex:String) {
        var hexSanitied = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitied = hexSanitied.replacingOccurrences(of: "#", with: "")
        
        let leght = hexSanitied.count
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        guard Scanner(string: hexSanitied).scanHexInt64(&rgb) else {return nil}
        
        if leght == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        }else if  leght == 8 {
            r = CGFloat((rgb & 0xFF0000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 16) / 255.0
            b =  CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x0000FF) / 255.0
            
        }else  {
            return nil
        }
        self.init(red: r, green: g, blue: b, alpha: a )
    }
}
