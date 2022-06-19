//
//  VerifyRestoredWalletViewController.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 29.05.2022..
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextFields
import HDWalletKit

class VerifyRestoredWalletViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var userContainerView: UIView!
    @IBOutlet weak var addressesListTableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Properties
    let refreshControl = UIRefreshControl()
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadAddress()
        
        addressesListTableView.dataSource = self
        addressesListTableView.delegate = self
        userContainerView.layer.applySketchShadow(color: .black, alpha: 0.1, x: 0, y: 0, blur: 10, spread: 0)
        setupButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addressesListTableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func goBack(_ sender: Any) {
        arrayOfAddresses.removeAll()
    }
}

// MARK: - Functions
extension VerifyRestoredWalletViewController {
    func setupButtons() {
        continueButton.setStyle(fillColor: .primaryBlue, title: "CONTINUE", fontSize: 16)
        continueButton.enable(fillColor: .primaryBlue)
    }
    
    func loadAddress() {
        arrayOfAddresses.removeAll()
        let seed = Mnemonic.createSeed(mnemonic: restoreMnemonics)
        let wallet = Wallet(seed: seed, coin: .ethereum)
        let account = wallet.generateAccount()
        let accountAddress = account.address
        arrayOfAddresses.append(accountAddress)
    }
}

// MARK: - Table View
extension VerifyRestoredWalletViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfAddresses.isEmpty ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressTableViewCell
        cell.selectionStyle = .none
        
        let address = arrayOfAddresses[indexPath.row]
        cell.addressLabel.text = "\(address)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIPasteboard.general.string = arrayOfAddresses[indexPath.row]
        //self.showToastTop(message: "Address has been copied", duration: 2.0)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AddressTableViewCell {
            cell.containerView.layer.applySketchShadow(color: .primaryBlue, alpha: 0.5, x: 0, y: 0, blur: 10, spread: 0)
            print("Highlited")
        }
        
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AddressTableViewCell {
            cell.containerView.layer.applySketchShadow(color: .black, alpha: 0.1, x: 0, y: 0, blur: 10, spread: 0)
            print("Unhighlited")
        }
    }
}

