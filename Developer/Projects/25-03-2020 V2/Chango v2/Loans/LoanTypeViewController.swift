//
//  LoanTypeViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 19/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import DropDown
import FTIndicator
import Alamofire
import FirebaseAuth

class LoanTypeViewController: BaseViewController {

    @IBOutlet weak var selectType: UIButton!
    @IBOutlet weak var groupBalanceLabel: UILabel!
    @IBOutlet weak var campaignDropDown: UIButton!
    @IBOutlet weak var destinationButton: UIButton!
    @IBOutlet weak var amountTextField: ACFloatingTextfield!
    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var walletNumberLabel: UILabel!
    @IBOutlet weak var reasonTextField: ACFloatingTextfield!
    
    let dropDown = DropDown()
    let selectTypeDropDown = DropDown()
    let campaignsDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.selectTypeDropDown,
            self.campaignsDropDown
        ]
    }()
    
    var loanOptions: [String] = ["Member Loan", "Group Loan"]
    var campaignNames: [GetGroupCampaignsResponse] = []
    var campaignName: String = ""
    var campaigns: [String] = []
    var campaignBalance: String = ""
    var campBal: Double = 0.0
    var campaignBal: [Double] = [0.0]
    var destinationType: String = ""
    var amount: String = ""
    var campaignId: [String] = []
    var campaignStatus: [String] = []
    var status: String = ""
    var campaignIdd: String = ""
    var groupId: String = ""
    var voteId: String = ""
    var loanType: String = "Member Loan"
    var campaignBalances: [GroupBalance] = []
    var userNumber: String = ""
    var userId: String = ""
    var walletId: String = ""
    var walletName: String = ""
    var walletNumber: String = ""
    var currency: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        userNumber = Auth.auth().currentUser?.phoneNumber! as! String
        userId = Auth.auth().currentUser?.uid as! String

        setupDropDowns()
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        
        for i in 0 ..< campaignNames.count {
//            self.campaignId.append(item.campaignId[0])
            campaignName = campaignNames[0].campaignName
            campaignIdd = campaignNames[0].campaignId
            status = campaignNames[0].status!
            for item in campaignBalances {
                if item.campaignId == campaignIdd {
//                    campaignBalanceLabel.text = "\(item.balance)"
                    groupBalanceLabel.text = "\(currency)\(formatNumber(figure: Double(item.balance)))"
                }
        }
        print("campaign id: \(campaignIdd)")

        }

        campaignDropDown.setTitle("\(campaignName)", for: .normal)
        
        walletNameLabel.text = walletName
        walletNumberLabel.text = walletNumber
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true )
    }
    
    func setupDropDowns() {
//        setupLoanTypeDropDown()
//        setupCampaignDropDown()
    }
    
    func setupLoanTypeDropDown(){
        selectTypeDropDown.anchorView = selectType
        //        campaignDropDown.anchorView = dropDownButton
        
        selectTypeDropDown.bottomOffset = CGPoint(x: 0, y: selectType.bounds.height + 10)
        
//        for item in loanOptions {
//            self.loanType.append(item)
//        }
        selectTypeDropDown.dataSource = loanOptions
        
        
        //        Action triggered on selection
        selectTypeDropDown.selectionAction = { [weak self] (index, item) in
            print("Selected item: \(item) at \(index)")
            self!.selectType.titleLabel?.text = item
            self!.loanType = "\(self!.selectType)"
            
            self!.selectTypeDropDown.backgroundColor = UIColor.white
            self!.selectTypeDropDown.selectionBackgroundColor = UIColor.white
            
        }
        
        selectType.width = 200
        
    }
    
    
    func setupCampaignDropDown(){
        campaignsDropDown.anchorView = campaignDropDown
        //        campaignDropDown.anchorView = dropDownButton
        
        campaignsDropDown.bottomOffset = CGPoint(x: 0, y: campaignDropDown.bounds.height + 10)
        
        for item in campaignNames {
            self.campaigns.append(item.campaignName)
            self.campaignId.append(item.campaignId)
            self.campaignStatus.append(item.status!)
            print("id: \(campaignId)")
        }
        campaignsDropDown.dataSource = campaigns
        
        
        //        Action triggered on selection
        campaignsDropDown.selectionAction = { [weak self] (index, item) in
            print("Selected item: \(item) at \(index)")
            self!.campaignDropDown.titleLabel?.text = item
            self?.campaignIdd = self!.campaignId[index]
            self?.status = self!.campaignStatus[index]
//            self?.campBal = self!.campaignBal[index]
            print(self!.campaignIdd)
            
            if index == 0 {
                self!.campaignBalance = self!.campaignBalance
            }else {
                self!.campaignBalance = "\(self!.campBal)"
            }
            
            
            self!.campaignsDropDown.backgroundColor = UIColor.white
            self!.campaignsDropDown.selectionBackgroundColor = UIColor.white
            
            if self!.status == "stop" {
                let alert = UIAlertController(title: "Borrow", message: "This campaign has been stopped.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                alert.addAction(okAction)
                
                self!.present(alert, animated: true, completion: nil)
            }else if self!.status == "pause"{
                let alert = UIAlertController(title: "Borrow", message: "This campaign has been paused.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                alert.addAction(okAction)
                
                self!.present(alert, animated: true, completion: nil)
            }
            
        }
        campaignsDropDown.width = 200
        
    }
    
    

    @IBAction func nextButtonAction(_ sender: UIButton) {
//        let vc: RequestLoanViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "description") as! RequestLoanViewController
        let vc: LoanDestinationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "destination") as! LoanDestinationViewController
//        vc.amount = amount
//        vc.loanType = loanType
        vc.campaignId = campaignIdd
        vc.voteId = voteId
        vc.groupId = groupId
        vc.campaignBalance = campaignBalance
        vc.campaignBalances = campaignBalances
//        print(loanType)
        print(campaignIdd)
        print(campaignName)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func selectTypeButtonAction(_ sender: UIButton) {
//        selectDestination()

    }
    
    @IBAction func selectCampaignButtonAction(_ sender: UIButton) {
        selectCamapaign()
    }
    
    
    @IBAction func requestButtonAction(_ sender: Any) {
        if (amountTextField.text?.isEmpty)! || (reasonTextField.text?.isEmpty)! {
            showAlert(title: "Borrow", message: "All fields should be filled.")
        }else if (Int(amountTextField.text!) == 0){
            showAlert(title: "Borrow", message: "Amount cannot be zero. Please enter a valid amount.")
        }else {
            FTIndicator.showProgress(withMessage: "processing request")
//            let parameter: RequestLoanParameter = RequestLoanParameter(amount: amountTextField.text!, reason: reasonTextField.text!, campaignId: campaignIdd, groupId: groupId, memberId: userId, status: "1", voteId: voteId, cashoutDestination: destinationType, cashoutDestinationCode: "", cashoutDestinationNumber: userNumber)
//            requestLoan(requestLoanParameter: parameter)
            let parameter: InitiateLoanWithWalletParameter = InitiateLoanWithWalletParameter(amount: amountTextField.text!, campaignId: campaignIdd, groupId: groupId, memberId: userId, reason: reasonTextField.text!, status: "1", walletId: walletId)
            initateLoanWithWallet(initiateLoanParameter: parameter)
        }
    }
    
    
    func initateLoanWithWallet(initiateLoanParameter: InitiateLoanWithWalletParameter) {
        AuthNetworkManager.initiateLoanWithWallet(parameter: initiateLoanParameter) { (result) in
            self.parseInitiateLoanWithWallet(result: result)
        }
    }
    
    private func parseInitiateLoanWithWallet(result: DataResponse<InitiateLoanWithWalletResponse, AFError>){
        switch result.result {
        case .success(let response):
            FTIndicator.dismissProgress()
            if response.responseCode == "100" {
                showAlert(title: "Chango", message: response.responseMessage!)
            }else {
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
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
            }
            break
        case .failure(_):
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
    
    //REQUEST LOAN
        private func requestLoan(requestLoanParameter: RequestLoanParameter){
            AuthNetworkManager.requestLoan(parameter: requestLoanParameter) { (result) in
    //                        self.parseRequestLoanResponse(result: result)
                FTIndicator.dismissProgress()
                print("result: \(result)")
                
                if result.contains("400"){
                    
                    self.sessionTimeout()

                }else {

                    let alert = UIAlertController(title: "Chango", message: "\(result)", preferredStyle: .alert)
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
                }
                }
        }
    
    func selectCamapaign(){
        var alert = UIAlertController(title: "Choose Repeat Cycle", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        switch UIDevice.current.screenType {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
            let actionSheetController: UIAlertController = UIAlertController(title: "Select Campaign", message: "", preferredStyle: .actionSheet)
            for item in campaignNames {
                actionSheetController.addAction(title: item.campaignName, style: .default, handler: {(action) in
                    self.campaignName = item.campaignName
                    self.campaignIdd = item.campaignId
                    self.campaignDropDown.setTitle(item.campaignName, for: .normal)
                    for item in self.campaignBalances {
                        if item.campaignId == self.campaignIdd {
                            print("id: \(item.campaignId) =  \(item.balance)")
                            self.groupBalanceLabel.text = "\(self.currency)\(formatNumber(figure: Double(item.balance)))"
                        }
                }
                })
            }
            actionSheetController.addAction(title: "Cancel", style: .cancel)
            self.present(actionSheetController, animated: true, completion: nil)
            break
        default:
            alert = UIAlertController(title: "Select Campaign", message: "", preferredStyle: UIAlertController.Style.alert)
            for item in campaignNames {
                alert.addAction(title: item.campaignName, style: .default, handler: {(action) in
                    self.campaignName = item.campaignName
                    self.campaignIdd = item.campaignId
                    self.campaignDropDown.setTitle(item.campaignName, for: .normal)
                    for item in self.campaignBalances {
                        if item.campaignId == self.campaignIdd {
                            print("id: \(item.campaignId) = \(item.balance)")
                            self.groupBalanceLabel.text = "\(self.currency)\(formatNumber(figure: Double(item.balance)))"
                        }
                }
                })
            }
            self.present(alert, animated: true, completion: nil)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
    }

    
    func selectDestination() {
        var alert = UIAlertController(title: "Choose Destination", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        switch UIDevice.current.screenType {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
            let actionSheetController: UIAlertController = UIAlertController(title: "Choose Destination", message: "", preferredStyle: .actionSheet)
            //Create and add the "Cancel" action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
                print("you cancelled")
            }
            let mobileWallet: UIAlertAction = UIAlertAction(title: "Mobile Wallet", style: .default) { action -> Void in
                self.destinationType = "wallet"
                self.destinationButton.setTitle("Mobile Wallet", for: .normal)
            }
            let bankAccount: UIAlertAction = UIAlertAction(title: "Bank Account", style: .default) { action -> Void in
                self.destinationType = "bank"
                self.destinationButton.setTitle("Bank Account", for: .normal)
            }

            actionSheetController.addAction(mobileWallet)
//            actionSheetController.addAction(bankAccount)
            actionSheetController.addAction(cancelAction)
            self.present(actionSheetController, animated: true, completion: nil)
            break
        default:
            alert = UIAlertController(title: "Choose Destination", message: "", preferredStyle: UIAlertController.Style.alert)
            //Create and add the "Cancel" action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
                print("you cancelled")
            }
            let mobileWallet: UIAlertAction = UIAlertAction(title: "Mobile Wallet", style: .default) { action -> Void in
                self.destinationType = "wallet"
                self.destinationButton.setTitle("Mobile Wallet", for: .normal)
            }
            let bankAccount: UIAlertAction = UIAlertAction(title: "Bank Account", style: .default) { action -> Void in
                self.destinationType = "bank"
                self.destinationButton.setTitle("Bank Account", for: .normal)
            }

            alert.addAction(mobileWallet)
//            alert.addAction(bankAccount)
            alert.addAction(cancelAction)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
