//
//  UIColor+Extension.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 27.05.2022..
//

import UIKit

extension UIColor {
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
    //Remove
    
    //Primary
    static let primaryBlue = rgb(70, 82, 246) //rgb(0, 210, 255)
    static let brightSkyBlue3 = rgb(191, 244, 255)
    static let brightCyanBlue = rgb(62, 207, 253)
    static let paleSkyBlue = rgb(187, 235, 251)
    
    //Neutral
    static let neutralDark = rgb(24, 25, 26)
    static let grey1 = rgb(95, 97, 103)
    static let grey2 = rgb(148, 149, 153)
    static let grey3 = rgb(184, 184, 189)
    static let grey4 = rgb(242, 242, 247)
    
    //Transactions
    static let grey = rgb(184, 184, 189)
    static let green = rgb(6, 214, 160)
    static let red = rgb(224, 75, 129)
    static let red2 = rgb(216, 17, 89)
    static let orange = rgb(243, 146, 55)
    
    static let greyBG =  rgb(230, 230, 233)
    static let greenBG = rgb(189, 241, 227) //57, 227, 77
    static let redBG = rgb(241, 191, 209)
    
    //Gradient
    static let blueOne = rgb(0, 210, 255)
    static let blueTwo = rgb(25, 172, 237)
    
}
