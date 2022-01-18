//
//  MobileVerificationCodeVC.swift
//  Alamofire
//
//  Created by Hosny Ben Savage on 23/03/2020.
//

import UIKit
import Alamofire
import FTIndicator
import KWVerificationCodeView
import Nuke

class MobileVerificationCodeVC: BaseViewController {

    @IBOutlet weak var verificationCodeTextField: KWVerificationCodeView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var networkImage: UIImageView!
    @IBOutlet weak var networkLabel: UILabel!
    
    var phoneNumber: String = ""
    var verificationCode: String = ""
    var network: String = ""
    var networkIcon: String = ""
    var fromWalletView: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        disableDarkMode()
        showChatController()
        verificationCodeTextField.delegate = self as? KWVerificationCodeViewDelegate
        
        NotificationCenter.default.addObserver( self,selector:#selector(self.keyboardDidShow), name: UITextField.textDidChangeNotification, object: verificationCodeTextField)

        networkLabel.text = network
        networkImage.image = nil
        networkImage.image = UIImage(named: "defaultgroupicon")
        let url = URL(string: networkIcon)
        if(networkIcon == "<null>") || (networkIcon == "") {
            networkImage.image = UIImage(named: "defaultgroupicon")
        }else {
            Nuke.loadImage(with: url!, into: networkImage)
        }
    }
    
    @objc func keyboardDidShow(notifcation: NSNotification) {
        if verificationCodeTextField.digits == 5 {
            print("picked")
//            buttonContinue.isEnabled = true
//            buttonLogin(buttonContinue)
        } else {
//            buttonContinue.isEnabled = false
            print("didn't")
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        
        if verificationCodeTextField.hasValidCode() == false {
            let alert = UIAlertController(title: "Chango", message: "Please enter verification code.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else {
            print("print - \(verificationCodeTextField.hasValidCode())")
            FTIndicator.showProgress(withMessage: "loading")
            let parameter: WalletOTPVerificationParameter = WalletOTPVerificationParameter(msisdn: phoneNumber, enteredPin: verificationCodeTextField.getVerificationCode())
            verifyWalletOTP(verifyOTPParameter: parameter)
        }
    }
    
    @IBAction func resendCodeButtonAction(_ sender: Any) {
        let parameter: WalletOTPGenerationParameter = WalletOTPGenerationParameter(msisdn: phoneNumber)
        generateWalletOTP(generateOTPParameter: parameter)
    }
    
    
    //VERIFY WALLET BY OTP
    
    func verifyWalletOTP(verifyOTPParameter: WalletOTPVerificationParameter) {
        AuthNetworkManager.verifyOTPForWallet(parameter: verifyOTPParameter) { (result) in
            self.parseVerifyOTPForWalletResponse(result: result)
        }
    }
    
    private func parseVerifyOTPForWalletResponse(result: DataResponse<ResponseMessage, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                if response.responseCode == "01" {
                    let parameter: AddWalletParameter = AddWalletParameter(channelId: "wallet", destinationCode: self.network, paymentDestinationNumber: self.phoneNumber, walletName: "")
                self.addWallet(addWalletParameter: parameter)
                FTIndicator.showProgress(withMessage: "adding wallet")
                }else {
                    
                }
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
                        
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
            
            if response.responseCode! == "100" {
                let alert = UIAlertController(title: "Wallets", message: response.responseMessage, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: WalletsVC.self){
                            self.navigationController?.popToViewController(controller, animated: true)
                        }
                    }
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            }
                
                let vc: CompleteVerificationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verified") as! CompleteVerificationVC
                
                //            let alert = UIAlertController(title: "Wallets", message: response.responseMessage, preferredStyle: .alert)
                //
                //            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                vc.network = self.network
                vc.networkIcon = self.networkIcon
                vc.fromWalletView = false
                self.navigationController?.pushViewController(vc, animated: true)
                //            }
                
                //            alert.addAction(okAction)
                //            self.present(alert, animated: true, completion: nil)
                
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
            showAlert(title: "Chango", message: response.responseMessage!)
                        
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
