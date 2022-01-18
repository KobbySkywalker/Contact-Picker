//
//  UpdatEmailViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 30/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FTIndicator
import Alamofire

class UpdatEmailViewController: BaseViewController {

    @IBOutlet weak var email: ACFloatingTextfield!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showChatController()
        disableDarkMode()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func emailButtonClick(_ sender: Any) {
        let currentUser = Auth.auth().currentUser

        if (email.text!.isEmpty){
            let alert = UIAlertController(title: "Update Email", message: "Please enter email address.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else if currentUser?.email == email.text!  {
            showAlert(title: "Update Email", message: "This is your current email address.")
        }else {
                print("CHANGED")
                Auth.auth().currentUser?.updateEmail(to: self.email.text!) { (error) in
                    if(!(error != nil)){
                        print("UPDATE PROFILE SUCCESSFUL")
                        
                        self.updateEmail()
                        FTIndicator.showProgress(withMessage: "loading")
                        
                    }else{
                        print("Error again")
                        print(error!)
                        self.showAlert(title: "Update Email", message: error!.localizedDescription)
                    }
                }
        }
    }
    
    
    func updateEmail() {
        AuthNetworkManager.updateEmail() { (result) in
            self.parseUpdateEmailResponse(result: result)
        }
    }
    
    private func parseUpdateEmailResponse(result: DataResponse<RegularResponse, AFError>){
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            FTIndicator.dismissProgress()
            
            let alert = UIAlertController(title: "Vote", message: "Email has been changed successfully." , preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in

                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: SettingsVC.self){
                        self.navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                }            }
            
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
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
