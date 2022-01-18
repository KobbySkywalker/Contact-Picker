//
//  WalletsVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 23/03/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import PopupDialog
import FirebaseAuth
import LocalAuthentication
import ESPullToRefresh

class WalletsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var addWalletMain: UIButton!
    @IBOutlet weak var addWalletButtoon: UIButton!
    @IBOutlet weak var walletLabel: UILabel!
    var easySlideNavigationController: ESNavigationController?

    var campaignId: String = ""
    var groupId: String = ""
    var voteId: String = ""
    var network: String = ""
    var groupNamed: String = ""
    var currency: String = ""
    var campaignExpiry: String = ""
    var maxSingleContributionLimit: Double = 0.0
    var contribution: Bool = false
    var groupIconPath: String = ""
    var publicGroupCheck: Int = 0
    var walletId: String = ""
    var transactionType: Int = 0
    var countryId: String = ""
    //cashout
    var cashoutAmount: String = ""
    var reason: String = ""
    var forSelf: Int = 0
    var paymentOption: String = ""
    var recipientName: String = ""
    var contributionParameters: ContributeParameters!
    //borrow
    var borrowCheck: Bool = false
    var campaignNames: [GetGroupCampaignsResponse] = []
    var campaignBalance: String = ""
    var cashoutCampaigns: [GetGroupCampaignsResponse] = []
    var campaigns: [GetGroupCampaignsResponse] = []
    var campaignBalances: [GroupBalance] = []
    
