//
//  ConfirmVoteVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 22/12/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import PopupDialog
import FTIndicator
import Alamofire

class ConfirmVoteVC: BaseViewController {

    
    @IBOutlet weak var voteYesButton: UIButton!
    @IBOutlet weak var voteNoButton: UIButton!
    
    var privateGroup: PrivateResponse!
    var groupId: String = ""
    var groupName: String = ""
    var voteId: String = ""
    var voteType: String = ""
    var name: String = ""
    var memberId: String = ""
    
    var amount: String = ""
    var campaignName: String = ""
    var campaignBalance: String = ""
    var campaignId: String = ""
    var memberNetwork: String = ""
    var destination: String = ""
    var destinationNumber: String = ""
    var currency: String = ""
    var destinationCode: String = ""
    
    var reason: String = ""
    
    var voteSelected: String = ""
    var dateString: String = ""
    
    var admin: Int = 0
    var approver: Int = 0
    var drop: Int = 0
    var loan: Int = 0
    var cashout: Int = 0
    var makeAdmin: Int = 0
    var makeApprover: Int = 0
    var loanVotesCompleted: Int = 0
    var loanVotesRemaining: Int = 0
    
    
    @IBOutlet weak var voteDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        disableDarkMode()
        showChatController()
        
        if voteType == "makeadmin"{
            voteDescriptionLabel.text = "Cast Vote"
            self.navigationItem.title = "Make \(name) Admin"
        }else if voteType == "makeapprover"{
            voteDescriptionLabel.text = "Make \(name) Approver"
        }else if voteType == "revokeadmin"{
            voteDescriptionLabel.text = "Revoke \(name) as Admin"
        }else if voteType == "revokeapprover"{
            voteDescriptionLabel.text = "Revoke \(name) as Approver"
        }else if voteType == "dropmember"{
            voteDescriptionLabel.text = "Remove \(name) from the group"
        }else if voteType == "cashout"{
            voteDescriptionLabel.text = "Approve \(name)'s cashout request of \(currency)\(amount) to number \(destinationNumber)"
        }else if voteType == "loan"{
            voteDescriptionLabel.text = "Approve \(name)'s borrowing request of \(currency)\(amount) to number \(destinationNumber)"
        }
        
        var new = Date()
        var day = ""
        var month = ""
        
        //MONTH
        //            var month = ""
        var monthValue = new.month
        if(monthValue < 10){
            month = "0\(monthValue)"
        }else{
            month = "\(monthValue)"
        }
        
        //DAY
        var dayValue = new.day
        if(dayValue < 10){
            day = "0\(dayValue)"
        }else{
            day = "\(dayValue)"
        }
        
        let year = new.year
         dateString = "\(year)-\(month)-\(day)"
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func yesVoteActionButton(_ sender: Any) {
        voteSelected = "yes"
        voteYesButton.setImage(UIImage(named: "yesvotecheckicon"), for: .normal)
        voteNoButton.setImage(UIImage(named: "voteno"), for: .normal)
    }
    
    @IBAction func noVoteActionButton(_ sender: Any) {
        voteSelected = "no"
        voteNoButton.setImage(UIImage(named: "novotecheckicon"), for: .normal)
        voteYesButton.setImage(UIImage(named: "yesvote"), for: .normal)
                print("no button")

    }
    
