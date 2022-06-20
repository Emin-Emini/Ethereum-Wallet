//
//  ChangeWalletNameViewController.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 19.06.2022..
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextFields
import SwiftKeychainWrapper

class ChangeWalletNameViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var changeWalletNameTextField: MDCFilledTextField!
    @IBOutlet weak var saveChangeButton: UIButton!
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTextFieldsLayout()
        setupButtons()
        
        tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        KeychainWrapper.standard.set(changeWalletNameTextField.text!, forKey: "walletName")
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
}

// MARK: - Text Field
extension ChangeWalletNameViewController: UITextFieldDelegate {
    func setupTextFieldsLayout() {
        changeWalletNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        changeWalletNameTextField.defaultStyle(label: "Wallet name", placeholder: "")
        changeWalletNameTextField.delegate = self
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard !changeWalletNameTextField.text!.isEmpty else {
            saveChangeButton.disable()
            return
        }
        saveChangeButton.enable(fillColor: .primaryBlue)
    }
}

// MARK: - Buttons
extension ChangeWalletNameViewController {
    func setupButtons() {
        saveChangeButton.setStyle(fillColor: .primaryBlue, title: "SAVE CHANGES", fontSize: 16)
        saveChangeButton.disable()
    }
}
