//
//  WalletsViewController.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 28.05.2022..
//

import UIKit
import SwiftKeychainWrapper

var wallet: [WalletModel] = []
let defaults = UserDefaults.standard

class WalletsViewController: ViewController {

    // MARK: - Outlets
    @IBOutlet weak var walletsTableView: UITableView!
    @IBOutlet weak var createWalletButton: UIButton!
    @IBOutlet weak var restoreWalletButton: UIButton!
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        walletsTableView.dataSource = self
        walletsTableView.delegate = self
        walletsTableView.allowsSelection = true
        
        loadWallet()
        loadLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWallet()
        walletsTableView.reloadData()
        print(wallet.count)
        isWalletEmpty()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Actions
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Layout Functions
extension WalletsViewController {
    func loadLayout() {
        createWalletButton.setStyle(fillColor: .primaryBlue, title: "CREATE WALLET", titleColor: .white, fontSize: 16)
        restoreWalletButton.setStyle(fillColor: .primaryBlue, title: "RESTORE WALLET", titleColor: .white, fontSize: 16)
    }
}

// MARK: - Unwing Functions
extension WalletsViewController {
    @IBAction func unwindToWallets(_ sender: UIStoryboardSegue) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            print("async after 1 second")
            self.viewDidLoad()
        }
    }
}

// MARK: - Table View
extension WalletsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletCell", for: indexPath) as! WalletTableViewCell
        
        let myWallet = wallet[indexPath.row]
        
        cell.walletName.text = myWallet.name
        //cell.containerView.backgroundColor = cell.isSelected ? UIColor.red : UIColor.gray
        cell.selectionStyle = .none
        //cell.selectionColor = UIColor.blue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? WalletTableViewCell {
            cell.containerView.backgroundColor = UIColor.rgb(60, 60, 67, 0.05)
            print("Highlited")
        }
        
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? WalletTableViewCell {
            cell.containerView.backgroundColor = UIColor.rgb(60, 60, 67, 0.10)
            print("Unhighlited")
        }
    }
}

// MARK: - Load Wallet
extension WalletsViewController {
    func loadWallet() {
        //guard wallet.isEmpty else { return }
        wallet.removeAll()
        guard let keychainWalletName = KeychainWrapper.standard.string(forKey: "walletName") else { return }
        let keychainAddressesString = KeychainWrapper.standard.string(forKey: "walletAddresses")
        arrayOfAddresses.append(keychainAddressesString!)
        let loadWallet = WalletModel(name: keychainWalletName, addresses: arrayOfAddresses)
        wallet.append(loadWallet)
        let keychainMnemonicsString = KeychainWrapper.standard.string(forKey: "walletMnemonics")
        guard let keychainMnemonicsArray = keychainMnemonicsString?.split(whereSeparator: {$0 == " "}).map(String.init) else { return }
        mnemonics = keychainMnemonicsArray
    }
    
    /// This function checks the addresses stored locally, based on that data will show buttons Create Wallet or Restore Wallet
    func isWalletEmpty() {
        if !wallet.isEmpty { //When Wallet is Created and Wallet is inside the App
            walletsTableView.isHidden = false
            createWalletButton.isHidden = true // Hide Create Wallet
            restoreWalletButton.isHidden = true // Hide Restore Wallet
        } else if wallet.isEmpty { //When user wants to create a wallet for the first time.
            walletsTableView.isHidden = true
            createWalletButton.isHidden = false // Show Create Wallet
            restoreWalletButton.isHidden = false // Hide Restore Wallet
        }
    }

}

struct WalletModel {
    let name: String
    let addresses: [String]
}
