//
//  SortResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 13/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct Sort: Codable {
    var sorted: Bool
    var unsorted: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        sorted = try container.decode(Bool.self, forKey: .sorted)
        unsorted = try container.decode(Bool.self, forKey: .unsorted)
        
    }
}
