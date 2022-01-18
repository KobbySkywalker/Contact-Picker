//
//  ExpiryDate.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 24/10/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct ExpiryDate: Codable {
    var duration: [String]
    var frequency: [String]
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        duration = try container.decode([String].self, forKey: .duration)
        frequency = try container.decode([String].self, forKey: .frequency)
        
        
    }
}
