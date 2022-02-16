//
//  InitiateCashoutTableViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 26/07/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import FirebaseAuth
import FTIndicator

class InitiateCashoutTableViewController: BaseTableViewController, UITextFieldDelegate {

    @IBOutlet weak var cashoutView: UIView!
    @IBOutlet weak var percentageRequiredLabel: UILabel!
    @IBOutlet weak var campaignOptionsDropDown: UIStackView!
    @IBOutlet weak var selectCampaignButton: UIButton!
    @IBOutlet weak var destinationOptionDropDown: UIStackView!
    @IBOutlet weak var selectDestinationButton: UIButton!
    @IBOutlet weak var paymentMethodDropDown: UIStackView!
    @IBOutlet weak var selectPaymentMethodButton: UIButton!
    @IBOutlet weak var campaignBalanceLabel: UILabel!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var reason: UITextField!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var walletBankTextField: UITextField!
    @IBOutlet weak var paymentInformationLabel: UILabel!
    @IBOutlet weak var initiateButton: UIButton!
    
    
    
    var bankCheck: Int = 0
    
    let dropDown = DropDown()
    
    var groupId: String = ""
    var voteId: String = ""
    var network: String = ""
    var campaignBalance: String = ""
    var cashoutVotesRequired: Double = 0.0
    var cashoutVotesCompleted: Int = 0
    let campaignDropDown = DropDown()
    let paymentDropDown = DropDown()
    let destinationDropDown = DropDown()
    var members: [MemberResponse] = []
    var firstName: String = ""
    var lastName: String = ""
    var memberName: String = ""
    var memberNumber: String = ""
    var cashout: Int = 0
    var destinationCheck: Int = 0
    var destinationCode: String = ""
    var destinationNumber: String = ""
    var cashoutDestination: String = ""
    var cashoutDestinationNumber: String = ""
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.campaignDropDown,
            self.paymentDropDown,
            self.destinationDropDown
        ]
    }()
    
    var campaignNames: [GetGroupCampaignsResponse] = []
    
    var campaignName1st: String = ""
    var campaignId1st: String = ""
    var campaignBalance1st: String = ""
    var campaignName: [String] = []
    var campName: String = ""
    var campaignIdd: String = ""
    var campaignId: [String] = []
    var campaignStatus: [String] = []
    var campaignBal : [Double] = [0.0]
    var campBal: Double = 0.0
    var status: String = ""
    var paymentMethod: [String] = ["      Mobile Wallet      ", "      Bank Account     "]
    var destinationOptions: [String] = ["    Self    ", "    Members    ", "    Other    "]
//    var minVoteCount: Double = 0.0
    let user = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()

        showChatController()
        disableDarkMode()
        
        let parameters: GetMemberParameter = GetMemberParameter(groupId: groupId)
        getMembers(getMembersParameter: parameters)
        
        print("voteid: \(voteId)")
//        let parameter: GetVoteSummaryParameter = GetVoteSummaryParameter(groupId: groupId)
//        self.getVoteSummary(getVoteSummaryParameter: parameter)
        
//        let parameter: CreatedVoteParameter = CreatedVoteParameter(groupId: groupId)
//        self.createdVotes(getCreatedVotes: parameter)
        
        cashoutView.layer.cornerRadius = 10
        cashoutView.layer.shadowColor = UIColor.black.cgColor
        cashoutView.layer.shadowOffset = CGSize(width: 2, height: 4)
        cashoutView.layer.shadowRadius = 8
        cashoutView.layer.shadowOpacity = 0.2
        
        cashout = 1
        
        setupDropDowns()
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        
        
        if memberName == "" {
            destinationLabel.text = user?.displayName
        }else {
            memberName = "\(firstName) \(lastName)"
            destinationLabel.text = "\(memberName)"
        }
        
        self.destinationLabel.text = self.user?.displayName
        self.paymentInformationLabel.text = self.user?.phoneNumber

        print(campaignName.count)
        
