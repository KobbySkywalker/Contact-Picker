//
//  PublicCampaginContributeViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 21/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator

class PublicCampaginContributeViewController: BaseViewController {

    @IBOutlet weak var contributionView: UIView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var contribute: UIButton!

    
    var publicGroup: GroupResponse!
    var userNumber: String = ""
    var userNetwork: String = ""
    var campaignId: String = ""
    var campaignName: String = ""
    var paymentDuration: String = ""
    var repeatCycle: String = ""
    var anonymous: String = "false"
    var maxContributionPerDay: Int = 0
    var currency: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()

        groupName.text = campaignName
        
        contributionView.layer.cornerRadius = 10
        contributionView.layer.shadowColor = UIColor.black.cgColor
        contributionView.layer.shadowOffset = CGSize(width: 2, height: 4)
        contributionView.layer.shadowRadius = 8
        contributionView.layer.shadowOpacity = 0.2
        
        contribute.cornerRadius = 15
        
        self.memberNetwork()
        

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = publicGroup.groupName
        self.navigationItem.titleView?.tintColor = UIColor.white
        print(publicGroup.groupName)
    }
    

    @IBAction func contributeButtonAction(_ sender: UIButton) {
        if (amount.text?.isEmpty)! {
            let alert = UIAlertController(title: "Make Contribution", message: "Please enter an amount", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else if (amount.text == "0") {
            let alert = UIAlertController(title: "Make Contribution", message: "Amount cannot be ", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else {
            
            let am = Double(amount.text!)
            print(am!)
            
            //            print(publicGroup.campaignId)
            print(publicGroup.countryId.currency)
            print(publicGroup.groupId)
            print(publicGroup.groupName)
            print(userNetwork)
            print(userNumber)
            print(campaignId)
            let parameter: MakeContributionParameter = MakeContributionParameter(amount: Double(amount.text!)!, campaignId: campaignId, currency: publicGroup.countryId.currency, destination: "", groupId: publicGroup.groupId, invoiceId: "", duration: paymentDuration, freqType: repeatCycle, msisdn: userNumber, narration: publicGroup.groupName, network: userNetwork, recurring: "false", voucher: "", othersMsisdn: "", othersMemberId: "", anonymous: anonymous)
            makeContribution(makeContributionParameter: parameter)
            
            FTIndicator.showProgress(withMessage: "loading")
        }
    }
    
    //PUBLIC CAMPAIGN CONTRIBUTION
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
            let alert = UIAlertController(title: "Chango", message: "Payment Processing. Please accept the mobile money prompt on your phone.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//                let vc: MainMenuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "menu") as! MainMenuViewController
                //                self.present(vc, animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            break
        case .failure(let error):
            
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

    
    
    func memberNetwork() {
        AuthNetworkManager.memberNetwork { (result) in
            self.parsememberNetworkResponse(result: result)
        }
    }
    
    
    private func parsememberNetworkResponse(result: DataResponse<MemberNetworkResponse, AFError>){
        switch result.result {
        case .success(let response):
            print(response)
            userNumber = response.msisdn
            userNetwork = response.network
            break
        case .failure(let error):
            if result.response?.statusCode == 400 {
                
                sessionTimeout()
                
            }
            print(NetworkManager().getErrorMessage(response: result))
        }
    }
    

    
}
