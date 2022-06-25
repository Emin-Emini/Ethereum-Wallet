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

var transactions: [Transaction]? = nil

class DashboardViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var walletBalanceLabel: UILabel!
    @IBOutlet weak var usdBalanceLabel: UILabel!
    @IBOutlet weak var transactionsTableView: UITableView!
    
    // MARK: - Properties
    let refreshControl = UIRefreshControl()
    
    private let ethScanAPIKey = "MT21DFIH1KY4MHCKB3ZIIGMJ5ZGWMNNPTD"
    var myAddress = ""
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupWallet()
        setUpRefreshAction()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
}

// MARK: - Refresh Functions
extension DashboardViewController {
    func setUpRefreshAction() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        transactionsTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        setupWallet()
        
        transactionsTableView.reloadData()
        refreshControl.endRefreshing()
    }
}

// MARK: Setup Wallet from Blockchain
extension DashboardViewController {
    func setupWallet() {
        
        guard let keychainAddressesString = KeychainWrapper.standard.string(forKey: "walletAddresses") else {
            print("Failed to load address from Keychain")
            return
        }
        myAddress = keychainAddressesString
        
        let web3 = Web3.InfuraMainnetWeb3()
        let address = EthereumAddress(myAddress)!
        let balance = try! web3.eth.getBalance(address: address)
        let balanceString = Web3.Utils.formatToEthereumUnits(balance, toUnits: .eth, decimals: 8)
        
        let amountInDouble = Double(balanceString ?? "0.0") ?? 0.0
        
        walletBalanceLabel.text = "\(amountInDouble) ETH"
        MyWallet.amount = amountInDouble
        
        getEthereumCurrentPrice()
        getEthereumTransactions(address: myAddress)
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

// MARK: - Get ETH price
extension DashboardViewController {
    func getEthereumTransactions(address: String) {
        let url = "https://api.etherscan.io/api?module=account&action=txlist&address=\(address)&startblock=0&endblock=latest&sort=desc&apikey=\(ethScanAPIKey)"
        AF.request(url).validate().responseDecodable(of: TransactionResult.self) { (response) in
            guard let txResult = response.value else { return }
            
            transactions = txResult.result
            self.transactionsTableView.isHidden = transactions?.count ?? 0 < 1 ? true : false
            DispatchQueue.main.async {
                self.transactionsTableView.reloadData()
            }
          }
    }
}

// MARK: - Table View
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionTableViewCell
        
        guard let transaction = transactions?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.myAddres = myAddress
        cell.loadDataInCell(tx: transaction)
        
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
