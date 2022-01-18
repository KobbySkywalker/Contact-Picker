//
//  CountryId.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 13/12/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation

class CountryId: Codable {
    var countryId: String? = ""
    var countryName: String = ""
    var created: String? = ""
    var currency: String = ""
    var modified: String? = ""
    
    
    private enum CodingKeys: String, CodingKey {
        case countryId
        case countryName
        case created
        case currency
        case modified

    }
    
    required init(countryId_: String, countryName_: String, created_: String, currency_: String, modified_: String) {
        
        self.countryId = countryId_
        self.countryName = countryName_
        self.created = created_
        self.currency = currency_
        self.modified = modified_
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
//        countryId = try container.decode(String.self, forKey: .countryId)
        countryName = try container.decode(String.self, forKey: .countryName)
        currency = try container.decode(String.self, forKey: .currency)
        
        if let ctryd = try? container.decode(String.self, forKey: .countryId) {
            countryId = ctryd
        }
        
        if let mod = try? container.decode(String.self, forKey: .modified) {
            modified = mod
        }
        
        if let cre = try? container.decode(String.self, forKey: .created) {
            created = cre
        }
        
    }
}

