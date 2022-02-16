//
//  MemberSearchViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 22/07/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Nuke
import Alamofire
import FTIndicator
import FirebaseAuth
import LocalAuthentication
import PopupDialog

class MemberSearchViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var searchBar: UISearchBar!

    let cell = "cellId"
    let searchController = UISearchController(searchResultsController: nil)
    var members: [MemberResponse] = []
    var filtered_members: [MemberResponse] = []
    var indexes: [String] = []
    var searchIndexes: [String] = []
    var searched: Bool = false
    var privateGroup: GroupResponse!
    var msisdn: String = ""
    var userNetwork: String = ""
    var userNumber: String = ""
    var amount: Double = 0.0
    var campaignId: String = ""
    var cashout: Int = 0
    var initiateCashoutVC: InitiateCashoutTableViewController!
    var memberName: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var memberNumber: String = ""
    var memberTag: MemberResponse!
    var groupId: String = ""
    var groupName: String = ""
    var memberId: String = ""
    var member: [MemberResponse] = []
    var voteId: String = ""
    var reason: String = ""
    var network: String = ""
    var currency: String = ""
    var voucherCode: String = ""
    var paymentDuration: String = ""
    var repeatCycle: String = ""
    var titleLabel: String = ""
    var campaignExpiry: String = ""
    var onBehalf: Bool = false
    var anonymous: String = "false"
    var recurringStatus: Int = 0
    var groupIconPath: String = ""
    var publicGroupCheck: Int = 0
    var walletId: String = ""
    var debitCharge: String = ""
    var cardCheck: Bool = false
    
    let currentUser = Auth.auth().currentUser
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var emptyMembersView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.memberNetwork()
        disableDarkMode()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 20)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableView.register(UINib(nibName: "MemberContributeCell", bundle: nil), forCellReuseIdentifier: "MemberContributeCell")
        self.tableView.register(UINib(nibName: "MemberContributeCell", bundle: nil), forCellReuseIdentifier: "MemberContributeCell")
        
//        searchController.searchBar.placeholder = "Search Member"
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.searchBar.sizeToFit()
        self.definesPresentationContext = true
        searchController.delegate = self
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.tableView.tableHeaderView = searchBar
        searchBar.delegate = self
