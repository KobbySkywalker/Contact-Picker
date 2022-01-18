//
//  ContributorModel.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 16/04/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class ContributionSections: NSObject {
    
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var totalAmount: Double = 0.0
    @objc dynamic var memberIconPath: String = ""
    @objc dynamic var memberId: String = ""
    var contributions: [Content] = []
    var contribution: [GetCampaignContributionResponse] = []
    
    
    convenience init(firstName_: String, lastName_: String, totalAmount_: Double, memberIconPath_: String, memberId_: String, contributions_: [Content], contribution_: [GetCampaignContributionResponse]) {
        self.init()
        
        self.firstName = firstName_
        self.lastName = lastName_
        self.totalAmount = totalAmount_
        self.memberIconPath = memberIconPath_
        self.contributions = contributions_
        self.memberId = memberId_
        self.contribution = contribution_
        
    }
}

class RecentContributionSections: NSObject {
    
    @objc dynamic var groupName: String = ""
    @objc dynamic var totalAmount: Double = 0.0
    @objc dynamic var displayAmount: String = ""
    @objc dynamic var groupIconPath: String = ""
    @objc dynamic var groupId: String = ""
    var contributions: [Content] = []
    var contribution: [GetCampaignContributionResponse] = []
    
    
    convenience init(groupName_: String, totalAmount_: Double, displayAmount_: String, groupId_: String, groupIconPath_: String, contributions_: [Content], contribution_: [GetCampaignContributionResponse]) {
        self.init()
        
        self.groupName = groupName_
        self.totalAmount = totalAmount_
        self.displayAmount = displayAmount_
        self.groupIconPath = groupIconPath_
        self.contributions = contributions_
        self.groupId = groupId_
        self.contribution = contribution_
        
    }
}
