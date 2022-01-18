//
//  ContactId.swift
//  
//
//  Created by Hosny Ben Savage on 12/03/2019.
//

import Foundation

struct ContactId: Codable {
    var contactType: String
    var groupId: MemberGroupIdResponse
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        contactType = try container.decode(String.self, forKey: .contactType)
        groupId = try container.decode(MemberGroupIdResponse.self, forKey: .groupId)
        
    }
}
