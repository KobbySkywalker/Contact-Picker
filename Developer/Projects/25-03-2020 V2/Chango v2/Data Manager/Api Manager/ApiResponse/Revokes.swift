//
//  Revokes.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 12/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class Revokes: Codable {
    var role: String
    var groupId: String
    var voteId: String
    var memberId: String
    var membersRTDB: MembersRTDB
    
    required init(role_: String, groupId_: String, voteId_: String, memberId_: String, membersRTDB_: MembersRTDB) {
        
        self.role = role_
        self.groupId = groupId_
        self.voteId = voteId_
        self.memberId = memberId_
        self.membersRTDB = membersRTDB_
    }
    
}
