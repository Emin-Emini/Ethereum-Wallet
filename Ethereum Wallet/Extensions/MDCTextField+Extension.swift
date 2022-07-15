//
//  MDCTextField+Extension.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 27.05.2022..
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextFields

extension MDCFilledTextField {
    func defaultStyle(label: String = "", placeholder: String = "") {
        self.backgroundColor = .clear
        self.label.text = label
        self.placeholder = placeholder
        
        self.setFilledBackgroundColor(.clear, for: .normal)
        self.setFilledBackgroundColor(.clear, for: .editing)
                
        self.label.font = UIFont.systemFont(ofSize: 15)
        self.setNormalLabelColor(.secondaryLabel, for: .normal)
        self.setFloatingLabelColor(.label, for: .editing)
        self.setFloatingLabelColor(.label, for: .normal)
                
        self.font = UIFont.systemFont(ofSize: 15)
        self.setTextColor(.label, for: .editing)
        self.setTextColor(.label, for: .normal)
        
        self.leadingAssistiveLabel.font = UIFont.systemFont(ofSize: 13)
        self.setLeadingAssistiveLabelColor(.secondaryLabel, for: .editing)
                
        self.setUnderlineColor(.secondaryLabel, for: .normal)
        self.setUnderlineColor(.primaryBlue, for: .editing)
    }
    
    func showErrorMessage(message: String) {
        self.leadingAssistiveLabel.text = message
        
        self.setUnderlineColor(.red, for: .normal)
        self.setUnderlineColor(.red, for: .editing)
        self.setFloatingLabelColor(.red, for: .normal)
        self.setFloatingLabelColor(.red, for: .editing)
        self.setLeadingAssistiveLabelColor(.red, for: .normal)
        self.setLeadingAssistiveLabelColor(.red, for: .editing)
    }
    
    func hideErrorMessage() {
        hideUnderlineMessage()
    }
    
    func showUnderlineMessage(message: String) {
        self.leadingAssistiveLabel.text = message
        
        normalLayout()
    }
    
    func hideUnderlineMessage() {
        self.leadingAssistiveLabel.text = ""
        
        normalLayout()
    }
    
    func hideUnderline() {
        self.setUnderlineColor(.clear, for: .normal)
    }
    
    func showUnderline() {
        self.setUnderlineColor(.secondaryLabel, for: .normal)
        self.setUnderlineColor(.primaryBlue, for: .editing)
    }
    
    private func normalLayout() {
        self.setUnderlineColor(.secondaryLabel, for: .normal)
        self.setUnderlineColor(.primaryBlue, for: .editing)
        self.setFloatingLabelColor(.label, for: .normal)
        self.setFloatingLabelColor(.label, for: .editing)
        self.setLeadingAssistiveLabelColor(.secondaryLabel, for: .normal)
        self.setLeadingAssistiveLabelColor(.secondaryLabel, for: .editing)
    }
}

extension MDCOutlinedTextField {
    func defaultStyle(label: String = "", placeholder: String = "") {
        self.backgroundColor = .clear
        self.label.text = label
        self.placeholder = placeholder
        
        self.setOutlineColor(.secondaryLabel, for: .normal)
        self.setOutlineColor(.primaryBlue, for: .editing)
                
        self.label.font = UIFont.systemFont(ofSize: 15)
        self.setNormalLabelColor(.secondaryLabel, for: .normal)
        self.setFloatingLabelColor(.label, for: .editing)
        self.setFloatingLabelColor(.label, for: .normal)
                
        self.font = UIFont.systemFont(ofSize: 15)
        self.setTextColor(.label, for: .editing)
        self.setTextColor(.label, for: .normal)
        
        self.leadingAssistiveLabel.font = UIFont.systemFont(ofSize: 12)
        self.setLeadingAssistiveLabelColor(.secondaryLabel, for: .editing)
    }
    
    func showErrorMessage(message: String) {
        self.leadingAssistiveLabel.text = message
        
        self.setOutlineColor(.red, for: .normal)
        self.setOutlineColor(.red, for: .editing)
        self.setFloatingLabelColor(.red, for: .normal)
        self.setFloatingLabelColor(.red, for: .editing)
        self.setLeadingAssistiveLabelColor(.red, for: .normal)
        self.setLeadingAssistiveLabelColor(.red, for: .editing)
    }
    
    func hideErrorMessage() {
        hideUnderlineMessage()
    }
    
    func showUnderlineMessage(message: String) {
        self.leadingAssistiveLabel.text = message
        
        normalLayout()
    }
    
    func hideUnderlineMessage() {
        self.leadingAssistiveLabel.text = ""
        
        normalLayout()
    }
    
    func setCorrectLayout() {
        self.setOutlineColor(.green, for: .normal)
        self.setOutlineColor(.primaryBlue, for: .editing)
        self.setFloatingLabelColor(.green, for: .normal)
        self.setFloatingLabelColor(.primaryBlue, for: .editing)
        self.setLeadingAssistiveLabelColor(.green, for: .normal)
        self.setLeadingAssistiveLabelColor(.primaryBlue, for: .editing)
    }
    
    private func normalLayout() {
        self.setOutlineColor(.secondaryLabel, for: .normal)
        self.setOutlineColor(.primaryBlue, for: .editing)
        self.setFloatingLabelColor(.label, for: .normal)
        self.setFloatingLabelColor(.label, for: .editing)
        self.setLeadingAssistiveLabelColor(.secondaryLabel, for: .normal)
        self.setLeadingAssistiveLabelColor(.secondaryLabel, for: .editing)
    }
    
    func isMnemonicWordValid(with word: String) -> Bool {
        guard let text = self.text,
              !text.isEmpty else {
            showErrorMessage(message: "Please fill the field.")
            return false
        }

        guard text.contains(word) else {
            showErrorMessage(message: "Wrong word. Please check again.")
            return false
        }

        hideErrorMessage()
        setCorrectLayout()
        return true
    }
}
