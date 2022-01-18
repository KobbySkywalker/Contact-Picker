//
//  SignInViewModel.swift
//  Chango v2
//
//  Created by Hosny Savage on 29/06/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import Foundation

//class SignInViewModel {
//    
//    //PASSWORD RESET DIALOG
//    func showPasswordResetDialog(animated: Bool = true) {
//        //create a custom view controller
//        let passwordVC = PasswordResetCell(nibName: "PasswordResetCell", bundle: nil)
//        //create the dialog
//        let popup = PopupDialog(viewController: passwordVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
//        //create first button
//        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
//        }
//        //create second button
//        let buttonTwo = DefaultButton(title: "VERIFY", height: 60) {
//            if(passwordVC.emailAddress.text?.isEmpty)!{
//                self.showAlert(title: "Password Reset", message: "Please enter email")
//            }else {
//                FTIndicator.init()
//                FTIndicator.setIndicatorStyle(UIBlurEffect.Style.dark)
//                FTIndicator.showProgress(withMessage: "Checking", userInteractionEnable: false)
//                Auth.auth().sendPasswordReset(withEmail: passwordVC.emailAddress.text!) { (error) in
//                    FTIndicator.dismissProgress()
//                    if error != nil {
//                        self.showAlert(withTitle: "Sign in", message: error!.localizedDescription)
//                    }else{
//                        FTIndicator.dismissProgress()
//                        self.showAlert(title: "Chango", message: "An email has been sent to \(passwordVC.emailAddress.text ?? "your mail")")
//                        print("email sent")
//                    }
//                }
//            }
//        }
//        //Add buttons to dialog
//        popup.addButtons([buttonOne, buttonTwo])
//        //Present dialog
//        present(popup, animated: animated, completion: nil)
//    }
//      
//      
//      
//    func updateRegistrationToken(updateRegistrationTokenParameter: UpdateRegistrationTokenParameter) {
//        AuthNetworkManager.updateRegistrationToken(parameter: updateRegistrationTokenParameter) { (result) in
//            print("result: \(result)")
//        }
//    }
//      
//    private func parseUpdateRegistrationToken(result: DataResponse<String, AFError>){
//        switch result.result {
//        case .success(let response):
//            print("response: \(response)")
//            break
//        case .failure(let error):
//            if result.response?.statusCode == 400 {
//                sessionTimeout()
//            }else {
//                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
//            }
//        }
//    }
//      
//    func memberExists(memberExistsParameter: MemberExistsParameter) {
//        AuthNetworkManager.memberExists(parameter: memberExistsParameter) { (result) in
//            FTIndicator.dismissProgress()
//            print("member exists: \(result)")
//            self.memberExists = result
//            if (self.memberExists == "true") {
//                print("member exists")
//                let vc: SlideController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! SlideController
//                vc.fromPush = self.fromPush
//                let idToken = UserDefaults.standard.string(forKey: "idToken")
//                let parameterr: UpdateRegistrationTokenParameter = UpdateRegistrationTokenParameter(registrationToken: idToken!)
//                print("reg token: \(idToken!)")
//                FTIndicator.dismissProgress()
//                self.present(vc, animated: true, completion: nil)
//            }else if (self.memberExists == "false") {
//                print("member does not ex")
//                self.areaCodeSearch(phoneNumber: self.phoneNumber)
//                let vc: CompleteRegistrationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "complete") as! CompleteRegistrationVC
//                vc.email = (self.currentUser?.email)!
//                vc.phone = self.phoneNumber
//                vc.failedSignUp = true
//                vc.areaCode = self.areaCode
//                print("area: \(self.areaCode)")
//                print("phone: \(self.phoneNumber)")
//                self.present(vc, animated: true, completion: nil)
//            }
//        }
//    }
//      
//    func fetchUserObject(completionHandler: @escaping FetchUIDCompletionHandler) {
//        
//        let groupsRef = Database.database().reference().child("users")
//        let user = Auth.auth().currentUser
//        let uid = groupsRef.child("\((user?.uid)!)")
//        print("uid: \(uid)")
//        _ = uid.observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            
//            if let snapshotValue = snapshot.value as? [String: AnyObject] {
//                
//                var authId = ""
//                if let authProviderId = snapshotValue["authProviderId"] as? String {
//                    authId = authProviderId
//                }
//                
//                var mail = ""
//                if let email = snapshotValue["email"] as? String {
//                    mail = email
//                }
//                
//                var mmbrId = ""
//                if let memberId = snapshotValue["memberId"] as? String {
//                    mmbrId = memberId
//                }
//                
//                var mssdn = ""
//                if let msisdn = snapshotValue["msisdn"] as? String {
//                    mssdn = msisdn
//                }
//                
//                var nm = ""
//                if let name = snapshotValue["name"] as? String {
//                    nm = name
//                }
//                
//                let users = UserObject(authProviderId_: authId, email_: mail, memberId_: mmbrId, msisdn_: mssdn, name_: nm)
//                
//                self.userObject = users
//                print("info \(users)")
//                completionHandler(users)
//            }else {
//                let users = UserObject(authProviderId_: "", email_: "", memberId_: "", msisdn_: "", name_: "")
//                
//                completionHandler(users)
//            }
//            
//        })
//    }
//      
//      
//      
//    func createDevice(createDeviceParameter: CreateDeviceParameter){
//        AuthNetworkManager.createDevice(parameter: createDeviceParameter) { (result) in
//            self.parseCreateDevice(result: result)
//        }
//    }
//      
//    private func parseCreateDevice(result: DataResponse<createDevice, AFError>){
//        switch result.result {
//        case .success(let response):
//            print(response)
//            break
//        case .failure(let error):
//            if result.response?.statusCode == 400 {
//                sessionTimeout()
//            }else {
//                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
//            }
//        }
//    }
//      
//      //verify id
//    func getVerifyIDToken(){
//        let currentUser = Auth.auth().currentUser
//        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
//            if let error = error {
//                // Handle error
//                print("error: \(error.localizedDescription)")
//                return
//            }
//            print("id token: \(String(describing: idToken))")
//            let def: UserDefaults = UserDefaults.standard
//            def.set(idToken, forKey: "idToken")
//            // Send token to your backend via HTTPS
//            // ...
//            self.fetchUserObject { (result) in
//                print(result)
//                print("authProvider: \(result.authProviderId)")
//                if result.authProviderId == "" {
//                    print("empty")
//                    self.areaCodeSearch(phoneNumber: (self.currentUser?.phoneNumber)!)
//                    let vc: CompleteRegistrationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "complete") as! CompleteRegistrationVC
//                    print("not a user in the fb rtdb")
//                    vc.email = (self.currentUser?.email)!
//                    vc.phone = (self.currentUser?.phoneNumber)!
//                    vc.failedSignUp = true
//                    vc.areaCode = self.areaCode
//                    print("area: \(self.areaCode)")
//                    print("phone: \(self.phoneNumber)")
//                    FTIndicator.dismissProgress()
//                    self.present(vc, animated: true, completion: nil)
//                }else {
//                    print("not empty")
//                    let vc: SlideController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! SlideController
//                    vc.fromPush = self.fromPush
//                    vc.modalPresentationStyle = .fullScreen
//                    let idToken = UserDefaults.standard.string(forKey: "idToken")
//                    //confirm user has signed in
//                    UserDefaults.standard.set(true, forKey: "authenticated")
//                    let parameterr: UpdateRegistrationTokenParameter = UpdateRegistrationTokenParameter(registrationToken: idToken!)
//                    print("reg token: \(idToken!)")
//                    FTIndicator.dismissProgress()
//                    
//                    self.present(vc, animated: true, completion: nil)
//                }
//            }
//        }
//    }
//}
