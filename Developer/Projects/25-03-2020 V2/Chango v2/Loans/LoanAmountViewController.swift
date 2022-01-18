//
//  LoanAmountViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 19/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class LoanAmountViewController: BaseViewController {

    @IBOutlet weak var loanAmount: ACFloatingTextfield!
    @IBOutlet weak var campaignBalanceLabel: UILabel!
    
    var groupId: String = ""
    var campaignId: String = ""
    var memberId: String = ""
    var voteId: String = ""
    var campaigns: [GetGroupCampaignsResponse] = []
    var campaignBalance: String = ""
    var cashoutDestination: String = ""
    var campaignBalances: [GroupBalance] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()

        print(voteId)
        
        for item in campaignBalances {
            if item.campaignId == campaignId {
                campaignBalanceLabel.text = "\(item.balance)"
            }
        }
//        campaignBalanceLabel.text = campaignBalance
    }
    

    @IBAction func nextButtonAction(_ sender: UIButton) {
        
        if loanAmount.text!.isEmpty {
            
            let alert = UIAlertController(title: "Request Loan", message: "Please enter an amount.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else if (loanAmount.text! == "0") || (loanAmount.text! == "0.00") || (loanAmount.text!) == "0.0" {
            let alert = UIAlertController(title: "Request Loan", message: "Amount cannot be zero. Please enter a valid amount.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else if (campaignBalance == "0.00") {
            
            let alert = UIAlertController(title: "Loan", message: "Insufficient Funds.", preferredStyle: .alert)
            let okActioin = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okActioin)
            self.present(alert, animated: true, completion: nil)
        }
        
        else {
        let vc: RequestLoanViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "description") as! RequestLoanViewController
            
            vc.amount = loanAmount.text!
//            vc.campaignId = [campaignId]
            vc.voteId = voteId
            vc.groupId = groupId
            vc.campaignId = campaignId
//            vc.campaignNames = campaigns
            vc.cashoutDestination = cashoutDestination
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
