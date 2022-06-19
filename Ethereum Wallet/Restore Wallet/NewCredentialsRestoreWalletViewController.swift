//
//  NewCredentialsRestoreWalletViewController.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 29.05.2022..
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextFields
import SwiftKeychainWrapper

class NewCredentialsRestoreWalletViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var walletNameTextField: MDCFilledTextField!
    @IBOutlet weak var walletPassTextField: MDCFilledTextField!
    @IBOutlet weak var passButton: UIButton!
    @IBOutlet weak var confirmWalletPassTextField: MDCFilledTextField!
    @IBOutlet weak var confirmPassButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupTextFields()
        setupButtons()
    }

    // MARK: - Actions
    @IBAction func passwordButton(_ sender: Any) {
        passViewTap(sender: sender as! UIButton, textField: walletPassTextField)
    }
    
    @IBAction func confirmPasswordButton(_ sender: Any) {
        passViewTap(sender: sender as! UIButton, textField: confirmWalletPassTextField)
    }
    @IBAction func confirmRestoringWallet(_ sender: Any) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        KeychainWrapper.standard.set(walletNameTextField.text!, forKey: "walletName")
        KeychainWrapper.standard.set(walletPassTextField.text!, forKey: "spendingPassword")
        KeychainWrapper.standard.set(arrayOfAddresses.first ?? "", forKey: "walletAddresses")
        KeychainWrapper.standard.set(restoreMnemonics, forKey: "walletMnemonics")
    }
}

// MARK: - Text Fields
extension NewCredentialsRestoreWalletViewController: UITextFieldDelegate {
    
    func setupTextFields() {
        walletNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        walletPassTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmWalletPassTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        setupTextFieldsLayout()
    }
    
    func setupTextFieldsLayout() {
        walletNameTextField.defaultStyle(label: "Wallet name", placeholder: "")
        walletNameTextField.delegate = self
        
        walletPassTextField.defaultStyle(label: "Spending password", placeholder: "**********")
        walletPassTextField.showUnderlineMessage(message: "Minimum 10 characters.")
        walletPassTextField.isSecureTextEntry = true
        walletPassTextField.delegate = self
        
        confirmWalletPassTextField.defaultStyle(label: "Repeat spending password", placeholder: "**********")
        confirmWalletPassTextField.isSecureTextEntry = true
        confirmWalletPassTextField.delegate = self
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard !walletNameTextField.text!.isEmpty else {
            continueButton.disable()
            return
        }
        guard walletPassTextField.text!.count >= 10 else {
            continueButton.disable()
            if !walletPassTextField.text!.isEmpty {
                walletPassTextField.showErrorMessage(message: "Minimum 10 characters.")
            }
            return
        }
        walletPassTextField.showUnderlineMessage(message: "Minimum 10 characters.")
        guard confirmWalletPassTextField.text!.count >= 10 && confirmWalletPassTextField.text == walletPassTextField.text else {
            if !confirmWalletPassTextField.text!.isEmpty {
                confirmWalletPassTextField.showErrorMessage(message: "Password do not match.")
            }
            continueButton.disable()
            return
        }
        confirmWalletPassTextField.hideErrorMessage()
        continueButton.enable(fillColor: .primaryBlue)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case walletPassTextField, confirmWalletPassTextField:
            if (string == " ") {
                return false
            }
            break
        default:
            break
        }
        return true
    }
}

// MARK: - Buttons Functions
extension NewCredentialsRestoreWalletViewController {
    func setupButtons() {
        passButton.setImage(UIImage(named: "ic-eyeOnn"), for: .normal)
        passButton.setImage(UIImage(named: "ic-eyeOff"), for: .selected)
        confirmPassButton.setImage(UIImage(named: "ic-eyeOn"), for: .normal)
        confirmPassButton.setImage(UIImage(named: "ic-eyeOff"), for: .selected)
        
        continueButton.setStyle(fillColor: .primaryBlue, title: "CONTINUE", fontSize: 16)
        continueButton.disable()
    }
}

// MARK: - Show/Hide Password Functions
extension NewCredentialsRestoreWalletViewController {
    func passViewTap(sender: UIButton, textField: MDCFilledTextField) {
        sender.isSelected = !sender.isSelected
        textField.isSecureTextEntry = !sender.isSelected
    }
}
