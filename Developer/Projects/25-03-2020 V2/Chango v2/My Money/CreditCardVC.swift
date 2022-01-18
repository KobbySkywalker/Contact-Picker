//
//  CreditCardVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 24/03/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import CreditCardForm
import Stripe
import PopupDialog
import FTIndicator
import Alamofire
import Sodium
import RNCryptor
import CCValidator

class CreditCardVC: BaseViewController, STPPaymentCardTextFieldDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var creditCardView: CreditCardFormView!
    @IBOutlet weak var cardNumberTextField: ACFloatingTextfield!
    @IBOutlet weak var cardHolderTextField: ACFloatingTextfield!
    @IBOutlet weak var expiryDateTextField: ACFloatingTextfield!
    @IBOutlet weak var cardAliasTextField: ACFloatingTextfield!
    @IBOutlet weak var enterCardDetailsLabel: UILabel!
    @IBOutlet weak var scannedCardNumberView: UIView!
    @IBOutlet weak var scannedCardNumberLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    
    let paymentTextField = STPPaymentCardTextField()
    var cardNumber: String = ""
    var cardHolderName: String = ""
    var expMonth: Int = 0
    var expYear: Int = 0
    var expDate: String = ""
    var cvc: String = ""
    var scanned: Bool = false
    
    var myPublicKeyHex: String = ""
    var mySecretKeyHex: String = ""
    var publicKeyHex: String = ""
    var secretKeyHex: String = ""
    
    //        byte values
    //        publicKey = [215, 145, 194, 166, 72, 60, 87, 69, 155, 156, 37, 226, 252, 109, 200, 88, 148, 54, 7, 167, 208, 104, 120, 2, 242, 104, 236, 151, 250, 248, 250, 0]
    //        secretKey = [3, 71, 8, 87, 230, 231, 241, 251, 223, 142, 228, 227, 230, 241, 232, 0, 135, 227, 71, 116, 91, 175, 205, 177, 43, 82, 229, 213, 202, 237, 137, 123]
    //        mypublicKey = [240, 70, 226, 130, 64, 199, 232, 119, 138, 128, 185, 157, 68, 107, 48, 221, 216, 24, 147, 109, 77, 167, 234, 153, 38, 55, 119, 145, 87, 211, 254, 125]
    //        mySecretKey = [165, 194, 83, 14, 127, 227, 187, 171, 33, 192, 19, 157, 52, 152, 5, 125, 23, 181, 82, 111, 3, 210, 32, 15, 217, 145, 11, 163, 172, 141, 182, 73]
    
    var myPublicKey: Bytes = [240, 70, 226, 130, 64, 199, 232, 119, 138, 128, 185, 157, 68, 107, 48, 221, 216, 24, 147, 109, 77, 167, 234, 153, 38, 55, 119, 145, 87, 211, 254, 125]
    var mySecretKey: Bytes = [165, 194, 83, 14, 127, 227, 187, 171, 33, 192, 19, 157, 52, 152, 5, 125, 23, 181, 82, 111, 3, 210, 32, 15, 217, 145, 11, 163, 172, 141, 182, 73]
    var publicKey: Bytes = [215, 145, 194, 166, 72, 60, 87, 69, 155, 156, 37, 226, 252, 109, 200, 88, 148, 54, 7, 167, 208, 104, 120, 2, 242, 104, 236, 151, 250, 248, 250, 0]
    var secretKey: Bytes = [3, 71, 8, 87, 230, 231, 241, 251, 223, 142, 228, 227, 230, 241, 232, 0, 135, 227, 71, 116, 91, 175, 205, 177, 43, 82, 229, 213, 202, 237, 137, 123]
    
    var mPK = ""
    var mSK = ""
    var pK = ""
    var sK = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()
        showChatController()
        print("exp: \(expDate)")
        if scanned == true {
            scannedCardNumberLabel.text = cardNumber
            cardNumberTextField.text = cardNumber
            textFieldDidChange(cardNumberTextField)
            
            if expDate != "" {
                expiryDateTextField.text = expDate
                expiryDateLabel.text = expDate
            }
            
            if cardHolderName != "" {
                creditCardView.cardHolderString = cardHolderName
                cardHolderTextField.text = cardHolderName
            }
            
        }else {
            cardNumberTextField.addTarget(self, action: #selector(CreditCardVC.textFieldDidChange(_:)), for: .editingChanged)
            cardNumberTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
            expiryDateTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
            expiryDateTextField.addTarget(self, action: #selector(CreditCardVC.textFieldDidChange(_:)), for: .editingChanged)
            editingChanged()
        }
        cardHolderTextField.addTarget(self, action: #selector(CreditCardVC.textFieldDidChange(_:)), for: .editingChanged)
        cardAliasTextField.addTarget(self, action: #selector(CreditCardVC.textFieldDidChange(_:)), for: .editingChanged)
                
        
        paymentTextField.delegate = self
        expiryDateTextField.delegate = self
        cardNumberTextField.delegate = self
        createTextField()
        
        paymentTextField.postalCodeEntryEnabled = false
        paymentTextField.isHidden = true
        creditCardView.chipImage = UIImage(named: "chip")
        creditCardView.colors[Brands.Visa.rawValue] = [UIColor.blue, UIColor.black]
        
        // Brands Color brand name, front color, back color
        //        [String: [UIColor]]
    }
    
    @objc func editingChanged() {
        cardNumberTextField.text = String(cardNumberTextField.text!.prefix(16))
        expiryDateTextField.text = String(expiryDateTextField.text!.prefix(5))
    }
    
    @objc func textFieldDidChange(_ textField: ACFloatingTextfield) {
        switch textField {
        case cardNumberTextField:
            var cardNumberArray = Array(cardNumberTextField.text!.replacingOccurrences(of: " ", with: ""))
            for (index,item) in cardNumberArray.enumerated() {
                if index == 3 {
                    cardNumberArray.insert(" ", at: 4)
                }
                if index == 8 {
                    cardNumberArray.insert(" ", at: 9)
                }
                if index == 13 {
                    cardNumberArray.insert(" ", at: 14)
                }
            }
            scannedCardNumberLabel.text = String(cardNumberArray.prefix(19))
            cardNumber = String(cardNumberArray.prefix(19))
            break
        case cardHolderTextField:
            creditCardView.cardHolderString = cardHolderTextField.text!
            break
        case expiryDateTextField:
            var expiryDateArray = Array(expiryDateTextField.text!)
//            for (index,item) in expiryDateArray.enumerated() {
//                if index == 1 {
//                    expiryDateArray.insert("/", at: 2)
//                    //                        expiryDateTextField.text?.insert("/", at: index)
//                }
//            }
            expiryDateLabel.text = String(expiryDateArray.prefix(5))
            expDate = String(expiryDateArray.prefix(5))
            break
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("did end editing")
        if textField == expiryDateTextField {
            if !validateExpiryDate(textField) {
                expiryDateTextField.showErrorWithText(errorText: "Expiry date is not valid")
            }
        }else
        if textField == cardNumberTextField {
            print("ended")
            if !validateCardNumber(textField.text!) {
                print("ended")
                cardNumberTextField.showErrorWithText(errorText: "Card number is not valid")
            }
        }
    }
    
    func validateExpiryDate(_ textField: UITextField) -> Bool {
        var success: Bool = true
        if textField.text!.count < 5 {
            success = false
            return success
        }
        let monthComponent = textField.text!.components(separatedBy: "/")[0]
        let yearComponent = textField.text!.components(separatedBy: "/")[1]
        if Int(monthComponent) > 12 || Int(monthComponent) < 1 {
            success = false
        }
        if Int(yearComponent) < (Date().year - 2000) {
            success = false
        }
        print("success: \(success)")
        return success
    }
    
    func validateCardNumber(_ textFieldValue: String) -> Bool {
        return CCValidator.validate(creditCardNumber: textFieldValue)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == expiryDateTextField {
            let text = (expiryDateTextField.text! as NSString).replacingCharacters(in: range, with: string)
            let count = text.count
            if string != "" {
                if count > 5
                {
                    return false
                }
                if count % 3 == 0{
                    expiryDateTextField.text?.insert("/", at: String.Index(utf16Offset: count - 1, in: text))
                }
                return true
            }
        }
        return true
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func createTextField() {
        paymentTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.size.width - 48, height: 44)
        paymentTextField.delegate = self
        paymentTextField.translatesAutoresizingMaskIntoConstraints = false
        paymentTextField.layer.masksToBounds = true
        
        view.addSubview(paymentTextField)
        
        NSLayoutConstraint.activate([
            paymentTextField.topAnchor.constraint(equalTo: enterCardDetailsLabel.bottomAnchor, constant: 20),
            paymentTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paymentTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-20),
            paymentTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
    }
    
    @IBAction func verifyBtnAction(_ sender: UIButton) {
        
        print("\(CCValidator.validate(creditCardNumber: cardNumberTextField.text!))")
        print(CCValidator.typeCheckingPrefixOnly(creditCardNumber: cardNumberTextField.text!))
        
        if cardHolderTextField.text!.isEmpty {
            
            let alert = UIAlertController(title: "Chango", message: "Please enter card holder name.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else if Int(cardHolderTextField.text!) != nil {
            showAlert(title: "Chango", message: "Card holder name cannot be numbers")
            
        }else if (cardNumberTextField.text!.isEmpty ) {
            
            let alert = UIAlertController(title: "Chango", message: "Please enter card number", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else if (expiryDateTextField.text!.isEmpty ) {
            let alert = UIAlertController(title: "Chango", message: "Please enter all card details", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else if (cardAliasTextField.text!.isEmpty ){
            let alert = UIAlertController(title: "Chango", message: "Please enter card alias", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else {
//            self.publicKeyEncryption(pan: self.cardNumber, cvv: self.cvc, expMonth: self.expMonth, expYear: self.expYear)
            
//            self.encryption(pan: self.cardNumber, cvv: self.cvc, expiry: "\(expMonth)\(expYear)")
            
            let vc: CvvVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cvv") as! CvvVC
            vc.pan = cardNumber
            vc.cardNumber = cardNumber
            vc.cardHolderName = cardHolderTextField.text!
            vc.expDate = expiryDateTextField.text!
            vc.cardAlias = cardAliasTextField.text!
            print(expiryDateTextField.text!)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func encryption(pan: String, cvv: String, expiry: String) {
        var api_token = UserDefaults.standard.string(forKey: "idToken")
        api_token = String(api_token!.prefix(32))
        print("token: \(api_token)")
        let body = ["pan": pan, "cvv": cvv,"expiry": expiry]

//        do {
//                    let sourceData = "\(body)".data(using: .utf8)!
//                    let password = api_token!
//                    let salt = AES256Crypter.randomSalt()
//                    let iv = AES256Crypter.randomIv()
//            let key = try AES256Crypter.createKey(password: password.data(using: .utf8)!, salt: salt)
//                    let aes = try AES256Crypter(key: key, iv: iv)
//                    let encryptedData = try aes.encrypt(sourceData)
//                    let decryptedData = try aes.decrypt(encryptedData)
//
//                    print("Encrypted hex string: \(encryptedData.hexString)")
//                    print("Decrypted hex string: \(decryptedData.hexString)")
//                } catch {
//                    print("Failed")
//                    print(error)
        var dataToEncrypt: String = ""
        let dic = body
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dic) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonData)
                 dataToEncrypt = jsonString
            }
        }
        
//                }
        
        
        // Encryption
//        let data: Data = "\(pan)".data(using: .utf8)!
//        let password = api_token!
//        let ciphertext = RNCryptor.encrypt(data: data, withPassword: password)
//
//        print("cipher: \(ciphertext.hexString)")
//        // Decryption
//        do {
//            let originalData = try RNCryptor.decrypt(data: ciphertext, withPassword: password)
//            print("original: \(originalData.hexString)")
//            // ...
//        } catch {
//            print(error)
//        }
        
//        do {
//            let aes = try AES(keyString: api_token!)
//
//            let stringToEncrypt: String = dataToEncrypt
//            print("String to encrypt:\t\t\t\(stringToEncrypt)")
//
//            let encryptedData: Data = try aes.encrypt(stringToEncrypt)
//            print("String encrypted (base64):\t\(encryptedData.base64EncodedString())")
//
//            let decryptedData: String = try aes.decrypt(encryptedData)
//            print("String decrypted:\t\t\t\(decryptedData)")
//
//        } catch {
//            print("Something went wrong: \(error)")
//        }
    }
    
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationMonth), cvc: textField.cvc)
            cardNumber = textField.cardNumber!
            expYear = Int(textField.expirationYear)
            expMonth = Int(textField.expirationMonth)
            if (textField.cvc != nil) {
                cvc = textField.cvc!
            }
        
        print("(CreditCard(pan=\(cardNumber),cvv=\(cvc),expiry=\(expMonth)/\(expYear)")
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
        expYear = Int(textField.expirationYear)
        expMonth = Int(textField.expirationMonth)
        if (textField.cvc != nil) {
            cvc = textField.cvc!
        }
        print("(CreditCard(pan=\(cardNumber),cvv=\(cvc),expiry=\(expMonth)/\(expYear)")

    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingCVC()
    }

    
    
    func publicKeyEncryption(pan: String, cvv:String, expMonth: Int, expYear: Int) {
        let sodium = Sodium()
        let iOSKeyPair = sodium.box.keyPair()!
        let backEndKeyPair = sodium.box.keyPair()!
        let nonceKeyPair = sodium.box.nonce()
        let message = "CreditCard(pan=\(pan),cvv=\(cvv),expiry=\(expMonth)/\(expYear)".bytes
        
        print("1: \(iOSKeyPair.publicKey)")
        print("1: \(iOSKeyPair.secretKey)")
        print("1: \(backEndKeyPair.publicKey)")
        print("1: \(backEndKeyPair.secretKey)")
                
        print("public key: \(publicKey)")
        print("secret key: \(secretKey)")
        print("my secret key: \(mySecretKey)")
        print("msg: \(message)")
        print("nonce: \(nonceKeyPair)")
        
//        let encryptedMessageFromMyKeyToBackEnd: Bytes = sodium.box.seal(message: message, recipientPublicKey: backEndKeyPair.publicKey, senderSecretKey: iOSKeyPair.secretKey, nonce: nonceKeyPair)!
        
        let encryptedMessageFromMyKeyToBackEnd: Bytes = sodium.box.seal(message: message, recipientPublicKey: publicKey, senderSecretKey: mySecretKey, nonce: nonceKeyPair)!
        
        print("publicKey: \(iOSKeyPair.publicKey)")
        print("encrypted Message: \(encryptedMessageFromMyKeyToBackEnd)")
        

//        let messageVerifiedAndDecryptedByBackend =
//            sodium.box.open(authenticatedCipherText: encryptedMessageFromMyKeyToBackEnd, senderPublicKey: iOSKeyPair.publicKey, recipientSecretKey: backEndKeyPair.secretKey, nonce: nonceKeyPair)
        
        let messageVerifiedAndDecryptedByBackend =
            sodium.box.open(authenticatedCipherText: encryptedMessageFromMyKeyToBackEnd, senderPublicKey: myPublicKey, recipientSecretKey: secretKey, nonce: nonceKeyPair)
        
        print("decrypted Message: \(messageVerifiedAndDecryptedByBackend)")
        
        if let string = String(bytes: messageVerifiedAndDecryptedByBackend!, encoding: .utf8) {
            print(string)
        } else {
            print("not a valid UTF-8 sequence")
        }

        print("1: \(iOSKeyPair.publicKey)")
        print("1: \(iOSKeyPair.secretKey)")
        print("1: \(backEndKeyPair.publicKey)")
        print("1: \(backEndKeyPair.secretKey)")
        
        
        //Hex encoding
//        let hexPublicKey = sodium.utils.bin2hex(backEndKeyPair.publicKey)
//        let hexSecretKey = sodium.utils.bin2hex(backEndKeyPair.secretKey)
//        let hexMyPublicKey = sodium.utils.bin2hex(iOSKeyPair.publicKey)
//        let hexMySecretKey = sodium.utils.bin2hex(iOSKeyPair.secretKey)
        let hexNonce = sodium.utils.bin2hex(nonceKeyPair)
        let hexMessage = sodium.utils.bin2hex(encryptedMessageFromMyKeyToBackEnd)
        
//        publicKeyHex = hexPublicKey!
//        secretKeyHex = hexSecretKey!
//        myPublicKeyHex = hexMyPublicKey!
//        mySecretKeyHex = hexMySecretKey!
        
//        print("hex public key: \(publicKeyHex)")
//        print("hex secret key: \(secretKeyHex)")
//        print("hex my public key: \(myPublicKeyHex)")
        print("hex nonce: \(hexNonce!)")
        print("hex message: \(hexMessage!)")
        
//        let data1 = sodium.utils.hex2bin(publicKeyHex)
//        let data2 = sodium.utils.hex2bin(secretKeyHex)
//        let data3 = sodium.utils.hex2bin(myPublicKeyHex)

//        print("dehex public key: \(data1!)")
//        print("dehex secret key: \(data2!)")
//        print("dehex my public key: \(data3!)")

        
//        byte values
//        publicKey = [215, 145, 194, 166, 72, 60, 87, 69, 155, 156, 37, 226, 252, 109, 200, 88, 148, 54, 7, 167, 208, 104, 120, 2, 242, 104, 236, 151, 250, 248, 250, 0]
//        secretKey = [3, 71, 8, 87, 230, 231, 241, 251, 223, 142, 228, 227, 230, 241, 232, 0, 135, 227, 71, 116, 91, 175, 205, 177, 43, 82, 229, 213, 202, 237, 137, 123]
//        mypublicKey = [240, 70, 226, 130, 64, 199, 232, 119, 138, 128, 185, 157, 68, 107, 48, 221, 216, 24, 147, 109, 77, 167, 234, 153, 38, 55, 119, 145, 87, 211, 254, 125]
//        mySecretKey = [165, 194, 83, 14, 127, 227, 187, 171, 33, 192, 19, 157, 52, 152, 5, 125, 23, 181, 82, 111, 3, 210, 32, 15, 217, 145, 11, 163, 172, 141, 182, 73]
//        hex values
//        publicKeyHex = d791c2a6483c57459b9c25e2fc6dc858943607a7d0687802f268ec97faf8fa00
//        secretKeyHex = 03470857e6e7f1fbdf8ee4e3e6f1e80087e347745bafcdb12b52e5d5caed897b
//        myPublicKeyHex = f046e28240c7e8778a80b99d446b30ddd818936d4da7ea992637779157d3fe7d
        
//        let parameter : AddCreditCardParameter = AddCreditCardParameter(body: hexMessage!, encodingType: "hex", nonce: hexNonce!)
//        self.addCreditCard(addCreditCardParameter: parameter)
    }
    
    
    //ADD ALIAS DIALOG
      func showAddAliasDialog(animated: Bool = true) {
          
          //create a custom view controller
          let aliasVC = AddAliasVC(nibName: "AddAliasVC", bundle: nil)
          
          //create the dialog
          let popup = PopupDialog(viewController: aliasVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
          
          //create first button
          let buttonOne = CancelButton(title: "CANCEL", height: 60) {
              //            self.label.text = "You canceled password reset"
          }
          
          //create second button
          let buttonTwo = DefaultButton(title: "SAVE", height: 60) {
            if(aliasVC.cardAliasTextField.text?.isEmpty)!{
                  let alert = UIAlertController(title: "Card Alias", message: "Please enter card alias.", preferredStyle: .alert)
                  
                  let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                      
                  }
                  
                  alert.addAction(OKAction)
                  
                  self.present(alert, animated: true, completion: nil)
                  
              }else {

                
                self.publicKeyEncryption(pan: self.cardNumber, cvv: self.cvc, expMonth: self.expMonth, expYear: self.expYear)
                                
            }
          }
          
          //Add buttons to dialog
          popup.addButtons([buttonOne, buttonTwo])
          
          //Present dialog
          present(popup, animated: animated, completion: nil)
          
      }



}

extension String {
    func chunkFormatted(withChunkSize chunkSize: Int = 4,
        withSeparator separator: Character = "-") -> String {
        return filter { $0 != separator }.chunk(n: chunkSize)
            .map{ String($0) }.joined(separator: String(separator))
    }
}

extension Collection {
    public func chunk(n: IndexDistance) -> [SubSequence] {
        var res: [SubSequence] = []
        var i = startIndex
        var j: Index
        while i != endIndex {
            j = index(i, offsetBy: n, limitedBy: endIndex) ?? endIndex
            res.append(self[i..<j])
            i = j
        }
        return res
    }
}
