//
//  MembersViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 23/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import Nuke
import FTIndicator
import FirebaseAuth


class MembersViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var easySlideNavigationController: ESNavigationController?

    let mem = ["Tsatus Adogla-Bessa", "Nathany Attipoe", "Eric Arden", "Esi Duku Prah"]

    var members: [MemberResponse] = []
    let cell = "cellId"
    var groupId: String = ""
    var groupInfo: PrivateResponse!
    var adminResponse: String = ""
    
    @IBOutlet weak var mainAddMemberButton: UIButton!
    @IBOutlet weak var addMemberButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var membersCount: UILabel!
    
    var loanFlag: Int = 0
    var voteId: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()

        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableView.register(UINib(nibName: "MemberCell", bundle: nil), forCellReuseIdentifier: "MemberCell")
        self.tableView.tableFooterView = UIView()
        
        if adminResponse == "true" {
            addMemberButton.isHidden = false
            mainAddMemberButton.isHidden = false
        }else {
            addMemberButton.isHidden = true
            mainAddMemberButton.isHidden = true
        }
        
        
        let parameter: GetMemberParameter = GetMemberParameter(groupId: groupId)
        print("parameter \(parameter)")
        getMembers(getMembersParameter: parameter)
//        FTIndicator.showProgress(withMessage: "loading members", userInteractionEnable: false)
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addMemberButtonAction(_ sender: UIButton) {
        
        let vc: AddMemberViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "add") as! AddMemberViewController
        vc.groupId = groupId
        vc.members = members
//        self.navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MemberCell = self.tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberCell
        cell.selectionStyle = .none
        
        self.members = members.sorted(by: {$0.memberId.firstName < $1.memberId.firstName})
        
        //MEMBER CELLS & URL IMAGE LOGIC
        let myMembers: MemberResponse = self.members[indexPath.row]
        
        cell.userImage.image = nil
        cell.userImage.image = UIImage(named: "defaulticon")
//        let url = URL(string: myMembers.memberId.memberIconPath!)
        cell.userName.text = "\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)"
        cell.msisdn.text = myMembers.memberId.msisdn
