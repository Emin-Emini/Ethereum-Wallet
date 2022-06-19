//
//  AddressTableViewCell.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 29.05.2022..
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    
    // MARK: - View
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.layer.applySketchShadow(color: .black, alpha: 0.1, x: 0, y: 0, blur: 10, spread: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        if selected {
            selectedBackgroundView?.backgroundColor = UIColor.clear
        } else {
            selectedBackgroundView?.backgroundColor = UIColor.clear
        }
    }
}

