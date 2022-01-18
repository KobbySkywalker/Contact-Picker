//
//  ContributeViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 07/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator
import Alamofire
import FirebaseAuth
import Nuke
import FirebaseDatabase
import LocalAuthentication
import PopupDialog

class ContributeViewController: BaseViewController {
    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var amountTextField: ACFloatingTextfield!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var anonymousCheckBox: VKCheckbox!
    @IBOutlet weak var recurringCheckBox: VKCheckbox!
    @IBOutlet weak var contributeForCheckBox: VKCheckbox!
    @IBOutlet weak var contributeButton: UIButton!
    @IBOutlet weak var onBehalf: UISwitch!
    @IBOutlet weak var maxContributionLimit: UILabel!
    @IBOutlet weak var onBehalfStack: UIStackView!
    @IBOutlet weak var recurringPaymentLabel: UILabel!
    @IBOutlet weak var recurrinngStack: UIStackView!
    @IBOutlet weak var contributionChargeLabel: UILabel!
    @IBOutlet weak var contributionChargeStack: UIStackView!
    
    var members: [MemberResponse] = []
    var campaignDetails: GetGroupCampaignsResponse!
    
    var userNumber: String = ""
    var userNetwork: String = ""
    var groupNamed: String = ""
    var campaignId: String = ""
    var groupId: String = ""
    var currency: String = ""
    var voucher: String = ""
    var defCont: Int = 0
    var campaignName: String = ""
    var voucherNotHidden: Bool = false
    var narration: String = ""
    var network: String = ""
    var voteId: String = ""
    var campaignExpiry: String = ""
    var privateGroup: GroupResponse!
    var defaultContributions: DefaultCampaignResponse!
    var defaultContribution: ContributionsPage!
    var maxContributionLimitPerDay: Double = 0.0
    var maxSingleContributionLimit: Double = 0.0
    var anonymous: String = "false"
    var groupIconPath: String = ""
    var msisdn: String = ""
    var othersMsisdn: String = ""
    var othersMemberId: String = ""
    var newDateString: String = ""
    var thirdPartyReferenceNo: String = ""
    var publicGroupCheck: Int = 0
    var walletNumber: String = ""
    var countryId: String = ""
    var walletId: String = ""
    var cardCheck: Bool = false
    var cardCharge: String = ""
    var mobileCharge: String = ""

    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showChatController()
        disableDarkMode()
        let parameters: GetMemberParameter = GetMemberParameter(groupId: groupId)
        getMembers(getMembersParameter: parameters)
        if defCont == 0 {
            narration = groupNamed
        }else if defCont == 1{
            narration = groupNamed
        }
        
        if publicGroupCheck == 1 {
            onBehalfStack.isHidden = true
        }

        self.title = "Contribute"
        print("resp: \(campaignDetails)")
        groupNameLabel.text = groupNamed
        self.memberNetwork()
        
