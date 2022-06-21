//
//  DashboardViewController.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 30.05.2022..
//

import UIKit
import HDWalletKit
import web3swift
import SwiftKeychainWrapper
import Alamofire

class DashboardViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var walletBalanceLabel: UILabel!
    @IBOutlet weak var usdBalanceLabel: UILabel!
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupWallet()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

// MARK: Setup Wallet from Blockchain
extension DashboardViewController {
    func setupWallet() {
        
        guard let keychainAddressesString = KeychainWrapper.standard.string(forKey: "walletAddresses") else {
            print("Failed to load address from Keychain")
            return
        }
        
        let web3 = Web3.InfuraMainnetWeb3()
        let address = EthereumAddress(keychainAddressesString)!
        let balance = try! web3.eth.getBalance(address: address)
        let balanceString = Web3.Utils.formatToEthereumUnits(balance, toUnits: .eth, decimals: 8)
        
        let amountInDouble = Double(balanceString ?? "0.0") ?? 0.0
        
        walletBalanceLabel.text = "\(amountInDouble) ETH"
        MyWallet.amount = amountInDouble
        
        getEthereumCurrentPrice()
        //print(balance)
        //print(balanceString)
    }
}

// MARK: - Get ETH price
extension DashboardViewController {
    func getEthereumCurrentPrice() {
        let url = "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=BTC,USD,EUR"
        AF.request(url).validate().responseDecodable(of: FiatModel.self) { (response) in
            guard let price = response.value else { return }
            print(price.USD)
            self.usdBalanceLabel.text = "$\((price.USD * MyWallet.amount).rounded(toPlaces: 4))"
          }
    }
}
