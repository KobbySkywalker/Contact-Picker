//
//  ContributorsModel.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 21/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

class ContributionSection: NSObject {
    
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var totalAmount: Double = 0.0
    @objc dynamic var memberIconPath: String = ""
    var contributions: [contribution] = []

    
    convenience init(firstName_: String, lastName_: String, totalAmount_: Double, memberIconPath_: String, contributions_: [contribution]) {
        self.init()
        
        self.firstName = firstName_
        self.lastName = lastName_
        self.totalAmount = totalAmount_
        self.memberIconPath = memberIconPath_
        self.contributions = contributions_

    }
}

