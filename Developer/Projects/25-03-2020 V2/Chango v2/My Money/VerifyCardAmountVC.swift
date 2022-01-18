//
//  VerifyCardAmountVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 10/06/2021.
//  Copyright © 2021 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import CreditCardForm

class VerifyCardAmountVC: BaseViewController {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountTextfield: UITextField!
    @IBOutlet weak var creditCardView: CreditCardFormView!
    @IBOutlet weak var paymentPlaceholderLabel: UILabel!
    @IBOutlet weak var attemptsLeftLabel: UILabel!
    
    var paymentCheck: Bool = false
    var walletId: String = ""
    var nickName: String = ""
    var maximumVerificationAttempts: Int = 0
    var verificationAttempts: Int = 0
    var attemptsLeft: Int = 0
    var verificationInitiationDate: String = ""
    var amount: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableDarkMode()
        showChatController()
        // Do any additional setup after loading the view.
        creditCardView.cardHolderPlaceholderString = "Nickname"
        creditCardView.cardHolderString = nickName
        paymentPlaceholderLabel.text = "Enter the 6 digit code sent to you on \(verificationInitiationDate)"
        print("attempts: \(verificationAttempts)")
        maxVerificationAttempts()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func verifyAmountBtnAction(_ sender: UIButton) {
        if amountTextfield.text!.isEmpty {
            showAlert(title: "Card Verification", message: "Code cannot be empty. Please enter a valid code.")
        } else {
            
            if (maximumVerificationAttempts - verificationAttempts == 1) {
                let alert = UIAlertController(title: "Card Verification", message: "You have one attempt left to verify your card. Card will be canceled if this fails.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Verify", style: .default) { (action: UIAlertAction!) in
                    FTIndicator.showProgress(withMessage: "verifying")
                    let parameter: VerifyDebitedAmountParameter = VerifyDebitedAmountParameter(walletId: self.walletId, code: self.amountTextfield.text!)
                    self.verifyDebitedAmount(verifyDebitedAmountParameter: parameter)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
            }else {
            FTIndicator.showProgress(withMessage: "verifying")
            let parameter: VerifyDebitedAmountParameter = VerifyDebitedAmountParameter(walletId: walletId, code: amountTextfield.text!)
            verifyDebitedAmount(verifyDebitedAmountParameter: parameter)
            }
        }
    }
    
    @IBAction func verifyLaterBtnAction(_ sender: UIButton) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: WalletsVC.self){
                self.navigationController?.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func maxVerificationAttempts() {
        AuthNetworkManager.maxVerificationAttempts() { (result) in
            self.parseMaxVerificationAttemptsResponse(result: result)
        }
    }
    
    private func parseMaxVerificationAttemptsResponse(result: DataResponse<Int, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            maximumVerificationAttempts = response
            attemptsLeft = response - verificationAttempts
            
            attemptsLeftLabel.text = "Attempts Left: \(attemptsLeft)"
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    func verifyDebitedAmount(verifyDebitedAmountParameter: VerifyDebitedAmountParameter) {
        AuthNetworkManager.verifyDebitedAmount(parameter: verifyDebitedAmountParameter) { (result) in
            self.parseVerifyDebitedAmount(result: result)
        }
    }
    
    private func parseVerifyDebitedAmount(result: DataResponse<RegularResponse, AFError>){
        switch result.result {
        case .success(let response):
            FTIndicator.dismissProgress()
            if response.responseCode! == "01" {
                let alert = UIAlertController(title: "Card Verification", message: response.responseMessage, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: SettingsVC.self){
                            self.navigationController?.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            } else if response.responseMessage == "Your card has been deleted because you failed to confirm debited amount after too many attempts. Kindly add a new card." {
                let alert = UIAlertController(title: "Card Verification", message: response.responseMessage, preferredStyle: .alert)

                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: WalletsVC.self){
                            self.navigationController?.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }

                alert.addAction(okAction)

                self.present(alert, animated: true, completion: nil)
            } else {
                showAlert(title: "Card Verification", message: response.responseMessage!)
                attemptsLeft = attemptsLeft - 1
                attemptsLeftLabel.text = "Attempts Left: \(attemptsLeft)"
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
    
}
