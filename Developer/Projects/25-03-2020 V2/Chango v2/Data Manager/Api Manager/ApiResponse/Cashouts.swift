//
//  Cashouts.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 12/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class Cashouts: Codable {
    var amount: String
    var campaignId: String
    var campaignName: String
    var groupId: String
    var voteId: String
    var cashoutDestinationNumber: String
    var cashoutDestinationCode: String
    var cashoutDestination: String
    var network: String
    var membersRTDB: MembersRTDB
//    var memberId: String
    
    required init(amount_: String, campaignId_: String, campaignName_: String, groupId_: String, voteId_: String, cashoutDestinationNumber_: String, cashoutDestinationCode_: String, cashoutDestination_: String, network_: String, membersRTDB_: MembersRTDB) {
        
        self.amount = amount_
        self.campaignId = campaignId_
        self.campaignName = campaignName_
        self.groupId = groupId_
        self.voteId = voteId_
        self.cashoutDestinationNumber = cashoutDestinationNumber_
        self.cashoutDestinationCode = cashoutDestinationCode_
        self.cashoutDestination = cashoutDestination_
        self.network = network_
        self.membersRTDB = membersRTDB_
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        amount = try container.decode(String.self, forKey: .amount)
        campaignId = try container.decode(String.self, forKey: .campaignId)
        campaignName = try container.decode(String.self, forKey: .campaignName)
        groupId = try container.decode(String.self, forKey: .groupId)
        voteId = try container.decode(String.self, forKey: .voteId)
        cashoutDestinationCode = try container.decode(String.self, forKey: .cashoutDestinationCode)
        cashoutDestinationNumber = try container.decode(String.self, forKey: .cashoutDestinationNumber)
        cashoutDestination = try container.decode(String.self, forKey: .cashoutDestination)
        network = try container.decode(String.self, forKey: .network)
        membersRTDB = try container.decode(MembersRTDB.self, forKey: .membersRTDB)
        
    }
}
