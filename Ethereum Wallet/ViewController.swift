//
//  ViewController.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 20.05.2022..
//

import UIKit
import MnemonicSwift
import HDWalletKit
import Network

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            let mnemonic = try Mnemonic.generateMnemonic(strength: 128, language: .english)
            print(mnemonic)
            
            let seed = Mnemonic.createSeed(mnemonic: mnemonic)
            print(seed.toHexString())
            
            let privateKey = PrivateKey(seed: seed, coin: .ethereum)
            print(privateKey)
            
            print(privateKey.publicKey.address)
            print(privateKey.publicKey.coin)
            print(privateKey.coin)
            print(privateKey.chainCode)
            print(privateKey.get())
            print()
            let wallet = Wallet(seed: seed, coin: .ethereum)
            let account = wallet.generateAccount()
            print(account.address)
            print()
            let erc20Token = ERC20(contractAddress: "0x8f0921f30555624143d427b340b1156914882c10", decimal: 18, symbol: "ESS")
            let data = try! erc20Token.generateGetBalanceParameter(toAddress: "2f5059f64D5C0c4895092D26CDDacC58751e0C3C")
            print(erc20Token)
            print(data)
        } catch {
            print(error)
        }
        
    }


}

