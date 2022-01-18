//
//  SendMessage.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 04/04/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class SendMessageParam: Codable {
    var groupId: String
    var key: String
    var message: String
    var timestamp: String
    var userId: String
    
    required init(groupId_: String, key_: String, message_: String, timestamp_: String, userId_: String) {
        
        self.groupId = groupId_
        self.key = key_
        self.message = message_
        self.timestamp = timestamp_
        self.userId = userId_
    }
}
