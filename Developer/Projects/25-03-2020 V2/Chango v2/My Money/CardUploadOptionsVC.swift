//
//  CardUploadOptionsVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 17/02/2021.
//  Copyright © 2021 IT Consortium. All rights reserved.
//

import UIKit
import CardScan
import Stripe
import PayCardsRecognizer

class CardUploadOptionsVC: UIViewController, ScanDelegate, PayCardsRecognizerPlatformDelegate {

    var recognizer: PayCardsRecognizer!
    var viewController: CreditCardVC!
    var fromWalletView: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // It's important that this goes in viewWillAppear because the user may
        // deny permission on the ScanViewController, in which case the button
        // must be hidden to avoid future presses.
//        if !ScanViewController.isCompatible() {
//            // Hide your "scan card" button because this device isn't compatible
//            // with CardScan
//        }
        //Pay Cards call

    }

        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        recognizer.stopCamera()
    }
    
    // PayCardsRecognizerPlatformDelegate
    
    func payCardsRecognizer(_ payCardsRecognizer: PayCardsRecognizer, didRecognize result: PayCardsRecognizerResult) {
        
        print("results recorded")
        print("res: \(result.recognizedNumber)") // Card number
        print(result.recognizedHolderName) // Card holder
        print(result.recognizedExpireDateMonth) // Expire month
        print(result.recognizedExpireDateYear) // Expire year
        let vc: CreditCardVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "card") as! CreditCardVC
        recognizer.stopCamera()

        vc.scanned = true
        vc.cardNumber = result.recognizedNumber!
        
        if result.recognizedHolderName != nil {
            vc.cardHolderName = result.recognizedHolderName!
        }

        if result.recognizedExpireDateMonth != nil && result.recognizedExpireDateYear != nil {
            vc.expDate = "\(result.recognizedExpireDateMonth!)/\(result.recognizedExpireDateYear!)"
        }
        if !(navigationController?.topViewController is (CreditCardVC)) {
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func takePictureButtonAction(_ sender: Any) {
        guard let vc = ScanViewController.createViewController(withDelegate: self) else {
            print("This device is incompatible with CardScan")
            return
        }
        self.present(vc, animated: true)
//        recognizer = PayCardsRecognizer(delegate: self, resultMode: .async, container: self.view, frameColor: .green)
//
//        recognizer.startCamera()


    }

    func userDidSkip(_ scanViewController: ScanViewController) {
        self.dismiss(animated: true)
    }

    func userDidCancel(_ scanViewController: ScanViewController) {
        self.dismiss(animated: true)
    }

    func userDidScanCard(
        _ scanViewController: ScanViewController,
        creditCard: CreditCard
    ) {
        let number = creditCard.number
        let expiryMonth = creditCard.expiryMonth
        let expiryYear = creditCard.expiryYear

        // If you're using Stripe and you include the CardScan/Stripe pod, you
        // can get `STPCardParams` directly from CardScan `CreditCard` objects,
        // which you can use with Stripe's APIs
//        let cardParams = creditCard.cardParams()
        print("\(number), \(expiryMonth), \(expiryYear)")

        // At this point you have the credit card number and optionally the
        // expiry. You can either tokenize the number or prompt the user for
        // more information (e.g., CVV) before tokenizing.
        self.dismiss(animated: true)
        let vc: CreditCardVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "card") as! CreditCardVC
        vc.scanned = true
        vc.cardNumber = number

        if expiryMonth != nil && expiryYear != nil {
            vc.expDate = "\(creditCard.expiryMonth!)/\(creditCard.expiryYear!)"
        }
        print("card: \(number)")
        self.navigationController?.pushViewController(vc, animated: true)
        }
    
    
    @IBAction func enterDetailsButtonAction(_ sender: Any) {
        let vc: CreditCardVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "card") as! CreditCardVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

