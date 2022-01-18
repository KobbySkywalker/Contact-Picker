//
//  Grants.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 12/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class Grants: Codable {
    var amount: String
    var campaignId: String
    var campaignName: String
    var groupId: String
    var voteId: String
    var reason: String
    var membersRTDB: MembersRTDB
    var memberId: String
    
    required init(amount_: String, campaignId_: String, campaignName_: String, groupId_: String, voteId_: String, reason_: String, memberId_: String, membersRTDB_: MembersRTDB) {
        
        self.amount = amount_
        self.campaignId = campaignId_
        self.campaignName = campaignName_
        self.groupId = groupId_
        self.voteId = voteId_
        self.reason = reason_
        self.memberId = memberId_
        self.membersRTDB = membersRTDB_
    }
    
}
