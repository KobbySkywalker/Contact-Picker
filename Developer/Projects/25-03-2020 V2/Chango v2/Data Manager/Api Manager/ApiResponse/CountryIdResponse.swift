//
//  CountryIdResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 26/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation

struct CountryIdResponse: Codable {
    var countryId: String
    var countryName: String
    var created: String
    var currency: String
    var modified: String?
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        countryId = try container.decode(String.self, forKey: .countryId)
        countryName = try container.decode(String.self, forKey: .countryName)
        created = try container.decode(String.self, forKey: .created)
        currency = try container.decode(String.self, forKey: .currency)
        
        if let mod = try? container.decode(String.self, forKey: .modified) {
            modified = mod
        }
        
    }
}
