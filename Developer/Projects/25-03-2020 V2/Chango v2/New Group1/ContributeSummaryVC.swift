//
//  ContributeSummaryVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 30/08/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import PopupDialog
import FirebaseDatabase
import FirebaseAuth

class ContributeSummaryVC: BaseViewController {
    
    @IBOutlet weak var contriInfoLabel: UILabel!
    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var recurringSwitch: UISwitch!
    @IBOutlet weak var contributeBtn: UIButton!
    @IBOutlet weak var contributeView: UIView!
    @IBOutlet weak var recurringLabel: UILabel!
    
    var campaignName: String = ""
    var amount: Double = 0.0
    var groupId: String = ""
    var campaignId: String = ""
    var network: String = ""
    var paymentOption: String = ""
    var voteId: String = ""
    var contributor: String = ""
    var voucherCode: String = ""
    var currency: String = ""
    var msisdn: String = ""
    var othersMsisdn: String = ""
    var othersMemberId: String = ""
    var paymentDuration: String = ""
    var repeatCycle: String = ""
    var recurring: String = ""
    var thirdPartyReferenceNo: String = ""
    var campaignExpiry: String = ""
    var newDateString: String = ""
    var onBehalf: Bool = false
    var anonymous: String = "false"
    var durationArray: [String] = ["One Week", "One Month", "Six Months", "One Year"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableDarkMode()
        self.title = "Contribution Summary"
        contributeBtn.layer.cornerRadius = 22.00
        
        print("summary amount: \(amount)")
        
        contributeView.layer.cornerRadius = 10
        contributeView.layer.shadowColor = UIColor.black.cgColor
        contributeView.layer.shadowOffset = CGSize(width: 2, height: 4)
        contributeView.layer.shadowRadius = 8
        contributeView.layer.shadowOpacity = 0.2
        
        if onBehalf == true {
            contriInfoLabel.text = "I am contributing to \(campaignName) for"
            campaignNameLabel.text = contributor
        }else {
            contriInfoLabel.text = "I am contributing to"
            campaignNameLabel.text = campaignName
        }
        amountLabel.text = "\(amount)"
        if (network != "MTN") {
            recurringSwitch.isHidden = true
            recurringLabel.isHidden = true
        }else {
            print("mtn network")
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
    
    
    @IBAction func switchToggle(_ sender: UISwitch) {
        if recurringSwitch.isOn{
            contributeBtn.setTitle("CONTINUE", for: .normal)
        }else {
            
        }
    }
    
    @IBAction func contributeButtonAction(_ sender: UIButton) {
        print("campaign expiry: \(campaignExpiry)")
        if (recurringSwitch.isOn) && (campaignExpiry == "nil" || campaignExpiry == ""){
            let vc: RecurringVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "recurring") as! RecurringVC
            vc.groupId = groupId
            vc.campaignId = campaignId
            vc.network = network
            vc.campaignName = campaignName
            vc.amount = amount
            vc.currency = currency
            vc.msisdn = msisdn
            print("msisdn: \(msisdn)")
            vc.othersMsisdn = othersMsisdn
            vc.othersMemberId = othersMemberId
            vc.anonymous = anonymous
            self.navigationController?.pushViewController(vc, animated: true)
        }else if (recurringSwitch.isOn) && (campaignExpiry != "nil") {
            let parameter: RecurringExpiryParameter = RecurringExpiryParameter(expiry: newDateString)
            recurringExpiry(recurringExpiry: parameter)
        }else {
            
            print("amount param: \(amount)")
            FTIndicator.showProgress(withMessage: "loading")
            let parameter: MakeContributionParameter = MakeContributionParameter(amount: amount, campaignId: campaignId, currency: currency, destination: "", groupId: groupId, invoiceId: "", duration: paymentDuration, freqType: repeatCycle, msisdn: msisdn, narration: campaignName, network: network, recurring: "false", voucher: voucherCode, othersMsisdn: othersMsisdn, othersMemberId: othersMemberId, anonymous: anonymous)
            makeContribution(makeContributionParameter: parameter)
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
            if network == "VODAFONE"{
                let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: MainMenuTableViewController.self){
                            (controller as! MainMenuTableViewController).refreshPage = true
                            self.navigationController?.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }else {
                let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: MainMenuTableViewController.self){
                            (controller as! MainMenuTableViewController).refreshPage = true
                            self.navigationController?.popToViewController(controller, animated: true)
                        }
                    }
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
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

                let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: MainMenuTableViewController.self){
                            (controller as! MainMenuTableViewController).refreshPage = true
                            self.navigationController?.popToViewController(controller, animated: true)
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

    
    
    func fetchMandateObject() {
        let groupsRef = Database.database().reference().child("mandate")
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
    
    
    
    //RECURRING OTP DIALOG
    func showRecurringOTPDialog(animated: Bool = true) {
        //create a custom view controller
        let recurringVC = RecurringPaymentCell(nibName: "RecurringPaymentCell", bundle: nil)
        //create the dialog
        let popup = PopupDialog(viewController: recurringVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
        //create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
        }
        //create second button
        let buttonTwo = DefaultButton(title: "VERIFY", height: 60) {
            if(recurringVC.oTP.text?.isEmpty)!{
                self.showAlert(title: "Recurring Payment Verification", message: "Please enter password")
            }else {
                FTIndicator.init()
                FTIndicator.setIndicatorStyle(UIBlurEffect.Style.dark)
                FTIndicator.showProgress(withMessage: "Checking", userInteractionEnable: false)
                //Firebase Auth
                let currentUser = Auth.auth().currentUser
                Auth.auth().signIn(withEmail: (currentUser?.email)!, password: recurringVC.oTP.text!) { (user, error) in
                    print("user: \(user)")
                    if error != nil {
                        FTIndicator.dismissProgress()
                        let alert = UIAlertController(title: "Recurring Payment", message: "Invalid credentials", preferredStyle: .alert)
                        print(error?.localizedDescription)
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                            alert.dismiss(animated: true, completion: nil)
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        print(error?.localizedDescription)
                    } else {
                        //call endpoint
                        let parameter: MakeContributionParameter = MakeContributionParameter(amount: self.amount, campaignId: self.campaignId, currency: self.currency, destination: "", groupId: self.groupId, invoiceId: "", duration: self.paymentDuration, freqType: self.repeatCycle, msisdn: self.msisdn, narration: self.campaignName, network: self.network, recurring: "true", voucher: self.voucherCode, othersMsisdn: self.othersMsisdn, othersMemberId: self.othersMemberId, anonymous: self.anonymous)
                        self.makeContribution(makeContributionParameter: parameter)
                        
                        FTIndicator.showProgress(withMessage: "loading")
                    }
                }
            }
        }
        //Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        //Present dialog
        present(popup, animated: animated, completion: nil)
        
    }
    
    
    //RECURRING PAYMENT OTP
    func recurringPayment(recurringPayment: RecurringOTPParameter) {
        AuthNetworkManager.recurringPayment(parameter: recurringPayment) { (result) in
            self.parseRecurringPaymentResponse(result: result)
        }
    }
    
    
    
    
    private func parseRecurringPaymentResponse(result: DataResponse<RecurringResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: MainMenuTableViewController.self){
                        (controller as! MainMenuTableViewController).refreshPage = true
                        self.navigationController?.popToViewController(controller, animated: true)
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
                vc.campaignName = campaignName
                vc.amount = amount
                vc.currency = currency
                vc.msisdn = msisdn
                vc.othersMsisdn = othersMsisdn
                vc.othersMemberId = othersMemberId
                vc.anonymous = anonymous
                print("an: \(anonymous)")
                vc.durationArray = response.duration
                vc.frequencyArray = response.frequency
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
    
    
    
}
