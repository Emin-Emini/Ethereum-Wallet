//
//  WalletSettingsViewController.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 19.06.2022..
//

import UIKit
import SwiftKeychainWrapper

class WalletSettingsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var walletShadowView: UIView!
    @IBOutlet weak var walletImage: UIImageView!
    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var walletIdLabel: UILabel!
    @IBOutlet weak var settingsShadowView: UIView!
    @IBOutlet weak var cardanoNetwork: UILabel!
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadWalletName()
        loadCardanoNetwork()
        
        if #available(iOS 15.0, *) {
            // use the feature only available in iOS 9
            // for ex. UIStackView
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
            navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.label]
            navigationController?.navigationBar.barTintColor = .label
            navigationController?.navigationBar.tintColor = .label
        } else {
            // or use some work around
            navigationController?.navigationBar.barStyle = .default
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        walletShadowView.layer.applySketchShadow(color: .black, alpha: 0.7, x: 0, y: 0, blur: 10, spread: 0)
        settingsShadowView.layer.applySketchShadow(color: .black, alpha: 0.1, x: 0, y: 0, blur: 32, spread: 0)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name(rawValue: "updateAmount"),
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name(rawValue: "calculateStakingFee"),
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name(rawValue: "submitStakeTransaction"),
                                                  object: nil)
        
        loadWalletName()
    }

    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

// MARK: - Unwing Functions
extension WalletSettingsViewController {
    @IBAction func unwindToSettings(_ sender: UIStoryboardSegue) {
        guard let keychainWalletName = KeychainWrapper.standard.string(forKey: "walletName") else { return }
        walletNameLabel.text = keychainWalletName
        self.viewDidLoad()
    }
}

// MARK: - Functions
extension WalletSettingsViewController {
    func loadWalletName() {
        guard let keychainWalletName = KeychainWrapper.standard.string(forKey: "walletName") else { return }
        walletNameLabel.text = keychainWalletName
    }
    
    func loadCardanoNetwork() {
        cardanoNetwork.text = "Ethereum Mainnet".capitalized
    }
}