        let largeNumber = maxSingleContributionLimit
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber))
        
        maxContributionLimit.isHidden = false
        maxContributionLimit.text = "Max. single contribution is \(currency)\(formattedNumber!)"
        
        print("icon: \(groupIconPath)")
        currencyLabel.text = currency
        
        if (groupIconPath == "<null>") || (groupIconPath == nil) || (groupIconPath == ""){
            groupImage.image = UIImage(named: "defaultgroupicon")
            groupImage.contentMode = .center
        }else {
            Nuke.loadImage(with: URL(string: groupIconPath)!, into: groupImage)
        }
        
        let parameter: GetPaymentChargeParameter = GetPaymentChargeParameter(countryId: countryId)
        getPaymentCharge(getPaymentChargeParameter: parameter)
        
        //anonymous checkbox
        anonymousCheckBox.checkboxValueChangedBlock = {
            isOn in
            self.anonymousCheckBox.vBorderColor = UIColor(hexString: "#228CC7")
            self.anonymousCheckBox.backgroundColor = UIColor(hexString: "#228CC7")
            self.anonymousCheckBox.color = .white
            print("Checkbox is \(isOn ? "ON" : "OFF")")
        
            if self.anonymousCheckBox.isOn() {
                self.anonymous = "true"
            }else{
                self.anonymous = "false"
                self.anonymousCheckBox.backgroundColor = UIColor.white
            }
        }
        
        if cardCheck == true {
            recurrinngStack.isHidden = true
        }
                
        //on behalf checkbox
        contributeForCheckBox.checkboxValueChangedBlock = {
            isOn in
            self.contributeForCheckBox.vBorderColor = UIColor(hexString: "#228CC7")
            self.contributeForCheckBox.backgroundColor = UIColor(hexString: "#228CC7")
            self.contributeForCheckBox.color = .white
            print("Checkbox is \(isOn ? "ON" : "OFF")")
        
            if self.contributeForCheckBox.isOn() {
                
            }else{
                self.contributeForCheckBox.backgroundColor = UIColor.white
            }
        }
        //recurring checkbox
        recurringCheckBox.checkboxValueChangedBlock = {
            isOn in
            self.recurringCheckBox.vBorderColor = UIColor(hexString: "#228CC7")
            self.recurringCheckBox.backgroundColor = UIColor(hexString: "#228CC7")
            self.recurringCheckBox.color = .white
            print("Checkbox is \(isOn ? "ON" : "OFF")")
        
            if self.recurringCheckBox.isOn() {
                
            }else{
                self.recurringCheckBox.backgroundColor = UIColor.white
            }
        }
        
        let formatters = DateFormatter()
        formatters.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatters.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let newDate = formatters.date(from: campaignExpiry){
            newDateString = dateFormatter.string(from: newDate)
            print("new date: \(dateFormatter.string(from: newDate))")
        }
        print(campaignExpiry)
        fetchMandateObject()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getMembers(getMembersParameter: GetMemberParameter) {
        AuthNetworkManager.getMembers(parameter: getMembersParameter) { (result) in
            self.parseGetMembersResponse(result: result)
        }
    }
    
    private func parseGetMembersResponse(result: DataResponse<[MemberResponse], AFError>){
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            for item in response {
                members.append(item)
            }
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    

    
    @IBAction func contributeButtonAction(_ sender: UIButton) {
        if (amountTextField.text?.isEmpty)! {
            showAlert(title: "Make Contribution", message: "Please enter an amount")
        }else if (Int(amountTextField.text!) == 0){
            showAlert(title: "Make Contribution", message: "Amount cannot be zero. Please enter a valid amount.")
        }else if contributeForCheckBox.isOn() {
            
            print("take them to member selection")
            
            let vc: MemberSearchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "membersearch") as! MemberSearchViewController
            self.contributeForCheckBox.vBorderColor = UIColor(hexString: "#228CC7")
             self.contributeForCheckBox.backgroundColor = UIColor(hexString: "#228CC7")
             self.contributeForCheckBox.color = .white
            if recurringCheckBox.isOn() && (campaignExpiry == "nil" || campaignExpiry == "") {
                vc.recurringStatus = 1
                vc.groupIconPath = groupIconPath
            }
            vc.members = members
            vc.privateGroup = privateGroup
            vc.campaignId = campaignId
            vc.groupName = groupNamed
            vc.groupId = groupId
            vc.amount = Double(amountTextField.text!)!
            vc.currency = currency
            vc.network = userNetwork
            vc.campaignExpiry = campaignExpiry
            vc.onBehalf = true
            vc.currency = currency
            vc.anonymous = anonymous
            vc.walletId = walletId
            vc.debitCharge = cardCharge
            vc.cardCheck = cardCheck
            print("anon:\(anonymous)")
            self.navigationController?.pushViewController(vc, animated: true)
        }else if (recurringCheckBox.isOn()) && (campaignExpiry == "nil" || campaignExpiry == "") {
            print("check box on")
            let vc: RecurringVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "recurring") as! RecurringVC
            vc.groupId = groupId
            vc.campaignId = campaignId
            vc.network = network
            vc.campaignName = groupNamed
            if let amount = Double(self.amountTextField.text!) {
                vc.amount = amount
            }
            vc.currency = currency
            vc.msisdn = msisdn
            print("msisdn: \(msisdn)")
            vc.othersMsisdn = othersMsisdn
            vc.othersMemberId = othersMemberId
            vc.anonymous = anonymous
            vc.groupImage = groupIconPath
            vc.publicGroupCheck = publicGroupCheck
            self.navigationController?.pushViewController(vc, animated: true)
        }else if (recurringCheckBox.isOn()) && (campaignExpiry != "nil"){
            //make room  for recurring campaign expiry not nil and member selection
            
            let parameter: RecurringExpiryParameter = RecurringExpiryParameter(expiry: newDateString)
            recurringExpiry(recurringExpiry: parameter)
        }else if cardCheck {
//            cardAuthVerificationDialog()
//            let parameter: GetPaymentChargeParameter = GetPaymentChargeParameter(countryId: countryId)
//            getPaymentCharge(getPaymentChargeParameter: parameter)
            debitNoticeDialog(charge: cardCharge)
        }else {
            var pNovemember = self.user?.phoneNumber
            pNovemember?.removeFirst()
            let msisdn = pNovemember!
            FTIndicator.showProgress(withMessage: "loading")
            print("amt: \(Double(self.amountTextField.text!)!)")
            let param: ContributeParameter = ContributeParameter(amount: Double(self.amountTextField.text!)!, anonymous: anonymous, campaignId: self.campaignId, currency: currency, duration: "", freqType: "", groupId: self.groupId, narration: self.groupNamed, othersMemberId: "", recurring: "false", walletId: walletId)
            self.contribute(contributeParameter: param)
        }
    }

    
    func debitNoticeDialog(charge: String) {
        var message = ""
        if charge == "No charge applied" {
            message = "You are attempting to make a contribution using card. \nKindly enter your password so we can verify it is you."
        }else {
            message = "You are attempting to make a contribution using card. \nKindly enter your password so we can verify it is you."
        }
        let alert = UIAlertController(title: "Contribution with Card", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            self.cardAuthVerificationDialog()
        }
        alert.addAction(okAction)
        alert.addAction(title: "Cancel", style: .cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //CARD AUTH VERIFICATION
    func cardAuthVerificationDialog(animated: Bool = true) {
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
                                self.unlockID()
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
                                self.unlockID()
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
                        var pNovemember = self.user?.phoneNumber
                        pNovemember?.removeFirst()
                        let msisdn = pNovemember!
                        FTIndicator.showProgress(withMessage: "loading")
                        print("amt: \(Double(self.amountTextField.text!)!)")
                        let param: ContributeParameter = ContributeParameter(amount: Double(self.amountTextField.text!)!, anonymous: self.anonymous, campaignId: self.campaignId, currency: self.currency, duration: "", freqType: "", groupId: self.groupId, narration: self.groupNamed, othersMemberId: "", recurring: "false", walletId: self.walletId)
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
    
    func unlockID() {
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
                var pNovemember = self.user?.phoneNumber
                pNovemember?.removeFirst()
                let msisdn = pNovemember!
                FTIndicator.showProgress(withMessage: "loading")
                print("amt: \(Double(self.amountTextField.text!)!)")
                let param: ContributeParameter = ContributeParameter(amount: Double(self.amountTextField.text!)!, anonymous: self.anonymous, campaignId: self.campaignId, currency: self.currency, duration: "", freqType: "", groupId: self.groupId, narration: self.groupNamed, othersMemberId: "", recurring: "false", walletId: self.walletId)
                self.contribute(contributeParameter: param)
            }
            // ...
        }
    }
    
    
    //CONTRIBUTE
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
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
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
            if response.network == "VODAFONE" {
            }
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }
            print(NetworkManager().getErrorMessage(response: result))
        }
    }
    
    func getPaymentCharge(getPaymentChargeParameter: GetPaymentChargeParameter) {
        AuthNetworkManager.getPaymentCharge(parameter: getPaymentChargeParameter) { (result) in
            self.parseGetPaymentChargeResponse(result: result)
        }
    }
    
    private func parseGetPaymentChargeResponse(result: DataResponse<GetPaymentChargeResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            cardCharge = response.cardContribution ?? ""
            mobileCharge = response.walletContribution ?? ""
            //contribution per wallet check
            if cardCheck {
                contributionChargeLabel.text = "Your card will be charged a transaction fee of \(cardCharge)"

            }else {
                contributionChargeLabel.text = "Your mobile wallet will be charged a transaction fee of \(mobileCharge)"
            }
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    //RECURRING EXPIRY
    func recurringExpiry(recurringExpiry: RecurringExpiryParameter) {
        AuthNetworkManager.recurringExpiry(parameter: recurringExpiry) { (result) in
            self.parseRecurringExpiryResponse(result: result)
        }
    }
    
    
    private func parseRecurringExpiryResponse(result: DataResponse<ExpiryDate, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            if response.duration == ["none"] {
                showAlert(title: "Chango", message: "This campaign no longer supports recurring payments.")
            }else {
                let vc: RecurringVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "recurring") as! RecurringVC
                vc.groupId = groupId
                vc.campaignId = campaignId
                vc.network = network
                vc.campaignName = groupNamed
                vc.amount = Double(self.amountTextField.text!)!
                vc.currency = currency
                vc.msisdn = msisdn
                vc.othersMsisdn = othersMsisdn
                vc.othersMemberId = othersMemberId
                vc.anonymous = anonymous
                print("an: \(anonymous)")
                vc.durationArray = response.duration
                vc.frequencyArray = response.frequency
                vc.publicGroupCheck = publicGroupCheck
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    func fetchMandateObject() {
        let groupsRef = Database.database().reference().child("mandate")
        var pNovemember = self.user?.phoneNumber
        pNovemember?.removeFirst()
        msisdn = pNovemember!
        let uid = groupsRef.child("\(msisdn)")
        print("uid: \(uid)")
        _ = uid.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshotValue = snapshot.value as? [String: AnyObject] {
                if snapshotValue.count > 0 {
                    var thrdPrtyRfrncN = ""
                    self.thirdPartyReferenceNo = "show"
                }else {
                    print("no mandate exists")
                    self.thirdPartyReferenceNo = ""
                }
            }
        })
    }
    
    
}
