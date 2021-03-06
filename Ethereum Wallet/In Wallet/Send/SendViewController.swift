//
//  SendViewController.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 31.05.2022..
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextFields
import SwiftKeychainWrapper
import web3swift
import BigInt

struct Web3Wallet {
    let address: String
    let data: Data
    let name: String
    let isHD: Bool
}

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
    var isFeeCalculated = false
    var gasPrice: BigUInt = 0
    
    let web3 = Web3.InfuraMainnetWeb3()
    var keystoreManager: KeystoreManager!
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //self.mainTokenAmountLabel.text = "\(adaAmountValue) ADA"
        
        amountTextFieldMessageView.isHidden = true
        
        setupTextFieldsLayout()
        setupButtons()
        
        setupWallet()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainTokenAmountLabel.text = "\(MyWallet.amount) ETH"
    }
    
    // MARK: - Actions
    @IBAction func goBack(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func maxAmount(_ sender: Any) {
        amountTextField.text = "\(MyWallet.amount)"
        validateTokenAmount()
    }
    
    @IBAction func continueSending(_ sender: Any) {
        sendTransactiongFlow()
    }
}

// MARK: - Unwing Functions
extension SendViewController {
    @IBAction func unwindToSendAfterSuccessfulScan(_ sender: UIStoryboardSegue) {
        addressTextField.text = scannedAddress
        
        if !amountTextField.text!.isEmpty {
            validateTokenAmount()
        } else {
            
        }
        
    }
}

// MARK: - Web3 & KeystoreManager
extension SendViewController {
    func setupWallet() {
        let keychainMnemonicsString = KeychainWrapper.standard.string(forKey: "walletMnemonics")
        let keychainWalletName = KeychainWrapper.standard.string(forKey: "walletName")
        let keychainWalletPassword = KeychainWrapper.standard.string(forKey: "spendingPassword")
        guard let mnemonics = keychainMnemonicsString else { return }
        guard let name = keychainWalletName else { return }
        guard let password = keychainWalletPassword else { return }
        
        let keystore = try! BIP32Keystore(
            mnemonics: mnemonics,
            password: password,
            mnemonicsPassword: "",
            language: .english)!
        
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
        let address = keystore.addresses!.first!.address
        let wallet = Web3Wallet(address: address, data: keyData, name: name, isHD: true)
        
        let data = wallet.data
        
        let keystoreDataBIP32 = BIP32Keystore(data)!
        keystoreManager = KeystoreManager([keystoreDataBIP32])
        
        web3.addKeystoreManager(keystoreManager)
    }
}

// MARK: - Sign Tx Function
extension SendViewController {
    func sendTransactiongFlow() {
        if isFeeCalculated {
            signTransaction()
        } else {
            calculateFee()
        }
    }
    
    func calculateFee() {
        continueButton.setStyle(fillColor: .primaryBlue, title: "CALCULATING FEE", fontSize: 16)
        continueButton.disable()
        
        let value: String = amountTextField.text ?? "0.0"
        guard let myAddressString = arrayOfAddresses.first else { return }
        let walletAddress = EthereumAddress(myAddressString)! // Your wallet address
        let toAddress = EthereumAddress(addressTextField.text!)!
        let contract = web3.contract(Web3.Utils.coldWalletABI, at: toAddress, abiVersion: 2)!
        let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
        var options = TransactionOptions.defaultOptions
        options.value = amount
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        print(try! web3.eth.getGasPrice())
        do {
            let gasPrice = try web3.eth.getGasPrice()
            self.gasPrice = gasPrice
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 15
            formatter.minimumFractionDigits = 0
            formatter.numberStyle = .decimal
            
            let fee = (Double(gasPrice) / ethDivident)
            let feeFormatted = formatter.string(for: fee)
            feeLabel.text = "\(feeFormatted ?? "0.0") ETH"
            isFeeCalculated = true
            continueButton.setStyle(fillColor: .primaryBlue, title: "SIGN TRANSACTION", fontSize: 16)
            continueButton.enable(fillColor: .primaryBlue)
        } catch {
            print("Failed to calculate fee.")
            isFeeCalculated = false
        }
    }
    
