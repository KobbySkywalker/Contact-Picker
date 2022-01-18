//
//  PublicContact.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 12/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct PublicContact: Codable {
    var contactType: String
    var contactValue: String
    var group: MemberGroupIdResponse
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        contactValue = try container.decode(String.self, forKey: .contactValue)
        contactType = try container.decode(String.self, forKey: .contactType)
        group = try container.decode(MemberGroupIdResponse.self, forKey: .group)
    }
}
