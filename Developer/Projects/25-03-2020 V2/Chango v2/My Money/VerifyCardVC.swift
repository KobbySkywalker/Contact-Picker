//
//  VerifyCardVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 06/04/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import CreditCardForm
import Stripe
import Alamofire
import FTIndicator

class VerifyCardVC: BaseViewController, STPPaymentCardTextFieldDelegate {

    @IBOutlet weak var creditCardForm: CreditCardFormView!
    @IBOutlet weak var scannedCardNumberView: UIView!
    @IBOutlet weak var scannedNumberLabel: UILabel!
    @IBOutlet weak var cardExpiryLabel: UILabel!
    @IBOutlet weak var cardLimitLabel: UILabel!
    
    var cardNumber: String = ""
    var pan: String = ""
    var cardAlias: String = ""
    var cardHolderName: String = ""
    var monthExpiry: String = ""
    var paymentCheck: Bool = false
    var walletId: String = ""
    var countryId: String = ""
    var verificationAttempts: Int = 0
    var verificationInitiationDate: String = ""
    
    var amount: Double = 0.0
    var text: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        disableDarkMode()
        showChatController()
        cardNumber = String(cardNumber.suffix(4))
        
        creditCardForm.cardHolderString = cardHolderName
        creditCardForm.cardHolderPlaceholderString = "Nickname"
        cardNumber = "XXXX XXXX XXXX \(cardNumber)"
        scannedNumberLabel.text = cardNumber
//        cardExpiryLabel.text = expDate
        creditCardForm.chipImage = UIImage(named: "chip")
        
        retrieveMember()
        
        
        text = "200"
        let two = String(format: "%.2f", 200)
        print("amt: \(two)")
//        creditCardForm.paymentCardTextFieldDidChange(cardNumber: "4422 5353 0095 6363", expirationYear: 22, expirationMonth: 03, cvc: "234")
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func verifyCardBtnAction(_ sender: UIButton) {
        FTIndicator.showProgress(withMessage: "verifying")
        let parameter: VerifyCardParameter = VerifyCardParameter(walletId: walletId)
        verifyCard(verifyCardParameter: parameter)
    }
    
    func retrieveMember() {
        AuthNetworkManager.retrieveMember() { (result) in
            self.parseRetrieveMemberResponse(result: result)
        }
    }
    
    private func parseRetrieveMemberResponse(result: DataResponse<RetrieveMemberResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            let parameter: LimitsForUnverifiedCardsParameter = LimitsForUnverifiedCardsParameter(countryId: response.countryId)
            limitsForUnverifiedCards(limitsForUnverifiedCardsParameter: parameter)
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    func limitsForUnverifiedCards(limitsForUnverifiedCardsParameter: LimitsForUnverifiedCardsParameter) {
        AuthNetworkManager.limitsForUnverifiedCards(parameter: limitsForUnverifiedCardsParameter) { (result) in
            self.parseLimitsForUnverifiedCardsResponse(result: result)
        }
    }
    
    private func parseLimitsForUnverifiedCardsResponse(result: DataResponse<LimitForUnverifiedCardsResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
                
            cardLimitLabel.text = "You currently have a contribution limit of \(response.currency!)\(response.displayAmount!) or its equivalent because your card has not been verified yet. To Verify your card, we will debit your card with a random amount and you will be asked to provide the 6 digit code on your bank statement. \n\nKindly note that the debited funds will be reversed back to your account within 7 days after the debit."
        
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    
    func verifyCard(verifyCardParameter: VerifyCardParameter) {
        AuthNetworkManager.verifyCard(parameter: verifyCardParameter) { (result) in
            self.parseVerifyCard(result: result)
        }
    }
    
    private func parseVerifyCard(result: DataResponse<VerifyCardResponse, AFError>){
        switch result.result {
        case .success(let response):
            FTIndicator.dismissProgress()
            if response.responseCode == "01" {
                let alert = UIAlertController(title: "Card Verification", message: response.responseMessage, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    let vc: VerifyCardAmountVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verifyamount") as! VerifyCardAmountVC
                    
                    vc.walletId = self.walletId
                    vc.paymentCheck = self.paymentCheck
                    vc.nickName = self.cardHolderName
                    vc.verificationAttempts = self.verificationAttempts
                    vc.verificationInitiationDate = dateConversionWithMilliSeconds(dateValue: response.verificationInitiationDate!)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }else {
                showAlert(title: "Card Verificationn", message: response.responseMessage!)
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
