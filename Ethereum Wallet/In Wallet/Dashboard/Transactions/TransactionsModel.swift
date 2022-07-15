//
//  TransactionsModel.swift
//  Ethereum Wallet
//
//  Created by Emin Emini on 25.06.2022..
//

import Foundation

struct TransactionResult: Codable {
    let result: [Transaction]
}

struct Transaction: Codable {
    let hash: String
    let from: String
    let to: String
    let value: String
    let gasPrice: String
    let gas: String
    let timeStamp: String
}

// 1000000000000000000
/*
{
    "status": "1",
    "message": "OK-Missing/Invalid API Key, rate limit of 1/5sec applied",
    "result": [
                {
                    "blockNumber": "13190217",
                    "timeStamp": "1631172661",
                    "hash": "0xd5765ebc0f3160195da3e969b595f574bc39791d663bb79ac0038ebaf45c467a",
                    "nonce": "1357303",
                    "blockHash": "0x9c32a8e7f2397efc3a590698bdb2830ca6bfbf968d18933dba1aff12b073095f",
                    "transactionIndex": "12",
                    "from": "0xdfd5293d8e347dfe59e90efd55b2956a1343963d",
                    "to": "0x90810fdbbcb0b781131a7014a44d032a598d118b",
                    "value": "23164120000000000",
                    "gas": "207128",
                    "gasPrice": "131000000000",
                    "isError": "0",
                    "txreceipt_status": "1",
                    "input": "0x",
                    "contractAddress": "",
                    "cumulativeGasUsed": "591625",
                    "gasUsed": "21000",
                    "confirmations": "1827792"
                }
    ]
}*/
