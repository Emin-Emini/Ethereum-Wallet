//
//  ConfirmCreateWalletViewController.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 27.05.2022..
//

import UIKit

class ConfirmCreateWalletViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var checkmarkFirst: CheckmarkView!
    @IBOutlet weak var checkmarkSecond: CheckmarkView!
    
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        continueButton.setStyle(fillColor: .primaryBlue, title: "CONTINUE", fontSize: 16)
        continueButton.disable()
        
        setupCallbacks()
    }
    
    // MARK: - Actions
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Checkmark
extension ConfirmCreateWalletViewController {
    func setupCallbacks() {
        checkmarkFirst.onStateChanged = { state in
            self.enableDisableContinueButton()
        }
        checkmarkSecond.onStateChanged = { state in
            self.enableDisableContinueButton()
        }
    }
    
    func enableDisableContinueButton() {
        if checkmarkFirst.isSelected && checkmarkSecond.isSelected {
            continueButton.enable(fillColor: .primaryBlue)
            return
        }
        continueButton.disable()
    }
}