//    var availableWallets: [String] = ["MTN Mobile Money", "FBN Card", "Bank Account"]
    var availableWallets: [GetPaymentMethodsResponse] = []
    var groupColorWays: [String] = ["#F14439", "#F8B52A", "#228CC7", "#034371"]

    let cell = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        disableDarkMode()
        showChatController()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        if contribution == true {
            self.tableView.register(UINib(nibName: "GroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupsTableViewCell")
        }else {
        self.tableView.register(UINib(nibName: "WalletCell", bundle: nil), forCellReuseIdentifier: "WalletCell")
        }
        
        if (contribution == true) {
            walletLabel.text = "Select wallet to contribute from"
        }else if transactionType == 1 {
            walletLabel.text = "Select cashout destination"
        }
        
        getPaymentMethods()
        
        self.tableView.es.addPullToRefresh {
            [unowned self] in
            getPaymentMethods()
            self.tableView.es.stopPullToRefresh()
            self.tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getPaymentMethods()
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addWalletBtn(_ sender: UIButton) {
        let vc: WalletOptionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "walletoptions") as! WalletOptionsVC
        if contribution == true {
//        vc.fromWalletView = false
//        vc.contributeParameters = ContributeParameters(campaignId: campaignId, groupId: groupId, voteId: voteId, network: network, groupName: groupNamed, currency: currency, campaignExpiry: campaignExpiry, maxSingleContributionLimit: maxSingleContributionLimit, groupIconPath: groupIconPath, walletNumber: "", walletId: "", publicGroupCheck: 0)
            navigateUserToWalletView()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func addWalletBtnAction(_ sender: UIBarButtonItem) {
        let vc: WalletOptionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "walletoptions") as! WalletOptionsVC
        if contribution == true {
        vc.fromWalletView = false
        vc.contributeParameters = ContributeParameters(campaignId: campaignId, groupId: groupId, voteId: voteId, network: network, groupName: groupNamed, currency: currency, campaignExpiry: campaignExpiry, maxSingleContributionLimit: maxSingleContributionLimit, groupIconPath: groupIconPath, walletNumber: "", walletId: "", publicGroupCheck: 0)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateUserToWalletView(){
        let alert = UIAlertController(title: "Chango", message: "To Add a new wallet, select My Wallets option from Settings.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Go to Settings", style: .default) { (action: UIAlertAction!) in
            let vc2: SettingsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersettings") as! SettingsVC
            vc2.allGroups = allGroups
            vc2.movedFromWallet = true
            self.navigationController?.pushViewController(vc2, animated: true)
        }
        let cancelAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(availableWallets.count)")
        return availableWallets.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if contribution == true {
            return 99.0
        }else {
        return 120.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wallet = availableWallets[indexPath.row]
        
        if contribution == true {
            let cell: GroupsTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
            cell.selectionStyle = .none
            
            cell.memberCampaignCount.isHidden = true
            cell.groupType.isHidden = true
            if (availableWallets[indexPath.row].channelId == "WALLET") || (availableWallets[indexPath.row].channelId == "wallet") {
                cell.groupsImage.contentMode = .scaleAspectFit
                if availableWallets[indexPath.row].destinationCode! == "MTN" {
                    cell.groupsImage.image = UIImage(named: "mtn_airtime")
                    cell.groupsImage.backgroundColor = UIColor(hexString: "#F3C743")
                    cell.groupsName.text = "MTN Mobile Money"
                }else if availableWallets[indexPath.row].destinationCode! == "VODAFONE" {
                    cell.groupsImage.image = UIImage(named: "vodafoneicon")
                    cell.groupsImage.backgroundColor = UIColor(hexString: "#DB483C")
                    cell.groupsName.text = "Vodafone Cash"
                }else {
                    cell.groupsImage.image = UIImage(named: "airteltigoicon")
                    cell.groupsImage.backgroundColor = UIColor(hexString: "#315284")
                    cell.groupsName.text = "AirtelTigo Cash"
                }
                cell.memerCampaignLabel.text = "Mobile"
            }else if (availableWallets[indexPath.row].channelId == "bank") || (availableWallets[indexPath.row].channelId == "BANK") {
                cell.groupsImage.image = UIImage(named: "banksicon")
                cell.memerCampaignLabel.text = wallet.destinationCode
                
                if availableWallets[indexPath.row].nickName == "nil" || availableWallets[indexPath.row].nickName == nil {
                    cell.groupsName.text = availableWallets[indexPath.row].destinationCode
                    
                }else {
                    cell.groupsName.text = availableWallets[indexPath.row].nickName
                }
            }else {
                cell.groupsImage.image = UIImage(named: "cardsicon")
                cell.groupsDate.isHidden = true
                if availableWallets[indexPath.row].verified == true {
                cell.memerCampaignLabel.text = "Verified"
                }else {
                    cell.memerCampaignLabel.text = "Unverified"
                }
                if availableWallets[indexPath.row].nickName == "nil" || availableWallets[indexPath.row].nickName == nil {
                    cell.groupsName.text = availableWallets[indexPath.row].destinationCode
                    
                }else {
                    cell.groupsName.text = availableWallets[indexPath.row].nickName
                }
                
            }
            
            var destinationString = availableWallets[indexPath.row].paymentDestinationNumber
            
            let start = destinationString!.index(destinationString!.startIndex, offsetBy: 0);
            let end = destinationString!.index(destinationString!.endIndex, offsetBy: -4);
            destinationString!.replaceSubrange(start..<end, with: "xxxxxxxx")
            
            cell.groupsDate.text = destinationString
            cell.rectangularView.backgroundColor = UIColor(hexString: groupColorWays[indexPath.row % groupColorWays.count])
            
            return cell
            
        }else {
            let cell: WalletCell = self.tableView.dequeueReusableCell(withIdentifier: "WalletCell", for: indexPath) as! WalletCell
            cell.selectionStyle = .none
            
            cell.infoButton.setImage(UIImage(named: "info"), for: .normal)
            cell.backgroundImage.contentMode = .center
            if (availableWallets[indexPath.row].channelId == "WALLET") {
                cell.backgroundImage.contentMode = .scaleAspectFit
                if availableWallets[indexPath.row].destinationCode == "MTN" {
                    cell.backgroundImage.image = UIImage(named: "mtn_airtime")
//                    cell.backgroundImage.backgroundColor = UIColor(hexString: "#F3C743")
                    cell.walletName.text = "MTN Mobile Money"
                }else if availableWallets[indexPath.row].destinationCode! == "VODAFONE" {
                    cell.walletName.text = "Vodafone Cash"
                    cell.backgroundImage.image = UIImage(named: "vodafoneicon")
                }else {
                    cell.walletName.text = "AirtelTigo Cash"
                    cell.backgroundImage.image = UIImage(named: "airteltigoicon")
                }
                cell.verifiedCardLabel.text = "Mobile"

            }else if (availableWallets[indexPath.row].channelId == "BANK") {
                cell.backgroundImage.image = UIImage(named: "bankicon")
                cell.verifiedCardLabel.text = wallet.destinationCode
                if availableWallets[indexPath.row].nickName == "nil" || availableWallets[indexPath.row].nickName == nil {
                    cell.walletName.text = availableWallets[indexPath.row].destinationCode
                }else {
                    cell.walletName.text = availableWallets[indexPath.row].nickName
                }
            }else {
                cell.backgroundImage.image = UIImage(named: "cardicon")
                cell.walletNumber.isHidden = true
                cell.verifiedCardLabel.text = "Card"
                
                if availableWallets[indexPath.row].verified == true {
                    cell.infoButton.setImage(UIImage(named: "verifiedicon"), for: .normal)
                }else {
                    cell.infoButton.setImage(UIImage(named: "unverified"), for: .normal)
                }

            if availableWallets[indexPath.row].nickName == "nil" || availableWallets[indexPath.row].nickName == nil {
                    cell.walletName.text = availableWallets[indexPath.row].destinationCode
                    
                }else {
                    cell.walletName.text = availableWallets[indexPath.row].nickName
                }

                
            }
            
            var destinationString = availableWallets[indexPath.row].paymentDestinationNumber
            
            let start = destinationString!.index(destinationString!.startIndex, offsetBy: 0);
            let end = destinationString!.index(destinationString!.endIndex, offsetBy: -4);
            destinationString!.replaceSubrange(start..<end, with: "xxxxxxxx")
            
            cell.walletNumber.text = destinationString
            cell.walletOptions.addTarget(self, action: #selector(walletActionOptions(button:)), for: .touchUpInside)
            cell.walletOptions.tag = indexPath.row
            cell.rectanglularView.backgroundColor = UIColor(hexString: groupColorWays[indexPath.row % groupColorWays.count])
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wallet = availableWallets[indexPath.row]

        if contribution == true {

            let vc: ContributeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contribute") as! ContributeViewController

            vc.campaignId = campaignId
            vc.groupId = groupId
            vc.voteId = voteId
            vc.network = network
            vc.groupNamed = groupNamed
            vc.currency = currency
            vc.campaignExpiry = campaignExpiry
            vc.maxSingleContributionLimit = maxSingleContributionLimit
            vc.currency = currency
            vc.countryId = countryId
            vc.groupIconPath = groupIconPath
            vc.walletNumber = wallet.paymentDestinationNumber!
            vc.walletId = wallet.walletId!
            vc.publicGroupCheck = publicGroupCheck
            if (wallet.channelId == "card" || wallet.channelId == "CARD") {
            vc.cardCheck = true
                }
            
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        } else if transactionType == 1 {
            var destinationString = wallet.paymentDestinationNumber

            let start = destinationString!.index(destinationString!.startIndex, offsetBy: 0);
            let end = destinationString!.index(destinationString!.endIndex, offsetBy: -4);
            destinationString!.replaceSubrange(start..<end, with: "xxxxxxxx")
            if borrowCheck {
                let vc: LoanTypeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loantype") as! LoanTypeViewController
                vc.groupId = groupId
                vc.voteId = voteId
                print("vid: \(voteId)")
                vc.campaignNames = campaignNames
                vc.campaignBalance = campaignBalance
                vc.campaignBalances = campaignBalances
                vc.walletId = wallet.walletId!
                if wallet.nickName == "" {
                    if (availableWallets[indexPath.row].channelId == "WALLET") {
                        if availableWallets[indexPath.row].destinationCode == "MTN" {
                            vc.walletName = "MTN Mobile Money"
                        }else if availableWallets[indexPath.row].destinationCode! == "VODAFONE" {
                            vc.walletName = "Vodafone Cash"
                        }else {
                            vc.walletName = "AirtelTigo Cash"
                        }
                    }
                }else {
                    vc.walletName = wallet.nickName!
                }
                vc.walletNumber = destinationString!
                vc.currency = currency
                print(campaignBalance)
                print(cashoutCampaigns)
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
            let vc: CashoutSummaryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cashoutsummary") as! CashoutSummaryVC
            

            vc.maskedWallet = destinationString!
            
            vc.groupId = self.groupId
            vc.campaignId = self.campaignId
            vc.voteId = self.voteId
            vc.network = self.network
            vc.reason = reason
            vc.amount = cashoutAmount
            vc.recipientName = recipientName
            vc.forSelf = 1
            vc.recipientNumber = wallet.paymentDestinationNumber!
            vc.paymentOption = (wallet.channelId?.lowercased())!
            vc.bankName = wallet.destinationCode!
            vc.cashoutDestinationCode = wallet.destinationCode!
            vc.nameOnWallet = wallet.nickName ?? ""
                print("code: \(availableWallets[indexPath.row].destinationCode)")
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            if (availableWallets[indexPath.row].channelId == "card") || (availableWallets[indexPath.row].channelId == "CARD") {
                walletActionOptionsOnDidSelect(walletId: wallet.walletId!, card: true, status: wallet.status!, nickName: wallet.nickName!, paymentWallet: availableWallets[indexPath.row])
            }else {
                walletActionOptionsOnDidSelect(walletId: wallet.walletId!, card: false, status: wallet.status!, nickName: wallet.nickName!, paymentWallet: availableWallets[indexPath.row])
            }
        }
    }
    
    func deleteWalletCautionAlert(walletId: String){
        let alert = UIAlertController(title: "Remove Wallet", message: "Are you sure you want to remove this wallet?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action: UIAlertAction!) in
            //delete Wallet call
            let parameter: DeleteWalletParameter = DeleteWalletParameter(walletId: walletId)
            self.deleteWallet(deleteWalletParameter: parameter)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action: UIAlertAction!) in
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func walletActionOptions(button: UIButton){
        walletId = availableWallets[button.tag].walletId!
        let nickName = availableWallets[button.tag].nickName
        let status = availableWallets[button.tag].status
        let verified = availableWallets[button.tag].verified
        let verificationAmount = availableWallets[button.tag].verificationAmount
        let verificationAttempts = availableWallets[button.tag].verificationAttempts
        let verificationDate = availableWallets[button.tag].verificationInitiationDate
        print("walletId: \(walletId)")
        var alert = UIAlertController(title: "Wallet Options", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        switch UIDevice.current.screenType {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
            let actionSheetController: UIAlertController = UIAlertController(title: "Wallet Options", message: "", preferredStyle: .actionSheet)
            
            //Create and add the "Cancel" action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
                print("you cancelled")
                
            }
            let verifyCard: UIAlertAction = UIAlertAction(title: "Verify Card", style: .default) { action -> Void in
                print("you just chose delete")
                //display card verification view
                if status == "PENDING_CONFIRMATION" {
                    let vc: VerifyCardAmountVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verifyamount") as! VerifyCardAmountVC
                    vc.walletId = self.walletId
                    vc.paymentCheck = true
                    vc.nickName = nickName ?? ""
                    vc.verificationAttempts = verificationAttempts ?? 0
                    if verificationDate == nil {
                        
                    }else {
                    vc.verificationInitiationDate = dateConversionWithMilliSeconds(dateValue: verificationDate ?? "")
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                let vc: VerifyCardVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verifycard") as! VerifyCardVC
                vc.walletId = self.walletId
                vc.cardHolderName = nickName ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            let deleteWallet: UIAlertAction = UIAlertAction(title: "Remove Wallet", style: .default) { [self] action -> Void in
                print("you just chose delete")
                //display delete caution in button
                self.deleteWalletCautionAlert(walletId: self.walletId)
            }
            if (availableWallets[button.tag].channelId == "CARD") && verified == false {
                actionSheetController.addAction(verifyCard)
            }
            actionSheetController.addAction(deleteWallet)
            actionSheetController.addAction(cancelAction)
            self.present(actionSheetController, animated: true, completion: nil)
            
            break
        default:
            alert = UIAlertController(title: "Wallet Options", message: "", preferredStyle: UIAlertController.Style.alert)
            
            //Create and add the "Cancel" action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
                print("you cancelled")
                
            }
            let verifyCard: UIAlertAction = UIAlertAction(title: "Verify Card", style: .default) { action -> Void in
                print("you just chose delete")
                //display card verification view
                if status == "PENDING_CONFIRMATION" {
                    let vc: VerifyCardAmountVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verifyamount") as! VerifyCardAmountVC
                    vc.walletId = self.walletId
                    vc.paymentCheck = true
                    vc.nickName = nickName ?? ""
                    vc.verificationAttempts = verificationAttempts ?? 0
                    if verificationDate == nil {
                        
                    }else {
                    vc.verificationInitiationDate = dateConversionWithMilliSeconds(dateValue: verificationDate ?? "")
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                let vc: VerifyCardVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verifycard") as! VerifyCardVC
                vc.walletId = self.walletId
                vc.cardHolderName = nickName ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            let deleteWallet: UIAlertAction = UIAlertAction(title: "Remove Wallet", style: .default) { action -> Void in
                print("you just chose delete")
                //display delete caution in button
                self.deleteWalletCautionAlert(walletId: self.walletId)
            }
            if (availableWallets[button.tag].channelId == "CARD") && verified == false {
                alert.addAction(verifyCard)
            }
            alert.addAction(deleteWallet)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func walletActionOptionsOnDidSelect(walletId: String, card: Bool, status: String, nickName: String, paymentWallet: GetPaymentMethodsResponse){
        print("walletId: \(walletId)")
        print("date: \(paymentWallet.verificationInitiationDate)")
        var alert = UIAlertController(title: "Wallet Options", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        switch UIDevice.current.screenType {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
            let actionSheetController: UIAlertController = UIAlertController(title: "Wallet Options", message: "", preferredStyle: .actionSheet)
            
            //Create and add the "Cancel" action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
                print("you cancelled")
                
            }
            let verifyCard: UIAlertAction = UIAlertAction(title: "Verify Card", style: .default) { action -> Void in
                print("you just chose delete")
                //display card verification view
                if status == "PENDING_CONFIRMATION" {
                    let vc: VerifyCardAmountVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verifyamount") as! VerifyCardAmountVC
                    vc.walletId = paymentWallet.walletId!
                    vc.paymentCheck = true
                    vc.nickName = paymentWallet.nickName!
                    vc.verificationAttempts = paymentWallet.verificationAttempts ?? 0
                    if paymentWallet.verificationInitiationDate == nil {
                        
                    }else {
                    vc.verificationInitiationDate = dateConversionWithMilliSeconds(dateValue: paymentWallet.verificationInitiationDate ?? "")
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    let vc: VerifyCardVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verifycard") as! VerifyCardVC
                    vc.walletId = walletId
                    vc.cardHolderName = nickName
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            let deleteWallet: UIAlertAction = UIAlertAction(title: "Remove Wallet", style: .default) { [self] action -> Void in
                print("you just chose delete")
                //display delete caution in button
                self.deleteWalletCautionAlert(walletId: paymentWallet.walletId!)
            }
            if card && paymentWallet.verified == false {
                actionSheetController.addAction(verifyCard)
            }
            actionSheetController.addAction(deleteWallet)
            actionSheetController.addAction(cancelAction)
            self.present(actionSheetController, animated: true, completion: nil)
            
            break
        default:
            alert = UIAlertController(title: "Wallet Options", message: "", preferredStyle: UIAlertController.Style.alert)
            
            //Create and add the "Cancel" action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
                print("you cancelled")
                
            }
            let verifyCard: UIAlertAction = UIAlertAction(title: "Verify Card", style: .default) { action -> Void in
                print("you just chose delete")
                //display card verification view
                if status == "PENDING_CONFIRMATION" {
                    let vc: VerifyCardAmountVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verifyamount") as! VerifyCardAmountVC
                    vc.walletId = paymentWallet.walletId!
                    vc.paymentCheck = true
                    vc.nickName = paymentWallet.nickName!
                    vc.verificationAttempts = paymentWallet.verificationAttempts ?? 0
                    if paymentWallet.verificationInitiationDate == nil {
                        
                    }else {
                    vc.verificationInitiationDate = dateConversionWithMilliSeconds(dateValue: paymentWallet.verificationInitiationDate ?? "")
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                let vc: VerifyCardVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verifycard") as! VerifyCardVC
                vc.walletId = walletId
                vc.cardHolderName = nickName
                self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            let deleteWallet: UIAlertAction = UIAlertAction(title: "Remove Wallet", style: .default) { action -> Void in
                print("you just chose delete")
                //display delete caution in button
                self.deleteWalletCautionAlert(walletId: paymentWallet.walletId!)
            }
            if card && paymentWallet.verified == false{
                alert.addAction(verifyCard)
            }
            alert.addAction(deleteWallet)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func deleteWallet(deleteWalletParameter: DeleteWalletParameter) {
        AuthNetworkManager.deleteWallet(parameter: deleteWalletParameter) { (result) in
            self.parseDeleteWallet(result: result)
        }
    }
    
    private func parseDeleteWallet(result: DataResponse<RegularResponse, AFError>){
        switch result.result {
        case .success(let response):

            let alert = UIAlertController(title: "Remove Wallet", message: response.responseMessage, preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                self.getPaymentMethods()
            }
            alert.addAction(okAction)

            self.present(alert, animated: true, completion: nil)
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
    
    //GET PAYMENT METHODS
    func getPaymentMethods() {
        AuthNetworkManager.getPaymentMethods { (result) in
            self.parseGetPaymentMethods(result: result)
        }
    }
    
    private func parseGetPaymentMethods(result: DataResponse<[GetPaymentMethodsResponse], AFError>){
        switch result.result {
        case .success(let response):
            FTIndicator.dismissProgress()
            print("response: \(response)")
            availableWallets = []
            for item in response {
                if transactionType == 1 {
                    print("trannsaction")
                    if !(item.channelId! == "card"){
                        if !(item.channelId! == "CARD"){
                        print("dont show cards")
                        availableWallets.append(item)
                        }
                    }
                }else if contribution {
                    print("contribution")
                    if (item.channelId! != "bank") {
                        if (item.channelId! != "BANK") {
                        availableWallets.append(item)
                        }
                    }
                }else {
                    print("came here too")
                    availableWallets.append(item)
                }
            }
            print("avaialable wallets 1: \(availableWallets.count)")

            if availableWallets.count <= 0 {
                print("avaialable wallets: \(availableWallets.count)")
                emptyView.isHidden = false
            }
            self.availableWallets = availableWallets.sorted(by: {$0.created > $1.created})
            
            self.tableView.reloadData()
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
}
