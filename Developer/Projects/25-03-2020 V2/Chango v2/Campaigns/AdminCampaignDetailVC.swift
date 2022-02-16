//
//  AdminCampaignDetailVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 08/12/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator
import Nuke
import Alamofire

class AdminCampaignDetailVC: BaseViewController {

    @IBOutlet weak var campaignImage: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var amountRaisedLabel: UILabel!
    @IBOutlet weak var targetAmountLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var campaignSettingsButtonn: UIButton!
    @IBOutlet weak var contributeButton: UIButton!
    @IBOutlet weak var totalContributionsButton: UIButton!
    @IBOutlet weak var campaignDescription: UILabel!
    
    var campaignName: String = ""
    var campaignDesc: String = ""
    var campaignId: String = ""
    var currency: String = ""
    var groupId: String = ""
    var dateEnded: String = ""
    var maxSingleContributionLimit: Double = 0.0
    var expiredCampaign: Bool = true
    
    var campaignContributions: [ContributionSections] = []
    var campaignContribution: [GetCampaignContributionResponse] = []
    var contributions: [ContributionSections] = []
    var campaignInfo: GetGroupCampaignsResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showChatController()
        disableDarkMode()
        
        campaignNameLabel.text = campaignName
        campaignImage.image = UIImage(named: "defaulticon")
        campaignImage.contentMode = .scaleAspectFit
        amountRaisedLabel.text = "\(currency) \(formatNumber(figure: campaignInfo.amountReceived!))"
        targetAmountLabel.text = "\(currency) \(formatNumber(figure: campaignInfo.target!))"
        createdLabel.text = "Created on \(dateConversion(dateValue: campaignInfo.created))"
        
