      //
//  LeftMenuTableViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 21/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import Nuke
import Alamofire
import FTIndicator
import FirebaseMessaging
import FirebaseDatabase
import BWWalkthrough

class LeftMenuTableViewController: BaseTableViewController, MenuDelegate, BWWalkthroughViewControllerDelegate {
    
    var easySlideNavigationController: ESNavigationController?
    
    typealias FetchAllGroupsCompletionHandler = (_ groups: [GroupInviteResponse]) -> Void
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var displayNumber: UILabel!
    @IBOutlet weak var invitationCount: UILabel!
    
    var groupCount: String = ""
    var invitesCount: Int = 0
    var recentContributions: [RecentPersonalContribution] = []
    let user = Auth.auth().currentUser

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        let searchController = UISearchController(searchResultsController: nil)
        
        self.table.tableFooterView = UIView()
        
        invitationCount.layer.cornerRadius = 15
        invitationCount.clipsToBounds = true
        invitationCount.clipsToBounds = true
        displayImage.clipsToBounds = true
        displayImage.layer.cornerRadius = 40.0
        displayImage.clipsToBounds = true
        
        displayName.text = user?.displayName
        displayNumber.text = user?.phoneNumber

        if (user!.photoURL != nil){
            print("not null")
            print(user!.photoURL!)
            Nuke.loadImage(with: URL(string: "\(user!.photoURL!)")!, into: displayImage)
        }else {
            print("default")
            displayImage.image = UIImage(named: "user-1")
        }
        
    }


    override func viewWillAppear(_ animated: Bool) {
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 50/255, green: 54/255, blue: 66/255, alpha: 1.0)
        statusBarView.backgroundColor = statusBarColor
        if #available(iOS 13.0, *) {


           let statusBar1 =  UIView()
           statusBar1.frame = UIApplication.shared.keyWindow?.windowScene?.statusBarManager!.statusBarFrame as! CGRect
           statusBar1.backgroundColor = UIColor(red: 50/255, green: 54/255, blue: 66/255, alpha: 1.0)

           UIApplication.shared.keyWindow?.addSubview(statusBar1)

        } else {
            let statusBar1 = UIApplication.shared.value(forKey: "statusBar") as? UIView
            statusBar1!.backgroundColor = UIColor(red: 50/255, green: 54/255, blue: 66/255, alpha: 1.0)
        }
