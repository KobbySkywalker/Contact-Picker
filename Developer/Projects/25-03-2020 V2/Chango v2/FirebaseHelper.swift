//
//  FirebaseHelper.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 19/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

class FirebaseUserStruct {
    
    
    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var email: String = ""
    
    convenience init(phoneNumber_: String, email_: String) {
        self.init()
        
        self.phoneNumber = phoneNumber_
        self.email = email_
    }
    
}


typealias LookupCompletionHandler = (_ user: FirebaseUserStruct?,_ error: Error?) -> Void

//typealias SignupCompletionHandler = (_ user: FirebaseUserStruct?, _ error: Error?) -> Void


//FIREBASE HELPER PROTOCOL
protocol FirebaseHelperProtocols {

    func lookup(phoneNumber: String, completionHandler: @escaping LookupCompletionHandler)
//    func signup(phoneNumber: String, completionHandler: @escaping SignupCompletionHandler)
}

public class FirebaseHelpers: FirebaseHelperProtocols {
    
    public init() {}
    
    
//SIGNUP
//    func signup(phoneNumber: String, completionHandler: @escaping SignupCompletionHandler) {
//
//
//                // User is signed in
//                // ...
//                //Saving Phone Number to Realtime Database
////                let profiles = Database.database().reference().child("users")
////                print("auth: \((authResult?.user.uid)!)")
////                //            let profile = profiles.child((authResult?.user.uid)!)
////                let profile = profiles.child((authResult?.user.phoneNumber)!)
////
////                profile.observeSingleEvent(of: .value, with: { (snapshot) in
////                    let snapshot = snapshot.value as? NSDictionary
////                    if (snapshot == nil) {
////                        print("\(self.phone)")
////                        print("\(self.area)")
////                        print("\(self.name)")
////                        print("\(self.mail)")
////
////                        profile.child("number").setValue(self.phone)
////                        profile.child("area Code").setValue(self.area)
////                        profile.child("name").setValue(self.name)
////                        profile.child("email").setValue(self.mail)
////                    }
////                })
//            }
    
    

    //LOOKUP
    func lookup(phoneNumber: String, completionHandler: @escaping LookupCompletionHandler) {
         let userProfiles = Database.database().reference().child("users")

        let userProfile = userProfiles.child(phoneNumber)
        userProfile.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                print(snapshot)
				
                if let snapDict = snapshot.value as? String {
                   let user = FirebaseUserStruct(phoneNumber_: phoneNumber, email_: snapDict)
                    completionHandler(user, nil)
                }else {
                    let message: String = "User does not have an account. Please sign up"
                    completionHandler(nil, NSError.createError(message))
    
                }
            }else{
                let message: String = "User does not have an account. Please sign up"
                completionHandler(nil, NSError.createError(message))
            }
        }
    )}
    
    
}


