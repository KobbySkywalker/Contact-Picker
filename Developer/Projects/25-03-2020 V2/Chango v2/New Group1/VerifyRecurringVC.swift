//
//  VerifyRecurringVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 23/10/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAuth
import FTIndicator
import Nuke

class VerifyRecurringVC: BaseViewController {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var verifyTextField: ACFloatingTextfield!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var hideShowButton: UIButton!
    
    var amount: Double = 0.0
    var campaignId: String = ""
    var currency: String = ""
    var groupId: String = ""
    var duration: String = ""
    var freqType: String = ""
    var msisdn: String = ""
    var narration: String = ""
    var network: String = ""
    var recurring: String = ""
    var voucherCode: String = ""
    var othersMsisdn: String = ""
    var othersMemberId: String = ""
    var anonymous: String = ""
    var publicGroupCheck: Int = 0
    var groupIconPath: String = ""
    var campaignName: String = ""
    var iconClick = true

    override func viewDidLoad() {
        super.viewDidLoad()

        groupNameLabel.text = campaignName
        if (groupIconPath == "<null>") || (groupIconPath == nil) || (groupIconPath == ""){
            groupImage.image = UIImage(named: "defaultgroupicon")
            groupImage.contentMode = .center
        }else {
            Nuke.loadImage(with: URL(string: groupIconPath)!, into: groupImage)
        }
        print("freq: \(freqType), duration: \(duration)")
    }
    

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func hideShowButtonAction(_ sender: UIButton) {
        
        if(iconClick == true) {
            sender.setTitle("HIDE", for: .normal)
            verifyTextField.isSecureTextEntry = false
            print("made visible so image invisible")
        } else {
            sender.setTitle("SHOW", for: .normal)
            verifyTextField.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
        
    }
    
    @IBAction func verifyButtonAction(_ sender: Any) {
        if(verifyTextField.text?.isEmpty)!{
            self.showAlert(title: "Recurring Payment Verification", message: "Please enter password")
        }else {
            FTIndicator.init()
            FTIndicator.setIndicatorStyle(UIBlurEffect.Style.dark)
            FTIndicator.showProgress(withMessage: "Checking", userInteractionEnable: false)
            //Firebase Auth
            var currentUser = Auth.auth().currentUser
            Auth.auth().signIn(withEmail: (currentUser?.email)!, password: verifyTextField.text!) { (user, error) in
                if error != nil {
                    FTIndicator.dismissProgress()
                    self.showAlert(withTitle: "Recurring Payment", message: "Invalid credentials")
                    print(error?.localizedDescription)
                } else {
                    //call endpoint
                    let parameter: MakeContributionParameter = MakeContributionParameter(amount: self.amount, campaignId: self.campaignId, currency: self.currency, destination: "", groupId: self.groupId, invoiceId: "", duration: self.duration, freqType: self.freqType, msisdn: self.msisdn, narration: self.narration, network: self.network, recurring: "true", voucher: self.voucherCode, othersMsisdn: self.othersMsisdn, othersMemberId: self.othersMemberId, anonymous: self.anonymous)
        self.makeContribution(makeContributionParameter: parameter)
        FTIndicator.showProgress(withMessage: "loading")
                    }
                }
            }
        }
    
    //CONTRIBUTE
    func makeContribution(makeContributionParameter: MakeContributionParameter) {
        AuthNetworkManager.makeContribution(parameter: makeContributionParameter) { (result) in
            self.parseMakeContributionResponse(result: result)
        }
    }
    
    private func parseMakeContributionResponse(result: DataResponse<ContributeResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
                let alert = UIAlertController(title: "Chango", message: "\(response.responseMessage!)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    if self.publicGroupCheck == 1 {
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: PublicGroupDashboardVC.self){
                                self.navigationController?.popToViewController(controller, animated: true)
                            }
                        }
                    }else {
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: PrivateGroupDashboardVC.self){
                                (controller as! PrivateGroupDashboardVC).refreshPage = true
                                self.navigationController?.popToViewController(controller, animated: true)
                            }
                        }
                    }
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    //CONTRIBUTION FOR WALLET
    func contribute(contributeParameter: ContributeParameter) {
        AuthNetworkManager.contribute(parameter: contributeParameter) { (result) in
            self.parseContributeResponse(result: result)
        }
    }
    
    private func parseContributeResponse(result: DataResponse<RegularResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")

                let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: MainMenuTableViewController.self){
                            (controller as! MainMenuTableViewController).refreshPage = true
                            self.navigationController?.popToViewController(controller, animated: true)
                        }
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

}
