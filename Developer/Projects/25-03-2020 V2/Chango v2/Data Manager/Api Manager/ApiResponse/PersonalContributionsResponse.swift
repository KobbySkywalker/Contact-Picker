//
//  File.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 04/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation


struct PersonalContributionsResponse: Codable {
    var contributions: [contribution]
    var total: String
    
    
    private enum CodingKeys: String, CodingKey {
        case contributions
        case total
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        contributions = try container.decode([contribution].self, forKey: .contributions)
        total = try container.decode(String.self, forKey: .total)
        
        
    }
}