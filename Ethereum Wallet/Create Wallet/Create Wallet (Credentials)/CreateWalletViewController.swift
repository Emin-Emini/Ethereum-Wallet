//
//  CreateWalletViewController.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 27.05.2022..
//

import UIKit
import SwiftKeychainWrapper
import MaterialComponents.MaterialTextControls_FilledTextFields

class CreateWalletViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var walletNameTextField: MDCFilledTextField!
    @IBOutlet weak var passTextField: MDCFilledTextField!
    @IBOutlet weak var passButton: UIButton!
    @IBOutlet weak var confirmPassTextField: MDCFilledTextField!
    @IBOutlet weak var confirmPassButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTextFields()
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KeychainWrapper.standard.removeObject(forKey: "walletName")
        KeychainWrapper.standard.removeObject(forKey: "spendingPassword")
        KeychainWrapper.standard.removeObject(forKey: "walletMnemonics")
        KeychainWrapper.standard.removeObject(forKey: "walletAddresses")
    }
    
    // MARK: - Actions
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        KeychainWrapper.standard.removeObject(forKey: "walletName")
        KeychainWrapper.standard.removeObject(forKey: "spendingPassword")
        KeychainWrapper.standard.removeObject(forKey: "walletMnemonics")
        KeychainWrapper.standard.removeObject(forKey: "walletAddresses")
    }
    
    @IBAction func passwordButton(_ sender: Any) {
        passViewTap(sender: sender as! UIButton, textField: passTextField)
    }
    
    @IBAction func confirmPasswordButton(_ sender: Any) {
        passViewTap(sender: sender as! UIButton, textField: confirmPassTextField)
    }
    
    @IBAction func continueButton(_ sender: Any) {
        KeychainWrapper.standard.set(walletNameTextField.text!, forKey: "walletName")
        KeychainWrapper.standard.set(passTextField.text!, forKey: "spendingPassword")
    }
    
}

// MARK: - Text Field
extension CreateWalletViewController: UITextFieldDelegate {
    
    func setupTextFields() {
        walletNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        passTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPassTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        setupTextFieldsLayout()
    }
    
    func setupTextFieldsLayout() {
        walletNameTextField.defaultStyle(label: "Wallet name", placeholder: "")
        walletNameTextField.delegate = self
        
        passTextField.defaultStyle(label: "Spending password", placeholder: "**********")
        passTextField.showUnderlineMessage(message: "Minimum 10 characters.")
        passTextField.isSecureTextEntry = true
        passTextField.delegate = self
        
        confirmPassTextField.defaultStyle(label: "Repeat spending password", placeholder: "**********")
        confirmPassTextField.isSecureTextEntry = true
        confirmPassTextField.delegate = self
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard !walletNameTextField.text!.isEmpty else {
            continueButton.disable()
            return
        }
        guard passTextField.text!.count >= 10 else {
            continueButton.disable()
            if !passTextField.text!.isEmpty {
                passTextField.showErrorMessage(message: "Minimum 10 characters.")
            }
            return
        }
        passTextField.showUnderlineMessage(message: "Minimum 10 characters.")
        guard confirmPassTextField.text!.count >= 10 && confirmPassTextField.text == passTextField.text else {
            if !confirmPassTextField.text!.isEmpty {
                confirmPassTextField.showErrorMessage(message: "Password do not match.")
            }
            continueButton.disable()
            return
        }
        confirmPassTextField.hideErrorMessage()
        continueButton.enable(fillColor: .primaryBlue)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case passTextField, confirmPassTextField:
            if (string == " ") {
                return false
            }
            break
        default:
            break
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Show/Hide Password Functions
extension CreateWalletViewController {
    func passViewTap(sender: UIButton, textField: MDCFilledTextField) {
        sender.isSelected = !sender.isSelected
        textField.isSecureTextEntry = !sender.isSelected
    }
}

// MARK: - Buttons Functions
extension CreateWalletViewController {
    func setupButtons() {
        passButton.setImage(UIImage(named: "ic-eyeOn"), for: .selected)
        passButton.setImage(UIImage(named: "ic-eyeOff"), for: .normal)
        confirmPassButton.setImage(UIImage(named: "ic-eyeOn"), for: .selected)
        confirmPassButton.setImage(UIImage(named: "ic-eyeOff"), for: .normal)
        
        continueButton.setStyle(fillColor: .primaryBlue, title: "CONTINUE", fontSize: 16)
        continueButton.disable()
    }
}
