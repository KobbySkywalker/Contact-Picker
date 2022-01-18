//
//  Votes.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 18/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class Votes: Codable {
    var amount: String
    var campaignId: String
    var campaignName: String
    var groupId: String
    var role: String
    var voteId: String
    var membersRTDB: MembersRTDB
    var voteType: String
    
    required init(amount_: String, campaignId_: String, campaignName_: String, groupId_: String, role_: String, voteId_: String, membersRTDB_: MembersRTDB, voteType_: String) {
        
        self.amount = amount_
        self.campaignId = campaignId_
        self.campaignName = campaignName_
        self.groupId = groupId_
        self.role = role_
        self.voteId = voteId_
        self.membersRTDB = membersRTDB_
        self.voteType = voteType_
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        amount = try container.decode(String.self, forKey: .amount)
        campaignId = try container.decode(String.self, forKey: .campaignId)
        campaignName = try container.decode(String.self, forKey: .campaignName)
        groupId = try container.decode(String.self, forKey: .groupId)
        voteId = try container.decode(String.self, forKey: .voteId)
        membersRTDB = try container.decode(MembersRTDB.self, forKey: .membersRTDB)
        voteType = try container.decode(String.self, forKey: .voteType)
        role = try container.decode(String.self, forKey: .role)

    }
}
