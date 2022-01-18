//
//  LoanVoteViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 25/04/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator

class LoanVoteViewController: BaseViewController {

    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var campaignBalance: UILabel!
    @IBOutlet weak var loanerLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    var campaignName: String = ""
    var campaignId: String = ""
    var loaner: String = ""
    var reason: String = ""
    var amount: String = ""
    var destination: String = ""
    var memberId: String = ""
    var voteId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showChatController()
        disableDarkMode()

        campaignNameLabel.text = campaignName
        loanerLabel.text = loaner
        reasonLabel.text = reason
        amountLabel.text = amount
        destinationLabel.text = destination
    }
    
    
    
    func grantLoan(grantLoanParameter: GrantLoanParameter) {
        AuthNetworkManager.grantLoan(parameter: grantLoanParameter) { (result) in
            //self.parseAddMemberResponse(result: result)
            print(result)
            FTIndicator.dismissProgress()
            let alert = UIAlertController(title: "Chango", message: "\(result)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
                
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }


}
