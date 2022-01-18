//
//  CampaignContributeViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 01/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import DropDown


class CampaignContributeViewController: BaseViewController {
    
    @IBOutlet weak var groupName: NiceButton!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var contributeButton: UIButton!
    @IBOutlet weak var contributeView: UIView!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var dropDownView: UIStackView!
    
    var publicGroup: GroupResponse!
    var campaignNames: [String] = []
    var campaignIds: [String] = []
    var campaignId: String = ""
    var userNumber: String = ""
    var userNetwork: String = ""
    var paymentDuration: String = ""
    var repeatCycle: String = ""
    var anonymous: String = "false"
    var maxSingleContributeLimit: String = ""

    let dropDown = DropDown()
    
    let campaignDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.campaignDropDown
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showChatController()
        disableDarkMode()

        contributeView.layer.cornerRadius = 10
        contributeView.layer.shadowColor = UIColor.black.cgColor
        contributeView.layer.shadowOffset = CGSize(width: 2, height: 4)
        contributeView.layer.shadowRadius = 8
        contributeView.layer.shadowOpacity = 0.2
        
        contributeButton.cornerRadius = 15
        
        setupDropDowns()
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        
        self.memberNetwork()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = publicGroup.groupName
        self.navigationItem.titleView?.tintColor = UIColor.white
        print(publicGroup.groupName)
    }
    
    
    func setupDropDowns() {
        setupCampaignDropDown()
    }
    
    func setupCampaignDropDown(){
        campaignDropDown.anchorView = dropDownView
//        campaignDropDown.anchorView = dropDownButton
        
        campaignDropDown.bottomOffset = CGPoint(x: 0, y: campaignDropDown.bounds.height + 40)
        
        
        campaignDropDown.dataSource = campaignNames
        

//        Action triggered on selection
        campaignDropDown.selectionAction = { [weak self] (index, item) in
            print("Selected item: \(item) at \(index)")
            self!.groupName.titleLabel?.text = item
            self!.campaignId = self!.campaignIds[index]
            print(self!.campaignId)
            
            self!.campaignDropDown.backgroundColor = UIColor.white
            self!.campaignDropDown.selectionBackgroundColor = UIColor.white

        }
        
        campaignDropDown.width = 200
        
    }
    

    @IBAction func dropDownButtonAction(_ sender: UIButton) {
        campaignDropDown.show()

    }
   
    @IBAction func ContributeButtonAction(_ sender: UIButton) {
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
            
            print(campaignId)
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
    
    func memberNetwork() {
        AuthNetworkManager.memberNetwork { (result) in
            self.parsememberNetworkResponse(result: result)
        }
    }
    
    
    
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
                let vc: MainMenuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "menu") as! MainMenuViewController
                //                self.present(vc, animated: true, completion: nil)
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
    
    
    //NEW CONTRIBUTION FOR WALLETS
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
            let alert = UIAlertController(title: "Chango", message: "Payment Processing. Please accept the mobile money prompt on your phone.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                let vc: MainMenuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "menu") as! MainMenuViewController
                //                self.present(vc, animated: true, completion: nil)
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
