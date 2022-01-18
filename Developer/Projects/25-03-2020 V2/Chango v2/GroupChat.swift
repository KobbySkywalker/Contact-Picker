//
//  GroupChat.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 04/04/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class GroupChat: NSObject {
    var messages: Message
    
    
    required init(messages_: Message) {
        
        self.messages = messages_
        
    }
}