//        if #available(iOS 11.0, *) {
//            navigationItem.searchController = searchController
//        }
        for item in members {
            if !(currentUser?.displayName == "\(item.memberId.firstName) \(item.memberId.lastName)" || (currentUser?.phoneNumber == "+\(item.memberId.msisdn!)")) {
                member.append(item)
            }
            print("member set: \(member)")
        }

        if members.isEmpty {
            emptyMembersView.isHidden = false
        } else {
            emptyMembersView.isHidden = true
        }
        
        if (cashout == 1) {
            actionLabel.text = "Cashout"
        }else {
            actionLabel.text = "Contribute"
        }
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func Contribute(button: UIButton){
        print("details: ")
        memberTag = member[button.tag]
        if (cashout == 2){
            firstName = memberTag.memberId.firstName
            lastName = memberTag.memberId.lastName
            memberNumber = memberTag.memberId.msisdn!
            print("\(firstName), \(lastName)")
            initiateCashoutVC.memberNumber = memberNumber
            initiateCashoutVC.firstName = firstName
            initiateCashoutVC.lastName = lastName
            self.navigationController?.popViewController(animated: true)
        }else {
            msisdn = memberTag.memberId.msisdn!
            memberId = memberTag.memberId.memberId!
            print(msisdn)
            print(amount)
            print(campaignId)
            print(groupId)
            print(groupName)
            let parameter: MakeContributionParameter = MakeContributionParameter(amount: amount, campaignId: campaignId, currency: self.currency, destination: "", groupId: groupId, invoiceId: "", duration: paymentDuration, freqType: repeatCycle, msisdn: userNumber, narration: groupName, network: userNetwork, recurring: "false", voucher: "", othersMsisdn: msisdn, othersMemberId: memberId, anonymous: anonymous)
            FTIndicator.showProgress(withMessage: "loading")
            self.makeContribution(makeContributionParameter: parameter)
        }
    }


    func searchMethod(searchText: String){
        filtered_members.removeAll()
        searchIndexes.removeAll()
        if (searchText.isEmpty){
            searched = false
            self.setupMembers()
            return
        }else if(!(searchText.isEmpty)){
            filtered_members = members.filter({ (member: MemberResponse) -> Bool in
                let name = "\(member.memberId.firstName) \(member.memberId.lastName)"
                return (name.lowercased().contains(searchText.lowercased()))
            })
            searched = true
            if filtered_members.isEmpty {
                print("hide")
            }else {
                print("show")
            }
            self.setupMembers()
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filtered_members.removeAll(keepingCapacity: false)
        let array = member.filter ({
            let name = "\($0.memberId.firstName) \($0.memberId.lastName)"
            return name.localizedCaseInsensitiveContains(searchText)
        })
        filtered_members = array
        if filtered_members.isEmpty {
            //member not found
        }
        self.tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        filterContentForSearchText(searchBar.text!)
        searchMethod(searchText: searchBar.text!)
        print("text: \(searchBar.text!)")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("update results")
        searchMethod(searchText: searchController.searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text did change")
        searchMethod(searchText: searchText)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searched){
            return self.filtered_members.count
        }else {
        return member.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (searched) {
            
            let cell: MemberContributeCell = self.tableView.dequeueReusableCell(withIdentifier: "MemberContributeCell", for: indexPath) as! MemberContributeCell
            cell.selectionStyle = .none
            
            //MEMBER CELLS & URL IMAGE LOGIC
            let myMembers: MemberResponse = self.filtered_members[indexPath.row]
            
            cell.memberImage.image = nil
            cell.memberImage.image = UIImage(named: "individual")
            
            
            cell.memberName.text = "\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)"
            cell.memberNumber.text = myMembers.memberId.msisdn
            
            if (myMembers.memberId.memberIconPath == nil){
                cell.memberImage.image = UIImage(named: "individual")
            }else {
                if let memberIconPath = myMembers.memberId.memberIconPath {
                Nuke.loadImage(with: URL(string: memberIconPath), into: cell.memberImage)
                print("name image: \(myMembers.memberId.firstName), \(myMembers.memberId.memberIconPath!)!))")
                }
            }
                        cell.contribute.isHidden = true
            if (currentUser?.displayName == "\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)") {
                print("\(currentUser?.displayName) should be hidden)")
            }else {
                memberName = "\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)"
                memberNumber = myMembers.memberId.msisdn!
                cell.contribute.addTarget(indexPath.row, action: #selector(Contribute(button:)), for: .touchUpInside)
            }
            return cell
        }
        
        let cell: MemberContributeCell = self.tableView.dequeueReusableCell(withIdentifier: "MemberContributeCell", for: indexPath) as! MemberContributeCell
        cell.selectionStyle = .none
        self.member = member.sorted(by: {$0.memberId.firstName > $1.memberId.firstName})
        //MEMBER CELLS & URL IMAGE LOGIC
        let myMembers: MemberResponse = self.member[indexPath.row]
        cell.memberImage.image = nil
        cell.memberImage.image = UIImage(named: "individual")
        cell.memberName.text = "\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)"
        cell.memberNumber.text = myMembers.memberId.msisdn
        if (myMembers.memberId.memberIconPath == nil){
            cell.memberImage.image = UIImage(named: "individual")
        }else {
            if let memberIconPath = myMembers.memberId.memberIconPath {
            Nuke.loadImage(with: URL(string: memberIconPath), into: cell.memberImage)
            print("name image: \(myMembers.memberId.firstName), \(myMembers.memberId.memberIconPath!)!))")
            }
        }
        cell.contribute.isHidden = true
        if (currentUser?.displayName == "\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)") {
            print("\(currentUser?.displayName) should be hidden)")
        }else {
            memberName = "\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)"
            memberNumber = myMembers.memberId.msisdn!
        }
        cell.contribute.addTarget(self, action: #selector(Contribute(button:)), for: .touchUpInside)
        cell.contribute.tag = indexPath.row
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (searched) {
            let myMembers: MemberResponse = self.filtered_members[indexPath.row]
            print("name: \(myMembers.memberId.firstName) \(myMembers.memberId.lastName), number: \(myMembers.memberId.msisdn)")
            msisdn = myMembers.memberId.msisdn!
            if cashout == 1 {
                let vc: MemberWalletsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "memberwallets") as! MemberWalletsVC
                vc.forMember = 1
                vc.recipientNumber = myMembers.memberId.msisdn!
                vc.recipientName = "\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)"
                vc.groupId = self.groupId
                vc.network = myMembers.memberId.networkCode ?? ""
                vc.campaignId = self.campaignId
                vc.paymentOption = "Mobile Wallet"
                vc.voteId = self.voteId
                vc.amount = "\(self.amount)"
                vc.reason = self.reason
                vc.memberId = myMembers.memberId.memberId!
                self.navigationController?.pushViewController(vc, animated: true)
            }else if recurringStatus == 1{
                let vc: RecurringVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "recurring") as! RecurringVC
                vc.groupId = self.groupId
                vc.campaignId = self.campaignId
                vc.network = network
                vc.campaignName = self.groupName
                vc.amount = self.amount
                vc.currency = currency
                var pNumber = self.currentUser?.phoneNumber!
                pNumber?.removeFirst()
                vc.msisdn = pNumber!
                print("msisdn: \(msisdn)")
                vc.othersMsisdn = myMembers.memberId.msisdn!
                vc.othersMemberId = myMembers.memberId.memberId!
                vc.anonymous = anonymous
                vc.groupImage = groupIconPath
                self.navigationController?.pushViewController(vc, animated: true)
            } else if cardCheck {
                FTIndicator.showProgress(withMessage: "loading")

                //            let param: ContributeParameter = ContributeParameter(amount: amount, anonymous: anonymous, campaignId: campaignId, currency: self.currency, duration: "", freqType: "", groupId: groupId, narration: groupName, othersMemberId: myMembers.memberId.memberId!, recurring: "false", walletId: walletId)
                //            self.contribute(contributeParameter: param)

                debitNoticeDialog(othersMemberId: myMembers.memberId.memberId!, charge: debitCharge)
            }else {
                FTIndicator.showProgress(withMessage: "loading")
                let param: ContributeParameter = ContributeParameter(amount: amount, anonymous: anonymous, campaignId: campaignId, currency: self.currency, duration: "", freqType: "", groupId: groupId, narration: groupName, othersMemberId: myMembers.memberId.memberId!, recurring: "false", walletId: walletId)
                self.contribute(contributeParameter: param)
            }
        } else {
        let myMembers: MemberResponse = self.member[indexPath.row]
        print("name: \(myMembers.memberId.firstName) \(myMembers.memberId.lastName), number: \(myMembers.memberId.msisdn)")
        msisdn = myMembers.memberId.msisdn!
        if cashout == 1 {
            let vc: MemberWalletsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "memberwallets") as! MemberWalletsVC
            vc.forMember = 1
            vc.recipientNumber = myMembers.memberId.msisdn!
            vc.recipientName = "\(myMembers.memberId.firstName) \(myMembers.memberId.lastName)"
            vc.groupId = self.groupId
            vc.network = myMembers.memberId.networkCode ?? ""
            vc.campaignId = self.campaignId
            vc.paymentOption = "Mobile Wallet"
            vc.voteId = self.voteId
            vc.amount = "\(self.amount)"
            vc.reason = self.reason
            vc.memberId = myMembers.memberId.memberId!
            self.navigationController?.pushViewController(vc, animated: true)
        }else if recurringStatus == 1{
            let vc: RecurringVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "recurring") as! RecurringVC
            vc.groupId = self.groupId
            vc.campaignId = self.campaignId
            vc.network = network
            vc.campaignName = self.groupName
            vc.amount = self.amount
            vc.currency = currency
            var pNumber = self.currentUser?.phoneNumber!
            pNumber?.removeFirst()
            vc.msisdn = pNumber!
            print("msisdn: \(msisdn)")
            vc.othersMsisdn = myMembers.memberId.msisdn!
            vc.othersMemberId = myMembers.memberId.memberId!
            vc.anonymous = anonymous
            vc.groupImage = groupIconPath
            self.navigationController?.pushViewController(vc, animated: true)
        } else if cardCheck {
            FTIndicator.showProgress(withMessage: "loading")

            //            let param: ContributeParameter = ContributeParameter(amount: amount, anonymous: anonymous, campaignId: campaignId, currency: self.currency, duration: "", freqType: "", groupId: groupId, narration: groupName, othersMemberId: myMembers.memberId.memberId!, recurring: "false", walletId: walletId)
            //            self.contribute(contributeParameter: param)
            
            debitNoticeDialog(othersMemberId: myMembers.memberId.memberId!, charge: debitCharge)
        }else {
            FTIndicator.showProgress(withMessage: "loading")
            let param: ContributeParameter = ContributeParameter(amount: amount, anonymous: anonymous, campaignId: campaignId, currency: self.currency, duration: "", freqType: "", groupId: groupId, narration: groupName, othersMemberId: myMembers.memberId.memberId!, recurring: "false", walletId: walletId)
            self.contribute(contributeParameter: param)
        }
        }
    }
    
    func setupMembers(){
        self.tableView.reloadData()
    }
    

    
    func debitNoticeDialog(othersMemberId: String, charge: String) {
        var message = ""
        if charge == "No charge applied" {
            message = "You are attempting to make a contribution using card. \nKindly enter your password so we can verify it is you."
        }else {
            message = "You are attempting to make a contribution using card. \nKindly enter your password so we can verify it is you."
        }
        let alert = UIAlertController(title: "Contribution with Card", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            self.cardAuthVerificationDialog(othersMemberId: othersMemberId)
        }
        alert.addAction(okAction)
        alert.addAction(title: "Cancel", style: .cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //GROUP CAMPAIGN
    func makeContribution(makeContributionParameter: MakeContributionParameter) {
        AuthNetworkManager.makeContribution(parameter: makeContributionParameter) { (result) in
            self.parseMakeContributionResponse(result: result)
        }
    }
    
    private func parseMakeContributionResponse(result: DataResponse<ContributeResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            let alert = UIAlertController(title: "Chango", message: "\(response.responseMessage!)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: PrivateGroupDashboardVC.self){
                        self.navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(withTitle: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    
    //CONTRIBUTION FOR WALLET
    func contribute(contributeParameter: ContributeParameter) {
        AuthNetworkManager.contribute(parameter: contributeParameter) { (result) in
            self.parseContributeResponse(result: result)
        }
    }
    
    private func parseContributeResponse(result: DataResponse<RegularResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")

            let alert = UIAlertController(title: "Chango", message: "\(response.responseMessage!)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                if self.publicGroupCheck == 1 {
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: PublicGroupDashboardVC.self){
                            self.navigationController?.popToViewController(controller, animated: true)
                        }
                    }
                }else {
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: PrivateGroupDashboardVC.self){
                            (controller as! PrivateGroupDashboardVC).refreshPage = true
                            self.navigationController?.popToViewController(controller, animated: true)
                        }
                    }
                }
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            break
        case .failure( _):
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
    
    
    func memberNetwork() {
        AuthNetworkManager.memberNetwork { (result) in
            self.parsememberNetworkResponse(result: result)
        }
    }
    
    
    private func parsememberNetworkResponse(result: DataResponse<MemberNetworkResponse, AFError>){
        switch result.result {
        case .success(let response):
            print(response)
            userNumber = response.msisdn
            userNetwork = response.network
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }
            print(NetworkManager().getErrorMessage(response: result))
        }
    }
    
    //CARD AUTH VERIFICATION
    func cardAuthVerificationDialog(othersMemberId: String, animated: Bool = true) {
        if UserDefaults.standard.bool(forKey: "touchID"){
            print("touchID")
            //TOUCH ID
            let context = LAContext()
            var error: NSError?
            switch UIDevice.current.screenType {
            case UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax, UIDevice.ScreenType.iPhone_XR_11:
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    let reason = "Verify user with Face ID"
                    UserDefaults.standard.set(true, forKey: "touchID")
//                    touchID.imageView?.image = UIImage(named: "faceid2")
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                        [unowned self] (success, authenticationError) in
                        DispatchQueue.main.async {
                            if success {
                                self.unlockID(otherMembersId: othersMemberId)
                            } else {
                                // error
                            }
                        }
                    }
                } else {
                    // no biometry
                    UserDefaults.standard.set(false, forKey: "touchID")
                    let alert = UIAlertController(title: "Face ID", message: "There are no enrolled faces or fingers.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
                break
            default:
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    let reason = "Verify user with Touch ID"
                    
                    UserDefaults.standard.set(true, forKey: "touchID")
                    
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                        [unowned self] (success, authenticationError) in
                        
                        DispatchQueue.main.async {
                            if success {
                                self.unlockID(otherMembersId: othersMemberId)
                            } else {
                                // error
                            }
                        }
                    }
                } else {
                    // no biometry
                    UserDefaults.standard.set(false, forKey: "touchID")
                    
                    let alert = UIAlertController(title: "Touch ID", message: "There are no enrolled faces or fingers.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        
                        
                    }
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
        }else {

        //create a custom view controller
        let recurringVC = RecurringPaymentCell(nibName: "RecurringPaymentCell", bundle: nil)
        //create the dialog
        let popup = PopupDialog(viewController: recurringVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
            recurringVC.descriptionLabel.text = "Please enter password to verify user"
        //create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
        }
        //create second button
        let buttonTwo = DefaultButton(title: "VERIFY", height: 60) {
            if(recurringVC.oTP.text?.isEmpty)!{
                self.showAlert(title: "User Verification", message: "Please enter password")
            }else {
                FTIndicator.init()
                FTIndicator.setIndicatorStyle(UIBlurEffect.Style.dark)
                FTIndicator.showProgress(withMessage: "verifying", userInteractionEnable: false)
                //Firebase Auth
                var currentUser = Auth.auth().currentUser
                Auth.auth().signIn(withEmail: (currentUser?.email)!, password: recurringVC.oTP.text!) { (user, error) in
                    if error != nil {
                        FTIndicator.dismissProgress()
                        self.showAlert(withTitle: "User Verification", message: "Invalid credentials")
                        print(error?.localizedDescription)
                    } else {
                        //call endpoint
                        var pNovemember = self.currentUser?.phoneNumber
                        pNovemember?.removeFirst()
                        let msisdn = pNovemember!
                        FTIndicator.showProgress(withMessage: "loading")
                        let param: ContributeParameter = ContributeParameter(amount: self.amount, anonymous: self.anonymous, campaignId: self.campaignId, currency: self.currency, duration: "", freqType: "", groupId: self.groupId, narration: self.groupName, othersMemberId: othersMemberId, recurring: "false", walletId: self.walletId)
                        self.contribute(contributeParameter: param)
                    }
                }
            }
        }
        //Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        //Present dialog
        present(popup, animated: animated, completion: nil)
        }
    }
    
    func unlockID(otherMembersId: String) {
        let pass = UserDefaults.standard.string(forKey: "password")
        let email = UserDefaults.standard.string(forKey: "email")
        print("\(pass), \(email)")
        
        FTIndicator.showProgress(withMessage: "verifying")
        Auth.auth().signIn(withEmail: email!, password: pass!) { (user, error) in
            if error != nil {
                //alert
                FTIndicator.dismissProgress()
                let alert = UIAlertController(title: "Sign in", message: "Invalid credentials", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                //continue contribution process
                var pNovemember = self.currentUser?.phoneNumber
                pNovemember?.removeFirst()
                let msisdn = pNovemember!
                FTIndicator.showProgress(withMessage: "loading")
                let param: ContributeParameter = ContributeParameter(amount: self.amount, anonymous: self.anonymous, campaignId: self.campaignId, currency: self.currency, duration: "", freqType: "", groupId: self.groupId, narration: self.groupName, othersMemberId: otherMembersId, recurring: "false", walletId: self.walletId)
                self.contribute(contributeParameter: param)
            }
            // ...
        }
    }
}
