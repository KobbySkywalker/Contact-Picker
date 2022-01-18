//
//  RecentPersonalContribution.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 14/06/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct RecentPersonalContribution: Codable {
    var contributions: [Content]
    var group: GroupCreationResponse
    
    
    private enum CodingKeys: String, CodingKey {
        case contributions
        case group
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        contributions = try container.decode([Content].self, forKey: .contributions)
        group = try container.decode(GroupCreationResponse.self, forKey: .group)
        
        
    }
}
