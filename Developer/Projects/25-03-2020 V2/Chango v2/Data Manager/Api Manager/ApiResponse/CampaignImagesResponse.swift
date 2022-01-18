//
//  CampaignImagesResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 24/09/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct CampaignImagesResponse: Codable {
    var image: [String]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        image = try container.decode([String].self, forKey: .image)
        
        
    }
}