//        for item in members {
//            self.members.append(item)
//            self.tableView.reloadData()
//        }
//
        if (myMembers.memberId.memberIconPath == nil) || (myMembers.memberId.memberIconPath! == "=") || (myMembers.memberId.memberIconPath! == ""){
            cell.userImage.image = UIImage(named: "defaulticon")
        }else {
            guard let memberImage = URL(string: myMembers.memberId.memberIconPath!) else { return cell }
            Nuke.loadImage(with: memberImage, into: cell.userImage)
            print("name image: \(myMembers.memberId.firstName), \(myMembers.memberId.memberIconPath!), \(myMembers.role)")
        }

        
        //MEMBER STATUS LABEL LOGIC
        
        let user: String! = UserDefaults.standard.string(forKey: "users")
        
        if user == "\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)" && (Auth.auth().currentUser?.phoneNumber == "+\(myMembers.memberId.msisdn)"){
            cell.userName.text = "You"
        }else {
            cell.userName.text = "\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)"
        }
                
        
        //if member is an admin
        if myMembers.role == "admin"{
            
            cell.memberStatus.text = "Admin"
//            cell.memberStatus.backgroundColor = UIColor(red: 50/255, green: 54/255, blue: 66/255, alpha: 1)
            cell.memberStatus.isHidden = false
            //if admin is the current user
            if user == "\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)" && (Auth.auth().currentUser?.phoneNumber == "+\(myMembers.memberId.msisdn)"){
                cell.userName.text = "You"

            }else {
                cell.userName.text = "\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)"

            }
            //if member is an approver
        }else if myMembers.role == "approver" {

            cell.memberStatus.text = "Approver"
//            cell.memberStatus.backgroundColor = UIColor(red: 50/255, green: 54/255, blue: 66/255, alpha: 1)
            cell.memberStatus.isHidden = false
            
            //if approver is the current user
            if user == "\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)" && (Auth.auth().currentUser?.phoneNumber == "+\(myMembers.memberId.msisdn)"){
                cell.userName.text = "You"

            }else {
                cell.userName.text = "\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)"
            }
            //if member is just a member
        }else {
            cell.memberStatus.isHidden = false
            cell.memberStatus.text = "Member"
//            cell.memberStatus.backgroundColor = UIColor(red: 50/255, green: 54/255, blue: 66/255, alpha: 1)
            if user == "\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)" && (Auth.auth().currentUser?.phoneNumber == "+\(myMembers.memberId.msisdn)"){
                cell.userName.text = "You"
            }else {
                cell.userName.text = "\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)"
            }
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let myMembers: MemberResponse = self.members[indexPath.row]
        print("\(myMembers.memberId.firstName) = \(myMembers.role)")
        
        let user: String! = UserDefaults.standard.string(forKey: "users")

        switch UIDevice.current.screenType {
            
            
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
        let actionSheetController: UIAlertController = UIAlertController(title: "Choose action", message: "", preferredStyle: .actionSheet)
        
        //Create and add the "Cancel" action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
            print("you cancelled")

        }
        
        let revokeApprover: UIAlertAction = UIAlertAction(title: "Revoke Approver", style: .default) { action -> Void in
            print("you just revoked an approver")
            FTIndicator.showProgress(withMessage: "loading")
//            let parameter: RevokeLoanApproverParameter = RevokeLoanApproverParameter(groupId: myMembers.groupId.groupId, memberId: myMembers.memberId.memberId!, status: "1")
//            self.revokeLoanApprover(revokeLoanApproverParameter: parameter)
            let parameter: InitiateApproverRevokalParameter = InitiateApproverRevokalParameter(groupId: myMembers.groupId.groupId, memberIdOnAction: myMembers.memberId.memberId!)
            self.initiateApproverRevokal(initiateApproverRevokalParameter: parameter)
            
        }
        
        let makeApprover: UIAlertAction = UIAlertAction(title: "Make Approver", style: .default) { action -> Void in
            //Create Loan Approver Call
            FTIndicator.showProgress(withMessage: "loading")
//            let parameter: CreateLoanApproverParameter = CreateLoanApproverParameter(groupId: myMembers.groupId.groupId, memberId: myMembers.memberId.memberId!, status: "1")
            let parameter: MakeLoanApproverParameter = MakeLoanApproverParameter(groupId: myMembers.groupId.groupId, memberId: myMembers.memberId.memberId!, status: "1")
            print("groupId: \(myMembers.groupId.groupId)")
            print("memberId: \(myMembers.memberId.memberId!)")
            
//                    self.createLoanApprover(createLoanApproverParameter: parameter)
            self.makeLoanApprover(makeLoanApproverParameter: parameter)

        }

        
        let makeAdmin: UIAlertAction = UIAlertAction(title: "Make Admin", style: .default) { action -> Void in
            print("you just made an admin")
            FTIndicator.showProgress(withMessage: "loading")

            //Create Admin Call
//            let parameter: CreateAdminParameter = CreateAdminParameter(groupId: myMembers.groupId.groupId, memberId: myMembers.memberId.memberId!, status: "1")
            print("groupId: \(myMembers.groupId.groupId)")
            print("memberId: \(myMembers.memberId.memberId!)")
//                self.createAdmin(createAdminParameter: parameter)
            
            let parameterr: InitiateAdminCreationParameter = InitiateAdminCreationParameter(groupId: myMembers.groupId.groupId, memberIdOnAction: myMembers.memberId.memberId!)
            self.initiateAdminCreation(initiateAdminCreationParameter: parameterr)
        }
        
        
        //Initiate Revoke Admin
        let revokeAdmin: UIAlertAction = UIAlertAction(title: "Revoke Admin", style: .default) { action -> Void in
            FTIndicator.showProgress(withMessage: "loading")
            print("you just revoked an admin")
//            let parameter: RevokeAdminParameter = RevokeAdminParameter(groupId: myMembers.groupId.groupId, memberId: myMembers.memberId.memberId!, status: "1")
            let parameter: InitiateAdminRevokalParameter = InitiateAdminRevokalParameter(groupId: myMembers.groupId.groupId, memberIdOnAction: myMembers.memberId.memberId!)
            print("groupId: \(myMembers.groupId.groupId)")
            print("memberId: \(myMembers.memberId.memberId!)")
            self.initiateAdminRevokal(initiateAdminRevokalParameter: parameter)
//            self.revokeAdmin(revokeAdminParameter: parameter)
            
        }
        
        
        let revokeMember: UIAlertAction = UIAlertAction(title: "Remove Member", style: .default) { action -> Void in
            FTIndicator.showProgress(withMessage: "loading")
            print("you just revoked a member")
            //Create Admin Call
            let parameter: InitiateDropMemberParameter = InitiateDropMemberParameter(groupId: myMembers.groupId.groupId, memberIdOnAction: myMembers.memberId.memberId!)
            print("groupId: \(myMembers.groupId.groupId)")
            print("memberId: \(myMembers.memberId.memberId!)")
                self.initiateDropMember(initiateDropMemberParameter: parameter)
        }
        
        
        let revokeUser: UIAlertAction = UIAlertAction(title: "Leave Group", style: .default) { action -> Void in
            print("you just revoked a member")
            
        }
            
            
            
                            //check for current user
                        if adminResponse == "true" {
                            if ((adminResponse == "true") && (myMembers.role == "admin") && ("\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)" == user)) {
                                //Curent user who is an admin - do nothing
                                
                                
                                //check selected member's role
                            }else if ((adminResponse == "true") && (myMembers.role != "admin") && ("\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)" != user) && (myMembers.role != "approver")) && (loanFlag == 1) {
                            print("\(myMembers.memberId.firstName), \(myMembers.role)")
                            print("member not an admin and not a loaner and accepts loans")
                            //make admin
                            actionSheetController.addAction(makeAdmin)
                            //make approver
                            actionSheetController.addAction(makeApprover)
                            //remove member
                            actionSheetController.addAction(revokeMember)
                            actionSheetController.addAction(cancelAction)
                            self.present(actionSheetController, animated: true, completion: nil)

                            
                            }else if ((adminResponse == "true") && (myMembers.role != "admin") && ("\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)" != user) && (myMembers.role == "approver"))  && (loanFlag == 1){
                                print("admin respone true, member not an admin but an approver and accepts loans")
                                //revoke approver
                                actionSheetController.addAction(revokeApprover)
                                //remove member
                                actionSheetController.addAction(revokeMember)
                                actionSheetController.addAction(cancelAction)
                                self.present(actionSheetController, animated: true, completion: nil)
                            }
                            
                            else if ((adminResponse == "true") && (myMembers.role == "admin") && ("\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)" != user) && (myMembers.role != "approver")) {
                                print("member an admin and not an approver")
                                //revoke approver
                                actionSheetController.addAction(revokeAdmin)
                                //revoke member
                                actionSheetController.addAction(revokeMember)
                                actionSheetController.addAction(cancelAction)
                                self.present(actionSheetController, animated: true, completion: nil)
                                
                            }else if ((adminResponse == "true") && (myMembers.role != "admin") && ("\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)" != user) && (myMembers.role == "approver"))  && (loanFlag == 0){
                                print("admin respone true, member not an admin but an approver and does not accepts loans")
                                //revoke approver
//                                actionSheetController.addAction(revokeApprover)
                                //remove member
                                actionSheetController.addAction(revokeMember)
                                actionSheetController.addAction(cancelAction)
                                self.present(actionSheetController, animated: true, completion: nil)
                            }else if ((adminResponse == "true") && (myMembers.role != "admin") && ("\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)" != user) && (myMembers.role != "approver")) && (loanFlag == 0) {
                                print("\(myMembers.memberId.firstName), \(myMembers.role)")
                                print("member not an admin and not a loaner and does not accepts loans")
                                //make admin
                                actionSheetController.addAction(makeAdmin)
                                //make approver
//                                actionSheetController.addAction(makeApprover)
                                //remove member
                                actionSheetController.addAction(revokeMember)
                                actionSheetController.addAction(cancelAction)
                                self.present(actionSheetController, animated: true, completion: nil)
                                
                                
                            }

        }
        
            default:
            let actionSheetController: UIAlertController = UIAlertController(title: "Choose action", message: "", preferredStyle: .alert)
                    
                    //Create and add the "Cancel" action
                    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                        //Just dismiss the action sheet
                        print("you cancelled")

                    }
                    
                    let revokeApprover: UIAlertAction = UIAlertAction(title: "Revoke Approver", style: .default) { action -> Void in
                        print("you just revoked an approver")
                        FTIndicator.showProgress(withMessage: "loading")
            //            let parameter: RevokeLoanApproverParameter = RevokeLoanApproverParameter(groupId: myMembers.groupId.groupId, memberId: myMembers.memberId.memberId!, status: "1")
            //            self.revokeLoanApprover(revokeLoanApproverParameter: parameter)
                        let parameter: InitiateApproverRevokalParameter = InitiateApproverRevokalParameter(groupId: myMembers.groupId.groupId, memberIdOnAction: myMembers.memberId.memberId!)
                        self.initiateApproverRevokal(initiateApproverRevokalParameter: parameter)
                        
                    }
                    
                    let makeApprover: UIAlertAction = UIAlertAction(title: "Make Approver", style: .default) { action -> Void in
                        //Create Loan Approver Call
                        FTIndicator.showProgress(withMessage: "loading")
//                        let parameter: CreateLoanApproverParameter = CreateLoanApproverParameter(groupId: myMembers.groupId.groupId, memberId: myMembers.memberId.memberId!, status: "1")
//                        print("groupId: \(myMembers.groupId.groupId)")
//                        print("memberId: \(myMembers.memberId.memberId!)")
//
//                                self.createLoanApprover(createLoanApproverParameter: parameter)
                        
                        let parameter: MakeLoanApproverParameter = MakeLoanApproverParameter(groupId: myMembers.groupId.groupId, memberId: myMembers.memberId.memberId!, status: "1")
                        print("groupId: \(myMembers.groupId.groupId)")
                        print("memberId: \(myMembers.memberId.memberId!)")
                        
                        //                    self.createLoanApprover(createLoanApproverParameter: parameter)
                        self.makeLoanApprover(makeLoanApproverParameter: parameter)
                    }

                    
                    let makeAdmin: UIAlertAction = UIAlertAction(title: "Make Admin", style: .default) { action -> Void in
                        print("you just made an admin")
                        FTIndicator.showProgress(withMessage: "loading")

                        //Create Admin Call
            //            let parameter: CreateAdminParameter = CreateAdminParameter(groupId: myMembers.groupId.groupId, memberId: myMembers.memberId.memberId!, status: "1")
                        print("groupId: \(myMembers.groupId.groupId)")
                        print("memberId: \(myMembers.memberId.memberId!)")
            //                self.createAdmin(createAdminParameter: parameter)
                        
                        let parameterr: InitiateAdminCreationParameter = InitiateAdminCreationParameter(groupId: myMembers.groupId.groupId, memberIdOnAction: myMembers.memberId.memberId!)
                        self.initiateAdminCreation(initiateAdminCreationParameter: parameterr)
                    }
                    
                    
                    //Initiate Revoke Admin
                    let revokeAdmin: UIAlertAction = UIAlertAction(title: "Revoke Admin", style: .default) { action -> Void in
                        FTIndicator.showProgress(withMessage: "loading")
                        print("you just revoked an admin")
            //            let parameter: RevokeAdminParameter = RevokeAdminParameter(groupId: myMembers.groupId.groupId, memberId: myMembers.memberId.memberId!, status: "1")
                        let parameter: InitiateAdminRevokalParameter = InitiateAdminRevokalParameter(groupId: myMembers.groupId.groupId, memberIdOnAction: myMembers.memberId.memberId!)
                        print("groupId: \(myMembers.groupId.groupId)")
                        print("memberId: \(myMembers.memberId.memberId!)")
                        self.initiateAdminRevokal(initiateAdminRevokalParameter: parameter)
            //            self.revokeAdmin(revokeAdminParameter: parameter)
                        
                    }
                    
                    
                    let revokeMember: UIAlertAction = UIAlertAction(title: "Remove Member", style: .default) { action -> Void in
                        FTIndicator.showProgress(withMessage: "loading")
                        print("you just revoked a member")
                        //Create Admin Call
                        let parameter: InitiateDropMemberParameter = InitiateDropMemberParameter(groupId: myMembers.groupId.groupId, memberIdOnAction: myMembers.memberId.memberId!)
                        print("groupId: \(myMembers.groupId.groupId)")
                        print("memberId: \(myMembers.memberId.memberId!)")
                            self.initiateDropMember(initiateDropMemberParameter: parameter)
                    }
                    
                    
                    let revokeUser: UIAlertAction = UIAlertAction(title: "Leave Group", style: .default) { action -> Void in
                        print("you just revoked a member")
                        
                    }
                        
                        
                        
                                        //check for current user
                                    if adminResponse == "true" {
                                        if ((adminResponse == "true") && (myMembers.role == "admin") && ("\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)" == user)) {
                                            //Curent user who is an admin - do nothing
                                            
                                            
                                            //check selected member's role
                                        }else if ((adminResponse == "true") && (myMembers.role != "admin") && ("\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)" != user) && (myMembers.role != "approver")) && (loanFlag == 1) {
                                        print("\(myMembers.memberId.firstName), \(myMembers.role)")
                                        print("member not an admin and not a loaner and accepts loans")
                                        //make admin
                                        actionSheetController.addAction(makeAdmin)
                                        //make approver
                                        actionSheetController.addAction(makeApprover)
                                        //remove member
                                        actionSheetController.addAction(revokeMember)
                                        actionSheetController.addAction(cancelAction)
                                        self.present(actionSheetController, animated: true, completion: nil)

                                        
                                        }else if ((adminResponse == "true") && (myMembers.role != "admin") && ("\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)" != user) && (myMembers.role == "approver"))  && (loanFlag == 1){
                                            print("admin respone true, member not an admin but an approver and accepts loans")
                                            //revoke approver
                                            actionSheetController.addAction(revokeApprover)
                                            //remove member
                                            actionSheetController.addAction(revokeMember)
                                            actionSheetController.addAction(cancelAction)
                                            self.present(actionSheetController, animated: true, completion: nil)
                                        }
                                        
                                        else if ((adminResponse == "true") && (myMembers.role == "admin") && ("\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)" != user) && (myMembers.role != "approver")) {
                                            print("member an admin and not an approver")
                                            //revoke approver
                                            actionSheetController.addAction(revokeAdmin)
                                            //revoke member
                                            actionSheetController.addAction(revokeMember)
                                            actionSheetController.addAction(cancelAction)
                                            self.present(actionSheetController, animated: true, completion: nil)
                                            
                                        }else if ((adminResponse == "true") && (myMembers.role != "admin") && ("\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)" != user) && (myMembers.role == "approver"))  && (loanFlag == 0){
                                            print("admin respone true, member not an admin but an approver and does not accepts loans")
                                            //revoke approver
            //                                actionSheetController.addAction(revokeApprover)
                                            //remove member
                                            actionSheetController.addAction(revokeMember)
                                            actionSheetController.addAction(cancelAction)
                                            self.present(actionSheetController, animated: true, completion: nil)
                                        }else if ((adminResponse == "true") && (myMembers.role != "admin") && ("\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)" != user) && (myMembers.role != "approver")) && (loanFlag == 0) {
                                            print("\(myMembers.memberId.firstName), \(myMembers.role)")
                                            print("member not an admin and not a loaner and does not accepts loans")
                                            //make admin
                                            actionSheetController.addAction(makeAdmin)
                                            //make approver
            //                                actionSheetController.addAction(makeApprover)
                                            //remove member
                                            actionSheetController.addAction(revokeMember)
                                            actionSheetController.addAction(cancelAction)
                                            self.present(actionSheetController, animated: true, completion: nil)
                                            
                                            
                                        }

                    }
        }

        
    }
    

 
    
    
    func getMembers(getMembersParameter: GetMemberParameter) {
        AuthNetworkManager.getMembers(parameter: getMembersParameter) { (result) in
            self.parseGetMembersResponse(result: result)
        }
    }
    
    private func parseGetMembersResponse(result: DataResponse<[MemberResponse], AFError>){
        switch result.result {
        case .success(let response):
            FTIndicator.dismissProgress()
            print("response: \(response)")
            print("code: \(result.response?.statusCode)")
            self.members.removeAll()
            for item in response {
                self.members.append(item)
                self.tableView.reloadData()
            }
            print("self: \(self.members)")
            self.title = "Members (\(members.count.formatUsingAbbrevation()))"
            membersCount.text = "(\(members.count.formatUsingAbbrevation()))"
            
            self.members = members.sorted(by: {$0.memberId.firstName > $1.memberId.firstName})
            
            self.tableView.reloadData()
            break
        case .failure(let error):
            FTIndicator.dismissProgress()

            if result.response?.statusCode == 400 {
                
                sessionTimeout()
                
            }else {
            
            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //CREATE ADMIN
    func createAdmin(createAdminParameter: CreateAdminParameter) {
        AuthNetworkManager.createAdmin(parameter: createAdminParameter) { (result) in
            self.parseCreateAdminResponse(result: result)
        }
    }

    private func parseCreateAdminResponse(result: DataResponse<RevokeLoanApproverResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
//            let parameter: GetMemberParameter = GetMemberParameter(groupId: groupId)
//            print("parameter \(parameter)")
//            getMembers(getMembersParameter: parameter)
//            self.tableView.reloadData()
            

            break
        case .failure(let error):
            
            if result.response?.statusCode == 400 {
                
                sessionTimeout()
                
            }else {
            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            }
        }
    }
    

     //INITIATE ADMIN
        func initiateAdminCreation(initiateAdminCreationParameter: InitiateAdminCreationParameter) {
            AuthNetworkManager.initiateAdminCreation(parameter: initiateAdminCreationParameter) { (result) in
                self.parseInitiateAdminCreation(result: result)
            }
        }
        
        
        
        
    private func parseInitiateAdminCreation(result: DataResponse<InitiateAdminCreationResponse, AFError>){
            FTIndicator.dismissProgress()
            switch result.result {
            case .success(let response):
                print(response)
                
//                let parameter: ExecuteMakeAdminParameter = ExecuteMakeAdminParameter(status: "1", voteId: response.voteId ?? "nil")
//                executeMakeAdmin(executeMakeAdminParameter: parameter)
                
                let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                    self.navigationController?.popViewController(animated: true)
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)

                

                break
            case .failure(let error):
                
                if result.response?.statusCode == 400 {
                    
                    sessionTimeout()
                    
                }else {
                let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                }
            }
        }
    
    
    
    
     //EXECUTE MAKE ADMIN
        func executeMakeAdmin(executeMakeAdminParameter: ExecuteMakeAdminParameter) {
            AuthNetworkManager.executeMakeAdmin(parameter: executeMakeAdminParameter) { (result) in
                self.parseExecuteMakeAdmin(result: result)
            }
        }
        
        
        
        
        private func parseExecuteMakeAdmin(result: DataResponse<ExecuteMakeAdminResponse, AFError>){
            FTIndicator.dismissProgress()
            switch result.result {
            case .success(let response):
                print(response)

                

                break
            case .failure(let error):
                
                if result.response?.statusCode == 400 {
                    
                    sessionTimeout()
                    
                }else {
                let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                }
            }
        }
    
    
    
         //INITIATE ADMIN REVOKAL
    func initiateAdminRevokal(initiateAdminRevokalParameter: InitiateAdminRevokalParameter) {
        AuthNetworkManager.initiateAdminRevokal(parameter: initiateAdminRevokalParameter) { (result) in
            self.parseInitiateAdminRevokalResponse(result: result)
        }
    }
            
            
            
            
    private func parseInitiateAdminRevokalResponse(result: DataResponse<InitiateAdminCreationResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            
            
            break
        case .failure(let error):
            
            if result.response?.statusCode == 400 {
                
                sessionTimeout()
                
            }else {
                let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
        
        
        
        
         //INITIATE APPROVER REVOKAL
            func initiateApproverRevokal(initiateApproverRevokalParameter: InitiateApproverRevokalParameter) {
                AuthNetworkManager.initiateApproverRevokal(parameter: initiateApproverRevokalParameter) { (result) in
                    self.parseInitiateApproverRevokalResponse(result: result)
                }
            }
            
            
            
            
            private func parseInitiateApproverRevokalResponse(result: DataResponse<InitiateAdminCreationResponse, AFError>){
                FTIndicator.dismissProgress()
                switch result.result {
                case .success(let response):
                    print(response)

                    let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)

                    break
                case .failure(let error):
                    
                    if result.response?.statusCode == 400 {
                        
                        sessionTimeout()
                        
                    }else {
                    let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        
                    }
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    }
                }
            }
    
    //INITIATE MEMBER REMOVAL
       func initiateDropMember(initiateDropMemberParameter: InitiateDropMemberParameter) {
           AuthNetworkManager.initiateDropMember(parameter: initiateDropMemberParameter) { (result) in
               self.parseInitiateDropMember(result: result)
           }
       }
       
       
       
       
   private func parseInitiateDropMember(result: DataResponse<InitiateAdminCreationResponse, AFError>){
           FTIndicator.dismissProgress()
           switch result.result {
           case .success(let response):
               print(response)
               
//                let parameter: ExecuteMakeAdminParameter = ExecuteMakeAdminParameter(status: "1", voteId: response.voteId ?? "nil")
//                executeMakeAdmin(executeMakeAdminParameter: parameter)
               
               let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
               
               let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                   
                   self.navigationController?.popViewController(animated: true)
               }
               
               alert.addAction(okAction)
               
               self.present(alert, animated: true, completion: nil)

               

               break
           case .failure(let error):
               
               if result.response?.statusCode == 400 {
                   
                   sessionTimeout()
                   
               }else {
               let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
               
               let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                   
               }
               
               alert.addAction(okAction)
               
               self.present(alert, animated: true, completion: nil)
               }
           }
       }
    
    

    //CREATE LOAN APPROVER
    func createLoanApprover(createLoanApproverParameter: CreateLoanApproverParameter) {
        AuthNetworkManager.createLoanApprover(parameter: createLoanApproverParameter) { (result) in
            self.parseCreateLoanApproverResponse(result: result)
        }
    }




    private func parseCreateLoanApproverResponse(result: DataResponse<CreateLoanApproverResponse, AFError>){
        FTIndicator.dismissProgress()

        switch result.result {
        case .success(let response):
            print(response)
            let parameter: GetMemberParameter = GetMemberParameter(groupId: groupId)
            print("parameter \(parameter)")
            getMembers(getMembersParameter: parameter)
            self.tableView.reloadData()
            
        
        break
        case .failure(let error):
        
            if result.response?.statusCode == 400 {
                
                sessionTimeout()
                
            }else {
        let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    //MAKE LOAN APPROVER
    func makeLoanApprover(makeLoanApproverParameter: MakeLoanApproverParameter) {
        AuthNetworkManager.makeLoanApprover(parameter: makeLoanApproverParameter) { (result) in
            self.parseMakeeLoanApproverResponse(result: result)
        }
    }




    private func parseMakeeLoanApproverResponse(result: DataResponse<MakeLoanApproverResponse, AFError>){
        FTIndicator.dismissProgress()

        switch result.result {
        case .success(let response):
            print(response)
            
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                                
                let parameter: GetMemberParameter = GetMemberParameter(groupId: self.groupId)
                print("parameter \(parameter)")
                self.getMembers(getMembersParameter: parameter)
                self.tableView.reloadData()
                
                self.navigationController?.popViewController(animated: true)

            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            

            
        
        break
        case .failure(let error):
        
            if result.response?.statusCode == 400 {
                
                sessionTimeout()
                
            }else {
        let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    //REVOKE LOAN APPROVER
    func revokeLoanApprover(revokeLoanApproverParameter: RevokeLoanApproverParameter) {
        AuthNetworkManager.revokeLoanApprover(parameter: revokeLoanApproverParameter) { (result) in
            self.parseRevokeLoanApproverResponse(result: result)
        }
    }
    
    
    
    
    private func parseRevokeLoanApproverResponse(result: DataResponse<RevokeLoanApproverResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
//            self.tableView.reloadData()
            
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                let parameter: GetMemberParameter = GetMemberParameter(groupId: self.groupId)
                print("parameter \(parameter)")
                self.getMembers(getMembersParameter: parameter)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)

            
            
            break
        case .failure(let error):
            
            if result.response?.statusCode == 400 {
                
                sessionTimeout()
                
            }else {
            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    
    //REVOKE ADMIN
    func revokeAdmin(revokeAdminParameter: RevokeAdminParameter) {
        AuthNetworkManager.revokeAdmin(parameter: revokeAdminParameter) { (result) in
            self.parseRevokeAdminResponse(result: result)
        }
    }
    
    
    private func parseRevokeAdminResponse(result: DataResponse<RevokeAdminResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
//            self.tableView.reloadData()
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                let parameter: GetMemberParameter = GetMemberParameter(groupId: self.groupId)
                print("parameter \(parameter)")
                self.getMembers(getMembersParameter: parameter)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            break
        case .failure(let error):
            
            if result.response?.statusCode == 400 {
                
                sessionTimeout()
                
            }else {
            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    //DROP MEMBER
    func dropMember(dropMemberParameter: DropMemberParameter) {
        AuthNetworkManager.dropMember(parameter: dropMemberParameter) { (result) in
            self.parseDropMemberResponse(result: result)
        }
    }
    
    
    
    
    private func parseDropMemberResponse(result: DataResponse<RevokeAdminResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                let parameter: GetMemberParameter = GetMemberParameter(groupId: self.groupId)
                print("parameter \(parameter)")
                self.getMembers(getMembersParameter: parameter)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            self.tableView.reloadData()

            
            
            break
        case .failure(let error):
            
            if result.response?.statusCode == 400 {
                
                sessionTimeout()
                
            }else {
            let alert = UIAlertController(title: "Chango", message: "Error. Please try again.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            }
        }
    }

}


extension Int {
    func formatUsingAbbrevation () -> String {
        let numFormatter = NumberFormatter()
        typealias Abbrevation = (threshold:Double, divisor:Double, suffix:String)
        let abbreviations:[Abbrevation] = [(0, 1, ""),
                                           (1000.0, 1000.0, "K"),
                                           (100_000.0, 1_000_000.0, "M"),
                                           (100_000_000.0, 1_000_000_000.0, "B")]
        // you can add more !
        let startValue = Double (abs(self))
        let abbreviation:Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if (startValue < tmpAbbreviation.threshold) {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        } ()
        let value = Double(self) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1
        return numFormatter.string(from: NSNumber (value:value))!
    }
}