    func signTransaction() {
        continueButton.setStyle(fillColor: .primaryBlue, title: "SIGNING TRANSACTION", fontSize: 16)
        continueButton.disable()
        
        let value: String = amountTextField.text ?? "0.0"
        guard let myAddressString = arrayOfAddresses.first else { return }
        let walletAddress = EthereumAddress(myAddressString)! // Your wallet address
        let toAddress = EthereumAddress(addressTextField.text!)!
        let contract = web3.contract(Web3.Utils.coldWalletABI, at: toAddress, abiVersion: 2)!
        let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
        var options = TransactionOptions.defaultOptions
        
        guard let myAmount = amount else { return }
        print(myAmount)
        print(walletAddress)
        options.value = myAmount
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        
        let tx = contract.write(
            "fallback",
            parameters: [AnyObject](),
            extraData: Data(),
            transactionOptions: options)!
        
        print()
        print("tx.transaction:")
        print(tx.transaction)
        print("tx.contract:")
        print(tx.contract)
        print("tx.transactionOptions:")
        print(tx.transactionOptions)
        print()
        
        do {
            try tx.send(password: "testing123", transactionOptions: options)
            print("Successfuly Sent Transaction")
            self.showToast(message: "Successfuly Sent Transaction", font: .systemFont(ofSize: 12.0))
        } catch {
            print(error)
            print("Failed to Send Transaction")
            self.showToast(message: "Failed to Send Transaction \(error)", font: .systemFont(ofSize: 12.0))
        }
        self.dismiss(animated: true)
    }
}

// MARK: - Buttons Setup
extension SendViewController {
    func setupButtons() {
        continueButton.setStyle(fillColor: .primaryBlue, title: "CONTINUE", fontSize: 16)
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
        //addKeyboardObservers()
    }
    
    func setupScanAddresIcon() {
        
        let scanIcon = UIImage(named: "ic-scan-qr")
        
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
        isFeeCalculated = false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        validateTextFields()
    }

    func validateTextFields() {
        if let addressText = addressTextField.text, addressText.isEmpty {
            addressTextField.hideErrorMessage()
            //addressTextfieldHeightConstraint.constant = 77
        }

        guard !amountTextField.text!.isEmpty else {
            continueButton.disable()
            guard !addressTextField.text!.isEmpty else {
                continueButton.disable()
                return
            }
            
            return
        }
        validateTokenAmount()
        guard !addressTextField.text!.isEmpty else {
            continueButton.disable()
            return
        }
        
        let toAddress = EthereumAddress(addressTextField.text!)
        
        guard toAddress?.isValid ?? false else {
            addressTextField.showErrorMessage(message: "Address is not valid.")
            return
        }
        addressTextField.hideErrorMessage()
        continueButton.enable(fillColor: .primaryBlue)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let addressText = addressTextField.text, addressText.isEmpty {
            addressTextField.hideErrorMessage()
            //addressTextfieldHeightConstraint.constant = 77
        }

        guard !amountTextField.text!.isEmpty else {
            continueButton.disable()
            guard !addressTextField.text!.isEmpty else {
                continueButton.disable()
                return
            }
            return
        }
        validateTokenAmount()
        guard !addressTextField.text!.isEmpty else {
            continueButton.disable()
            return
        }
        
        continueButton.enable(fillColor: .primaryBlue)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - Send Validations
extension SendViewController {
    func validateTokenAmount() {
        let amountInput = amountTextField.text
        let doubleAmountInput = Double(amountInput!)
        validate(amountInput: doubleAmountInput ?? 0, balance: MyWallet.amount)
    }
    
    func validate(amountInput: Double, balance: Double) {
        if amountInput < 0.0000001 {
            continueButton.disable()
            amountTextFieldMessageView.isHidden = false
            amountTextFieldMessage.text = "Amount too low. Minimum amount to send is 0.0000001 ETH"
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        } else {
            if balance < 0.0000001 {
                continueButton.disable()
                amountTextFieldMessageView.isHidden = false
                amountTextFieldMessage.text = "Account balance needs to be to at least 0.0000001 ETH to send minimum value of ETH."
                
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            } else if (balance >= 0.0000001 && amountInput > balance) {
                continueButton.disable()
                amountTextFieldMessageView.isHidden = false
                amountTextFieldMessage.text = "Not enough ETH to send this transaction."
                
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            } else {
                amountTextFieldMessageView.isHidden = true
                
                continueButton.setStyle(fillColor: .primaryBlue, title: "CALCULATE FEE", fontSize: 16)
                continueButton.enable(fillColor: .primaryBlue)
            }
        }
    }
}

