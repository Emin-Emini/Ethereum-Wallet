//
//  CheckmarkView.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 27.05.2022..
//

import UIKit

class CheckmarkView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var imvCheckmark: UIImageView!
    
    var onStateChanged: ((Bool) -> Void)?
    
    var isSelected: Bool = false {
        didSet {
            setCheckmarkStatus()
            onStateChanged?(isSelected)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle(for: CheckmarkView.self).loadNibNamed("CheckmarkView", owner: self, options: nil)
        addSubview(view)
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        configureLayout()
        setCheckmarkStatus()
    }
    
    func configureLayout() {
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkmarkTapped)))
    }
    
    @objc func checkmarkTapped() {
           isSelected = !isSelected
       }
    
    func setCheckmarkStatus() {
        if isSelected {
            checkCheckmark()
            return
        }
        
        uncheckCheckmark()
    }

    func checkCheckmark() {
        imvCheckmark.tintColor = .white
        view.backgroundColor = .primaryBlue
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    func uncheckCheckmark() {
        imvCheckmark.tintColor = .clear //.grey3
        view.backgroundColor = .white //.grey4
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grey3.cgColor
    }

}