        var endDate = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        print("type: \(campaignInfo.campaignType)")
        if campaignInfo.campaignType == "perpetual" {
            daysLeftLabel.text = "Perpetual"
        }else{
            if (self.campaignInfo.end == nil) || (self.campaignInfo.end == "") || (self.campaignInfo.end == "nil"){
                
            }else {
        endDate = formatter.date(from: self.campaignInfo.end!)!
        
        
        
        formatter.dateStyle = DateFormatter.Style.medium
        _ = formatter.string(from: endDate as! Date)
        daysLeftLabel.text = "\(daysLeft(endDate)) left"
                dateEnded = "\(daysLeft(endDate)) left"
        
        print("end: \(campaignInfo.end) \(campaignInfo.created)")
            }
        }
        progressBar.progress = Float(campaignInfo.amountReceived!/campaignInfo.target!)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if expiredCampaign == true {
            print("expired")
            contributeButton.isHidden = true
            campaignSettingsButtonn.setTitleColor(.gray, for: .disabled)
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func campaignSettingsButtonAction(_ sender: Any) {
        if expiredCampaign == true {
            showAlert(title: "Campaign", message: "This campaign has expired")
        }else {
        let vc: AdminCampaignSettingsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "campsettings") as! AdminCampaignSettingsVC
        
        vc.campaignInfo = campaignInfo
        vc.campaignName = campaignInfo.campaignName
        vc.currency = currency
        vc.groupId = groupId
        vc.dateEnded = dateEnded
        
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func totalContributionsButtonAction(_ sender: Any) {
        FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)

        let par: CampaignContributionParameter = CampaignContributionParameter(campaignId: campaignInfo.campaignId ?? "")
        self.getCampaignContribution(campaignContributionParameter: par, campaignData: campaignInfo)
    }
    
    @IBAction func contributeButtonAction(_ sender: Any) {
        let vc: WalletsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wallets") as! WalletsVC
        vc.campaignId = campaignInfo.campaignId ?? ""
        vc.groupNamed = campaignInfo.campaignName
        vc.currency = currency
        vc.groupId = groupId
        vc.contribution = true
        vc.maxSingleContributionLimit = maxSingleContributionLimit
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    @IBAction func sendStatementButtonAction(_ sender: UIButton) {
//        let vc: SendStatementViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "send") as! SendStatementViewController
//            vc.groupId = groupId
//            vc.groupName = campaignName
//            vc.campaignStatement = true
//            vc.campaignId = campaignInfo.campaignId
//            vc.statementType = "CAMPAIGN"
//        self.navigationController?.pushViewController(vc, animated: true)
        campaignOrPersonalStatementOptions()
    }
    
       //updated-list
        func getCampaignContribution(campaignContributionParameter: CampaignContributionParameter, campaignData: GetGroupCampaignsResponse){
            AuthNetworkManager.campaignContribution(parameter: campaignContributionParameter) { (result) in
                self.parseCampaignContributionResponse(result: result, campaignData: campaignData)
            }
        }
        
    private func parseCampaignContributionResponse(result: DataResponse<[GetCampaignContributionResponse], AFError>, campaignData: GetGroupCampaignsResponse){
        switch result.result {
        case .success(let response):
            print(response)
            FTIndicator.dismissProgress()
            
        let vc: AdminCampaignContributionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "campcont") as! AdminCampaignContributionsVC
            
            vc.campaignInfo = campaignData
            vc.campaignContribution = response
            vc.campaignName = campaignData.campaignName
            vc.currency = currency
            vc.groupId = groupId
            self.navigationController?.pushViewController(vc, animated: true)
                            
            
            break
        case .failure(_ ):
            FTIndicator.dismissProgress()
            if result.response?.statusCode == 400 {
                self.sessionTimeout()
            }else {
                self.showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    //GROUP LIMITS
    func retrieveGroupLimits(groupLimitsParameter: GroupLimitsParamter) {
        AuthNetworkManager.retrieveGroupLimits(parameter: groupLimitsParameter) { (result) in
            self.parseGroupLimitsResponse(result: result)
        }
    }
    
    
    private func parseGroupLimitsResponse(result: DataResponse<GroupLimitsResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            
//            maxCashoutLimit = response.mobileLimitPerCashout ?? 0.0
//            maxContributionLimit = response.maxContributionPerDay ?? 0.0
            maxSingleContributionLimit = response.maxSingleContribution ?? 0.0
            
            
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

    func campaignOrPersonalStatementOptions(){
        var alert = UIAlertController(title: "Choose Statement Option", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        switch UIDevice.current.screenType {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
            let actionSheetController: UIAlertController = UIAlertController(title: "Choose Statement Option", message: "", preferredStyle: .actionSheet)
            actionSheetController.addAction(title: "Campaign Statement", style: .default, handler: { (action) in
                //move to statemennt view
                let vc: SendStatementViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "send") as! SendStatementViewController
                vc.groupId = self.groupId
                vc.groupName = self.campaignName
                vc.campaignStatement = true
                vc.campaignId = self.campaignInfo.campaignId ?? ""
                vc.statementType = "CAMPAIGN"
                self.navigationController?.pushViewController(vc, animated: true)
            })
            actionSheetController.addAction(title: "Personal Statement", style: .default, handler:  { (action) in
                //move to statemennt view
                let vc: SendStatementViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "send") as! SendStatementViewController
                vc.groupId = self.groupId
                vc.groupName = self.campaignName
                vc.campaignStatement = true
                vc.campaignId = self.campaignInfo.campaignId ?? ""
                vc.statementType = "MEMBER"
                self.navigationController?.pushViewController(vc, animated: true)
            })
            actionSheetController.addAction(title: "Cancel", style: .cancel)
            self.present(actionSheetController, animated: true, completion: nil)
            break
        default:
            alert = UIAlertController(title: "Choose Statement Option", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(title: "Campaign Statement", style: .default, handler: {(action) in
                let vc: SendStatementViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "send") as! SendStatementViewController
                vc.groupId = self.groupId
                vc.groupName = self.campaignName
                vc.campaignStatement = true
                vc.campaignId = self.campaignInfo.campaignId ?? ""
                vc.statementType = "CAMPAIGN"
                self.navigationController?.pushViewController(vc, animated: true)
            })
            alert.addAction(title: "Personal Statement", style: .default, handler: {(action) in
                let vc: SendStatementViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "send") as! SendStatementViewController
                vc.groupId = self.groupId
                vc.groupName = self.campaignName
                vc.campaignStatement = true
                vc.campaignId = self.campaignInfo.campaignId ?? ""
                vc.statementType = "MEMBER"
                self.navigationController?.pushViewController(vc, animated: true)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
