//
//  CvvVC.swift
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
import RNCryptor

class CvvVC: BaseViewController, UITextFieldDelegate, STPPaymentCardTextFieldDelegate {

    @IBOutlet weak var cvvTextField: ACFloatingTextfield!
    @IBOutlet weak var creditCardView: CreditCardFormView!
    @IBOutlet weak var scannedCardNumberView: UIView!
    @IBOutlet weak var scannedCardNumberLabel: UILabel!
    @IBOutlet weak var expiryDateView: UIView!
    @IBOutlet weak var cardExpiryLabel: UILabel!
    
    
    var cardNumber: String = ""
    var pan: String = ""
    var cardHolderName: String = ""
    var cardAlias: String = ""
    var monthExpiry: String = ""
    var yearExpiry: String = ""
    var expDate: String = ""
    var api_token: String = ""
    var key: String = ""
    var amountLimit: String = ""
    var expDateParam: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        disableDarkMode()
        showChatController()
        
        scannedCardNumberLabel.text = cardNumber
        expiryDateView.isHidden = false
//        cvvTextField.addTarget(self, action: #selector(CvvVC.textFieldDidChange(_:)), for: .editingChanged)
        creditCardView.cardHolderString = cardHolderName
        cardExpiryLabel.text = expDate
        creditCardView.chipImage = UIImage(named: "chip")
        editingChanged()
        
        expDateParam = expDate.replacingOccurrences(of: "/", with: "")
        print("\(pan),\(expDateParam),\(cardHolderName)")
        
        api_token = UserDefaults.standard.string(forKey: "idToken")!
        api_token = String(api_token.prefix(32))
        key = String(api_token.prefix(16))
        
        


    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editingChanged() {
        cvvTextField.text = String(cvvTextField.text!.prefix(3))
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidChange(cardNumber: "", expirationYear: 0, expirationMonth: 0, cvc: textField.cvc)
    }
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingCVC()
    }

    
    
    
    
    @IBAction func verifyCvvBtnAction(_ sender: UIButton) {
        
        if cvvTextField.hasText == false {
                let alert = UIAlertController(title: "Chango", message: "Please enter cvv before you can proceed.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
        }else {
            
            FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)
            pan = pan.replacingOccurrences(of: " ", with: "")
            let body = ["pan":pan,"cvv":cvvTextField.text!,"expiry":expDateParam]
            print("body: \(body)")
            
            var dataToEncrypt: String = ""
            let dic = body
            let encoder = JSONEncoder()
            if let jsonData = try? encoder.encode(dic) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                    dataToEncrypt = jsonString
                }
            }
            
            //                do {
            //                    let aes = try AES(keyString: api_token)
            //
            //                    let stringToEncrypt: String = dataToEncrypt
            //                    print("String to encrypt:\t\t\t\(stringToEncrypt)")
            //
            //                    let encryptedData: Data = try aes.encrypt(stringToEncrypt)
            //                    print("String encrypted (base64):\t\(encryptedData.base64EncodedString())")
            //
            //                    let decryptedData: String = try aes.decrypt(encryptedData)
            //                    print("String decrypted:\t\t\t\(decryptedData)")
            //
            
            //
            //                } catch {
            //                    print("Something went wrong: \(error)")
            //                }
            //
            
            let data = dataToEncrypt
            let key256   = api_token   // 32 bytes for AES256
            let iv       = key                   // 16 bytes for AES128
            
            let aes256 = AES(key: key256, iv: iv)
            
            
            let encryptedData256 = aes256?.encrypt(string: "\(data)")
            let decryptedData = aes256?.decrypt(data: encryptedData256)
            
            print("encrypted: \(encryptedData256!.base64EncodedString())")
            print("decrypted: \(decryptedData)")
            
            let parameter: AddCreditCardParameter = AddCreditCardParameter(body: "\(encryptedData256!.base64EncodedString())", alias: cardAlias)
            self.addCreditCard(addCreditCardParameter: parameter)
            
            
            
        }
    }
    
    //ADD CARD
    func addCreditCard(addCreditCardParameter: AddCreditCardParameter) {
        AuthNetworkManager.addCreditCard(parameter: addCreditCardParameter) { (result) in
            self.parseAddCreditCardResponse(result: result)
        }
    }
    
    private func parseAddCreditCardResponse(result: DataResponse<AddWalletResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            

            if response.responseCode == "01" {
                let vc: CompleteCardVerificationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardverified") as! CompleteCardVerificationVC
                vc.cardNumber = cardNumber
                vc.cardHolderName = cardHolderName
                vc.cardAlias = cardAlias
                vc.expDate = expDate
                vc.yearExpiry = yearExpiry
                vc.walletId = (response.paymentWallet?.walletId)!
                vc.nickName = response.paymentWallet?.nickName ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)

                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in

                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
}
