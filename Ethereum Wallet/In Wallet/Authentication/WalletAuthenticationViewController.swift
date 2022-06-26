//
//  WalletAuthenticationViewController.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 26.06.2022..
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextFields
import SwiftKeychainWrapper
import LocalAuthentication

class WalletAuthenticationViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var oldPasswordTextField: MDCFilledTextField!
    @IBOutlet weak var oldPassButton: UIButton!
    
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupTextFields()
        setupButtons()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadFaceID()
    }

    // MARK: - Actions
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func oldPasswordButton(_ sender: Any) {
        passViewTap(sender: sender as! UIButton, textField: oldPasswordTextField)
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

// MARK: - Face ID Auth
extension WalletAuthenticationViewController {
    func loadFaceID() {
        let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [weak self] success, authenticationError in

                    DispatchQueue.main.async {
                        if success {
                            self?.performSegue(withIdentifier: "goInWallet", sender: nil)
                        } else {
                            // error
                        }
                    }
                }
            } else {
                // no biometry
                let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }
    }
}

// MARK: - Text Field
extension WalletAuthenticationViewController: UITextFieldDelegate {
    
    func setupTextFields() {
        oldPasswordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        setupTextFieldsLayout()
    }
    
    func setupTextFieldsLayout() {
        oldPasswordTextField.defaultStyle(label: "Your wallet password", placeholder: "**********")
        oldPasswordTextField.isSecureTextEntry = true
        oldPasswordTextField.delegate = self
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard oldPasswordTextField.text!.count >= 10 else {
            continueButton.disable()
            if !oldPasswordTextField.text!.isEmpty {
                oldPasswordTextField.showErrorMessage(message: "Wrong password.")
            }
            return
        }
        let keychainWalletPassword = KeychainWrapper.standard.string(forKey: "spendingPassword")
        guard oldPasswordTextField.text! == keychainWalletPassword else {
            continueButton.disable()
            oldPasswordTextField.showErrorMessage(message: "Wrong password.")
            return
        }
        oldPasswordTextField.hideErrorMessage()
        
        continueButton.enable(fillColor: .primaryBlue)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Buttons Functions
extension WalletAuthenticationViewController {
    func setupButtons() {
        oldPassButton.setImage(UIImage(named: "ic-eyeOn"), for: .normal)
        oldPassButton.setImage(UIImage(named: "ic-eyeOff"), for: .selected)
        
        continueButton.setStyle(fillColor: .primaryBlue, title: "CONTINUE", fontSize: 16)
        continueButton.disable()
    }
}

// MARK: - Show/Hide Password Functions
extension WalletAuthenticationViewController {
    func passViewTap(sender: UIButton, textField: MDCFilledTextField) {
        sender.isSelected = !sender.isSelected
        textField.isSecureTextEntry = !sender.isSelected
    }
}
