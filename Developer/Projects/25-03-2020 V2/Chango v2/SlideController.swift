//
//  SlideController.swift
//  MedServe
//
//  Created by Created by Hosny Ben Savage on 06/02/2017.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator
import FirebaseAuth
import PopupDialog
import Nuke
import Alamofire

    class SlideController: ESNavigationController {
        
        var fromPush: Bool = false
        var privateGroups: [GroupResponse] = []
        var groupDates: [String] = []
        var cashoutPolicy: Double = 0.0
        var groupDescription: String = ""
        var groupId: String = ""
        var groupName: String = ""
        var tnc: String = ""
        var generatedId: String = ""
        var groupExists: Bool = false
        var groupIconPath: String = ""
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            
//            _ = SwiftEventBus.onMainThread(self, name: "chats", handler: { result in
//                let event: ChatEvent = result?.object as! ChatEvent
//                print("start chats segue")
//
//                self.chatMessageSegue(event)
//            })
            
            if UserDefaults.standard.bool(forKey: "grouplinkexists") {
                generatedId = UserDefaults.standard.string(forKey: "generatedId")!
                
                let parameter: VerifyGroupLinkParameter = VerifyGroupLinkParameter(id: generatedId)
                verifyGroupLink(verifyGroupLinkParameter: parameter)

            }
            
            _ = SwiftEventBus.onMainThread(self, name: "grouplink") { result in
                let event: GroupLinkEvent = result?.object as! GroupLinkEvent
                
                if event.responseCode == "100" {
                    self.showAlert(title: "Invite via link", message: event.responseMessage)
                }else {
//                    self.showInvitationDialog(animated: true, cashout: event.cashoutPolicy, groupDescription: event.groupDescription, groupId: event.groupId, groupName: event.groupName, tnc: event.tnc, groupIconPath: event.groupIconPath, groupEvent: event)
//                    print("cashout: \(event.cashoutPolicy)")
//
                    let parameter: GroupPoliciesParameter = GroupPoliciesParameter(groupId: event.groupId)
                    self.groupPolicy(groupPolicies: parameter, groupInfo: GroupInviteResponse(countryId_: CountryId(countryId_: "", countryName_: "", created_: "", currency_: "", modified_: ""), groupId_: event.groupId, groupName_: event.groupName, groupType_: "", groupIconPath_: event.groupIconPath, tnc_: event.tnc, status_: "", created_: "", modified_: "", description_: event.groupDescription, messageBody_: "", timestamp_: ""))
                }
                    }
            
            _ = SwiftEventBus.onMainThread(self, name: "push") { result in
                let event: PushEvent = result?.object as! PushEvent
                
                //Alert for in-app notifications
//                let alert = UIAlertController(title: "New Invite", message: event.message, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "View Invite", style: .default, handler: { (alertAction) in
                    //You are going to do your stuff here
                    self.loginResults()

//                }))
//                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
//                    alert.dismiss(animated: true, completion: nil)
//                }))
//                self.present(alert, animated: true, completion: nil)
            }
            
            


            // set left menu view controllers
            let optionalLeftVC = self.storyboard?.instantiateViewController(withIdentifier: "leftdrawer")
            if let leftVC = optionalLeftVC {
                self.setupMenuViewController(.leftMenu, viewController: leftVC)
                if var delegate: MenuDelegate = leftVC as? MenuDelegate{
                    delegate.easySlideNavigationController = self
                }
            }
            delay(2) {
                if self.fromPush == true {
                self.loginResults()
                }
            }
            
        }
        
        func loginResults(){
            
            let vc: InvitationsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "invite") as! InvitationsViewController
            self.pushViewController(vc, animated: true)
        }        
        
         //POP UP DIALOG
        func showInvitationDialog(animated: Bool = true, cashout: Double, groupDescription: String, groupId: String, groupName: String, tnc: String, groupIconPath: String, groupEvent: GroupLinkEvent) {
                //create a custom view controller
                let invitationVC = InvitationDialogViewController(nibName: "InvitationDialogViewController", bundle: nil)
                //create the dialog
                let popup = PopupDialog(viewController: invitationVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
                            
                if (groupIconPath == "") || (groupIconPath == "<null>") {
                    print("group icon is nil")
                    invitationVC.groupImage.image = UIImage(named: "people")
                }else {
                    Nuke.loadImage(with: URL(string: groupIconPath)!, into: invitationVC.groupImage)
                }

                invitationVC.groupName.text = groupName.uppercased()
                invitationVC.groupDescription.text = groupDescription
                invitationVC.termsConditions.text = tnc
            print("cash: \(cashout*100) \(String(format: "%.0f", cashout))")
                invitationVC.cashoutPolicy.text = "\(String(format: "%.0f", cashout))% of members including all administrators are required to vote YES to approve cashout. A single NO vote cancels the vote."
                
                //create first button
                let buttonOne = CancelButton(title: "REJECT INVITE", height: 60) {

                    let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
                        
                        let alert = UIAlertController(title: "Reject Invite", message: "Are you sure you want to reject this invite?", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "Reject", style: .default) { (action: UIAlertAction!) in
        //                    self.present(vc, animated: true, completion: nil)
                            //make call

                        }
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action: UIAlertAction!) in
                        }
                        alert.addAction(okAction)
                        alert.addAction(cancelAction)
                        
                        self.present(alert, animated: true, completion: nil)
                    
                    }
                CancelButton.appearance().titleColor = .red
                
                
                //create second button
                let buttonTwo = DefaultButton(title: "JOIN GROUP", height: 60) {
                    
                    let alert = UIAlertController(title: "JOIN GROUP", message: "By joining \(groupName), you agree to the terms & conditions of \(groupName).", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Yes, Join", style: .default) { (action: UIAlertAction!) in
                        
                        FTIndicator.showProgress(withMessage: "loading")
                        let parameter: JoinPrivateGroupParameter = JoinPrivateGroupParameter(groupId: groupId)
                        self.groupId = groupId
                        self.joinPrivateGroup(joinPrivateGroupParameter: parameter)
                    }
                    
                    let cancelAction = UIAlertAction(title: "Dismiss", style: .default) { (action: UIAlertAction!) in
                        
                    }
                    alert.addAction(cancelAction)
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                DefaultButton.appearance().titleColor = UIColor(red: 62/255, green: 161/255, blue: 71/255, alpha: 1)
                
        //        buttonTwo.tintColor = UIColor(red: 62/255, green: 161/255, blue: 71/255, alpha: 1)
                //Add buttons to dialog
                popup.addButtons([buttonOne, buttonTwo])
                
                //Present dialog
                present(popup, animated: animated, completion: nil)
                
            }
        
        
         //VERIFY GROUP LINK
        func verifyGroupLink(verifyGroupLinkParameter: VerifyGroupLinkParameter) {
            AuthNetworkManager.verifyGroupLink(parameter: verifyGroupLinkParameter) { (result) in
                self.parseVerifyGroupLinkResponse(result: result)
            }
        }
             
             private func parseVerifyGroupLinkResponse(result: DataResponse<VerifyGroupLinkResponse, AFError>){
                switch result.result {
                case .success(let response):
                    print(response)
                    print("clear stored group links")
                    let prefs = UserDefaults.standard
                    prefs.removeObject(forKey: "authenticated")
                    prefs.removeObject(forKey: "grouplinkexists")
                    if response.responseCode == "100" {
                        showAlert(title: "Invite via link", message: response.responseMessage!)
                    }else if response.responseCode == "01" {
                        groupExists = true
                        SwiftEventBus.post("grouplink", sender: GroupLinkEvent(cashoutPolicy_: (response.data?.cashoutPolicy)!, groupDescription_: (response.data?.groupDescription)!, groupId_: (response.data?.groupId)!, groupName_: (response.data?.groupName)!, tnc_: tnc, groupIconPath_: (response.data?.groupIconPath ?? ""), generatedId_: "", responseMessage_: "", responseCode_: ""))
                    }
                    
                    break
                case .failure( _):
                    if result.response?.statusCode == 400 {
                        //                 sessionTimeout()
                        //                show time out
                    }else {
                        //show network error
                        //                 showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
                    }
                }
             }
        
        //GROUP POLICIES
        func groupPolicy(groupPolicies: GroupPoliciesParameter, groupInfo: GroupInviteResponse) {
            AuthNetworkManager.getGroupPolicy(parameter: groupPolicies) { (result) in
                self.parseGetGroupResponse(result: result, groupInfo: groupInfo)
            }
        }
        
        private func parseGetGroupResponse(result: DataResponse<GroupPolicyResponse, AFError>, groupInfo: GroupInviteResponse){
            FTIndicator.dismissProgress()
            switch result.result {
            case .success(let response):

                print("response: \(response.cashout)")
    //            showInvitationDialog(dialogGroup: groupInfo, cashout: response.cashout ?? 0.0, tnc: response.TermsConditions ?? "")
                
                print("print: \(groupInfo.description)")
                
                let vc: JoinGroupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "joingroup") as! JoinGroupVC
                
                vc.cashout = response.cashout ?? ""
                vc.tnc = response.termsAndConditions ?? ""
                vc.groups = groupInfo
                vc.joinViaLink = true
//                self.navigationController?.pushViewController(vc, animated: true)
                self.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
                break
            case .failure(let error):
                
                if result.response?.statusCode == 400 {
                    
//                    sessionTimeout()
                    
                }else {
                    let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        
                    }
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        
        //JOIN GROUP
        func joinGroup(joinGroupParameter: JoinGroupParameter) {
            AuthNetworkManager.joinGroup(parameter: joinGroupParameter) { (result) in
                self.parseJoinGroupResponse(result: result)
            }
        }
        
        
        private func parseJoinGroupResponse(result: DataResponse<JoinGroupResponse, AFError>){
            FTIndicator.dismissProgress()
            switch result.result {
            case .success(let response):
                print(response)
                
                let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
                
                let alert = UIAlertController(title: "Chango", message: "You have joined group successfully.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                
                
                break
            case .failure(let error):
                
                if result.response?.statusCode == 400 {
                    
//                    sessionTimeout()
                    
                }else {
                let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        //NEW JOIN GROUP ENDPOINT
        func joinPrivateGroup(joinPrivateGroupParameter: JoinPrivateGroupParameter) {
            AuthNetworkManager.joinPrivateGroup(parameter: joinPrivateGroupParameter) { (result) in
                self.parseJoinPrivateGroupResponse(result: result)
            }
        }
        
        
        private func parseJoinPrivateGroupResponse(result: DataResponse<JoinPrivateGroupResponse, AFError>){
            FTIndicator.dismissProgress()
            switch result.result {
            case .success(let response):
                print(response)
                
                let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
                
                let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                
                
                break
            case .failure(let error):
                
                if result.response?.statusCode == 400 {
                    
                    //                    sessionTimeout()
                    
                }else {
                    let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        
                    }
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }


    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
