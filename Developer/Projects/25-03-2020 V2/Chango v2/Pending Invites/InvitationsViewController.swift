//
//  InvitationsViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 12/12/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import UIKit
//import RealmSwift
import FirebaseDatabase
import Firebase
import FirebaseAuth
import Nuke
import PopupDialog
import FTIndicator
import Alamofire
import ESPullToRefresh

class InvitationsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

//    var Invitations: [Invite] = []
//    var invite: [Invite] = []
    var groupInvite: [GroupInviteResponse] = []
    let user = Auth.auth().currentUser
    var groupId: String = ""
    var newUser: Bool = false

    var groupp: GroupInviteResponse!


    
    typealias FetchAllGroupsCompletionHandler = (_ groups: [GroupInviteResponse]) -> Void

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var menuIcon: UIButton!
    @IBOutlet weak var pendingInvitesLabel: UILabel!

    let Groups = ["Elikem's Wedding", "Alice Birthday", "Korle Bu Children's Ward"]
    let cell = "cellId"


    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableView.register(UINib(nibName: "InvitesCell", bundle: nil), forCellReuseIdentifier: "InvitesCell")
        self.tableView.register(UINib(nibName: "InvitationsViewController", bundle: nil), forCellReuseIdentifier: "InvitationsViewController")
        self.tableView.tableFooterView = UIView()
        self.groupInvite.removeAll()
        fetchAllGroups { [self] (result) in
            self.groupInvite = result
            print("result: \(self.groupInvite)")
            self.groupInvite = self.groupInvite.sorted(by: {$0.timestamp > $1.timestamp})
            self.pendingInvitesLabel.text = "Pending Invites(\(self.groupInvite.count))"
            if self.groupInvite.count > 0 {
                self.emptyView.isHidden = true
            }else {
                self.emptyView.isHidden = false
            }
            
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
        
        self.tableView.es.addPullToRefresh {
            [unowned self] in
            //Do anything you want...
            
            self.fetchAllGroups { (result) in
                self.groupInvite = result
                print("result: \(self.groupInvite)")
                self.groupInvite = self.groupInvite.sorted(by: {$0.timestamp > $1.timestamp})
                pendingInvitesLabel.text = "Pending Invites(\(groupInvite.count))"
                self.tableView.reloadData()
            }
            self.tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if newUser == true {
            menuIcon.setImage(UIImage(named: "icons-dark-back"), for: .normal)
        }else {
            menuIcon.setImage(UIImage(named: "menu"), for: .normal)
        }
    }
    
    //Retrieving From Firebase RealTime Database
    
    func fetchAllGroups(completionHandler: @escaping FetchAllGroupsCompletionHandler) {
        
        var groups: [GroupInviteResponse] = []
        let groupsRef = Database.database().reference().child("invites")
        let uid = groupsRef.child("\((user?.uid)!)")
        print("uid: \(uid)")
        _ = uid.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshotValue = snapshot.children.allObjects as? [DataSnapshot]{
                for snapDict in snapshotValue{
                    print("snapdict")
                    let dict = snapDict.value as! Dictionary<String, AnyObject>
                    print(dict)
                    if let groupArray = dict as? NSDictionary {
                        
                    var gip = ""
                    if let groupIconPath = groupArray.value(forKey: "groupIconPath") as? String {
                        gip = groupIconPath
                        }
                        
                        var tmstmp = ""
                        if let timestamp = groupArray.value(forKey: "timestamp") as? String {
                            tmstmp = timestamp
                        }
                        
                        print("group array: \(groupArray)")
                        print("id: \(groupArray.value(forKey: "groupId")!)")
                        print("name: \(groupArray.value(forKey: "groupName")!)")
//                        print("icon: \(groupArray.value(forKey: "groupIconPath")!)")
                        print(" description: \(groupArray.value(forKey: "description")!)")
                        print("tnc: \(groupArray.value(forKey: "tnc")!)")
                        let groupDetails = GroupInviteResponse(countryId_: CountryId(countryId_: "", countryName_: "", created_: "", currency_: "", modified_: ""), groupId_: groupArray.value(forKey: "groupId") as! String, groupName_: groupArray.value(forKey: "groupName") as! String, groupType_: "", groupIconPath_: gip, tnc_: groupArray.value(forKey: "tnc") as! String, status_: "", created_: "", modified_:  "", description_: groupArray.value(forKey: "description") as! String, messageBody_: groupArray.value(forKey: "messageBody") as! String, timestamp_: tmstmp)


                                groups.append(groupDetails)
                                
                            }
                    }
                }
                print("info \(groups)")
                completionHandler(groups)
            })
        }
    
    fileprivate func getEasySlide() -> ESNavigationController {
        return self.navigationController as! ESNavigationController
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        if newUser == true {
            self.navigationController?.popViewController(animated: true)
        }else {
        self.getEasySlide().openMenu(.leftMenu, animated: true, completion: {})
        }
    }
    
    
    //POP UP DIALOG
    func showInvitationDialog(animated: Bool = true, dialogGroup: GroupInviteResponse, cashout: Double, tnc: String) {
        
        //create a custom view controller
        let invitationVC = InvitationDialogViewController(nibName: "InvitationDialogViewController", bundle: nil)
        
        //create the dialog
        let popup = PopupDialog(viewController: invitationVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
        
        print("inf: \(groupInvite)")
        
        if (dialogGroup.groupIconPath == "") || (dialogGroup.groupIconPath == "<null>") {
            print("group icon is nil")
            invitationVC.groupImage.image = UIImage(named: "people")
        }else {
            Nuke.loadImage(with: URL(string: dialogGroup.groupIconPath!)!, into: invitationVC.groupImage)
        }

        invitationVC.groupName.text = dialogGroup.groupName.uppercased()
        invitationVC.groupDescription.text = dialogGroup.description
        invitationVC.termsConditions.text = dialogGroup.tnc ?? "\(tnc)"
        print(String(format: "%.0f", cashout))
        invitationVC.cashoutPolicy.text = "\(String(format: "%.0f", cashout))% of members including all administrators are required to vote YES to approve cashout. A single NO vote cancels the vote."
        
        //create first button
        let buttonOne = CancelButton(title: "REJECT INVITE", height: 60) {

            let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
                
                let alert = UIAlertController(title: "Reject Invite", message: "Are you sure you want to reject this invite?", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Reject", style: .default) { (action: UIAlertAction!) in
                    
                    self.remove(child: dialogGroup.groupId)
                    
//                    self.present(vc, animated: true, completion: nil)
                    //make call
                    self.fetchAllGroups { (result) in
                        self.groupInvite = result
                        print("result: \(self.groupInvite)")
                        self.groupInvite = self.groupInvite.sorted(by: {$0.timestamp > $1.timestamp})
                        
                        self.tableView.reloadData()
                    }
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
            
            let alert = UIAlertController(title: "JOIN GROUP", message: "By joining \(dialogGroup.groupName), you agree to the terms & conditions of \(dialogGroup.groupName).", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Yes, Join", style: .default) { (action: UIAlertAction!) in
                
                FTIndicator.showProgress(withMessage: "loading")
                let parameter: JoinPrivateGroupParameter = JoinPrivateGroupParameter(groupId: dialogGroup.groupId)
                self.groupId = dialogGroup.groupId
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
                self.remove(child: self.groupId)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
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
    
    //NEW JOIN GROUP END POINT
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
                self.remove(child: self.groupId)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
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
    
    
    //REMOVE INVITATION FROM NOTIFICATION
    
    func remove(child: String) {
        
        let user = Auth.auth().currentUser
        
        let ref = Database.database().reference().child("invites").child((user?.uid)!)
        
        let itemReference = ref.child(child)
        itemReference.removeValue { (error, ref) in
            
            print(error)
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(groupInvite.count)")
      return groupInvite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InvitesCell = self.tableView.dequeueReusableCell(withIdentifier: "InvitesCell", for: indexPath) as! InvitesCell
        cell.selectionStyle = .none
        let groupCell = groupInvite[indexPath.row]
        cell.groupImage.image = nil
        let url = URL(string: groupCell.groupIconPath!)
        if(groupCell.groupIconPath == "<null>") || (groupCell.groupIconPath == nil) || (groupCell.groupIconPath == "") {
            cell.groupImage.image = UIImage(named: "defaultgroupicon")
            cell.groupName.text = self.groupInvite[indexPath.row].groupName
            
        }else {
            Nuke.loadImage(with: url!, into: cell.groupImage)
            cell.groupName.text = self.groupInvite[indexPath.row].groupName
        }
//        cell.groupName.text = Groups[indexPath.row]
//        cell.groupName.text = groupInvite[indexPath.row].groupName
        cell.messageBody.text = groupInvite[indexPath.row].messageBody
        
    return cell
}
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let groupInfo = groupInvite[indexPath.row]
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller: JoinGroupViewController = storyboard.instantiateViewController(withIdentifier: "join") as! JoinGroupViewController
//        controller.groups = groupInfo
        
        let parameter: GroupPoliciesParameter = GroupPoliciesParameter(groupId: groupInvite[indexPath.row].groupId)
        self.groupPolicy(groupPolicies: parameter, groupInfo: groupInvite[indexPath.row])
        FTIndicator.showProgress(withMessage: "loading")
//        self.groupPolicies(groupPolicies: parameter, groupInfo: groupInvite[indexPath.row])
        
//        showInvitationDialog(dialogGroup: groupInvite[indexPath.row])

        
        
        
//        print(groupInfo.groupName)
//        print(groupInfo.groupId)
        
//        self.navigationController!.pushViewController(controller, animated: true)
    }
    

    //GROUP POLICIES
    func groupPolicy(groupPolicies: GroupPoliciesParameter, groupInfo: GroupInviteResponse) {
        AuthNetworkManager.getGroupPolicy(parameter: groupPolicies) { (result) in
            self.parseGetGroupPolicyResponse(result: result, groupInfo: groupInfo)
        }
    }
    
    
    private func parseGetGroupPolicyResponse(result: DataResponse<GroupPolicyResponse, AFError>, groupInfo: GroupInviteResponse){
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
            self.navigationController?.pushViewController(vc, animated: true)
            
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
 

}


extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
