//
//  MemberNetworkResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 13/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct MemberNetworkResponse: Codable {
    
    var msisdn: String
    var network: String

    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        msisdn = try container.decode(String.self, forKey: .msisdn)
        network = try container.decode(String.self, forKey: .network)

        
    }
}
