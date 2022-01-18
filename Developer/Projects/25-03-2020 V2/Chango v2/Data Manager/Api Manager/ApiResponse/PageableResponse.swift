//
//  PageableResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 13/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct Pageable: Codable {
    var offset: Int
    var pageNumber: Int
    var pageSize: Int
    var paged: Bool
    var unpaged: Bool
    
    private enum CodingKeys: String, CodingKey {
        case offset
        case pageNumber
        case pageSize
        case paged
        case unpaged
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        offset = try container.decode(Int.self, forKey: .offset)
        pageNumber = try container.decode(Int.self, forKey: .pageNumber)
        pageSize = try container.decode(Int.self, forKey: .pageSize)
        paged = try container.decode(Bool.self, forKey: .paged)
        unpaged = try container.decode(Bool.self, forKey: .unpaged)

    }

}
