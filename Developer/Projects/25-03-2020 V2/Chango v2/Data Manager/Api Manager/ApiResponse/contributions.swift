//
//  contributions.swift
//  Chango v2
//
//  Created by Hosny Savage on 15/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct contribution: Codable {
    var amount: Double
    var contributionId: String
    var created: String
    var currency: String
    var memberId: Member
    var groupId: GroupIdInfo
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        amount = try container.decode(Double.self, forKey: .amount)
        contributionId = try container.decode(String.self, forKey: .contributionId)
        created = try container.decode(String.self, forKey: .created)
        currency = try container.decode(String.self, forKey: .currency)
        memberId = try container.decode(Member.self, forKey: .memberId)
        groupId = try container.decode(GroupIdInfo.self, forKey: .groupId)
    }
}


