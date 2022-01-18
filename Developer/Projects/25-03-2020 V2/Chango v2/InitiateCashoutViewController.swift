//
//  InitiateCashoutViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 13/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import DropDown
import EPContactsPicker
import FirebaseAuth

class InitiateCashoutViewController: BaseViewController, EPPickerDelegate {

    @IBOutlet weak var selectCampaign: UIButton!
    @IBOutlet weak var selectPaymentMethod: UIButton!
    @IBOutlet weak var enterAmount: ACFloatingTextfield!
    @IBOutlet weak var recipientNumber: ACFloatingTextfield!
    @IBOutlet weak var reason: ACFloatingTextfield!
    @IBOutlet weak var campaignDropDown: UIStackView!
    @IBOutlet weak var paymentMethodDropDown: UIStackView!
    @IBOutlet weak var reasonIcon: UIImageView!
    @IBOutlet weak var lastIcon: UIImageView!
    @IBOutlet weak var lastTextfield: ACFloatingTextfield!
    @IBOutlet weak var campaignBalances: UILabel!
    @IBOutlet weak var numberOfVotesRequired: UILabel!
    @IBOutlet weak var campaignBalanceLabel: UILabel!
    
    var bankCheck: Int = 0
    
    let dropDown = DropDown()
    
    var groupId: String = ""
    var voteId: String = ""
    var network: String = ""
    var campaignBalance: String = ""
    var cashoutVotesRequired: Int = 0
    var cashoutVotesCompleted: Int = 0
    let cashoutDropDown = DropDown()
    let paymentDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.cashoutDropDown,
            self.paymentDropDown
        ]
    }()
    
    var campaignNames: [GetGroupCampaignsResponse] = []
    
    var campaignName: [String] = []
    var campaignIdd: String = ""
    var campaignId: [String] = []
    var campaignStatus: [String] = []
    var campaignBal : [Double] = [0.0]
    var campBal: Double = 0.0
    var status: String = ""
    var paymentMethod: [String] = ["      Mobile Wallet      ", "      Bank Account     "]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()

        setupDropDowns()
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        
        campaignBalances.text = campaignBalance
        
        print("cashout vote id: \(voteId)")
        
        campaignBalances.isHidden = true
        campaignBalanceLabel.isHidden  = true
        
        
        let parameters: GetVoteSummaryParameter = GetVoteSummaryParameter(groupId: groupId)
        self.getVoteSummary(getVoteSummaryParameter: parameters)
    }
    
    
    
    func setupDropDowns() {
        setupCashoutDropDown()
        setupPaymentDropDown()
    }
    
    func setupCashoutDropDown(){
        cashoutDropDown.anchorView = campaignDropDown
        //        campaignDropDown.anchorView = dropDownButton
        
        cashoutDropDown.bottomOffset = CGPoint(x: 0, y: campaignDropDown.bounds.height + 10)
        
        for item in campaignNames {
            self.campaignName.append(item.campaignName)
            self.campaignId.append(item.campaignId)
            self.campaignStatus.append(item.status!)
            self.campaignBal.append(item.amountReceived!)
            print("id: \(campaignId)")
            print("campaign balance: \(campaignBal)")
        }
        cashoutDropDown.dataSource = campaignName
        
        
        //        Action triggered on selection
        cashoutDropDown.selectionAction = { [weak self] (index, item) in
            print("Selected item: \(item) at \(index)")
            self!.selectCampaign.titleLabel?.text = item
            self?.campaignIdd = self!.campaignId[index]
            self?.status = self!.campaignStatus[index]
            self?.campBal = (self?.campaignBal[index])!
            print(self!.status)
            print(self!.campaignIdd)
            print(self!.campBal)
            
            self!.campaignBalanceLabel.isHidden = false
            self!.campaignBalances.isHidden = false
            
            if index == 0 {
     
                self!.campaignBalances.text = "\(self!.campaignBalance)"
            }else {
                self!.campaignBalances.text = "\(self!.campBal)"

            }
//            self!.campaignId = self!.campaignIds[index]
//            print(self!.campaignId)
            
            self!.cashoutDropDown.backgroundColor = UIColor.white
            self!.cashoutDropDown.selectionBackgroundColor = UIColor.white
            
            if self!.status == "stop" {
                let alert = UIAlertController(title: "Cashout", message: "This campaign has been stopped.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                alert.addAction(okAction)
                
                self!.present(alert, animated: true, completion: nil)
            }else if self!.status == "pause"{
                let alert = UIAlertController(title: "Cashout", message: "This campaign has been paused.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                alert.addAction(okAction)
                
                self!.present(alert, animated: true, completion: nil)
            }
            
        }
        

        campaignDropDown.width = 200
        
    }
    
    
    func setupPaymentDropDown(){
        paymentDropDown.anchorView = paymentMethodDropDown
        //        campaignDropDown.anchorView = dropDownButton
        
        paymentDropDown.bottomOffset = CGPoint(x: 0, y: paymentMethodDropDown.bounds.height + 10)
        
        
        paymentDropDown.dataSource = paymentMethod
        
        
        //        Action triggered on selection
        paymentDropDown.selectionAction = { [weak self] (index, item) in
            print("Selected item: \(item) at \(index)")
            
            print(self!.paymentMethod)
            
            if item == "      Bank Account     " {
                
                self!.selectPaymentMethod.titleLabel?.text = item

                self!.bankCheck = 1
                self!.reasonIcon.image = UIImage(named: "bank")
                self!.reason.placeholder = "Enter recipient account number"
                
                self!.lastIcon.isHidden = false
                self!.lastTextfield.isHidden = false
                
            }else {
                self!.selectPaymentMethod.titleLabel?.text = item

                self!.bankCheck = 0
                self!.reasonIcon.image = UIImage(named: "reason")
                self!.reason.placeholder = "Reason"
                self!.reason.keyboardType = .asciiCapable
                self!.lastIcon.isHidden = true
                self!.lastTextfield.isHidden = true
            }
            
            self!.paymentDropDown.backgroundColor = UIColor.white
            self!.paymentDropDown.selectionBackgroundColor = UIColor.white
            
        }

        
        paymentDropDown.width = 200
        
    }
    
    
    
    func epContactPicker(_: EPContactsPicker, didSelectContact contact: [EPContact]){
        for item in contact {
            print(item.phoneNumbers[0].phoneNumber)
            let numbers = item.phoneNumbers[0].phoneNumber
            
            let alpha = numbers.removeCharacters(from: CharacterSet.decimalDigits.inverted)
            print(alpha)
            
            recipientNumber.text = alpha
            
        }
    }
    
    @IBAction func campaignDropDownAction(_ sender: UIButton) {
        cashoutDropDown.show()
    }
    
    @IBAction func paymentMethodDropDownAction(_ sender: UIButton) {
        paymentDropDown.show()
    }
    
    
    @IBAction func contactPickerButtonAction(_ sender: UIButton) {
    }
    
    
    //CASHOUT INITIATION
    func initiateCashout(initiateCashoutParameter: InitiateCashoutParameter) {
        AuthNetworkManager.initiateCashout(parameter: initiateCashoutParameter) { (result) in
            self.parseInitiateCashoutResponse(result: result)
        }
    }
    
    
    private func parseInitiateCashoutResponse(result: DataResponse<RevokeLoanApproverResponse, AFError>){
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
    
    @IBAction func initiateCashoutActionButton(_ sender: UIButton) {
        
        if (enterAmount.text!.isEmpty || (reason.text?.isEmpty)!) {
            
            let alert = UIAlertController(title: "Cashout", message: "Please fill all fields.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else if (enterAmount.text == "0") || (enterAmount.text == "0.00") {
            
            let alert = UIAlertController(title: "Cashout", message: "Amount cannot be zero. Please enter a valid amount.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else if (campaignBalance == "0.00") {
    
            let alert = UIAlertController(title: "Cashout", message: "Insufficient Funds.", preferredStyle: .alert)
            let okActioin = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
    
            }
            alert.addAction(okActioin)
            self.present(alert, animated: true, completion: nil)
        }
        
        FTIndicator.showProgress(withMessage: "initiating cashout")
        
        if bankCheck == 1 {
            
            
            
//            let parameter: InitiateCashoutParameter = InitiateCashoutParameter(amount: enterAmount.text!, campaignId: campaignIdd, cashoutDestination: "bank", cashoutDestinationCode: "EBG", cashoutDestinationNumber: reason.text! , groupId: groupId, network: "EBG", voteId: voteId, reason: lastTextfield.text!)
//            initiateCashout(initiateCashoutParameter: parameter)
        }else {
            
            let user = Auth.auth().currentUser
//            let parameter: InitiateCashoutParameter = InitiateCashoutParameter(amount: enterAmount.text!, campaignId: campaignIdd, cashoutDestination: "wallet", cashoutDestinationCode: "EBG", cashoutDestinationNumber: (user?.phoneNumber)!, groupId: groupId, network: network, voteId: voteId, reason: reason.text!)
//            initiateCashout(initiateCashoutParameter: parameter)
        }

        
    }
    
    
    //VOTE SUMMARY
    func getVoteSummary(getVoteSummaryParameter: GetVoteSummaryParameter) {
        AuthNetworkManager.getVoteSummary(parameter: getVoteSummaryParameter) { (result) in
            self.parseGetVoteSummary(result: result)
        }
    }
    
    
    private func parseGetVoteSummary(result: DataResponse<[BallotSummary], AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            
            for item in response {
                if item.ballot == "cashout"{
                    cashoutVotesRequired = item.minVoteCount
                    cashoutVotesCompleted = item.votesCompleted
                }
                
                self.numberOfVotesRequired.text = "The number of votes required for a cashout is \(cashoutVotesRequired)"
            }
            
            
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
