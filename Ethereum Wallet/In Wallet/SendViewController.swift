//
//  SendViewController.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 31.05.2022..
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextFields
import SwiftKeychainWrapper

class SendViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var mainTokenAmountLabel: UILabel!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var amountTextFieldMessageView: UIView!
    @IBOutlet weak var amountTextFieldMessage: UILabel!
    @IBOutlet weak var maxAmountButtonView: UIView!
    @IBOutlet weak var maxAmountButton: UIButton!

    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressTextField: MDCFilledTextField!
    
    @IBOutlet weak var balanceAfterAmountLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var addressTextfieldHeightConstraint: NSLayoutConstraint!

    // MARK: - Properties
    
    
    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //self.mainTokenAmountLabel.text = "\(adaAmountValue) ADA"
        
        amountTextFieldMessageView.isHidden = true
        
        setupTextFieldsLayout()
        setupButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.title = "Send"
//        self.tabBarController?.viewControllers?[2].tabBarItem.title = NSLocalizedString("Send", comment: "")
//
//        tabBarController?.tabBar.isHidden = false
//
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Actions
    @IBAction func goBack(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func maxAmount(_ sender: Any) {
        //amountTextField.text = "\(revuAmountValue)"
        guard !(addressTextField.text!.isEmpty) else {
            addressTextField.showErrorMessage(message: "Address cannot be empty!")
            return
        }
        addressTextField.hideErrorMessage()
        //validateTokenAmount()
    }
    
    @IBAction func continueSending(_ sender: Any) {
        //continuSendingButton(isFeeCalculated: isFeeCalculated)
    }
    
    // MARK: - Helpers
    
}

// MARK: - Unwing Functions
extension SendViewController {
    
}

// MARK: - Buttons Setup
extension SendViewController {
    func setupButtons() {
        continueButton.setStyle(fillColor: .brightSkyBlue, title: "CONTINUE", fontSize: 16)
        continueButton.disable()
    }
}

// MARK: - Text Field
extension SendViewController: UITextFieldDelegate {
    func setupTextFieldsLayout() {
        amountTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        addressTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        amountTextField.delegate = self
        addressTextField.delegate = self
        
        addressTextField.defaultStyle(label: "Address", placeholder: "Address")
        
        setupScanAddresIcon()
        addKeyboardObservers()
    }
    
