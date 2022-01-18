//
//  Event.swift
//  iKolilu
//
//  Created by Created by Hosny Ben Savage on 04/08/2016.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import Foundation

class Event: NSObject {
	var status: String
	var message: String
	
	init(status_: String, message_: String) {
		self.status = status_
		self.message = message_
	}
}


class PushEvent: NSObject {

    var message: String
    
    init(message_: String) {
        self.message = message_
    }
}

class ChatEvent: NSObject {
    var groupId: String
    
    init(groupId_: String) {
        self.groupId = groupId_
    }
}


class GroupBalanceEvent: NSObject {
    var groupId: String
    
    init(groupId_: String) {
        self.groupId = groupId_
    }
}

class CampaignEvent: NSObject {
    var groupId: String
    
    init(groupId_: String) {
        self.groupId = groupId_
    }
}


class VoteEvent: NSObject {
    var groupId: String
    
    init(groupId_: String) {
        self.groupId = groupId_
    }
}


class imageEvent: NSObject {
    var groupImages: [String]
    
    init(groupImages_: [String]) {
        self.groupImages = groupImages_
    }
}

class GroupNameChangeEvent: NSObject {
    var groupName: String
    
    init(groupName_: String) {
        self.groupName = groupName_
    }
}


class GroupLinkEvent: NSObject {
    var cashoutPolicy: Double
    var groupDescription: String
    var groupId: String
    var groupName: String
    var tnc: String
    var groupIconPath: String
    var generatedId: String
    var responseMessage: String
    var responseCode: String
    
    init(cashoutPolicy_: Double, groupDescription_: String, groupId_: String, groupName_: String, tnc_: String, groupIconPath_: String, generatedId_: String, responseMessage_: String, responseCode_: String) {
        self.cashoutPolicy = cashoutPolicy_
        self.groupDescription = groupDescription_
        self.groupId = groupId_
        self.groupName = groupName_
        self.tnc = tnc_
        self.groupIconPath = groupIconPath_
        self.generatedId = generatedId_
        self.responseMessage = responseMessage_
        self.responseCode = responseCode_
    }
}

