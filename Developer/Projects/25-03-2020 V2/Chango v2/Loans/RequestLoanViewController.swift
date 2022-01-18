//
//  RequestLoanViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 19/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import FirebaseAuth

class RequestLoanViewController: BaseViewController {

    @IBOutlet weak var loanDescription: ACFloatingTextfield!
    @IBOutlet weak var requestButton: UIButton!
    
    var amount: String = ""
    var paybackDate: String = ""
    var loanType: String = ""
    var campaignId: String = ""
    var groupId: String = ""
    var memberId: String = ""
    var voteId: String = ""
    let user = Auth.auth().currentUser
    var cashoutDestination: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        memberId = (user?.uid)!
        
        if cashoutDestination == "" {
            cashoutDestination = "wallet"
        }

    }
    
    @IBAction func requestButtonAction(_ sender: UIButton) {
        FTIndicator.showProgress(withMessage: "processing request")
        let parameter: RequestLoanParameter = RequestLoanParameter(amount: amount, reason: loanDescription.text!, campaignId: campaignId, groupId: groupId, memberId: "\(memberId)", status: "1", voteId: voteId, cashoutDestination: cashoutDestination, cashoutDestinationCode: "", cashoutDestinationNumber:(user?.phoneNumber)!)
        requestLoan(requestLoanParameter: parameter)
    }
    

    
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
                        if controller.isKind(of: MainMenuTableViewController.self){
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
    
    
    
    private func parseRequestLoanResponse(result: DataResponse<String, AFError>){
        switch result.result {
        case .success(let response):
            print(response)
            

            
            
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
