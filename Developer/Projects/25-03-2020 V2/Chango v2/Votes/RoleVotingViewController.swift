//
//  RoleVotingViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 09/07/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import PopupDialog

class RoleVotingViewController: BaseViewController {

    @IBOutlet weak var noVoteButton: UIButton!
    @IBOutlet weak var yesVoteButton: UIButton!
    
    @IBOutlet weak var voteHeading: UILabel!
    
    var admin: Int = 0
    var approver: Int = 0
    var drop: Int = 0
    var groupId: String = ""
    var memberId: String = ""
    var loan: Int = 0
    var cashout: Int = 0
    var makeAdmin: Int = 0
    var makeApprover: Int = 0
    var name: String = ""
    var currency: String = ""
    
    var cashoutCampaignName: String = ""
    var cashoutCampaignBalance: String = ""
    var cashoutReason: String = ""
    var cashoutAmount: String = ""
    var campaignId: String = ""
    var cashoutDestination: String = ""
    var cashoutDestinationNumber: String = ""
    var memberNetwork: String = ""
    var voteId: String = ""
    var cashoutVotesCompleted: Int = 0
    var cashoutVotesRemaining: Int = 0
    
    
    var campaignName: String = ""
//    var campaignId: String = ""
    var loaner: String = ""
    var reason: String = ""
    var amount: String = ""
    var loanDestination: String = ""
//    var voteId: String = ""
    var campaignBalance: String = ""
    var loanVotesCompleted: Int = 0
    var loanVotesRemaining: Int = 0
    var loanDestinationNumber: String = ""
    
    var voteType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        showChatController()
        disableDarkMode()
        