    func setupScanAddresIcon() {
        
        let scanIcon = UIImage(named: "scan-qr")
        
        let scanButton = UIButton(type: .custom)
        scanButton.frame = CGRect(x: CGFloat(0), y: CGFloat(addressTextField.frame.height - 45), width: CGFloat(45), height: CGFloat(45))
        scanButton.setImage(scanIcon, for: .normal)
        scanButton.addTarget(self, action: #selector(openScanner), for: .touchUpInside)
        
        addressTextField.trailingView = scanButton
        addressTextField.trailingViewMode = .always
    }
    
    @objc func openScanner(sender: UIButton) {
        print("Open Scanner")
        view.endEditing(true)
        self.performSegue(withIdentifier: "goToQrScan", sender: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        continueButton.disable()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        validateTextFields()
    }

    func validateTextFields() {
        if let addressText = addressTextField.text, addressText.isEmpty {
            addressTextField.hideErrorMessage()
            addressTextfieldHeightConstraint.constant = 77
        }

        guard !amountTextField.text!.isEmpty else {
            continueButton.disable()
            guard !addressTextField.text!.isEmpty else {
                continueButton.disable()
                return
            }
            
            return
        }
        //validateTokenAmount()
        guard !addressTextField.text!.isEmpty else {
            continueButton.disable()
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let addressText = addressTextField.text, addressText.isEmpty {
            addressTextField.hideErrorMessage()
            addressTextfieldHeightConstraint.constant = 77
        }

        guard !amountTextField.text!.isEmpty else {
            continueButton.disable()
            guard !addressTextField.text!.isEmpty else {
                continueButton.disable()
                return
            }
            return
        }
        //validateTokenAmount()
        guard !addressTextField.text!.isEmpty else {
            continueButton.disable()
            return
        }
        
    }
    
    /// UITextFieldDelegate functions -> shouldChangeCharactersIn Range this functions is used to not to allow space in the text field.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let myTextField = amountTextField.text ?? ""
        
        switch textField {
        case addressTextField, amountTextField:
            if (string == " ") {
                return false
            }
            if (string == "," && myTextField.isEmpty) {
                return false
            }
            if (string == ",") {
                if myTextField.contains(".") {
                    print("exists")
                    return false
                }
                amountTextField.text = amountTextField.text! + "."
                return false
            }
            break
        default:
            break
        }
        return true
    }
}

// MARK: - Keyboard Will Show
extension SendViewController {
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
    }
}



/*
// MARK: - Send Validations
extension SendViewController {
    func validateTokenAmount() {
        let amountInput = amountTextField.text
        let doubleAmountInput = Double(amountInput!)
        if tokensAvailable.count == 1 {
            validateIfOnlyAda(amountInput: doubleAmountInput ?? 0, adaBalance: adaAmountValue)
        } else {
            if selectedSendingTokenIndex == 0 {
                validateIfBothAvailableAndSelectedAda(amountInput: doubleAmountInput ?? 0, adaBalance: adaAmountValue)
            } else {
                validateIfBothAvailableAndSelectedRevu(amountInput: doubleAmountInput ?? 0,
                                                       adaBalance: adaAmountValue,
                                                       revuBalance: revuAmountValue,
                                                       minimumToSend: selectedToken?.minimumAmountSend ?? 1)
            }
        }
    }
    
    func validateIfOnlyAda(amountInput: Double, adaBalance: Double) {
        if amountInput < 1 {
            continueButton.disable(.filled)
//            amountTextField.hideErrorMessage()
//            amountTextField.showErrorMessage(message: "Amount too low. Minimum amount to send is 1 ADA")
            amountTextFieldMessageView.isHidden = false
            amountTextFieldMessage.text = "Amount too low. Minimum amount to send is 1 ADA"
            print("Amount too low. Minimum amount to send is 1 ADA")
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        } else {
            if adaBalance < 2 {
                continueButton.disable(.filled)
//                amountTextField.hideErrorMessage()
//                amountTextField.showErrorMessage(message: "Account balance needs to be to at least 2 ADA to send minimum value of ADA.")
                amountTextFieldMessageView.isHidden = false
                amountTextFieldMessage.text = "Account balance needs to be to at least 2 ADA to send minimum value of ADA."
                print("Account balance needs to be to at least 2 ADA to send minimum value of ADA.")
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            } else if (adaBalance >= 2 && amountInput >= adaBalance) {
                continueButton.disable(.filled)
//                amountTextField.hideErrorMessage()
//                amountTextField.showErrorMessage(message: "Not enough ADA to send this transaction.")
                amountTextFieldMessageView.isHidden = false
                amountTextFieldMessage.text = "Not enough ADA to send this transaction."
                print("Not enough ADA to send this transaction.")
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            } else {
                //amountTextField.hideErrorMessage()
                amountTextFieldMessageView.isHidden = true
                updateAmount(destinationAddress: addressTextField.text!, amountToSend: amountTextField.text!)
                continueButton.setStyle(.filled, fillColor: .brightSkyBlue, title: "CALCULATE FEE", fontSize: 16)
                continueButton.enable(.filled, fillColor: .brightSkyBlue)
                print("Calculate Fee.")
            }
        }
    }
    
    func validateIfBothAvailableAndSelectedAda(amountInput: Double, adaBalance: Double) {
        if amountInput < 1 {
            continueButton.disable(.filled)
//            amountTextField.hideErrorMessage()
//            amountTextField.showErrorMessage(message: "Amount too low. Minimum amount to send is 1 ADA")
            amountTextFieldMessageView.isHidden = false
            amountTextFieldMessage.text = "Amount too low. Minimum amount to send is 1 ADA"
            print("Amount too low. Minimum amount to send is 1 ADA")
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        } else {
            if adaBalance < 2.7 {
                continueButton.disable(.filled)
//                amountTextField.hideErrorMessage()
//                amountTextField.showErrorMessage(message: "Account balance needs to be at least 2.7 ADA to send ADA transaction.")
                amountTextFieldMessageView.isHidden = false
                amountTextFieldMessage.text = "Account balance needs to be at least 2.7 ADA to send ADA transaction."
                print("Account balance needs to be at least 2.7 ADA to send ADA transaction.")
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            } else if (adaBalance >= 2.7) && (amountInput > (adaBalance - 1.7)) {
                continueButton.disable(.filled)
//                amountTextField.hideErrorMessage()
//                amountTextField.showErrorMessage(message: "Not enough ADA to send this transaction. Try a lower amount.")
                amountTextFieldMessageView.isHidden = false
                amountTextFieldMessage.text = "Not enough ADA to send this transaction. Try a lower amount."
                print("Not enough ADA to send this transaction. Try a lower amount.")
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            } else {
                //amountTextField.hideErrorMessage()
                amountTextFieldMessageView.isHidden = true
                updateAmount(destinationAddress: addressTextField.text!, amountToSend: amountTextField.text!)
                continueButton.setStyle(.filled, fillColor: .brightSkyBlue, title: "CALCULATE FEE", fontSize: 16)
                continueButton.enable(.filled, fillColor: .brightSkyBlue)
                print("Calculate Fee.")
            }
        }
    }
    
    func validateIfBothAvailableAndSelectedRevu(amountInput: Double, adaBalance: Double, revuBalance: Double, minimumToSend: Double) {
        print(minimumToSend)
        if amountInput < minimumToSend {
            continueButton.disable(.filled)
//            amountTextField.hideErrorMessage()
//            amountTextField.showErrorMessage(message: "Amount too low. Minimum amount to send is \(minRevuToSend) REVU")
            amountTextFieldMessageView.isHidden = false
            amountTextFieldMessage.text = "Amount too low. Minimum amount to send is \(minimumToSend) \(selectedToken?.displayName ?? "REVU")"
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        } else {
            if (adaBalance >= minAdaToSend && adaBalance < 3) && (amountInput == revuBalance) {
                //amountTextField.hideErrorMessage()
                amountTextFieldMessageView.isHidden = true
                updateAmount(destinationAddress: addressTextField.text!, amountToSend: amountTextField.text!)
                continueButton.setStyle(.filled, fillColor: .brightSkyBlue, title: "CALCULATE FEE", fontSize: 16)
                continueButton.enable(.filled, fillColor: .brightSkyBlue)
            } else if (adaBalance > 3 && amountInput <= revuBalance) {
                //amountTextField.hideErrorMessage()
                amountTextFieldMessageView.isHidden = true
                updateAmount(destinationAddress: addressTextField.text!, amountToSend: amountTextField.text!)
                continueButton.setStyle(.filled, fillColor: .brightSkyBlue, title: "CALCULATE FEE", fontSize: 16)
                continueButton.enable(.filled, fillColor: .brightSkyBlue)
            } else if (amountInput > revuBalance) {
                continueButton.disable(.filled)
//                amountTextField.hideErrorMessage()
//                amountTextField.showErrorMessage(message: "Not enough REVU to send this transaction.")
                amountTextFieldMessageView.isHidden = false
                amountTextFieldMessage.text = "Not enough \(selectedToken?.displayName ?? "REVU") to send this transaction."
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            } else {
                continueButton.disable(.filled)
//                amountTextField.hideErrorMessage()
//                amountTextField.showErrorMessage(message: "Account balance needs to be at least \(minAdaToSend) ADA to send MAX tokens or more than 3 ADA to send partial amount of tokens.")
                amountTextFieldMessageView.isHidden = false
                amountTextFieldMessage.text = "Account balance needs to be at least \(minAdaToSend) ADA to send MAX tokens or more than 3 ADA to send partial amount of tokens."
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            }
        }
    }
}
*/
