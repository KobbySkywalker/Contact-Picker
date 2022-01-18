//
//  GroupTotals.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 11/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct GroupTotalsResponse: Codable {
    var totalCashouts: String
    var totalContributions: String
    var totalGroupLoans: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        totalCashouts = try container.decode(String.self, forKey: .totalCashouts)
        totalContributions = try container.decode(String.self, forKey: .totalContributions)
        totalGroupLoans = try container.decode(String.self, forKey: .totalGroupLoans)
        
    }
    
}
