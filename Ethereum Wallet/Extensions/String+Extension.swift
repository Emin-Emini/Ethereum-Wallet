//
//  String+Extension.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 29.05.2022..
//

import Foundation

extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}
