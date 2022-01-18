//
//  CashoutModel.swift
//  Chango v2
//
//  Created by Hosny Savage on 17/06/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import Foundation

class CashoutModel: NSObject {
    
    @objc dynamic var destinationNumber: String = ""
    @objc dynamic var destinationAccountName: String = ""
    @objc dynamic var totalAmount: Double = 0.0
    @objc dynamic var created: String = ""
    @objc dynamic var amount: Double = 0.0
    @objc dynamic var cashoutDestinationCode: String = ""
    @objc dynamic var cashoutId: String = ""
    @objc dynamic var campaignId: String = ""
    @objc dynamic var cashoutDestination: String = ""
    var contents: [Contents] = []
    
    convenience init(destinationNumber_: String, destinationAccountName_: String, totalAmount_: Double, created_: String, amount_: Double, cashoutDestinationCode_: String, cashoutId_: String, campaignId_: String, cashoutDestination_: String, contents_: [Contents]) {
        self.init()
        
        self.destinationNumber = destinationNumber_
        self.destinationAccountName = destinationAccountName_
        self.totalAmount = totalAmount_
        self.created = created_
        self.amount = amount_
        self.cashoutId = cashoutId_
        self.campaignId = campaignId_
        self.cashoutDestination = cashoutDestination_
        self.contents = contents_
        
    }
}
