//
//  ReceiveViewController.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 30.05.2022..
//

import UIKit

var myQrCodeImage = UIImage()
var myCardanoAddress = ""

class ReceiveViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var topMessageLabel: UILabel!
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var addressesTableView: UITableView!
    
    // MARK: - Properties
    var totalTokensToClaim: Float = 0
    //let appDelegate = AppDelegate()
    var handleNames: [String] = []
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        self.title = "Receive"
//        self.tabBarController?.viewControllers?[3].tabBarItem.title = NSLocalizedString("Receive", comment: "")
        topMessageLabel.text = "Use this address to receive ETH."
        
        loadQRCode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Actions
    @IBAction func goBack(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func goToSettings(_ sender: Any) {
//        let myStoryboard: UIStoryboard = UIStoryboard(name: "WalletSettings", bundle: nil)
//        guard let destinationViewController = myStoryboard.instantiateViewController(withIdentifier: "WalletSettingsViewController") as? WalletSettingsViewController else {
//            return
//        }
//        //self.present(newViewController, animated: true, completion: nil)
//        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    @IBAction func shareQrCode(_ sender: Any) {
        // image to share
    }
}

// MARK: - Unwing Functions
extension ReceiveViewController {
    @IBAction func unwindToReceive(_ sender: UIStoryboardSegue) {
        print("Unwind to Receive")
        let claimableTokens = 0 //UserManager.getUserInstance()?.claimableTokens ?? 0
        //totalTokensToClaimLabel.text = "Total tokens to claim after Unwind: 0"
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            print("async after 1 second")
            self.viewDidLoad()
        }
    }
}

// MARK: - QR Code Functions
extension ReceiveViewController {
    func loadQRCode() {
        let myString = arrayOfAddresses[0]
        let data = myString.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else { return }
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return }
        let processedImage = UIImage(cgImage: cgImage)

        qrCodeImage.image = processedImage
        myQrCodeImage = processedImage
    }
}

// MARK: - Table View
extension ReceiveViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfAddresses.isEmpty ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Address"
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .white
            headerView.backgroundView?.backgroundColor = .white
            headerView.textLabel?.textColor = .black
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrayOfAddresses.isEmpty ? 0 : 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressTableViewCell
        
        if indexPath.section == 0 {
            let address = arrayOfAddresses[indexPath.row]
            cell.addressLabel.text = address
        }
        
        cell.selectionStyle = .none
        if cell.isHighlighted {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressTableViewCell
            cell.containerView.layer.applySketchShadow(color: .brightSkyBlue, alpha: 0.5, x: 0, y: 0, blur: 10, spread: 0)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressTableViewCell
            cell.containerView.layer.applySketchShadow(color: .black, alpha: 0.1, x: 0, y: 0, blur: 10, spread: 0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressTableViewCell
        cell.containerView.layer.applySketchShadow(color: .brightSkyBlue, alpha: 0.5, x: 0, y: 0, blur: 10, spread: 0)
        if indexPath.section == 0 {
            UIPasteboard.general.string = arrayOfAddresses[indexPath.row]
            //self.showToastTop(message: "Address has been copied", duration: 2.0)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected")
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AddressTableViewCell {
            cell.containerView.layer.applySketchShadow(color: .brightSkyBlue, alpha: 0.5, x: 0, y: 0, blur: 10, spread: 0)
            print("Highlited")
        }
        
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AddressTableViewCell {
            cell.containerView.layer.applySketchShadow(color: .black, alpha: 0.1, x: 0, y: 0, blur: 10, spread: 0)
            print("Unhighlited")
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressTableViewCell
        cell.containerView.layer.applySketchShadow(color: .black, alpha: 0.1, x: 0, y: 0, blur: 10, spread: 0)
        print("Deselected")
    }
}
