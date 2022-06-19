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
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var walletAddressLabel: UILabel!
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadQRCode()
        
        walletAddressLabel.text = arrayOfAddresses[0]
    }
    
    // MARK: - Actions
    @IBAction func goBack(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func copyAddress(_ sender: Any) {
        UIPasteboard.general.string = arrayOfAddresses[0]
        self.showToast(message: "Address copied", font: .systemFont(ofSize: 12.0))
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
