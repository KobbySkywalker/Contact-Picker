//
//  PhoneContacts.swift
//  Contact Picker
//
//  Created by Hosny Ben Savage on 11/11/2019.
//  Copyright © 2019 ITConsortium. All rights reserved.
//

import Foundation
import ContactsUI


class PhoneContact: NSObject {
    
    var name: String?
    var avatarData: Data?
    var phoneNumber: [String] = [String]()
    var email: [String] = [String]()
    var isSelected: Bool = false
    var isInvited = false
    
    init(contact: CNContact) {
        name        = contact.givenName + " " + contact.familyName
        avatarData  = contact.thumbnailImageData
        for phone in contact.phoneNumbers {
            phoneNumber.append(phone.value.stringValue)
        }
        for mail in contact.emailAddresses {
            email.append(mail.value as String)
        }
    }
    
    required init(name_: String, avatarData_: Data?, phoneNumber_: [String], email_: [String], isSelected_: Bool, isInvited_: Bool) {
        
        name = name_
        avatarData = avatarData_
        phoneNumber = phoneNumber_
        email = email_
        isSelected = isSelected_
        isInvited = isInvited_
    }
    
    override init() {
        super.init()
    }
}

