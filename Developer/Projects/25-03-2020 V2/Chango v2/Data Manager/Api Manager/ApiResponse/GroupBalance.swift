//
//  GroupBalance.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 07/10/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct GroupBalance: Codable {
    var balance: Double
    var campaignId: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        balance = try container.decode(Double.self, forKey: .balance)
        campaignId = try container.decode(String.self, forKey: .campaignId)
        
    }
}
