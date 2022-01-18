//
//  Feedback.swift
//  
//
//  Created by Hosny Ben Savage on 12/03/2019.
//

import Foundation

struct Feedback: Codable {
    var campaignId: String
    var created: String
    var id: String
    var message: String
    var name: String
    var phone: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        campaignId = try container.decode(String.self, forKey: .campaignId)
        created = try container.decode(String.self, forKey: .created)
        id = try container.decode(String.self, forKey: .id)
        message = try container.decode(String.self, forKey: .message)
        name = try container.decode(String.self, forKey: .name)
        phone = try container.decode(String.self, forKey: .phone)

        
    }
    
}