//        view.addSubview(statusBarView)
        UIApplication.shared.statusBarStyle = .lightContent
        
        fetchAllGroups { (result) in
            self.invitesCount = result.count
            
            if self.invitesCount == 0 {
                self.invitationCount.isHidden = true
            }
            self.invitationCount.text = "\(self.invitesCount)"
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
    
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        switch indexPath.section {
            
        case 0:
            
            if (indexPath.row == 0){
                //Header
                
            } else if (indexPath.row == 1){
                //All Groups
                let vc: AllGroupsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "all") as! AllGroupsViewController
                
                if let slideController = self.easySlideNavigationController{
                    slideController.setBodyViewController(vc, closeOpenMenu: true, ignoreClassMatch: true)
                }
                
            }else if (indexPath.row == 2){
                //Private Groups
                let vc: GroupsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "groups") as! GroupsViewController
                
                if let slideController = self.easySlideNavigationController{
                    slideController.setBodyViewController(vc, closeOpenMenu: true, ignoreClassMatch: true)
                }
            }else{
                //Public Groups
                let vc: PublicGroupsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "public") as! PublicGroupsViewController
                
                if let slideController = self.easySlideNavigationController{
                    slideController.setBodyViewController(vc, closeOpenMenu: true, ignoreClassMatch: true)
                }
            }
            break
        case 1:
            if (indexPath.row == 0){
                //Recent Activity
                FTIndicator.showProgress(withMessage: "Getting Activities")
                getMemberActivity()
                
                
            }else if (indexPath.row == 1){
                //Recent Contributions
                
//                getRecentPersonalContribution()

//                let parameter: PersonalContributionsParameter = PersonalContributionsParameter(offset: "0", pageSize: "50")
//                getPersonalContributionsParameter(personalContributionsParameter: parameter)
                FTIndicator.showProgress(withMessage: "getting personal contributions")
                
                

                
            }else if (indexPath.row == 2){
                //Pending Invites
                let vc: InvitationsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "invite") as! InvitationsViewController
                
                if let slideController = self.easySlideNavigationController{
                    slideController.setBodyViewController(vc, closeOpenMenu: true, ignoreClassMatch: true)
                }
            }else if (indexPath.row == 3) {
                //Recurring Payments
                let vc: RecurringPaymentsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "recpay") as! RecurringPaymentsVC
                
                if let slideController = self.easySlideNavigationController{
                    slideController.setBodyViewController(vc, closeOpenMenu: true, ignoreClassMatch: true)
                }
                
            }else if (indexPath.row == 4) {
                //FAQs
                let vc: FAQsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "faqs") as! FAQsVC
                
                if let slideController = self.easySlideNavigationController{
                    slideController.setBodyViewController(vc, closeOpenMenu: true, ignoreClassMatch: true)
                }
            }
            break
        case 2:
            if (indexPath.row == 0){
                //FAQs
                let vc: FAQsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "faqs") as! FAQsVC
                
                if let slideController = self.easySlideNavigationController{
                    slideController.setBodyViewController(vc, closeOpenMenu: true, ignoreClassMatch: true)
                }
            }else {
                let vc: ContactUsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contactus") as! ContactUsVC
                vc.loginCheck = 1
                
                if let slideController = self.easySlideNavigationController{
                    slideController.setBodyViewController(vc, closeOpenMenu: true, ignoreClassMatch: true)
                }
            }
        case 3:
                if (indexPath.row == 0){
                //Settings
                print("settings")
                let vc: SettingsTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settings") as! SettingsTableViewController
                    vc.allGroups = allGroups
                
                if let slideController = self.easySlideNavigationController{
                    slideController.setBodyViewController(vc, closeOpenMenu: true, ignoreClassMatch: true)
                }
            }else {
                //Logout
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }

                
                let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
                
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
//                    let prefs = UserDefaults.standard
//                    prefs.removeObject(forKey: "email")
//                    prefs.removeObject(forKey: "password")
//                    //group link stored preferences
//                    prefs.removeObject(forKey: "authenticated")
//                    prefs.removeObject(forKey: "grouplinkexists")
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
            }
            break
        default:
            print("nil")
        }
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
    
    
//    func getRecentPersonalContribution(){
//        AuthNetworkManager.recentPersonalContribution { (result) in
//            self.parseRecentPersonalContributionResponse(result: result)
//        }
//    }
    
    
//    private func parseRecentPersonalContributionResponse(result: DataResponse<[RecentPersonalContribution], AFError>){
//        FTIndicator.dismissProgress()
//
//        switch result.result {
//        case .success(let response):
//            print(response)
//
//            let vc: MyRecentContributionsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "recent") as! MyRecentContributionsViewController
//
//
//            vc.myRecentContributions = response
//
//
//
//
//
//            if let slideController = self.easySlideNavigationController{
//                slideController.setBodyViewController(vc, closeOpenMenu: true, ignoreClassMatch: true)
//            }
//
//            break
//        case .failure(let error):
//
//            if result.response?.statusCode == 400 {
//
//                let alert = UIAlertController(title: "Chango", message: "Your session has timed out. Please login", preferredStyle: .alert)
//
//                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//
//                    if UserDefaults.standard.bool(forKey: "touchID"){
//
//                        let vc: LoginTouchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "touch") as! LoginTouchVC
//
//                        self.present(vc, animated: true, completion: nil)
//                        print("touchID")
//
//                    }else {
//                        let vc: LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "in") as! LoginVC
//
//
//                        self.present(vc, animated: true, completion: nil)
//                    }
//                }
//
//                alert.addAction(okAction)
//
//                self.present(alert, animated: true, completion: nil)
//
//            }else {
//            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
//
//            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//
//            }
//
//            alert.addAction(okAction)
//
//            self.present(alert, animated: true, completion: nil)
//            }
//        }
//    }
    

}
