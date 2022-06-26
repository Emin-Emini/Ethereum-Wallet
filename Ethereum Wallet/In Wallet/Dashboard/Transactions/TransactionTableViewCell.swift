//
//  TransactionTableViewCell.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 25.06.2022..
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var transactionImage: UIImageView!
    @IBOutlet weak var transactionTypeLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var transactionFeeLabel: UILabel!
    @IBOutlet weak var transactionDateLabel: UILabel!
    
    // MARK: - Properties
    var myAddres = ""
    
    // MARK: - View
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - Functions
extension TransactionTableViewCell {
    func loadDataInCell(tx: Transaction) {
        setTransactionType(tx: tx)
        transactionAmountLabel.text = "\((Double(tx.value) ?? 0) / ethDivident) ETH"
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 15
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .decimal
        
        let fee = ((Double(tx.gasPrice) ?? 0) / ethDivident)
        let feeFormatted = formatter.string(for: fee)
        print(fee)
        print(feeFormatted)
        
        transactionFeeLabel.text = "\(feeFormatted ?? "0.0") ETH"
        transactionDateLabel.text = loadTransactionDate(timestamp: tx.timeStamp)
    }
    
    func setTransactionType(tx: Transaction) {
        print(myAddres)
        print(tx.to)
        print(tx.from)
        if myAddres.caseInsensitiveCompare(tx.to) == .orderedSame {
            transactionImage.image = UIImage(named: "ic-receive")
            transactionImage.tintColor = .green
            transactionTypeLabel.text = "Received"
        } else if myAddres.caseInsensitiveCompare(tx.from) == .orderedSame {
            transactionImage.image = UIImage(named: "ic-send")
            transactionImage.tintColor = .red
            transactionTypeLabel.text = "Sent"
        }
    }
}

// MARK: - Date Functions
extension TransactionTableViewCell {
    /// This function convert Timestamp to Date
    func loadTransactionDate(timestamp: String) -> String {
        let epocTime = TimeInterval(timestamp)!
        let myDate = Date(timeIntervalSince1970: epocTime)
        
        return formatDate(date: myDate, onlyTime: true)
    }
    
    /// This function formats date in the way you select.
    func formatDate(date: Date, onlyTime: Bool) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        dateFormatter.dateFormat = "dd/MM/yyyy - HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
}
