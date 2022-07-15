//
//  PhraseRestoreWalletViewController.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 29.05.2022..
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextFields
import HDWalletKit

var restoreMnemonics = ""

class PhraseRestoreWalletViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var phraseConfirmationTextField: MDCFilledTextField!
    @IBOutlet weak var restoreWalletButton: UIButton!
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupTextFieldsLayout()
        setupButtons()
    }
    
    // MARK: - Actions
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func restoreWallet(_ sender: Any) {
        //generateShelleyAddresses(networkChannel: 0, mnemonicWords: phraseConfirmationTextField.text!)
        restoreMnemonics = phraseConfirmationTextField.text!
        self.performSegue(withIdentifier: "goToVerifyRestoredAddresses", sender: nil)
    }
}

// MARK: - Text Field
extension PhraseRestoreWalletViewController: UITextFieldDelegate {
    func setupTextFieldsLayout() {
        phraseConfirmationTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        phraseConfirmationTextField.defaultStyle(label: "Recovery phrase", placeholder: "")
        phraseConfirmationTextField.delegate = self
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let phraseText = phraseConfirmationTextField.text,
              !phraseText.isEmpty && countWords(string: phraseText) == 12 else {
            phraseConfirmationTextField.showErrorMessage(message: "Phrase should be 12 words")
            restoreWalletButton.disable()
            return
        }
        phraseConfirmationTextField.hideErrorMessage()
        restoreWalletButton.enable(fillColor: .primaryBlue)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("TextField End Editting")
        guard let phraseText = phraseConfirmationTextField.text,
              !phraseText.isEmpty && countWords(string: phraseText) == 12 else {
            phraseConfirmationTextField.showErrorMessage(message: "Phrase should be 12 words")
            restoreWalletButton.disable()
            return
        }
        phraseConfirmationTextField.hideErrorMessage()
        let trimmedString = phraseConfirmationTextField.text!.trimmingCharacters(in: .whitespaces)
        phraseConfirmationTextField.text = trimmedString.condenseWhitespace()
        
        restoreWalletButton.enable(fillColor: .primaryBlue)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Buttons
extension PhraseRestoreWalletViewController {
    func setupButtons() {
        restoreWalletButton.setStyle(fillColor: .primaryBlue, title: "RESTORE WALLET", fontSize: 16)
        restoreWalletButton.disable()
    }
}

// MARK: - Functions
extension PhraseRestoreWalletViewController {
    /// This function
    func countWords(string: String) -> Int {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = string.components(separatedBy: chararacterSet)
        let words = components.filter { !$0.isEmpty }
        return words.count
    }
}

// MARK: - Alert Functions
extension PhraseRestoreWalletViewController {
    func loadAlert(errorMessage: String) {
        if errorMessage.contains("Invalid mnemonic format") {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            restoreWalletButton.disable()
            phraseConfirmationTextField.showErrorMessage(message: "Please check your mnemonic phrase! Something is wrong.")
        } else {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            restoreWalletButton.disable()
            phraseConfirmationTextField.showErrorMessage(message: "Something is wrong with restoring wallet.\nPlease try later or contact support!")
        }
    }
}
