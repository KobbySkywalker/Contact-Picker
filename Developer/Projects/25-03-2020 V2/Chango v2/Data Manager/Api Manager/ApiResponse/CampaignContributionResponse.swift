//
//  CampaignContributionResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 12/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct CampaignContributionResponse: Codable {
    var content: [Content]
    var first: Bool
    var last: Bool
    var number: Int
    var numberOfElements: Int
    var pageable: Pageable
    var size: Int
    var sort: Sort
    var totalElements: Int
    var totalPages: Int
    
    
    private enum CodingKeys: String, CodingKey {
        case content
        case first
        case last
        case number
        case numberOfElements
        case pageable
        case size
        case sort
        case totalElements
        case totalPages
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        content = try container.decode([Content].self, forKey: .content)
        first = try container.decode(Bool.self, forKey: .first)
        last = try container.decode(Bool.self, forKey: .last)
        number = try container.decode(Int.self, forKey: .number)
        numberOfElements = try container.decode(Int.self, forKey: .numberOfElements)
        pageable = try container.decode(Pageable.self, forKey: .pageable)
        size = try container.decode(Int.self, forKey: .size)
        sort = try container.decode(Sort.self, forKey: .sort)
        totalElements = try container.decode(Int.self, forKey: .totalElements)
        totalPages = try container.decode(Int.self, forKey: .totalPages)
        
    }
}
