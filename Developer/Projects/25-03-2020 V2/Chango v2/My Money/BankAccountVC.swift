//
//  BankAccountVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 24/03/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import Nuke
import FTIndicator
import Alamofire

class BankAccountVC: BaseViewController {
    
    @IBOutlet weak var bankLogo: UIImageView!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var accountNumberField: ACFloatingTextfield!
    @IBOutlet weak var accountHolderField: ACFloatingTextfield!
    
    var bankName: String = ""
    var bankIcon: String = ""
    var bankCode: String = ""
    var fromWalletView: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        disableDarkMode()
        showChatController()
        
        bankNameLabel.text = bankName
        bankLogo.image = nil
        bankLogo.backgroundColor = .white
        bankLogo.image = UIImage(named: "defaultgroupicon")
        let url = URL(string: bankIcon)
        if(bankIcon == "<null>") || (bankIcon == "") {
            bankLogo.image = UIImage(named: "defaultgroupicon")
        }else {
            Nuke.loadImage(with: url!, into: bankLogo)
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        
        if accountNumberField.text!.isEmpty {
            let alert = UIAlertController(title: "Chango", message: "Please enter account number.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else if accountHolderField.text!.isEmpty {
            let alert = UIAlertController(title: "Chango", message: "Please enter account holder name.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else if (Int(accountHolderField.text!) != nil) {
            showAlert(title: "Chango", message: "Account holder name cannot be only numeric.")
        }else {
            FTIndicator.showProgress(withMessage: "loading")
            let parameter: AddWalletParameter = AddWalletParameter(channelId: "bank", destinationCode: self.bankCode, paymentDestinationNumber: self.accountNumberField.text!, walletName: self.accountHolderField.text!)
            addWallet(addWalletParameter: parameter)
        }
    }
    
    func addWallet(addWalletParameter: AddWalletParameter) {
        AuthNetworkManager.addWallet(parameter: addWalletParameter) { (result) in
            self.parseAddWallet(result: result)
        }
    }
    
    private func parseAddWallet(result: DataResponse<AddWalletResponse, AFError>){
        switch result.result {
        case .success(let response):
            FTIndicator.dismissProgress()
            print("response: \(response)")
                
            if response.responseCode! == "01" {
                let vc: CompleteVerificationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verified") as! CompleteVerificationVC
                vc.network = bankName
                vc.networkIcon = bankIcon
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let alert = UIAlertController(title: "Wallets", message: response.responseMessage, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
                
//                if (self.fromWalletView == false) {
//                    for controller in self.navigationController!.viewControllers as Array {
//                        if controller.isKind(of: PrivateGroupDashboardVC.self){
//                            self.navigationController?.popToViewController(controller, animated: true)
//                        }
//                    }
//                }else {
//                    for controller in self.navigationController!.viewControllers as Array {
//                        if controller.isKind(of: SettingsVC.self){
//                            self.navigationController?.popToViewController(controller, animated: true)
//                        }
//                    }
//                }

            break
        case .failure( _):
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
