//
//  MobileNetworkVC.swift
//  Alamofire
//
//  Created by Hosny Ben Savage on 23/03/2020.
//

import UIKit
import FTIndicator
import Alamofire
import Nuke

class MobileNetworkVC: BaseViewController {
    
    @IBOutlet weak var networkLogo: UIImageView!
    @IBOutlet weak var networkName: UILabel!
    @IBOutlet weak var phoneNumberField: ACFloatingTextfield!
    @IBOutlet weak var verifyButton: UIButton!
    
    
    var network: String = ""
    var networkIcon: String = ""
    var fromWalletView: Bool = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()
        showChatController()

        networkName.text = network
        networkLogo.image = nil
        networkLogo.image = UIImage(named: "defaultgroupicon")
        let url = URL(string: networkIcon)
        if(networkIcon == "<null>") || (networkIcon == "") {
            networkLogo.image = UIImage(named: "defaultgroupicon")
        }else {
            Nuke.loadImage(with: url!, into: networkLogo)
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func verifiyButtonAction(_ sender: UIButton) {
        
        if phoneNumberField.text!.isEmpty {
            let alert = UIAlertController(title: "Chango", message: "Please enter a valid \(networkName.text!) number.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else {
            FTIndicator.showProgress(withMessage: "loading")
            let parameter: WalletOTPGenerationParameter = WalletOTPGenerationParameter(msisdn: phoneNumberField.text!)
            generateWalletOTP(generateOTPParameter: parameter)
        }
        
    }
    
    //GENERATE WALLET OTP
    func generateWalletOTP(generateOTPParameter: WalletOTPGenerationParameter) {
        AuthNetworkManager.generateOTPForWallet(parameter: generateOTPParameter) { (result) in
            self.parseGenerateOTPForWalletResponse(result: result)
        }
    }
    
    
    private func parseGenerateOTPForWalletResponse(result: DataResponse<ResponseMessage, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            
            if response.responseCode == "100" {
                let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in

                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }else {
//            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                let vc: MobileVerificationCodeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcode") as! MobileVerificationCodeVC
                
                vc.phoneNumber = self.phoneNumberField.text!
                vc.network = self.network
                vc.networkIcon = self.networkIcon
                vc.fromWalletView = false
                self.navigationController?.pushViewController(vc, animated: true)
//            }
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
            }
                        
            break
        case .failure( _):
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
