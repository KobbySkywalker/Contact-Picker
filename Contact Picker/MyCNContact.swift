//
//  MyCNContact.swift
//  Contact Picker
//
//  Created by Hosny Savage on 30/04/2020.
//  Copyright © 2020 ITConsortium. All rights reserved.
//

import Foundation
import ContactsUI


class MyCNContact: NSObject {
    
    var name: String?
    var phoneNumber: CNPhoneNumber?
    
    required init(name_: String, phoneNumber_: CNPhoneNumber) {
        
        name = name_
        phoneNumber = phoneNumber_

    }
    
    override init() {
        super.init()
    }
}
