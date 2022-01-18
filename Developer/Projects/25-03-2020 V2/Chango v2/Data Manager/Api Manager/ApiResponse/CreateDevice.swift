//
//  CreateDevice.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 14/05/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct createDevice: Codable {
    var id: String
    var memberId: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        memberId = try container.decode(String.self, forKey: .memberId)
        
    }
}
