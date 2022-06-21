//
//  RemoveWalletViewController.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 19.06.2022..
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextFields
import SwiftKeychainWrapper

class RemoveWalletViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var myWalletNameLabel: UILabel!
    @IBOutlet weak var myWalletNameTextField: MDCFilledTextField!
    @IBOutlet weak var checkMark: CheckmarkView!
    @IBOutlet weak var saveChangeButton: UIButton!
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupTextFieldsLayout()
        setupButtons()
        setupCallbacks()
        
        guard let keychainWalletName = KeychainWrapper.standard.string(forKey: "walletName") else { return }
        myWalletNameLabel.text = keychainWalletName
        
        tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func removeWallet(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "walletName")
        KeychainWrapper.standard.removeObject(forKey: "spendingPassword")
        KeychainWrapper.standard.removeObject(forKey: "walletMnemonics")
        KeychainWrapper.standard.removeObject(forKey: "walletAddresses")
        wallet.removeAll()
    }
}

// MARK: - Functions
extension RemoveWalletViewController {
    func setupCallbacks() {
        checkMark.onStateChanged = { state in
            self.enableDisableContinueButton()
        }
    }
    
    func enableDisableContinueButton() {
        if checkMark.isSelected && myWalletNameTextField.text == myWalletNameLabel.text {
            saveChangeButton.enable(fillColor: .primaryBlue, textColor: .primaryBlue)
            return
        }
        saveChangeButton.disable()
    }
}

// MARK: - Text Field
extension RemoveWalletViewController: UITextFieldDelegate {
    func setupTextFieldsLayout() {
        myWalletNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        myWalletNameTextField.defaultStyle(label: "Wallet name", placeholder: "")
        myWalletNameTextField.delegate = self
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard !myWalletNameTextField.text!.isEmpty && myWalletNameTextField.text == myWalletNameLabel.text && checkMark.isSelected else {
            saveChangeButton.disable()
            return
        }
        
        saveChangeButton.enable(fillColor: .primaryBlue)
    }
}

// MARK: - Buttons
extension RemoveWalletViewController {
    func setupButtons() {
        saveChangeButton.setStyle(fillColor: .primaryBlue, title: "SAVE CHANGES", fontSize: 16)
        saveChangeButton.disable()
    }
}
