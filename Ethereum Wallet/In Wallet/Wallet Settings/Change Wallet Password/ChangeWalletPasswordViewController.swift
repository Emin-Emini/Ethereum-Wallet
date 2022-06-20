//
//  ChangeWalletPasswordViewController.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 19.06.2022..
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextFields
import SwiftKeychainWrapper

class ChangeWalletPasswordViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var oldPasswordTextField: MDCFilledTextField!
    @IBOutlet weak var oldPassButton: UIButton!
    @IBOutlet weak var newPasswordTextField: MDCFilledTextField!
    @IBOutlet weak var newPassButton: UIButton!
    @IBOutlet weak var confirmNewPasswordTextField: MDCFilledTextField!
    @IBOutlet weak var confirmNewPassButton: UIButton!
    @IBOutlet weak var saveChangeButton: UIButton!
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupTextFields()
        setupButtons()
        
        tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Actions
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func oldPasswordButton(_ sender: Any) {
        passViewTap(sender: sender as! UIButton, textField: oldPasswordTextField)
    }
    
    @IBAction func newPasswordButton(_ sender: Any) {
        passViewTap(sender: sender as! UIButton, textField: newPasswordTextField)
    }
    
    @IBAction func confirmPassButton(_ sender: Any) {
        passViewTap(sender: sender as! UIButton, textField: confirmNewPasswordTextField)
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        KeychainWrapper.standard.set(newPasswordTextField.text!, forKey: "spendingPassword")
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

// MARK: - Text Field
extension ChangeWalletPasswordViewController: UITextFieldDelegate {
    
    func setupTextFields() {
        oldPasswordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        newPasswordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmNewPasswordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        setupTextFieldsLayout()
    }
    
    func setupTextFieldsLayout() {
        oldPasswordTextField.defaultStyle(label: "Old spending password", placeholder: "**********")
        oldPasswordTextField.isSecureTextEntry = true
        oldPasswordTextField.delegate = self
        
        newPasswordTextField.defaultStyle(label: "New spending password", placeholder: "**********")
        newPasswordTextField.showUnderlineMessage(message: "Minimum 10 characters.")
        newPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.delegate = self
        
        confirmNewPasswordTextField.defaultStyle(label: "Repeat new spending password", placeholder: "**********")
        confirmNewPasswordTextField.isSecureTextEntry = true
        confirmNewPasswordTextField.delegate = self
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard oldPasswordTextField.text!.count >= 10 else {
            saveChangeButton.disable()
            if !oldPasswordTextField.text!.isEmpty {
                oldPasswordTextField.showErrorMessage(message: "Wrong password.")
            }
            return
        }
        let keychainWalletPassword = KeychainWrapper.standard.string(forKey: "spendingPassword")
        guard oldPasswordTextField.text! == keychainWalletPassword else {
            saveChangeButton.disable()
            oldPasswordTextField.showErrorMessage(message: "Wrong password.")
            return
        }
        oldPasswordTextField.hideErrorMessage()
        
        guard newPasswordTextField.text!.count >= 10 else {
            saveChangeButton.disable()
            if !newPasswordTextField.text!.isEmpty {
                newPasswordTextField.showErrorMessage(message: "Minimum 10 characters.")
            }
            return
        }
        guard newPasswordTextField.text! != oldPasswordTextField.text! else {
            saveChangeButton.disable()
            newPasswordTextField.showErrorMessage(message: "New password should differ from old one.")
            return
        }
        newPasswordTextField.hideErrorMessage()
        
        guard confirmNewPasswordTextField.text!.count >= 10 && confirmNewPasswordTextField.text == newPasswordTextField.text else {
            if !confirmNewPasswordTextField.text!.isEmpty {
                confirmNewPasswordTextField.showErrorMessage(message: "Password do not match.")
            }
            saveChangeButton.disable()
            return
        }
        confirmNewPasswordTextField.hideErrorMessage()
        saveChangeButton.enable(fillColor: .primaryBlue)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        return true
    }
}

// MARK: - Buttons Functions
extension ChangeWalletPasswordViewController {
    func setupButtons() {
        oldPassButton.setImage(UIImage(named: "ic-eyeOn"), for: .normal)
        oldPassButton.setImage(UIImage(named: "ic-eyeOff"), for: .selected)
        newPassButton.setImage(UIImage(named: "ic-eyeOn"), for: .normal)
        newPassButton.setImage(UIImage(named: "ic-eyeOff"), for: .selected)
        confirmNewPassButton.setImage(UIImage(named: "ic-eyeOn"), for: .normal)
        confirmNewPassButton.setImage(UIImage(named: "ic-eyeOff"), for: .selected)
        
        saveChangeButton.setStyle(fillColor: .primaryBlue, title: "SAVE CHANGES", fontSize: 16)
        saveChangeButton.disable()
    }
}

// MARK: - Show/Hide Password Functions
extension ChangeWalletPasswordViewController {
    func passViewTap(sender: UIButton, textField: MDCFilledTextField) {
        sender.isSelected = !sender.isSelected
        textField.isSecureTextEntry = !sender.isSelected
    }
}
