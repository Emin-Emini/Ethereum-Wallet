//
//  CALayer+Extension.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 29.05.2022..
//

import UIKit

extension CALayer {
    func applySketchShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4, spread: CGFloat = 0) {
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2.0
        
    if spread == 0 {
      shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
    
    func applyLightShadow() {
        applySketchShadow(
        color: .black,
        alpha: 0.07,
        x: 0,
        y: 2,
        blur: 5,
        spread: 0)
    }
    
    func applyNotificationCellShadow() {
        applySketchShadow(
        color: .black,
        alpha: 0.13,
        x: 0,
        y: 1,
        blur: 5,
        spread: 0)
    }
    
    func setContainerShadow() {
        applySketchShadow(
        color: .black,
        alpha: 0.07,
        x: 0,
        y: 7,
        blur: 64,
        spread: 0)
    }
    
}

