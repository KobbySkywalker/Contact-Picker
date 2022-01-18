//
//  Mandate.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 04/09/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class Mandate: Codable {
    var amount: String
    var campaignName: String
    var created: String
    var currency: String
    var duration: String
    var expired: String
    var frequencyType: String
    var groupName: String
    var lastDebitDate: String
    var mandateId: String?
    var modified: String
    var msisdn: String
    var status: String
    var thirdPartyReferenceNo: String
    
    
    required init(amount_: String, campaignName_: String, created_: String, currency_: String, duration_: String, expired_: String, frequencyType_: String, groupName_: String, lastDebitDate_: String, mandateId_: String, modified_: String, msisdn_: String, status_: String, thirdPartyReferenceNo_: String) {
        
        self.amount = amount_
        self.campaignName = campaignName_
        self.created = created_
        self.currency = currency_
        self.duration = duration_
        self.expired = expired_
        self.groupName = groupName_
        self.frequencyType = frequencyType_
        self.lastDebitDate = lastDebitDate_
        self.mandateId = mandateId_
        self.modified = modified_
        self.msisdn = msisdn_
        self.status = status_
        self.thirdPartyReferenceNo = thirdPartyReferenceNo_
    }
    
}
