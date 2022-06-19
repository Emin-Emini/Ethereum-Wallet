//
//  UIButton+Extension.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 27.05.2022..
//

import UIKit

extension UIButton {
    func setStyle(fillColor: UIColor, title: String, titleColor: UIColor = .white, fontSize: CGFloat) {
        self.filledStyle(color: fillColor, title: title, titleColor: titleColor, fontSize: fontSize)
    }
    
    private func filledStyle(color: UIColor, title: String, titleColor: UIColor, fontSize: CGFloat) {
        self.layer.cornerRadius = self.frame.height/2
        self.backgroundColor = color
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        self.setTitleColor(titleColor, for: .normal)
        self.tintColor = titleColor
    }
    
    func enable(fillColor: UIColor, textColor: UIColor = .white) {
        self.backgroundColor = fillColor
        
        self.setTitleColor(textColor, for: .normal)
        self.tintColor = textColor
        self.isEnabled = true
    }
    
    func disable(textColor: UIColor = .grey3) {
        self.backgroundColor = .grey4
        
        self.setTitleColor(textColor, for: .normal)
        self.tintColor = textColor
        self.isEnabled = false
    }
}
