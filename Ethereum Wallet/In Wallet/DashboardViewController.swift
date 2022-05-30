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

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupWallet()
    }
    
    func setupWallet() {
        
        guard let keychainAddressesString = KeychainWrapper.standard.string(forKey: "walletAddresses") else {
            print("Failed to load address from Keychain")
            return
        }
        
        let web3 = Web3.InfuraMainnetWeb3()
        let address = EthereumAddress(keychainAddressesString)!
        let balance = try! web3.eth.getBalance(address: address)
        //let balanceString = Web3.Utils.formatToEthereumUnits(balance, toUnits: .eth, decimals: 8)
        //print(balance)
        //print(balanceString)
    }

}
