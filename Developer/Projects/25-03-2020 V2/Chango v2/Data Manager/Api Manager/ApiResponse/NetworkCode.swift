//
//  File.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 22/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation

struct NetworkCode: Codable {
    var name: String
    var networkCode: String
    
     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        networkCode = try container.decode(String.self, forKey: .networkCode)
        name = try container.decode(String.self, forKey: .name)
        
    }

}

