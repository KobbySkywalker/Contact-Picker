//
//  CompleteCardVerificationVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 19/02/2021.
//  Copyright © 2021 IT Consortium. All rights reserved.
//

import UIKit
import CreditCardForm

class CompleteCardVerificationVC: UIViewController {

    @IBOutlet weak var creditCardView: CreditCardFormView!
    @IBOutlet weak var scannedCardNumberView: UIView!
    @IBOutlet weak var scannedCardNumberLabel: UILabel!
    @IBOutlet weak var cardExpiryLabel: UILabel!
    
    var cardNumber: String = ""
    var cardHolderName: String = ""
    var cardAlias: String = ""
    var monthExpiry: String = ""
    var yearExpiry: String = ""
    var expDate: String = ""
    var walletId: String = ""
    var nickName = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        scannedCardNumberLabel.text = cardNumber
        creditCardView.cardHolderString = cardHolderName
        cardExpiryLabel.text = expDate
        creditCardView.chipImage = UIImage(named: "chip")
    }
    
    @IBAction func okayButtonAction(_ sender: Any) {
        verifyNowOrLater()
    }
    
    func verifyNowOrLater(){
        let alert = UIAlertController(title: "Chango", message: "Would you like to verify your card right away?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action: UIAlertAction!) in
            let vc: VerifyCardVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verifycard") as! VerifyCardVC
            vc.walletId = self.walletId
            vc.cardHolderName = self.nickName 
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let cancelAction = UIAlertAction(title: "No, verify later", style: .default) { (action: UIAlertAction!) in
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: WalletsVC.self){
                    self.navigationController?.popToViewController(controller, animated: true)
                }
            }
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    
}
