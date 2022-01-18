//
//  VoteConfirmationVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 12/03/2021.
//  Copyright © 2021 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator
import Alamofire

class VoteCompletionVC: BaseViewController {
    
    @IBOutlet weak var voteInfoLabel: UILabel!
    
    var voteType: String = ""
    var voteOption: String = ""
    var amount: String = ""
    var campaignId: String = ""
    var destination: String = ""
    var destinationCode: String = ""
    var destinationNumber: String = ""
    var decisionDate: String = ""
    var groupId: String = ""
    var memberId: String = ""
    var narration: String = ""
    var network: String = ""
    var memberNetwork: String = ""
    var voteId: String = ""
    var currency: String = ""
    var votePreference: String = ""
    var reason: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()
        showChatController()
        let formattedString = NSMutableAttributedString()
        formattedString.normal("Are you sure you want to vote to \(votePreference) \(voteType) of")
        formattedString.bold(" \(currency)\(amount)")
        formattedString.normal(" from")
        formattedString.bold(" \(narration)")
        formattedString.normal(" to this number")
        formattedString.bold(" \(destinationNumber)")
        formattedString.normal("?")
        
        voteInfoLabel.attributedText = formattedString
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func yesVoteButton(_ sender: UIButton) {
        
        if voteType == "cashout" {
            if voteOption == "yes" {
                print("voting yes")
                let parameter: CashoutVoteParameter = CashoutVoteParameter(campaignId: campaignId, status: "1", voteId: voteId)
                cashoutVote(cashoutVoteParameter: parameter)
            }else {
                print("voting no")
                let parameter: CashoutVoteParameter = CashoutVoteParameter(campaignId: campaignId, status: "0", voteId: voteId)
                cashoutVote(cashoutVoteParameter: parameter)
            }
        }else {
            //borrow
            if voteOption == "yes" {
                print("voting yes")
                let parameter: GrantLoanParameter = GrantLoanParameter(amount: amount, cashoutDestination: destination, cashoutDestinationCode: "", cashoutDestinationNumber: destinationNumber, campaignId: campaignId, groupId: groupId, memberId: memberId, reason: reason, status: "1", voteId: voteId)
                grantLoan(grantLoanParameter: parameter)
            }else {
                print("voting no")
                let parameter: GrantLoanParameter = GrantLoanParameter(amount: amount, cashoutDestination: destination, cashoutDestinationCode: "", cashoutDestinationNumber: destinationNumber, campaignId: campaignId, groupId: groupId, memberId: memberId, reason: reason, status: "0", voteId: voteId)
                grantLoan(grantLoanParameter: parameter)
            }
        }
    }
    
    
    //CASHOUT VOTE
    func cashoutVote(cashoutVoteParameter: CashoutVoteParameter) {
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
                
//                for controller in self.navigationController!.viewControllers as Array {
//                    if controller.isKind(of: PrivateGroupDashboardVC.self){
//                        self.navigationController?.popToViewController(controller, animated: true)
//                    }
//                }
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
    
    //GRANT LOAN
    func grantLoan(grantLoanParameter: GrantLoanParameter) {
        AuthNetworkManager.grantLoan(parameter: grantLoanParameter) { (result) in
            //self.parseAddMemberResponse(result: result)
            print(result)
            FTIndicator.dismissProgress()
            
            let alert = UIAlertController(title: "Chango", message: "\(result)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
//                for controller in self.navigationController!.viewControllers as Array {
//                    if controller.isKind(of: PrivateGroupDashboardVC.self){
//                        self.navigationController?.popToViewController(controller, animated: true)
//                    }
//                }
                self.dismiss(animated: true, completion: nil)
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    
}



