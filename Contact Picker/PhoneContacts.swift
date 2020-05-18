//
//  PhoneContacts.swift
//  Contact Picker
//
//  Created by Hosny Ben Savage on 11/11/2019.
//  Copyright © 2019 ITConsortium. All rights reserved.
//

import Foundation
import ContactsUI

class PhoneContacts {
    
    class func getContacts(filter: ContactsFilter = .none) -> [MyCNContact] { //  ContactsFilter is Enum find it below
        
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var results: [CNContact] = []
        
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching containers")
            }
        }
        
        var phoneResults: [MyCNContact] = []
        
        for item in results {
            if item.phoneNumbers.count > 1 {
                
                for info in item.phoneNumbers {
                    
                    let contact = MyCNContact()
                    
                    contact.phoneNumber = info.value
                    contact.name = "\(item.givenName) \(item.familyName)"
                    
                    phoneResults.append(MyCNContact(name_: contact.name!, phoneNumber_: contact.phoneNumber!))

                }
                
            }else {

                let singleContact = MyCNContact()
                
                singleContact.name = "\(item.givenName) \(item.familyName)"
                singleContact.phoneNumber = item.phoneNumbers[0].value
                
                phoneResults.append(MyCNContact(name_: singleContact.name!, phoneNumber_: singleContact.phoneNumber!))
            }
            
        }
        return phoneResults
    }
}

enum ContactsFilter {
    case none
    case mail
    case message
}