    @IBAction func confirmVoteButtonAction(_ sender: Any) {
        
        if voteSelected == "yes" {
            if self.voteType == "makeadmin" {
                FTIndicator.showProgress(withMessage: "voting")
                let parameterr: ExecuteMakeAdminParameter = ExecuteMakeAdminParameter(status: "1", voteId: self.voteId)
                self.executeMakeAdmin(executeMakeAdminParameter: parameterr)
            }else if self.voteType == "makeapprover"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: MakeLoanApproverParameter = MakeLoanApproverParameter(groupId: groupId, memberId: memberId, status: "1")
                self.makeLoanApprover(makeLoanApproverParameter: parameter)
            }else if self.voteType == "dropmember"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: DropMemberParameter = DropMemberParameter(voteId: voteId, status: "1")
                self.dropMember(dropMemberParameter: parameter)
            }else if self.voteType == "revokeapprover"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: ExecuteRevokeApproverParameter = ExecuteRevokeApproverParameter(status: "1", voteId: self.voteId)
                self.executeRevokeApprvoer(executeRevokeApproverParameter: parameter)
            }else if self.voteType == "revokeadmin"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: ExecuteRevokeAdminParameter = ExecuteRevokeAdminParameter(status: "1", voteId: self.voteId)
                self.executeRevokeAdmin(executeRevokeAdminParameter: parameter)
            }else if self.voteType == "loan" {
//                let parameter: GrantLoanParameter = GrantLoanParameter(amount: self.amount, cashoutDestination: self.destination, cashoutDestinationCode: "", cashoutDestinationNumber: self.destinationNumber, campaignId: self.campaignId, groupId: self.groupId, memberId: self.memberId, reason: self.reason, status: "1", voteId: self.voteId)
//
//                self.grantLoan(grantLoanParameter: parameter)
                
                let parameter: ExecuteLoanParameter = ExecuteLoanParameter(campaignId: self.campaignId, status: "1", voteId: self.voteId)
                self.executeLoan(executeLoanParameter: parameter)
                
                FTIndicator.showProgress(withMessage: "voting")
            }else if self.voteType == "cashout" {
                let parameter : CashoutVoteParameter = CashoutVoteParameter(campaignId: campaignId, status: "1", voteId: voteId)
                
                self.cashout(cashoutVoteParameter: parameter)
                FTIndicator.showProgress(withMessage: "voting")
            }
        }else if voteSelected == "no" {
            if self.voteType == "makeadmin" {
                FTIndicator.showProgress(withMessage: "voting")
                let parameterr: ExecuteMakeAdminParameter = ExecuteMakeAdminParameter(status: "0", voteId: self.voteId)
                self.executeMakeAdmin(executeMakeAdminParameter: parameterr)
            }else if self.voteType == "makeapprover"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: MakeLoanApproverParameter = MakeLoanApproverParameter(groupId: groupId, memberId: memberId, status: "0")
                self.makeLoanApprover(makeLoanApproverParameter: parameter)
            }else if self.voteType == "dropmember"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: DropMemberParameter = DropMemberParameter(voteId: voteId, status: "0")
                self.dropMember(dropMemberParameter: parameter)
            }else if self.voteType == "revokeapprover"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: ExecuteRevokeApproverParameter = ExecuteRevokeApproverParameter(status: "0", voteId: self.voteId)
                self.executeRevokeApprvoer(executeRevokeApproverParameter: parameter)
            }else if self.voteType == "revokeadmin"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: ExecuteRevokeAdminParameter = ExecuteRevokeAdminParameter(status: "0", voteId: self.voteId)
                self.executeRevokeAdmin(executeRevokeAdminParameter: parameter)
            }else if self.voteType == "loan" {
//                let parameter: GrantLoanParameter = GrantLoanParameter(amount: self.amount, cashoutDestination: self.destination, cashoutDestinationCode: "", cashoutDestinationNumber: self.destinationNumber, campaignId: self.campaignId, groupId: self.groupId, memberId: self.memberId, reason: self.reason, status: "0", voteId: self.voteId)
//
//                self.grantLoan(grantLoanParameter: parameter)
                let parameter: ExecuteLoanParameter = ExecuteLoanParameter(campaignId: self.campaignId, status: "0", voteId: self.voteId)
                self.executeLoan(executeLoanParameter: parameter)
                FTIndicator.showProgress(withMessage: "voting")
            }else if self.voteType == "cashout" {
                let parameter : CashoutVoteParameter = CashoutVoteParameter(campaignId: campaignId, status: "0", voteId: voteId)
                
                self.cashout(cashoutVoteParameter: parameter)
                FTIndicator.showProgress(withMessage: "voting")
            }
        }else if voteSelected == "" {
            showAlert(title: "Chango", message: "Please select an option before confirming vote.")
        }
    }
    
    func showCashoutVoteNo(animated: Bool = true, amount: String, campaignId: String, cashoutDestination: String, cashoutDestinationCode: String, cashoutDestinationNumber: String, decisionDate: String, groupId: String, memberId: String, invoiceId: String, narration: String, network: String, status: String, voteId: String) {
        
        //create a custom view controller
        let voteVC = VoteOptionDialogViewController(nibName: "VoteOptionDialogViewController", bundle: nil)
        
        //create the dialog
        let popup = PopupDialog(viewController: voteVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
        
        
        
        voteVC.voteTitle.text = "Cast vote to reject"
        let formattedString = NSMutableAttributedString()
        formattedString.normal("Are you sure you want to vote to reject a cashout of ")
        formattedString.bold(" \(currency) \(amount)")
        formattedString.normal(" from")
        formattedString.bold(" \(campaignName)")
        formattedString.normal(" to this number")
        formattedString.bold(" \(cashoutDestinationNumber)")
        formattedString.normal("?")
        
        voteVC.voteDescription.attributedText = formattedString
        
        
        //create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            
            self.dismiss(animated: true, completion: nil)

        }
        DefaultButton.appearance().titleColor = .gray
        //            UIColor(red: 0.00, green: 1.00, blue: 0.00, alpha: 1.00)
        CancelButton.appearance().titleColor = .gray
        
        
        //create second button
        
        let buttonTwo = DefaultButton(title: "YES", height: 60) {
            
            popup.dismiss(animated: true, completion: nil)

            let parameter : CashoutVoteParameter = CashoutVoteParameter(campaignId: campaignId, status: status, voteId: voteId)
            
            self.cashout(cashoutVoteParameter: parameter)
            FTIndicator.showProgress(withMessage: "voting")
            
        }
        
        buttonTwo.tintColor = UIColor.green
        //Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        //Present dialog
        present(popup, animated: animated, completion: nil)
        
    }
    
    
    func showLoanVoteNo(animated: Bool = true, amount: String, campaignId: String, cashoutDestination: String, cashoutDestinationCode: String, cashoutDestinationNumber: String, groupId: String, memberId: String, reason: String, status: String, voteId: String) {
        
        //create a custom view controller
        let voteVC = VoteOptionDialogViewController(nibName: "VoteOptionDialogViewController", bundle: nil)
        
        //create the dialog
        let popup = PopupDialog(viewController: voteVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
        
        
        
        voteVC.voteTitle.text = "Cast vote to reject"
        let formattedString = NSMutableAttributedString()
        formattedString.normal("Are you sure you want to vote to deny borrowing request of")
        formattedString.bold(" \(currency)\(amount)")
        formattedString.normal(" from")
        formattedString.bold(" \(campaignName)")
        formattedString.normal(" to this number")
        formattedString.bold(" \(destinationNumber)")
        formattedString.normal("?")
        
        voteVC.voteDescription.attributedText = formattedString
        
        
        //create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            
            self.dismiss(animated: true, completion: nil)

        }
        DefaultButton.appearance().titleColor = .gray
        //            UIColor(red: 0.00, green: 1.00, blue: 0.00, alpha: 1.00)
        CancelButton.appearance().titleColor = .gray
        
        
        //create second button
        
        let buttonTwo = DefaultButton(title: "YES", height: 60) {
            
            popup.dismiss(animated: true, completion: nil)

//            let parameter: GrantLoanParameter = GrantLoanParameter(amount: self.amount, cashoutDestination: self.destination, cashoutDestinationCode: "", cashoutDestinationNumber: self.destinationNumber, campaignId: self.campaignId, groupId: self.groupId, memberId: self.memberId, reason: self.reason, status: "0", voteId: self.voteId)
//
//            self.grantLoan(grantLoanParameter: parameter)
            
            let parameter: ExecuteLoanParameter = ExecuteLoanParameter(campaignId: self.campaignId, status: "0", voteId: self.voteId)
            self.executeLoan(executeLoanParameter: parameter)
            FTIndicator.showProgress(withMessage: "voting")
            
        }
        
        buttonTwo.tintColor = UIColor.green
        //Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        //Present dialog
        present(popup, animated: animated, completion: nil)
        
    }

    
    func showVoteNo(animated: Bool = true, name: String, groupId: String, memberId: String) {
        
        //create a custom view controller
        let voteVC = VoteOptionDialogViewController(nibName: "VoteOptionDialogViewController", bundle: nil)
        
        //create the dialog
        let popup = PopupDialog(viewController: voteVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
        
        
        
        if voteType == "makeadmin" {
            voteVC.voteTitle.text = "Cast vote to reject"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to reject")
            formattedString.bold(" \(name)")
            formattedString.normal(" as an admin?")
            formattedString.normal("This action cannot be undone?")
            
            voteVC.voteDescription.attributedText = formattedString
            //                "Are you sure you want to vote to make \(name) an admin? This action cannot be undone."
            print("alert else")
        }else if voteType == "makeapprover" {
            voteVC.voteTitle.text = "Cast vote to reject"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to reject")
            formattedString.bold(" \(name)")
            formattedString.normal(" as an approver?")
            formattedString.normal("This action cannot be undone?")
            voteVC.voteDescription.attributedText = formattedString
        }else if voteType == "dropmember" {
            voteVC.voteTitle.text = "Cast vote to reject"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to reject removing")
            formattedString.bold(" \(name)")
            formattedString.normal(" from this group?")
            formattedString.normal("This action cannot be undone?")
            voteVC.voteDescription.attributedText = formattedString
        }else if voteType == "revokeapprover" {
            voteVC.voteTitle.text = "Cast vote to reject"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to reject revoking")
            formattedString.bold(" \(name)")
            formattedString.normal(" as an approver?")
            formattedString.normal("This action cannot be undone?")
            voteVC.voteDescription.attributedText = formattedString
        }else if voteType == "revokeadmin" {
            voteVC.voteTitle.text = "Cast vote to reject"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to reject revoking")
            formattedString.bold(" \(name)")
            formattedString.normal(" as an admin?")
            formattedString.normal("This action cannot be undone?")
            voteVC.voteDescription.attributedText = formattedString
        }
        
        //create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            
            self.dismiss(animated: true, completion: nil)
            print("dismiss")
            //            voteVC.dismiss(animated: true, completion: nil)
            
        }
        DefaultButton.appearance().titleColor = .gray
        //            UIColor(red: 0.00, green: 1.00, blue: 0.00, alpha: 1.00)
        CancelButton.appearance().titleColor = .gray
        
        
        //create second button
        
        let buttonTwo = DefaultButton(title: "YES", height: 60) { [self] in
            
            if self.voteType == "makeadmin" {
                FTIndicator.showProgress(withMessage: "voting")
                let parameterr: ExecuteMakeAdminParameter = ExecuteMakeAdminParameter(status: "0", voteId: self.voteId)
                self.executeMakeAdmin(executeMakeAdminParameter: parameterr)
            }else if self.voteType == "makeapprover"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: MakeLoanApproverParameter = MakeLoanApproverParameter(groupId: groupId, memberId: memberId, status: "0")
                self.makeLoanApprover(makeLoanApproverParameter: parameter)
            }else if self.voteType == "dropmember"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: DropMemberParameter = DropMemberParameter(voteId: self.voteId, status: "0")
                self.dropMember(dropMemberParameter: parameter)
            }else if self.voteType == "revokeapprover"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: ExecuteRevokeApproverParameter = ExecuteRevokeApproverParameter(status: "0", voteId: self.voteId)
                self.executeRevokeApprvoer(executeRevokeApproverParameter: parameter)
            }else if self.voteType == "revokeadmin"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: ExecuteRevokeAdminParameter = ExecuteRevokeAdminParameter(status: "0", voteId: self.voteId)
                self.executeRevokeAdmin(executeRevokeAdminParameter: parameter)
            }
            
        }
        
        buttonTwo.tintColor = UIColor.green
        //Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        //Present dialog
        present(popup, animated: animated, completion: nil)
        
    }
    
    
    //POP UP DIALOG
    func showVoteYes(animated: Bool = true, name: String, groupId: String, memberId: String) {
        
        //create a custom view controller
        let voteVC = VoteOptionDialogViewController(nibName: "VoteOptionDialogViewController", bundle: nil)
        
        //create the dialog
        let popup = PopupDialog(viewController: voteVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
        
        if voteType == "makeadmin" {
            voteVC.voteTitle.text = "Cast vote to approve"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to make")
            formattedString.bold(" \(name)")
            formattedString.normal(" as an admin?")
            formattedString.normal("This action cannot be undone.")
            
            voteVC.voteDescription.attributedText = formattedString
            print("alert else")
        }else if voteType == "makeapprover" {
            
            voteVC.voteTitle.text = "Cast vote to approve"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to make")
            formattedString.bold(" \(name)")
            formattedString.normal(" as an approver?")
            formattedString.normal("This action cannot be undone.")
            voteVC.voteDescription.attributedText = formattedString
            
        }else if voteType == "dropmember" {
            voteVC.voteTitle.text = "Cast vote to approve"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to remove")
            formattedString.bold(" \(name)")
            formattedString.normal(" from this group?")
            formattedString.normal("This action cannot be undone.")
            voteVC.voteDescription.attributedText = formattedString
        }else if voteType == "revokeapprover" {
            voteVC.voteTitle.text = "Cast vote to reject"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to revoke")
            formattedString.bold(" \(name)")
            formattedString.normal(" as an approver?")
            formattedString.normal("This action cannot be undone.")
            voteVC.voteDescription.attributedText = formattedString
        }else if voteType == "revokeadmin" {
            voteVC.voteTitle.text = "Cast vote to reject"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to revoke")
            formattedString.bold(" \(name)")
            formattedString.normal(" as an admin?")
            formattedString.normal(" This action cannot be undone.")
            voteVC.voteDescription.attributedText = formattedString
        }
        
        //create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {

            self.dismiss(animated: true, completion: nil)
            
        }
        DefaultButton.appearance().titleColor = .gray
        //            UIColor(red: 0.00, green: 1.00, blue: 0.00, alpha: 1.00)
        CancelButton.appearance().titleColor = .gray
        
        
        //create second button
        let buttonTwo = DefaultButton(title: "YES", height: 60) { [self] in
            
            
            if self.voteType == "makeadmin" {
                FTIndicator.showProgress(withMessage: "voting")
                //                let parameter: CreateAdminParameter = CreateAdminParameter(groupId: groupId, memberId: memberId, status: "1")
                //                self.createAdmin(createAdminParameter: parameter)
                //                self.dismiss(animated: true, completion: nil)
                let parameterr: ExecuteMakeAdminParameter = ExecuteMakeAdminParameter(status: "1", voteId: self.voteId)
                self.executeMakeAdmin(executeMakeAdminParameter: parameterr)
                
            }else if self.voteType == "makeapprover"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: MakeLoanApproverParameter = MakeLoanApproverParameter(groupId: groupId, memberId: memberId, status: "1")
                self.makeLoanApprover(makeLoanApproverParameter: parameter)
                
            }else if self.voteType == "dropmember"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: DropMemberParameter = DropMemberParameter(voteId: self.voteId, status: "1")
                self.dropMember(dropMemberParameter: parameter)
                
            }else if self.voteType == "revokeapprover"{
                FTIndicator.showProgress(withMessage: "voting")
                //                let parameter: RevokeLoanApproverParameter = RevokeLoanApproverParameter(groupId: groupId, memberId: memberId, status: "1")
                //                self.revokeLoanApprover(revokeLoanApproverParameter: parameter)
                //                self.dismiss(animated: true, completion: nil)
                let parameter: ExecuteRevokeApproverParameter = ExecuteRevokeApproverParameter(status: "1", voteId: self.voteId)
                self.executeRevokeApprvoer(executeRevokeApproverParameter: parameter)
            }else if self.voteType == "revokeadmin"{
                FTIndicator.showProgress(withMessage: "voting")
                //                let parameter: RevokeAdminParameter = RevokeAdminParameter(groupId: groupId, memberId: memberId, status: "1")
                //                self.revokeAdmin(revokeAdminParameter: parameter)
                let parameter: ExecuteRevokeAdminParameter = ExecuteRevokeAdminParameter(status: "1", voteId: self.voteId)
                self.executeRevokeAdmin(executeRevokeAdminParameter: parameter)
            }
        }
        
        buttonTwo.tintColor = UIColor.green
        //Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        //Present dialog
        present(popup, animated: animated, completion: nil)
        
        }
        
        
        //POP UP DIALOG
        func showCashoutVoteYes(animated: Bool = true, amount: String, campaignId: String, cashoutDestination: String, cashoutDestinationCode: String, cashoutDestinationNumber: String, decisionDate: String, groupId: String, memberId: String, invoiceId: String, narration: String, network: String, status: String, voteId: String) {
            
            //create a custom view controller
            let voteVC = VoteOptionDialogViewController(nibName: "VoteOptionDialogViewController", bundle: nil)
            
            //create the dialog
            let popup = PopupDialog(viewController: voteVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
            
            voteVC.voteTitle.text = "Cast vote to approve"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to approve a cashout of")
            formattedString.bold(" \(currency) \(amount)")
            formattedString.normal(" from")
            formattedString.bold(" \(campaignName)")
            formattedString.normal(" to this number")
            formattedString.bold(" \(destinationNumber)")
            formattedString.normal("?")
            
            voteVC.voteDescription.attributedText = formattedString
            //                "Are you sure you want to vote to make \(name) an admin? This action cannot be undone."
            
            //create first button
            let buttonOne = CancelButton(title: "CANCEL", height: 60) {
                
                self.dismiss(animated: true, completion: nil)
            }
            DefaultButton.appearance().titleColor = .gray
            //            UIColor(red: 0.00, green: 1.00, blue: 0.00, alpha: 1.00)
            CancelButton.appearance().titleColor = .gray
            
            
            //create second button
            let buttonTwo = DefaultButton(title: "YES", height: 60) {
                
    //            popup.dismiss(animated: true, completion: nil)
                popup.dismiss()

                let parameter : CashoutVoteParameter = CashoutVoteParameter(campaignId: campaignId, status: status, voteId: voteId)
                
                self.cashout(cashoutVoteParameter: parameter)
                FTIndicator.showProgress(withMessage: "voting")

            }
            
            buttonTwo.tintColor = UIColor.green
            //Add buttons to dialog
            popup.addButtons([buttonOne, buttonTwo])
            
            //Present dialog
            present(popup, animated: animated, completion: nil)
            
        }
    
    
    //CASHOUT VOTE
    func cashout(cashoutVoteParameter: CashoutVoteParameter) {
        AuthNetworkManager.cashout(parameter: cashoutVoteParameter) { (result) in
            self.parseCashoutVoteResponse(result: result)
        }
    }
    
    
    private func parseCashoutVoteResponse(result: DataResponse<RevokeLoanApproverResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            if result.response!.statusCode == 200 {
                
                UserDefaults.standard.set(1, forKey: "cashout\(campaignId)-\(voteId)")
                
            }
            let alert = UIAlertController(title: "Vote", message: response.responseMessage , preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.dismiss(animated: true, completion: nil)
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
    
    //EXECUTE MAKE ADMIN
    func executeMakeAdmin(executeMakeAdminParameter: ExecuteMakeAdminParameter) {
        AuthNetworkManager.executeMakeAdmin(parameter: executeMakeAdminParameter) { (result) in
            self.parseExecuteMakeAdmin(result: result)
        }
    }
    
    
    
    
    private func parseExecuteMakeAdmin(result: DataResponse<ExecuteMakeAdminResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.dismiss(animated: true, completion: nil)

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
    
    
    //EXECUTE REVOKE ADMIN
    func executeRevokeAdmin(executeRevokeAdminParameter: ExecuteRevokeAdminParameter) {
        AuthNetworkManager.executeRevokeAdmin(parameter: executeRevokeAdminParameter) { (result) in
            self.parseExecuteRevokeAdmin(result: result)
        }
    }
    
    
    
    
    private func parseExecuteRevokeAdmin(result: DataResponse<ExecuteMakeAdminResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.dismiss(animated: true, completion: nil)
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
    
    
    //EXECUTE REVOKE APPROVER
    func executeRevokeApprvoer(executeRevokeApproverParameter: ExecuteRevokeApproverParameter) {
        AuthNetworkManager.executeRevokeApprover(parameter: executeRevokeApproverParameter) { (result) in
            self.parseExecuteRevokeApprover(result: result)
        }
    }
    
    
    
    
    private func parseExecuteRevokeApprover(result: DataResponse<ExecuteMakeAdminResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.dismiss(animated: true, completion: nil)

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
    

        //DROP MEMBER
        func dropMember(dropMemberParameter: DropMemberParameter) {
            AuthNetworkManager.dropMember(parameter: dropMemberParameter) { (result) in
                self.parseDropMemberResponse(result: result)
            }
        }
        
        
        
        
        private func parseDropMemberResponse(result: DataResponse<RevokeAdminResponse, AFError>){
            FTIndicator.dismissProgress()
            switch result.result {
            case .success(let response):
                print(response)
                
                if result.response!.statusCode == 200 {
                    
                    UserDefaults.standard.set(1, forKey: "dropmember\(campaignId)-\(voteId)")
                    
                }
                //            self.remove(child: self.groupId)
                let alert = UIAlertController(title: "Vote", message: response.responseMessage , preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                    self.dismiss(animated: true, completion: nil)
    //                self.navigationController?.popViewController(animated: true)
                    
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                
                break
            case .failure(let error):
                
                if result.response?.statusCode == 400 {
                    
                    sessionTimeout()
                    
                }
                    
                else {
                let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        
        func grantLoan(grantLoanParameter: GrantLoanParameter) {
            AuthNetworkManager.grantLoan(parameter: grantLoanParameter) { (result) in
                print(result)
                
                FTIndicator.dismissProgress()
                let alert = UIAlertController(title: "Chango", message: "\(result)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                    let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
                    
                    self.dismiss(animated: true, completion: nil)
    //                self.navigationController?.popViewController(animated: true)
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    
    func executeLoan(executeLoanParameter: ExecuteLoanParameter) {
        AuthNetworkManager.executeLoan(parameter: executeLoanParameter) { (result) in
            self.parseExecuteLoan(result: result)
        }
    }
    
    private func parseExecuteLoan(result: DataResponse<RegularResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
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

    
        //REVOKE LOAN APPROVER
        func makeLoanApprover(makeLoanApproverParameter: MakeLoanApproverParameter) {
            AuthNetworkManager.makeLoanApprover(parameter: makeLoanApproverParameter) { (result) in
                self.parseMakeLoanApproverResponse(result: result)
            }
        }
        
        
        
        
        private func parseMakeLoanApproverResponse(result: DataResponse<MakeLoanApproverResponse, AFError>){
            FTIndicator.dismissProgress()
            switch result.result {
            case .success(let response):
                print(response)
                
                if result.response!.statusCode == 200 {
                    
                    UserDefaults.standard.set(1, forKey: "revokeapprover\(campaignId)-\(voteId)")
                    
                }
                let alert = UIAlertController(title: "Vote", message: response.responseMessage , preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                
                break
            case .failure(let error):
                
                if result.response?.statusCode == 400 {
                    
                    sessionTimeout()
                    
                }

                else {
                let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                }
            }
        }
}
