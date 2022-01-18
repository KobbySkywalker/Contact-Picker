      //
//  CashoutSummaryVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 28/08/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import FTIndicator
import Alamofire


class CashoutSummaryVC: BaseViewController {

    //Wallet
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var recipientNumberLabel: UILabel!
    @IBOutlet weak var paymentOptionLabel: UILabel!
    
    //Bank
    @IBOutlet weak var bankView: UIView!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var bankBranchLabel: UILabel!
    @IBOutlet weak var accountNumberLabel: UILabel!
    
    @IBOutlet weak var initiateButton: UIButton!
    @IBOutlet weak var walletNameLabel: UILabel!
    
    var amount: String = ""
    var recipientName: String = ""
    var recipientNumber: String = ""
    var paymentOption: String = ""
    var groupId: String = ""
    var campaignId: String = ""
    var cashoutDestinationCode: String = ""
    var network: String = ""
    var voteId: String = ""
    var reason: String = ""
    var forSelf: Int = 0
    var forOther: Int = 0
    var forMember: Int = 0
    var bankCode: String = ""
    var bankName: String = ""
    var walletRecipientNumber: String = ""
    var nameOnWallet: String = ""
    var cashoutVoteId: String = ""
    var maskedWallet: String = ""
    
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()

        self.title = "Cashout Summary"
        
        print("vote id: \(voteId) \(campaignId)")
        
        FTIndicator.showProgress(withMessage: "", userInteractionEnable: false)
        let parameterr: CreatedVoteParameter = CreatedVoteParameter(groupId: groupId)
        self.getCreatedVotes(createdVoteParameter: parameterr)
        
        initiateButton.layer.cornerRadius = 22.00
        


        amountLabel.text = "\(amount)"
        if (forSelf == 1) {
            recipientLabel.text = "\((user?.displayName!)!) (Self)"
//            var pNumber = user?.phoneNumber!
//            pNumber?.removeFirst()
//            recipientNumber = walletRecipientNumber
//            walletRecipientNumber = pNumber!
            recipientNumberLabel.text = maskedWallet
            walletNameLabel.text = nameOnWallet
            print("code: \(walletRecipientNumber)")
            if paymentOption == "bank" {
                bankNameLabel.text = bankName
                accountNumberLabel.text = maskedWallet
            }
        }else if (forOther == 1) {
            if paymentOption == "wallet" {
                recipientNumberLabel.text = recipientNumber
                print("network: \(network)")
            }
            recipientLabel.text = recipientName
            bankNameLabel.text = bankName
            accountNumberLabel.text = recipientNumber
            print("rec: \(recipientNumber)")
            print("recs: \(walletRecipientNumber)")
        }else if (forMember == 1) {
            if paymentOption == "bank" {
            bankNameLabel.text = bankName
            accountNumberLabel.text = maskedWallet
            }
            recipientNumberLabel.text = maskedWallet
            recipientLabel.text = recipientName
            walletNameLabel.text = nameOnWallet

        }
        
        paymentOptionLabel.text = paymentOption
        
        if paymentOption == "bank" {
            walletView.isHidden = true
            bankView.isHidden = false
        }else {
            walletView.isHidden = false
            bankView.isHidden = true
        }

    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func initiateCashout(_ sender: UIButton) {
        
        if paymentOption == "bank" {
            FTIndicator.showProgress(withMessage: "initiating cashout")
            let parameter: InitiateCashoutParameter = InitiateCashoutParameter(amount: amount, campaignId: campaignId, cashoutDestination: "bank", cashoutDestinationCode: cashoutDestinationCode, cashoutDestinationNumber: recipientNumber, cashoutRecipientName: recipientName, groupId: groupId, reason: reason)
            initiateCashout(initiateCashoutParameter: parameter)
            
        }else if paymentOption == "wallet" {
            FTIndicator.showProgress(withMessage: "initiating cashout")
            let parameter: InitiateCashoutParameter = InitiateCashoutParameter(amount: amount, campaignId: campaignId, cashoutDestination: "wallet", cashoutDestinationCode: cashoutDestinationCode, cashoutDestinationNumber: recipientNumber, cashoutRecipientName: recipientName, groupId: groupId, reason: reason)
            initiateCashout(initiateCashoutParameter: parameter)
        }else {
            FTIndicator.showProgress(withMessage: "initiating cashout")
            let parameter: InitiateCashoutParameter = InitiateCashoutParameter(amount: amount, campaignId: campaignId, cashoutDestination: "wallet", cashoutDestinationCode: cashoutDestinationCode, cashoutDestinationNumber: recipientNumber, cashoutRecipientName: recipientName, groupId: groupId, reason: reason)
            initiateCashout(initiateCashoutParameter: parameter)
            
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
                
                UserDefaults.standard.set(1, forKey: "cashout\(self.campaignId)-\(self.voteId)")
                
//                self.navigationController?.popViewController(animated: true)
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: PrivateGroupDashboardVC.self){
                        self.navigationController?.popToViewController(controller, animated: true)
                    }
                }
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
    

    
    //    GET CREATED VOTES
    func getCreatedVotes(createdVoteParameter: CreatedVoteParameter) {
        AuthNetworkManager.createdVotes(parameter: createdVoteParameter) { (result) in
            self.parseCreatedVotesResponse(result: result)
        }
    }


    private func parseCreatedVotesResponse(result: DataResponse<CreatedVotesResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")

            for item in response.votes {
                print("ballot id: \(item.ballotId)")
//                ballotId = "\(item.ballotId.ballotId)"
                if ("\(item.ballotId.ballotId)" == "cashout") {
                    voteId = item.voteId
                    cashoutVoteId = item.voteId
                }
                print("vote Id: \(voteId)")

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
