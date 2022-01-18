//
//  ContributionsPage.swift
//  
//
//  Created by Hosny Ben Savage on 16/04/2019.
//

import Foundation

struct ContributionsPage: Codable {
    
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
