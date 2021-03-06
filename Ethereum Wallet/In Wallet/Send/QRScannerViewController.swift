//
//  QRScannerViewController.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 21.06.2022..
//

import UIKit
import AVFoundation

var scannedAddress = ""

class QRScanerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var cameraContainerView: UIView!
    
    // MARK: - Properties
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var qrCodeBounds:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.layer.borderColor = UIColor.primaryBlue.cgColor
        view.layer.borderWidth = 3
        return view
    }()

    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadScanLayout()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.previewLayer?.frame = self.cameraContainerView.layer.bounds
        // Fix orientation
        if let connection = self.previewLayer?.connection {
            let orientation = self.view.window?.windowScene?.interfaceOrientation ?? UIInterfaceOrientation.portrait
            let previewLayerConnection : AVCaptureConnection = connection
            
            if (previewLayerConnection.isVideoOrientationSupported) {
                switch (orientation) {
                case .landscapeRight:
                    previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.landscapeRight
                case .landscapeLeft:
                    previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
                case .portraitUpsideDown:
                    previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.portraitUpsideDown
                default:
                    previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.portrait
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (self.captureSession?.isRunning == false) {
            self.captureSession?.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (self.captureSession?.isRunning == true) {
            self.captureSession?.stopRunning()
        }
    }
    
    // MARK: - Actions
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Load Functions
extension QRScanerViewController {
    func loadScanLayout() {
        scannedAddress = ""
        
        self.view.backgroundColor = UIColor.black
        
        // Setup Camera Capture
        self.captureSession = AVCaptureSession()

        // Get the default camera (there are normally between 2 to 4 camera 'devices' on iPhones)
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (self.captureSession.canAddInput(videoInput)) {
            self.captureSession.addInput(videoInput)
        } else {
            self.failed() // Simulator mostly
            return
        }

        // Now the camera is setup add a metadata output
        let metadataOutput = AVCaptureMetadataOutput()

        if (self.captureSession.canAddOutput(metadataOutput)) {
            self.captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr] // Also have things like Face, body, cats
        } else {
            self.failed()
            return
        }

        // Setup the UI to show the camera
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer.frame = view.layer.bounds
        self.previewLayer.videoGravity = .resizeAspectFill
        self.cameraContainerView.layer.addSublayer(self.previewLayer)

        self.qrCodeBounds.alpha = 0
        self.cameraContainerView.addSubview(self.qrCodeBounds)
        
        self.captureSession.startRunning()
    }
}

// MARK: - Help Functions
extension QRScanerViewController {
    func failed() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        let ac = UIAlertController(title: "Scanning failed", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
        present(ac, animated: true)
        self.captureSession = nil
    }
    
    func showQRCodeBounds(frame: CGRect?) {
        guard let frame = frame else { return }
        
        self.qrCodeBounds.layer.removeAllAnimations() // resets any previous animations and cancels the fade out
        self.qrCodeBounds.alpha = 1
        self.qrCodeBounds.frame = frame
        UIView.animate(withDuration: 0.2, delay: 1, options: [], animations: { // after 1 second fade away
            self.qrCodeBounds.alpha = 0
        })
    }
    
    // MARK: AVCaptureMetadataOutputObjectsDelegate
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            // Get text value
            if stringValue != scannedAddress {
                print("QR Code: \(stringValue)")
                scannedAddress = stringValue
                performSegue(withIdentifier: "unwindToSendAfterSuccessfulScan", sender: nil)
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
            
            // Show bounds
            let qrCodeObject = self.previewLayer.transformedMetadataObject(for: readableObject)
            self.showQRCodeBounds(frame: qrCodeObject?.bounds)
        }
    }
}

