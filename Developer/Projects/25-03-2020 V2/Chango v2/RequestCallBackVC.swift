//
//  RequestCallBackVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 22/10/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Alamofire
import FTIndicator

class RequestCallBackVC: BaseViewController {

    @IBOutlet weak var phoneNumberTextField: ACFloatingTextfield!
    
    var loginCheck: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableDarkMode()
        showChatController()
        
        if let phoneNumber : String = Auth.auth().currentUser?.phoneNumber {
            phoneNumberTextField.text = phoneNumber
        }else {
            phoneNumberTextField.text = ""
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        if loginCheck == 0 {
            self.dismiss(animated: true, completion: nil)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    

    @IBAction func callBackButtonAction(_ sender: Any) {
        FTIndicator.showProgress(withMessage: "loading")
        let parameter: RequestACallbackParameter = RequestACallbackParameter(contactNumber: phoneNumberTextField.text!)
        self.requestACallback(requestACallbackParameter: parameter)
    }

    
    //REQUEST A CALL BACK
    func requestACallback(requestACallbackParameter: RequestACallbackParameter) {
        AuthNetworkManager.requestACallback(parameter: requestACallbackParameter) { (result) in
            self.parseRequestACallbackResponse(result: result)
        }
    }
    
    private func parseRequestACallbackResponse(result: DataResponse<RevokeLoanApproverResponse, AFError>){
        switch result.result {
        case .success(let response):
            FTIndicator.dismissProgress()
            print("response: \(response)")
            
            let alert = UIAlertController(title: "Contact Us", message: response.responseMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            break
        case .failure(let error):
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