//        self.selectPaymentMethodButton.titleLabel?.text = campaignName1st
//        self.campaignBalanceLabel.text = campaignBalance
//        campaignIdd = campaignId1st
    }
    
    override func viewWillAppear(_ animated: Bool) {
        

        
        print("member name: \(firstName) \(lastName)")
        
      if cashout == 2 {
        print("cashout is for a member now")
        self.destinationLabel.text = "\(firstName) \(lastName)"
        self.paymentInformationLabel.text = memberNumber
        self.cashoutDestinationNumber = memberNumber
        }
        
        if paymentInformationLabel.text == "No bank info available" {
            self.initiateButton.isEnabled = false
            self.initiateButton.backgroundColor = UIColor.gray
        }else {
            self.initiateButton.isEnabled = true
            self.initiateButton.backgroundColor = UIColor(red: 51/255, green: 54/255, blue: 65/255, alpha: 1)
        }
        
    }
    
    
    
    func setupDropDowns() {
        setupCashoutDropDown()
        setupPaymentDropDown()
        setupDestinationDropDown()
    }
    
    
    
    func setupCashoutDropDown(){
        campaignDropDown.anchorView = campaignOptionsDropDown
        
        campaignDropDown.bottomOffset = CGPoint(x: 0, y: campaignDropDown.bounds.height + 10)
        
        campaignBal = []
        campaignStatus = []
        
        for item in campaignNames {
            self.campaignName.append(item.campaignName)
            self.campaignId.append(item.campaignId ?? "")
            self.campaignStatus.append(item.status!)
            self.campaignBal.append(item.amountReceived!)
            print("campaign names: \(campaignName)")
            print("id: \(campaignId)")
            print("campaign balance: \(campaignBal)")
        }
        campaignDropDown.dataSource = campaignName
                
        
        //        Action triggered on selection
        campaignDropDown.selectionAction = { [weak self] (index, item) in
            print("Selected item: \(item) at \(index)")
            self!.selectCampaignButton.titleLabel?.text = item
            self?.campaignIdd = self!.campaignId[index]
            self?.status = self!.campaignStatus[index]
            self?.campBal = (self?.campaignBal[index])!
            self?.campName = self!.campaignName[index]
            print(self!.status)
            print(self!.campaignIdd)
            print(self!.campBal)
            print(self!.campName)
            
            self!.campaignBalanceLabel.isHidden = false
            //            self!.campaignBalances.isHidden = false
            
            if index == 0 {
                
                self!.campaignBalanceLabel.text = "\(self!.campaignBalance)"
            }else {
                self!.campaignBalanceLabel.text = "\(self!.campBal)"
                
            }
            
            
            self!.campaignDropDown.backgroundColor = UIColor.white
            self!.campaignDropDown.selectionBackgroundColor = UIColor.white
            
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
        
        
        paymentDropDown.bottomOffset = CGPoint(x: 0, y: paymentMethodDropDown.bounds.height + 10)
        
        
        paymentDropDown.dataSource = paymentMethod
        
        self.cashoutDestination = "wallet"
        self.cashoutDestinationNumber = (user?.phoneNumber)!
        cashoutDestinationNumber.removeFirst()
        print("first removed: \(cashoutDestinationNumber)")
        
        //        Action triggered on selection
        paymentDropDown.selectionAction = { [weak self] (index, item) in
            print("Selected item: \(item) at \(index)")
            self!.selectPaymentMethodButton.titleLabel?.text = item
            
            print(item)
            print(self!.selectPaymentMethodButton.titleLabel?.text)
            
            
            
            
            if item == "      Bank Account     " {
                
                self!.selectPaymentMethodButton.titleLabel?.text = "  Bank Account  "
                print(item)
                print(self!.selectPaymentMethodButton.titleLabel?.text)
                
                if self!.cashout == 1 {
                    //self bank account
                    self!.paymentInformationLabel.text = ""
                    self!.alert(message: "This user does not have any bank account setup.")
                    self!.cashoutDestination = "bank"
//                    self!.initiateButton.isEnabled = false
//                    self!.initiateButton.backgroundColor = UIColor.gray
                    
                }else if self!.cashout == 2 {
                    //Member
                    self!.paymentInformationLabel.text = ""
                    self!.alert(message: "This user does not have any bank account setup.")

                    self!.cashoutDestination = "bank"
//                    self!.initiateButton.isEnabled = false
//                    self!.initiateButton.backgroundColor = UIColor.gray

                }else if self!.cashout == 3 {
                //others
                    print("others and bank account")
                self!.walletBankTextField.isHidden = false
                self!.paymentInformationLabel.isHidden = true
                self!.walletBankTextField.placeholder = "Enter Bank Account"
                self!.cashoutDestination = "bank"
                    
                }

                
            }else if item == "      Mobile Wallet      " {
                
                self!.selectPaymentMethodButton.titleLabel?.text = "      Mobile Wallet      "
                
                
                if self!.cashout == 1 {
                    //self
                    self!.walletBankTextField.isHidden = true
                    self!.paymentInformationLabel.isHidden = false
                    
                    self!.memberName = "\(self!.firstName) \(self!.lastName)"
                    self!.destinationLabel.text = self!.user?.displayName
                    self!.paymentInformationLabel.text = (self!.user?.phoneNumber)!
                    self!.cashoutDestination = "wallet"
                    self!.destinationNumber = (self!.user?.phoneNumber)!
                    self!.initiateButton.isEnabled = true
                    self!.initiateButton.backgroundColor = UIColor(red: 51/255, green: 54/255, blue: 65/255, alpha: 1)
                    
                    
                }else if self!.cashout == 2 {
                    //Member
                    
                    print("this is members")
                self!.walletBankTextField.isHidden = true
                self!.paymentInformationLabel.isHidden = false
                    
                    self!.memberName = "\(self!.firstName) \(self!.lastName)"
                    self!.destinationLabel.text = self!.memberName
                    self!.cashoutDestination = "wallet"
                    self!.initiateButton.isEnabled = true
                    self!.initiateButton.backgroundColor = UIColor(red: 51/255, green: 54/255, blue: 65/255, alpha: 1)
                    
                }else if self!.cashout == 3 {
                    //other
                    
                    print("this is others and mobile wallet")
                self!.walletBankTextField.isHidden = false
                self!.paymentInformationLabel.isHidden = true
                self!.walletBankTextField.placeholder = "Enter Mobile Wallet"
                self!.cashoutDestination = "wallet"
                self!.initiateButton.isEnabled = true
                self!.initiateButton.backgroundColor = UIColor(red: 51/255, green: 54/255, blue: 65/255, alpha: 1)
                }

            }
            
            self!.paymentDropDown.backgroundColor = UIColor.white
            self!.paymentDropDown.selectionBackgroundColor = UIColor.white
            
        }
        
        
        paymentDropDown.width = 200
        
    }
    
    func alert(message: String){
    let alert = UIAlertController(title: "Cashout", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
        
    }
    alert.addAction(okAction)
    
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupDestinationDropDown(){
        destinationDropDown.anchorView = destinationOptionDropDown
        
        
        destinationDropDown.bottomOffset = CGPoint(x: 0, y: destinationOptionDropDown.bounds.height + 10)
        
        
        destinationDropDown.dataSource = destinationOptions
        
        
        //        Action triggered on selection
        destinationDropDown.selectionAction = { [weak self] (index, item) in
            print("Selected item: \(item) at \(index)")
            self!.selectDestinationButton.titleLabel?.text = item
            
            print(self!.destinationOptions)
            
            if item == "    Self    " {
                
               self!.cashout = 1
//            self!.selectDestinationButton.titleLabel?.text = item
                self!.destinationLabel.isHidden = false
                self!.destinationLabel.text = self!.user?.displayName
                self!.paymentInformationLabel.isHidden = false
                self!.walletBankTextField.isHidden = true
                self!.paymentInformationLabel.text = self!.user?.phoneNumber
                
                
            }else if item == "    Other    " {
                
                self!.cashout = 3
//                self!.selectDestinationButton.titleLabel?.text = item
                self!.walletBankTextField.isHidden = false
                self!.paymentInformationLabel.isHidden = true
                self!.walletBankTextField.placeholder = "Enter Mobile Wallet"
                self!.destinationLabel.text = ""
                //                self!.selectDesitnationButton.titleLabel?.text = item
                
            }else {
//                self!.selectDestinationButton.titleLabel?.text = item

                self!.cashout = 2
                self!.paymentInformationLabel.isHidden = false
                self!.walletBankTextField.isHidden = true
                self!.destinationLabel.text = "\(self!.firstName) \(self!.lastName)"
                self!.paymentInformationLabel.text = self!.memberNumber
                
                let vc: MemberSearchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "membersearch") as! MemberSearchViewController
                
                vc.members = self!.members
                vc.cashout = self!.cashout
                vc.firstName = self!.firstName
                vc.lastName = self!.lastName
                vc.memberNumber = self!.memberNumber
                vc.initiateCashoutVC = self
                
                self?.navigationController?.pushViewController(vc, animated: true)
                
            }
            
            self!.destinationDropDown.backgroundColor = UIColor.white
            self!.destinationDropDown.selectionBackgroundColor = UIColor.white
            
        }
        
        
        destinationDropDown.width = 200
        
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
        case .failure(let error):
            
            if result.response?.statusCode == 400 {
                
                baseTableSessionTimeout()
                
            }else {
            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Table view data source
    @IBAction func campaignDropDownAction(_ sender: UIButton) {
        campaignDropDown.show()

    }
    
    @IBAction func destinationDropDownAction(_ sender: UIButton) {
        destinationDropDown.show()

    }
    
    @IBAction func paymentMethodDropDownAction(_ sender: UIButton) {
        paymentDropDown.show()

    }
    
    
    @IBAction func initiateCashoutAction(_ sender: UIButton) {
        
        print(campaignIdd)
        print(cashoutDestinationNumber)
        print(groupId)
        print(cashoutDestination)
        
        if (amount.text!.isEmpty) || (reason.text!.isEmpty) {
            
            let alert = UIAlertController(title: "Cashout", message: "Please fill all empty fields. Amount and Reason cannot be empty.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            
        }else if (amount.text == "0") || (amount.text == "0.00") {
            
            let alert = UIAlertController(title: "Cashout", message: "Amount cannot be zero. Please enter a valid amount.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else if campName == "" {
            
            let alert = UIAlertController(title: "Cashout", message: "Please select a campaign.", preferredStyle: .alert)
            let okActioin = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okActioin)
            self.present(alert, animated: true, completion: nil)
            
        }else if (campaignBalance == "0.00") {
            
            let alert = UIAlertController(title: "Cashout", message: "Insufficient Funds.", preferredStyle: .alert)
            let okActioin = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okActioin)
            self.present(alert, animated: true, completion: nil)
        }else {
        if cashout == 1 {
            
            FTIndicator.showProgress(withMessage: "initiating cashout")
//            let parameter: InitiateCashoutParameter = InitiateCashoutParameter(amount: amount.text!, campaignId: campaignIdd, cashoutDestination: cashoutDestination, cashoutDestinationCode: "EBG", cashoutDestinationNumber: (user?.phoneNumber)! , groupId: groupId, network: "EBG", voteId: voteId, reason: reason.text!)
//            initiateCashout(initiateCashoutParameter: parameter)
        }else if cashout == 2 {
        
            FTIndicator.showProgress(withMessage: "initiating cashout")
//            let parameter: InitiateCashoutParameter = InitiateCashoutParameter(amount: amount.text!, campaignId: campaignIdd, cashoutDestination: cashoutDestination, cashoutDestinationCode: "EBG", cashoutDestinationNumber: cashoutDestinationNumber, groupId: groupId, network: network, voteId: voteId, reason: reason.text!)
//            initiateCashout(initiateCashoutParameter: parameter)
        }else {
            
            if (walletBankTextField.text!.isEmpty) {
                
                let alert = UIAlertController(title: "Cashout", message: "Please fill the empty field.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                
            }else {
                
                FTIndicator.showProgress(withMessage: "initiating cashout")
//            let parameter: InitiateCashoutParameter = InitiateCashoutParameter(amount: amount.text!, campaignId: campaignIdd, cashoutDestination: cashoutDestination, cashoutDestinationCode: "EBG", cashoutDestinationNumber: walletBankTextField.text! , groupId: groupId, network: "EBG", voteId: voteId, reason: reason.text!)
//            initiateCashout(initiateCashoutParameter: parameter)
                }
            
            }
        }
        
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
            
            baseTableSessionTimeout()
            
        }else {
        let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        }
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
//                    cashoutVotesRequired = item.minVoteCount
                    cashoutVotesCompleted = item.votesCompleted
                }
                
                self.percentageRequiredLabel.text = "The percentage of votes required to cashout is \(cashoutVotesRequired * 100)% of members"
            }
            
            
            break
        case .failure(let error):
            
            if result.response?.statusCode == 400 {
                
                baseTableSessionTimeout()
                
            }else {
            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
//    //GET VOTES
//    func createdVotes(getCreatedVotes: CreatedVoteParameter) {
//        AuthNetworkManager.createdVotes(parameter: getCreatedVotes) { (result) in
//            self.parseCreatedVotes(result: result)
//        }
//    }
//
//
//    private func parseCreatedVotes(result: DataResponse<CreatedVotesResponse>){
//        FTIndicator.dismissProgress()
//        switch result.result {
//        case .success(let response):
//            print("response: \(response)")
//
//            for item in response.votes {
//
//                if item.ballotId.ballot == "Cashout" {
//                    print(item.minVotes)
//
//                    cashoutVotesRequired = item.minVotes
//                }
//                self.percentageRequiredLabel.text = "The percentage of votes required to cashout is \(cashoutVotesRequired * 100)% of members"
//            }
//
//
//            break
//        case .failure(let error):
//
//            if result.response?.statusCode == 400 {
//
//                baseTableSessionTimeout()
//
//            }else {
//            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
//
//            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//            }
//
//            alert.addAction(okAction)
//
//            self.present(alert, animated: true, completion: nil)
//            }
//        }
//    }
    
    

}