        if voteType == "makeadmin"{
            voteHeading.text = "Cast Vote"
            self.navigationItem.title = "Make Admin"
        }else if voteType == "makeapprover"{
            voteHeading.text = "Cast Vote"
            self.navigationItem.title = "Make Approver"
        }else if voteType == "revokeadmin"{
            voteHeading.text = "Cast Vote"
            self.navigationItem.title = "Revoke Admin"
        }else if voteType == "revokeapprover"{
            voteHeading.text = "Cast Vote"
            self.navigationItem.title = "Revoke Approver"
        }else if voteType == "dropmember"{
            voteHeading.text = "Cast Vote"
            self.navigationItem.title = "Remove Member"
        }else if voteType == "cashout"{
            voteHeading.text = "Cast Vote"

        }else if voteType == "loan"{
            voteHeading.text = "Cast Vote"

        }
        
    }

    @IBAction func noVoteButtonAction(_ sender: UIButton) {
        print("no button")
//        if admin == 1 {
//            print("admin no vote")
//            FTIndicator.showProgress(withMessage: "voting")
//            let parameter: RevokeAdminParameter = RevokeAdminParameter(groupId: groupId, memberId: memberId, status: "0")
//            self.revokeAdmin(revokeAdminParameter: parameter)
//
//        }else if approver == 1 {
//            print("approver no vote")
//
//            FTIndicator.showProgress(withMessage: "voting")
//            let parameter: RevokeAdminParameter = RevokeAdminParameter(groupId: groupId, memberId: memberId, status: "0")
//            self.revokeAdmin(revokeAdminParameter: parameter)
//
//        }else if drop == 1 {
//            print("drop no vote")
//
//            FTIndicator.showProgress(withMessage: "voting")
//            let parameter: DropMemberParameter = DropMemberParameter(groupId: groupId, removeMemberId: memberId, status: "0")
//            self.dropMember(dropMemberParameter: parameter)
//
//        }else if loan == 1 {
//            print("loan no vote")
//
//            let parameter: GrantLoanParameter = GrantLoanParameter(amount: self.amount, cashoutDestination: self.loanDestination, cashoutDestinationCode: "", cashoutDestinationNumber: loanDestinationNumber, campaignId: self.campaignId, groupId: self.groupId, memberId: self.memberId, reason: self.reason, status: "0", voteId: self.voteId)
//
//            self.grantLoan(grantLoanParameter: parameter)
//            FTIndicator.showProgress(withMessage: "voting")
//
//        }else if cashout == 1 {
//            print("cashout no vote")
//
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
            let dateString = "\(year)-\(month)-\(day)"
//
//            let parameter : CashoutVoteParameter = CashoutVoteParameter(amount: self.cashoutAmount, campaignId: self.campaignId, cashoutDestination: cashoutDestination, cashoutDestinationCode: "", cashoutDestinationNumber: self.cashoutDestinationNumber, decisionDate: dateString, groupId: self.groupId, initiationMemberId: self.memberId, invoiceId: "", narration: self.cashoutCampaignName, network: self.memberNetwork, status: "0", voteId: self.voteId)
//            self.cashout(cashoutVoteParameter: parameter)
//            FTIndicator.showProgress(withMessage: "voting")
//        }else if makeAdmin == 1 {
//            print("make admin no")
//
//            FTIndicator.showProgress(withMessage: "voting")
//            let parameter: CreateAdminParameter = CreateAdminParameter(groupId: groupId, memberId: memberId, status: "0")
//
//            self.createAdmin(createAdminParameter: parameter)
//
//        }else if makeApprover == 1 {
//            print("make approver no")
//
//            FTIndicator.showProgress(withMessage: "voting")
//            let parameter: CreateLoanApproverParameter = CreateLoanApproverParameter(groupId: groupId, memberId: memberId, status: "0")
//
//            self.createLoanApprover(createLoanApproverParameter: parameter)
//
//        }
        
        
        
        
        
        if voteType == "makeadmin"{
            showVoteNo(animated: true, name: name, groupId: groupId, memberId: memberId)
            
        }else if voteType == "makeapprover"{
            showVoteNo(animated: true, name: name, groupId: groupId, memberId: memberId)
            
        }else if voteType == "revokeadmin"{
            showVoteNo(animated: true, name: name, groupId: groupId, memberId: memberId)
            
        }else if voteType == "revokeapprover"{
            showVoteNo(animated: true, name: name, groupId: groupId, memberId: memberId)
            
        }else if voteType == "dropmember"{
            showVoteNo(animated: true, name: name, groupId: groupId, memberId: memberId)
            
        }else if voteType == "cashout"{
            showCashoutVoteNo(animated: true, amount: cashoutAmount, campaignId: campaignId, cashoutDestination: cashoutDestination, cashoutDestinationCode: "", cashoutDestinationNumber: cashoutDestinationNumber, decisionDate: dateString, groupId: groupId, memberId: memberId, invoiceId: "", narration: campaignName, network: memberNetwork, status: "0", voteId: voteId)
        }else if voteType == "loan"{
            showLoanVoteNo(animated: true, amount: amount, campaignId: campaignId, cashoutDestination: loanDestination, cashoutDestinationCode: "", cashoutDestinationNumber: loanDestinationNumber, groupId: groupId, memberId: memberId, reason: reason, status: "0", voteId: voteId)
        }
    }
    

    @IBAction func yesVoteButtonAction(_ sender: UIButton) {
        print("yes button")
//        if admin == 1 {
//            print("admin yes vote")
//
//            FTIndicator.showProgress(withMessage: "voting")
//            let parameter: RevokeAdminParameter = RevokeAdminParameter(groupId: groupId, memberId: memberId, status: "1")
//            self.revokeAdmin(revokeAdminParameter: parameter)
//
//        }else if approver == 1 {
//            print("approver yes vote")
//
//            FTIndicator.showProgress(withMessage: "voting")
//            let parameter: RevokeLoanApproverParameter = RevokeLoanApproverParameter(groupId: groupId, memberId: memberId, status: "1")
//            self.revokeLoanApprover(revokeLoanApproverParameter: parameter)
//
//        }else if drop == 1 {
//            print("drop yes vote")
//
//            FTIndicator.showProgress(withMessage: "voting")
//            let parameter: DropMemberParameter = DropMemberParameter(groupId: groupId, removeMemberId: memberId, status: "0")
//            self.dropMember(dropMemberParameter: parameter)
//
//        }else if loan == 1 {
//            print("loan yes vote")
//            let parameter: GrantLoanParameter = GrantLoanParameter(amount: self.amount, cashoutDestination: self.loanDestination, cashoutDestinationCode: "", cashoutDestinationNumber: loanDestinationNumber, campaignId: self.campaignId, groupId: self.groupId, memberId: self.memberId, reason: self.reason, status: "1", voteId: self.voteId)
//
//            self.grantLoan(grantLoanParameter: parameter)
//            FTIndicator.showProgress(withMessage: "voting")
//
//        }else if cashout == 1 {
//            print("cashout yes vote")
//
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
            let dateString = "\(year)-\(month)-\(day)"
//
//            let parameter : CashoutVoteParameter = CashoutVoteParameter(amount: self.cashoutAmount, campaignId: self.campaignId, cashoutDestination: cashoutDestination, cashoutDestinationCode: "", cashoutDestinationNumber: self.cashoutDestinationNumber, decisionDate: dateString, groupId: self.groupId, initiationMemberId: self.memberId, invoiceId: "", narration: self.cashoutCampaignName, network: self.memberNetwork, status: "1", voteId: self.voteId)
//            self.cashout(cashoutVoteParameter: parameter)
//            FTIndicator.showProgress(withMessage: "voting")
//        }else if makeAdmin == 1 {
//
//            print("make admin yes")
//            FTIndicator.showProgress(withMessage: "voting")
//            let parameter: CreateAdminParameter = CreateAdminParameter(groupId: groupId, memberId: memberId, status: "1")
//
//            self.createAdmin(createAdminParameter: parameter)
//
//        }else if makeApprover == 1 {
//
//            print("make approver yes")
//
//            FTIndicator.showProgress(withMessage: "voting")
//            let parameter: CreateLoanApproverParameter = CreateLoanApproverParameter(groupId: groupId, memberId: memberId, status: "1")
//
//            self.createLoanApprover(createLoanApproverParameter: parameter)
//
//        }
        
        
        if voteType == "makeadmin"{
            showVoteYes(animated: true, name: name, groupId: groupId, memberId: memberId)
            
        }else if voteType == "makeapprover"{
            showVoteYes(animated: true, name: name, groupId: groupId, memberId: memberId)
            
        }else if voteType == "revokeadmin"{
            showVoteYes(animated: true, name: name, groupId: groupId, memberId: memberId)
            
        }else if voteType == "revokeapprover"{
            showVoteYes(animated: true, name: name, groupId: groupId, memberId: memberId)
            
        }else if voteType == "dropmember"{
            showVoteYes(animated: true, name: name, groupId: groupId, memberId: memberId)
            
        }else if voteType == "cashout"{
            showCashoutVoteYes(animated: true, amount: cashoutAmount, campaignId: campaignId, cashoutDestination: cashoutDestination, cashoutDestinationCode: "", cashoutDestinationNumber: cashoutDestinationNumber, decisionDate: dateString, groupId: groupId, memberId: memberId, invoiceId: "", narration: campaignName, network: memberNetwork, status: "1", voteId: voteId)
            
        }else if voteType == "loan"{
            showLoanVoteYes(animated: true, amount: amount, campaignId: campaignId, cashoutDestination: loanDestination, cashoutDestinationCode: "", cashoutDestinationNumber: loanDestinationNumber, groupId: groupId, memberId: memberId, reason: reason, status: "1", voteId: voteId)
        }
    }
    
    
    //REVOKE LOAN APPROVER
    func revokeLoanApprover(revokeLoanApproverParameter: RevokeLoanApproverParameter) {
        AuthNetworkManager.revokeLoanApprover(parameter: revokeLoanApproverParameter) { (result) in
            self.parseRevokeLoanApproverResponse(result: result)
        }
    }
    
    
    
    
    private func parseRevokeLoanApproverResponse(result: DataResponse<RevokeLoanApproverResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            if result.response!.statusCode == 200 {
                
                UserDefaults.standard.set(1, forKey: "revokeapprover\(campaignId)-\(voteId)")
                
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
//            else if result.response?.statusCode == 500 {
//
//                UserDefaults.standard.set(1, forKey: "revokeapprover\(campaignId)-\(voteId)")
//
//                let alert = UIAlertController(title: "Vote", message: "You have already voted." , preferredStyle: .alert)
//
//                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//
//                    self.navigationController?.popViewController(animated: true)
//                }
//
//                alert.addAction(okAction)
//
//                self.present(alert, animated: true, completion: nil)
//
//            }
            else {
            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    //REVOKE ADMIN
    func revokeAdmin(revokeAdminParameter: RevokeAdminParameter) {
        AuthNetworkManager.revokeAdmin(parameter: revokeAdminParameter) { (result) in
            self.parseRevokeAdminResponse(result: result)
        }
    }
    
    
    private func parseRevokeAdminResponse(result: DataResponse<RevokeAdminResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            if result.response!.statusCode == 200 {
                
                UserDefaults.standard.set(1, forKey: "revokeadmin\(campaignId)-\(voteId)")
                
            }
            //            self.remove(child: self.groupId)
            let alert = UIAlertController(title: "Vote", message: response.responseMessage , preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
//                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)

            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            break
        case .failure(let error):
            
            if result.response?.statusCode == 400 {
                
                sessionTimeout()
                
            }
//            else if result.response?.statusCode == 500 {
//
//                UserDefaults.standard.set(1, forKey: "revokeadmin\(campaignId)-\(voteId)")
//
//                let alert = UIAlertController(title: "Vote", message: "You have already voted." , preferredStyle: .alert)
//
//                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//
//                    self.navigationController?.popViewController(animated: true)
//                }
//
//                alert.addAction(okAction)
//
//                self.present(alert, animated: true, completion: nil)
//
//            }
            else {
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
//            else if result.response?.statusCode == 500 {
//
//                UserDefaults.standard.set(1, forKey: "dropmember\(campaignId)-\(voteId)")
//
//                let alert = UIAlertController(title: "Vote", message: "You have already voted." , preferredStyle: .alert)
//
//                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//
//                    self.navigationController?.popViewController(animated: true)
//                }
//
//                alert.addAction(okAction)
//
//                self.present(alert, animated: true, completion: nil)
//
//            }
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
            //self.parseAddMemberResponse(result: result)
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
    
    
    //CREATE ADMIN
//    func createAdmin(createAdminParameter: CreateAdminParameter) {
//        AuthNetworkManager.createAdmin(parameter: createAdminParameter) { (result) in
//            self.parseCreateAdminResponse(result: result)
//        }
//    }
    
    
    
    
    private func parseCreateAdminResponse(result: DataResponse<RevokeLoanApproverResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
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
//            else if result.response?.statusCode == 500 {
//             
//                UserDefaults.standard.set(1, forKey: "createadmin\(campaignId)-\(voteId)")
//
//                let alert = UIAlertController(title: "Vote", message: "You have already voted." , preferredStyle: .alert)
//                
//                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//                    
//                    self.navigationController?.popViewController(animated: true)
//                }
//                
//                alert.addAction(okAction)
//                
//                self.present(alert, animated: true, completion: nil)
//                
//            }
            else {
            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    
    //CREATE LOAN APPROVER
    func createLoanApprover(createLoanApproverParameter: CreateLoanApproverParameter) {
        AuthNetworkManager.createLoanApprover(parameter: createLoanApproverParameter) { (result) in
            self.parseCreateLoanApproverResponse(result: result)
        }
    }
    
    
    
    
    private func parseCreateLoanApproverResponse(result: DataResponse<CreateLoanApproverResponse, AFError>){
        FTIndicator.dismissProgress()
        
        switch result.result {
        case .success(let response):
            print(response)
            
//            let alert = UIAlertController(title: "Vote", message: response.responseMessage, preferredStyle: .alert)
//
//            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//
//
//                self.navigationController?.popViewController(animated: true)
//            }
//
//            alert.addAction(okAction)
//
//            self.present(alert, animated: true, completion: nil)
            
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
            //                "Are you sure you want to vote to make \(name) an admin? This action cannot be undone."
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
            
            //            if self.voteType == "makeadmin" {
            //                FTIndicator.showProgress(withMessage: "voting")
            //                let parameter: CreateAdminParameter = CreateAdminParameter(groupId: groupId, memberId: memberId, status: "0")
            //                self.createAdmin(createAdminParameter: parameter)
            //            }else if self.voteType == "makeApprover"{
            //                FTIndicator.showProgress(withMessage: "voting")
            //                let parameter: CreateAdminParameter = CreateAdminParameter(groupId: groupId, memberId: memberId, status: "0")
            //                self.createAdmin(createAdminParameter: parameter)
            //            }else if self.voteType == "dropmember"{
            //                FTIndicator.showProgress(withMessage: "voting")
            //                let parameter: DropMemberParameter = DropMemberParameter(groupId: groupId, removeMemberId: memberId, status: "0")
            //                self.dropMember(dropMemberParameter: parameter)
            //
            //            }
            self.dismiss(animated: true, completion: nil)

        }
        DefaultButton.appearance().titleColor = .gray
        //            UIColor(red: 0.00, green: 1.00, blue: 0.00, alpha: 1.00)
        CancelButton.appearance().titleColor = .gray
        
        
        //create second button
        let buttonTwo = DefaultButton(title: "YES", height: 60) {
            
            
            if self.voteType == "makeadmin" {
                FTIndicator.showProgress(withMessage: "voting")
//                let parameter: CreateAdminParameter = CreateAdminParameter(groupId: groupId, memberId: memberId, status: "1")
//                self.createAdmin(createAdminParameter: parameter)
//                self.dismiss(animated: true, completion: nil)
                let parameterr: ExecuteMakeAdminParameter = ExecuteMakeAdminParameter(status: "1", voteId: self.voteId)
                self.executeMakeAdmin(executeMakeAdminParameter: parameterr)

            }else if self.voteType == "makeapprover"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: RevokeLoanApproverParameter = RevokeLoanApproverParameter(groupId: groupId, memberId: memberId, status: "1")
                self.revokeLoanApprover(revokeLoanApproverParameter: parameter)
//                self.dismiss(animated: true, completion: nil)

            }else if self.voteType == "dropmember"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: DropMemberParameter = DropMemberParameter(voteId: self.voteId, status: "1")
                self.dropMember(dropMemberParameter: parameter)
//                self.dismiss(animated: true, completion: nil)

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
            
            
            //            if self.voteType == "makeadmin" {
            //                FTIndicator.showProgress(withMessage: "voting")
            //                let parameter: CreateAdminParameter = CreateAdminParameter(groupId: groupId, memberId: memberId, status: "1")
            //                self.createAdmin(createAdminParameter: parameter)
            //            }else if self.voteType == "makeApprover"{
            //                FTIndicator.showProgress(withMessage: "voting")
            //                let parameter: RevokeLoanApproverParameter = RevokeLoanApproverParameter(groupId: groupId, memberId: memberId, status: "1")
            //                self.revokeLoanApprover(revokeLoanApproverParameter: parameter)
            //            }else if self.voteType == "dropmember"{
            //                FTIndicator.showProgress(withMessage: "voting")
            //                let parameter: DropMemberParameter = DropMemberParameter(groupId: groupId, removeMemberId: memberId, status: "1")
            //                self.dropMember(dropMemberParameter: parameter)
            //            }
            self.dismiss(animated: true, completion: nil)
            print("dismiss")
//            voteVC.dismiss(animated: true, completion: nil)

        }
        DefaultButton.appearance().titleColor = .gray
        //            UIColor(red: 0.00, green: 1.00, blue: 0.00, alpha: 1.00)
        CancelButton.appearance().titleColor = .gray
        
        
        //create second button
        
        let buttonTwo = DefaultButton(title: "YES", height: 60) {
            
            if self.voteType == "makeadmin" {
                FTIndicator.showProgress(withMessage: "voting")
//                let parameter: CreateAdminParameter = CreateAdminParameter(groupId: groupId, memberId: memberId, status: "0")
//                self.createAdmin(createAdminParameter: parameter)
//                self.dismiss(animated: true, completion: nil)
                let parameterr: ExecuteMakeAdminParameter = ExecuteMakeAdminParameter(status: "0", voteId: self.voteId)
                self.executeMakeAdmin(executeMakeAdminParameter: parameterr)

            }else if self.voteType == "makeapprover"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: RevokeLoanApproverParameter = RevokeLoanApproverParameter(groupId: groupId, memberId: memberId, status: "0")
                self.revokeLoanApprover(revokeLoanApproverParameter: parameter)
//                self.dismiss(animated: true, completion: nil)

            }else if self.voteType == "dropmember"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: DropMemberParameter = DropMemberParameter(voteId: self.voteId,status: "0")
                self.dropMember(dropMemberParameter: parameter)
//                self.dismiss(animated: true, completion: nil)

            }else if self.voteType == "revokeapprover"{
                FTIndicator.showProgress(withMessage: "voting")
//                let parameter: RevokeLoanApproverParameter = RevokeLoanApproverParameter(groupId: groupId, memberId: memberId, status: "0")
//                self.revokeLoanApprover(revokeLoanApproverParameter: parameter)
                let parameter: ExecuteRevokeApproverParameter = ExecuteRevokeApproverParameter(status: "0", voteId: self.voteId)
                self.executeRevokeApprvoer(executeRevokeApproverParameter: parameter)
//                self.dismiss(animated: true, completion: nil)
            }else if self.voteType == "revokeadmin"{
                FTIndicator.showProgress(withMessage: "voting")
//                let parameter: RevokeAdminParameter = RevokeAdminParameter(groupId: groupId, memberId: memberId, status: "0")
//                self.revokeAdmin(revokeAdminParameter: parameter)
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
        formattedString.bold(" \(cashoutCampaignName)")
        formattedString.normal(" to this number")
        formattedString.bold(" \(cashoutDestinationNumber)")
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
        formattedString.bold(" \(cashoutCampaignName)")
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
    
    
    //POP UP DIALOG
    func showLoanVoteYes(animated: Bool = true, amount: String, campaignId: String, cashoutDestination: String, cashoutDestinationCode: String, cashoutDestinationNumber: String, groupId: String, memberId: String, reason: String, status: String, voteId: String) {
        
        //create a custom view controller
        let voteVC = VoteOptionDialogViewController(nibName: "VoteOptionDialogViewController", bundle: nil)
        
        //create the dialog
        let popup = PopupDialog(viewController: voteVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
        
        voteVC.voteTitle.text = "Cast vote to approve"
        let formattedString = NSMutableAttributedString()
        formattedString.normal("Are you sure you want to vote to approve borrowing request of")
        formattedString.bold(" \(currency) \(amount)")
        formattedString.normal(" from")
        formattedString.bold(" \(campaignName)")
        formattedString.normal(" to this number")
        formattedString.bold(" \(cashoutDestinationNumber)")
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
            
            popup.dismiss(animated: true, completion: nil)

            let parameter: GrantLoanParameter = GrantLoanParameter(amount: self.amount, cashoutDestination: self.loanDestination, cashoutDestinationCode: "", cashoutDestinationNumber: self.loanDestinationNumber, campaignId: self.campaignId, groupId: self.groupId, memberId: self.memberId, reason: self.reason, status: "1", voteId: self.voteId)
            
            self.grantLoan(grantLoanParameter: parameter)
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

            let parameter: GrantLoanParameter = GrantLoanParameter(amount: self.amount, cashoutDestination: self.loanDestination, cashoutDestinationCode: "", cashoutDestinationNumber: self.loanDestinationNumber, campaignId: self.campaignId, groupId: self.groupId, memberId: self.memberId, reason: self.reason, status: "0", voteId: self.voteId)
            
            self.grantLoan(grantLoanParameter: parameter)
            FTIndicator.showProgress(withMessage: "voting")
            
        }
        
        buttonTwo.tintColor = UIColor.green
        //Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        //Present dialog
        present(popup, animated: animated, completion: nil)
        
    }

}
