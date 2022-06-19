//
//  RecoveryPhraseViewController.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 27.05.2022..
//

import UIKit
import MnemonicSwift

var mnemonics = [String]()

class RecoveryPhraseViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        generateMnemonic()
        
        //continueButton.setStyle(.filled, fillColor: .brightSkyBlue, title: "VERIFY", fontSize: 16)
    }
    
    // MARK: - Actions
    @IBAction func goNext(_ sender: Any) {
    }
    
}

// MARK: - Functions for Mnemonics
extension RecoveryPhraseViewController {
    /// Generate Mnemonics
    func generateMnemonic() {
        do {
            let myMnemonic = try Mnemonic.generateMnemonic(strength: 128, language: .english)
            print("Mnemonic: \(myMnemonic)")
            
            mnemonics = myMnemonic.split {$0 == " "}.map(String.init)
            
            let passphrase: String = ""
            let seedString = try Mnemonic.deterministicSeedString(from: myMnemonic,
                                                                  passphrase: passphrase,
                                                                  language: .english)
            print("Deterministic Seed String: \(seedString)")
        } catch {
            print(error)
        }
    }
}

// MARK: Collection View
extension RecoveryPhraseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mnemonics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "phraseWordCell", for: indexPath) as! PhraseWordCollectionViewCell
        cell.numberOfWord.text = "\(indexPath.item + 1)"
        cell.phraseWordLabel.text = "\(mnemonics[indexPath.item])"
        
        if UIScreen.main.scale < UIScreen.main.nativeScale {
            /// When Accessibility Settings are turned on (Zoomed)
            cell.containerViewHeight.constant = 42
            cell.containerViewWidth.constant = 134
        } else {
            /// When Accessibility Settings are Standard (Non-Zoomed)
            cell.containerViewHeight.constant = 42
            cell.containerViewWidth.constant = 154
        }
        
        return cell
    }
}

