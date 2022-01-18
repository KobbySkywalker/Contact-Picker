//
//  LeftMenuViewController.swift
//  Chango v2
//
//  Created by Hosny Savage on 17/09/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import Nuke
import Alamofire
import FTIndicator
import FirebaseMessaging
import FirebaseDatabase
import BWWalkthrough


class LeftMenuViewController:  BaseViewController, MenuDelegate, BWWalkthroughViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var easySlideNavigationController: ESNavigationController?
    typealias FetchAllGroupsCompletionHandler = (_ groups: [GroupInviteResponse]) -> Void
    let cell = "cellId"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    @IBOutlet weak var versionNumberLabel: UILabel!

    var groupCount: String = ""
    var invitesCount: Int = 0
    var countryId: String = ""
    var recentContributions: [RecentPersonalContribution] = []
    let user = Auth.auth().currentUser
    
    var drawerItems: [DrawerModel] = [DrawerModel(id_: 1, itemName_: "My Groups", itemImage_: "drawerusers"), DrawerModel(id_: 2, itemName_: "Public Groups", itemImage_: "publicicon"), DrawerModel(id_: 3, itemName_: "My Recent Activities", itemImage_: "drawerrecent"), DrawerModel(id_: 4, itemName_: "My Recent Contributions", itemImage_: "drawercontributions"), DrawerModel(id_: 5, itemName_: "My Pending Invites", itemImage_: "drawerinvites"), DrawerModel(id_: 6, itemName_: "My Recurring Payments", itemImage_: "drawerpayments"), DrawerModel(id_: 7, itemName_: "Settings", itemImage_: "drawersettings"), DrawerModel(id_: 8, itemName_: "Feedback", itemImage_: "drawercontact"), DrawerModel(id_: 9, itemName_: "FAQ & About Us", itemImage_: "drawerfaqs"), DrawerModel(id_:10, itemName_: "Terms & Conditions", itemImage_: "tncs"), DrawerModel(id_:11, itemName_: "Logout", itemImage_: "drawerlogout")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        self.tableView.tableFooterView = UIView()
        
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 40.0
        profileImage.clipsToBounds = true
        
        userNameLabel.text = user?.displayName
        userPhoneNumberLabel.text = user?.phoneNumber
        profileImage.contentMode = .scaleToFill
        
        if (user!.photoURL != nil){
            print("not null")
            print(user!.photoURL!)
            Nuke.loadImage(with: URL(string: "\(user!.photoURL!)")!, into: profileImage)
        }else {
            print("default")
            profileImage.image = UIImage(named: "defaulticon")
        }
        
        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableView.register(UINib(nibName: "LeftDrawerCell", bundle: nil), forCellReuseIdentifier: "LeftDrawerCell")
        self.tableView.tableFooterView = UIView()

        versionNumberLabel.text = "Version \(globalAppVersion)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAllGroups { (result) in
            self.invitesCount = result.count
        }
    }
    
    func fetchAllGroups(completionHandler: @escaping FetchAllGroupsCompletionHandler) {
        
        var groups: [GroupInviteResponse] = []
        let groupsRef = Database.database().reference().child("invites")
        let uid = groupsRef.child("\((user?.uid)!)")
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
                        
                        let groupDetails = GroupInviteResponse(countryId_: CountryId(countryId_: "", countryName_: "", created_: "", currency_: "", modified_: ""), groupId_: groupArray.value(forKey: "groupId") as! String, groupName_: groupArray.value(forKey: "groupName") as! String, groupType_: "", groupIconPath_: gip, tnc_: groupArray.value(forKey: "tnc") as! String, status_: "", created_: "", modified_:  "", description_: groupArray.value(forKey: "description") as! String, messageBody_: groupArray.value(forKey: "messageBody") as! String, timestamp_: tmstmp)
                        
                        
                        groups.append(groupDetails)
                        
                    }
                }
            }
            completionHandler(groups)
        })
    }
    
    
    //PERSONAL CONTRIBUTIONS
    func getPersonalContributionsParameter(personalContributionsParameter: PersonalContributionsParameter) {
        AuthNetworkManager.personalContributions(parameter: personalContributionsParameter) { (result) in
            self.parsePersonalContributionsResponse(result: result)
        }
    }
    
    private func parsePersonalContributionsResponse(result: DataResponse<CampaignContributionResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            let vc: PersonalContributionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "personal") as! PersonalContributionViewController
            vc.personalContributions = response
            if let slideController = self.easySlideNavigationController{
                slideController.setBodyViewController(vc, closeOpenMenu: true, ignoreClassMatch: true)
            }
            
            break
        case .failure(let error):
            if result.response?.statusCode == 400 {
                let alert = UIAlertController(title: "Chango", message: "Your session has timed out. Please login", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    if UserDefaults.standard.bool(forKey: "touchID"){
                        let vc: LoginTouchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "touch") as! LoginTouchVC
                        self.present(vc, animated: true, completion: nil)
                        print("touchID")
                    }else {
                        let vc: LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "in") as! LoginVC
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }else {
                let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func getMemberActivity() {
        AuthNetworkManager.getMemberActivity { (result) in
            self.parseGetMemberActivityResponse(result: result)
        }
    }
    
    private func parseGetMemberActivityResponse(result: DataResponse<[UserActivity], AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            let vc: MemberActivityViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "activity") as! MemberActivityViewController
            vc.memberActivities = response
            if let slideController = self.easySlideNavigationController{
                slideController.setBodyViewController(vc, closeOpenMenu: true, ignoreClassMatch: true)
            }
            break
        case .failure(let error):
            print(NetworkManager().getErrorMessage(response: result))
            if result.response?.statusCode == 400 {
                
                let alert = UIAlertController(title: "Chango", message: "Your session has timed out. Please login", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                    if UserDefaults.standard.bool(forKey: "touchID"){
                        
                        let vc: LoginTouchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "touch") as! LoginTouchVC
                        
                        self.present(vc, animated: true, completion: nil)
                        print("touchID")
                        
                    }else {
                        let vc: LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "in") as! LoginVC
                        
                        
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    
    func deleteDevice(deleteDeviceParameter: DeleteDeviceParameter) {
        AuthNetworkManager.deleteDevice(parameter: deleteDeviceParameter) { (result) in
            print("result: \(result)")
        }
    }
    
    func showWalkThrough(){
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
        let page_one = stb.instantiateViewController(withIdentifier: "walk1")
        let page_two = stb.instantiateViewController(withIdentifier: "walk2")
        let page_three = stb.instantiateViewController(withIdentifier: "walk3")
        let page_four = stb.instantiateViewController(withIdentifier: "walk4")
        let page_five = stb.instantiateViewController(withIdentifier: "walk5")
        let page_six = stb.instantiateViewController(withIdentifier: "walk6")
        //Attach the pages to the master
        walkthrough.delegate = self as? BWWalkthroughViewControllerDelegate
        //        walkthrough.add(viewController: page_one)
        //        walkthrough.add(viewController: page_three)
        walkthrough.add(viewController: page_two)
        walkthrough.add(viewController: page_four)
        walkthrough.add(viewController: page_five)
        walkthrough.add(viewController: page_six)
        walkthrough.modalPresentationStyle = .fullScreen
        self.present(walkthrough, animated: true, completion: nil)
    }
    
    
    func getRecentPersonalContribution(){
        AuthNetworkManager.recentPersonalContribution { (result) in
            self.parseRecentPersonalContributionResponse(result: result)
        }
    }
    
    private func parseRecentPersonalContributionResponse(result: DataResponse<[GetCampaignContributionResponse], AFError>){
        FTIndicator.dismissProgress()
        
        switch result.result {
        case .success(let response):
            print(response)
            
            let vc: MyRecentContributionsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "recent") as! MyRecentContributionsViewController
            
            vc.myRecentContributions = response
            
            if let slideController = self.easySlideNavigationController{
                slideController.setBodyViewController(vc, closeOpenMenu: true, ignoreClassMatch: true)
            }
            
            break
        case .failure(let error):
            
            if result.response?.statusCode == 400 {
                
                let alert = UIAlertController(title: "Chango", message: "Your session has timed out. Please login", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                    if UserDefaults.standard.bool(forKey: "touchID"){
                        
                        let vc: LoginTouchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "touch") as! LoginTouchVC
                        
                        self.present(vc, animated: true, completion: nil)
                        print("touchID")
                        
                    }else {
                        let vc: LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "in") as! LoginVC
                        
                        
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                
            }else {
                let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drawerItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: LeftDrawerCell = self.tableView.dequeueReusableCell(withIdentifier: "LeftDrawerCell", for: indexPath) as! LeftDrawerCell
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 4:
            fetchAllGroups { (result) in
                print("count: \(self.invitesCount)")
                self.invitesCount = result.count
                cell.drawerCellName.text = "\(self.drawerItems[indexPath.row].itemName)"
            }
            break
        default:
            cell.drawerCellName.text = drawerItems[indexPath.row].itemName
        }
        cell.drawerIcon.image = UIImage(named: "\(drawerItems[indexPath.row].itemImage)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        
        case 0:
            //All Groups
            print("tapped groups")
            
            let vc: AllGroupsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "all") as! AllGroupsViewController
            
            if let slideController = self.easySlideNavigationController{
                slideController.setBodyViewController(vc, closeOpenMenu: true, ignoreClassMatch: true)
            }
            break
        case 1:
            let vc: PublicGroupsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "public") as! PublicGroupsViewController
            
            if let slideController = self.easySlideNavigationController{
                slideController.setBodyViewController(vc, closeOpenMenu: true, ignoreClassMatch: true)
            }
            break
        case 2:
            //Recent Activity
            FTIndicator.showProgress(withMessage: "Getting Activities")
            getMemberActivity()
            break
        case 3:
            //Recent Contributions
            getRecentPersonalContribution()
            FTIndicator.showProgress(withMessage: "getting personal contributions")
            break
        case 4:
            //Pending Invites
            let vc: InvitationsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "invite") as! InvitationsViewController
            if let slideController = self.easySlideNavigationController{
                slideController.setBodyViewController(vc, closeOpenMenu: true, ignoreClassMatch: true)
            }
            break
        case 5:
            //Recurring Payments
            let vc1: RecurringPaymentsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "recpay") as! RecurringPaymentsVC
            if let slideController = self.easySlideNavigationController{
                slideController.setBodyViewController(vc1, closeOpenMenu: true, ignoreClassMatch: true)
            }
            break
        case 6:
            let vc2: SettingsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersettings") as! SettingsVC
            vc2.allGroups = allGroups
            if let slideController = self.easySlideNavigationController{
                slideController.setBodyViewController(vc2, closeOpenMenu: true, ignoreClassMatch: true)
            }
            
            //            easySlideNavigationController?.setupMenuViewController(.leftMenu, viewController: vc2)
            break
        case 7:
            let vc3: ContactUsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contactus") as! ContactUsVC
            vc3.loginCheck = 1
            
            if let slideController = self.easySlideNavigationController{
                slideController.setBodyViewController(vc3, closeOpenMenu: true, ignoreClassMatch: true)
            }
            break
        case 8:
            //FAQs
            let vc4: FAQsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "faqs") as! FAQsVC
            if let slideController = self.easySlideNavigationController{
                slideController.setBodyViewController(vc4, closeOpenMenu: true, ignoreClassMatch: true)
            }
            break
        case 9:
            //Terms & Conditions
            let vc5: PrivacyPolicyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "privacy") as! PrivacyPolicyViewController
            vc5.checkNavigation = 2
            if let slideController = self.easySlideNavigationController{
                slideController.setBodyViewController(vc5, closeOpenMenu: true, ignoreClassMatch: true)
            }
            break
        case 10:
            //Logout
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout? Your biometric data will be cleared.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                let idToken = UserDefaults.standard.string(forKey: "idToken")
                let parameter: DeleteDeviceParameter = DeleteDeviceParameter(id: idToken!)
                self.deleteDevice(deleteDeviceParameter: parameter)
                
                for item in allGroups {
                    
                    Messaging.messaging().unsubscribe(fromTopic: item.groupId)
                    
                    print("unsubscribed from \(item.groupId)")
                }
                //store idToken in variable
                let idTokenRestore = idToken!
                //removing all userdefaults data
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                print("user logged out: \(Array(UserDefaults.standard.dictionaryRepresentation().keys))")
                //Restore token
                UserDefaults.standard.set(idTokenRestore, forKey: "idToken")
                self.showWalkThrough()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action: UIAlertAction!) in
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
            break
        default:
            break
            
            
        }
    }
    
    // EASY SLIDE
    fileprivate func getEasySlide() -> ESNavigationController {
        return self.navigationController as! ESNavigationController
    }
    
}
