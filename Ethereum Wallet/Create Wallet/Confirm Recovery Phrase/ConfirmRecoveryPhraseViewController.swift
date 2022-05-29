//
//  ConfirmRecoveryPhraseViewController.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 27.05.2022..
//

import UIKit
import SwiftKeychainWrapper
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import HDWalletKit
import web3swift

var arrayOfAddresses: [String] = []

class ConfirmRecoveryPhraseViewController: ViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var firstTextField: MDCOutlinedTextField!
    @IBOutlet weak var secondTextField: MDCOutlinedTextField!
    @IBOutlet weak var thirdTextField: MDCOutlinedTextField!
    @IBOutlet weak var fourthTextField: MDCOutlinedTextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var generatingWalletLabel: UILabel!
    
    // MARK: - Properties
    var firstWord = Int.random(in: 1...3)
    var secondWord = Int.random(in: 4...6)
    var thirdWord = Int.random(in: 7...9)
    var fourthWord = Int.random(in: 10...12)
    
    // MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        generatingWalletLabel.isHidden = true
        
        loadButtonsLayout()
        setupTextFields()
    }
    
    // MARK: - Actions
    @IBAction func confirm(_ sender: Any) {
        print("Confirm Button is Pressed")
        createWallet()
    }
    
}

// MARK: - Text Fields
extension ConfirmRecoveryPhraseViewController: UITextFieldDelegate {
    func setupTextFields() {
        firstTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        secondTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        thirdTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        fourthTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        firstTextField.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self
        fourthTextField.delegate = self
        
        setupTextFieldsLayout()
    }
    
    func setupTextFieldsLayout() {
        firstTextField.defaultStyle(label: "Word #\(firstWord)", placeholder: "Word #\(firstWord)")
        secondTextField.defaultStyle(label: "Word #\(secondWord)", placeholder: "Word #\(secondWord)")
        thirdTextField.defaultStyle(label: "Word #\(thirdWord)", placeholder: "Word #\(thirdWord)")
        fourthTextField.defaultStyle(label: "Word #\(fourthWord)", placeholder: "Word #\(fourthWord)")
        
        //firstTextField.containerRadius = 30.0
        //firstTextField.leadingEdgePaddingOverride = 10.0
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard validateTextFields(textField as! MDCOutlinedTextField) else { return }
        
        confirmButton.enable(fillColor: .brightSkyBlue)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard validateTextFields(textField as! MDCOutlinedTextField) else { return }
        
        confirmButton.enable(fillColor: .brightSkyBlue)
        
        //generateShelleyAddresses(mnemonicWords: mnemonics.joined(separator:" "))
        generatingWalletLabel.isHidden = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let _ = string.rangeOfCharacter(from: .uppercaseLetters) {
            // Don't allow upper case letters
            return false
        }

        return true
    }
    
    func validateTextFields(_ textField: MDCOutlinedTextField) -> Bool {
        guard firstTextField.isMnemonicWordValid(with: mnemonics[firstWord-1]),
              secondTextField.isMnemonicWordValid(with: mnemonics[secondWord-1]),
              thirdTextField.isMnemonicWordValid(with: mnemonics[thirdWord-1]),
              fourthTextField.isMnemonicWordValid(with: mnemonics[fourthWord-1]) else {
                  self.confirmButton.disable()
                  return false
              }
        return true
    }
}

// MARK: - Button Functions
extension ConfirmRecoveryPhraseViewController {
    func loadButtonsLayout() {
        confirmButton.setStyle(fillColor: .brightSkyBlue, title: "CONFIRM", fontSize: 16)
        confirmButton.disable()
    }
}

// MARK: - Button Functions
extension ConfirmRecoveryPhraseViewController {
    func createWallet() {
        let mnemonic = mnemonics.joined(separator:" ")
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let privateKey = PrivateKey(seed: seed, coin: .ethereum)
        let wallet = Wallet(seed: seed, coin: .ethereum)
        let account = wallet.generateAccount()
        let accountAddress = account.address
        
        KeychainWrapper.standard.set(mnemonic, forKey: "walletMnemonics")
        KeychainWrapper.standard.set(accountAddress, forKey: "walletAddresses")
        
//        guard !arrayOfAddresses.isEmpty else {
//            KeychainWrapper.standard.removeObject(forKey: "walletName")
//            KeychainWrapper.standard.removeObject(forKey: "spendingPassword")
//            KeychainWrapper.standard.removeObject(forKey: "walletMnemonics")
//            KeychainWrapper.standard.removeObject(forKey: "walletAddresses")
//            return
//        }
        
        print("Addresses are stored in Keychain & Wallet has been created.")
        self.performSegue(withIdentifier: "unwindToWallets", sender: nil)
    }
}
