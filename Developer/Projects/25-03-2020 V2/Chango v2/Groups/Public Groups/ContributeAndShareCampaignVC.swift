//
//  ContributeAndShareCampaignVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 09/10/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import Nuke
import Alamofire
import FTIndicator

class ContributeAndShareCampaignVC: BaseViewController {

    @IBOutlet weak var campaignImages: UIImageView!
    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var amountRaisedLabel: UILabel!
    @IBOutlet weak var raisedOutOfLabel: UILabel!
    @IBOutlet weak var targetAmountLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var reportGroupLabel: UILabel!
    @IBOutlet weak var guaranteeLabel: UILabel!
    @IBOutlet weak var institutionLogo: UIImageView!
    @IBOutlet weak var progressBarView: UIProgressView!

    var campaignEndDateLabel: String = ""
    var dateCreated: String = ""
    var campaignStatusLabel: String = ""
    var targetAmount: Double = 0.0
    var publicGroupDescriptionLabel: String = ""
    var campaignId: String = ""
    var groupId: String = ""
    var campaignName: String = ""
    var publicGroup: GroupResponse!
    var amountReceived: Double = 0.0
    var campaignDescription: String = ""
    var campaignType: String = ""
    var campaignExpiry: String = ""
    var alias: String = ""
    var userNumber: String = ""
    var userNetwork: String = ""
    var msisdn: String = ""
    var maxContributionPerDay: Int = 0
    var currency: String = ""
    var groupIconPath: String = ""
    var campaignAlias: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()
        showChatController()
        
        print("camp id: \(campaignId)")

        descriptionLabel.text = campaignDescription
        reportGroupLabel.text = "If you have a concern or an issue with this campaign, please report it here and we will get back to you."
        if publicGroup.countryId.countryId == "GH" {
            guaranteeLabel.isHidden = false
            institutionLogo.isHidden = false
        guaranteeLabel.text = "This App has been approved by The Central Bank of Ghana"
        }else {
            guaranteeLabel.isHidden = true
            institutionLogo.isHidden = true
        }
        dateCreatedLabel.text = "Created on \(dateCreated)"
        if campaignType == "perpetual" {
            amountRaisedLabel.text = "\(currency)\(formatNumber(figure: amountReceived))"
            daysLeftLabel.isHidden = true
            raisedOutOfLabel.isHidden = true
            targetAmountLabel.isHidden = true
        }else {
        daysLeftLabel.text = "\(campaignEndDateLabel) left"
        amountRaisedLabel.text = "\(currency)\(formatNumber(figure: amountReceived))"
        targetAmountLabel.text = "\(currency)\(formatNumber(figure: targetAmount))"
        }
        campaignNameLabel.text = "\(campaignName)"
            
        
        if (groupIconPath == "<null>") || (groupIconPath == ""){
            campaignImages.image = UIImage(named: "defaultgroupicon")
                    print(groupIconPath)
            campaignImages.contentMode = .scaleAspectFit
        }else {
            campaignImages.contentMode = .scaleAspectFill
            Nuke.loadImage(with: URL(string: groupIconPath)!, into: campaignImages)
        }
        progressBarView.progress = Float(amountReceived/targetAmount)
    }
    

    @IBAction func contributeActionButton(_ sender: Any) {
        
        let vc: WalletsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wallets") as! WalletsVC

        vc.campaignId = campaignId
        vc.groupId = publicGroup.groupId
        vc.network = userNetwork
//       vc.userNumber = userNumber
        vc.groupNamed = campaignName
        vc.currency = publicGroup.countryId.currency
        if !(groupIconPath == "<null>") || !(groupIconPath == nil) || !(groupIconPath == ""){
            vc.groupIconPath = groupIconPath
        }
        vc.maxSingleContributionLimit = Double(maxContributionPerDay)
        vc.publicGroupCheck = 1
        vc.contribution = true
        
        print("\(userNumber),\(userNetwork)")
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func myPublicCotributionsButton(_ sender: UIButton) {
        let vc: PublicContributionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PublicContributionViewController") as! PublicContributionViewController
        vc.campaignId = campaignId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func shareActionButton(_ sender: Any) {
//        let shareText = "Share this campaign with your friends"
//        let secondActivityItem : NSURL = NSURL(string: "https://campaignsuat.changoapp.com/\(alias)")! //uat
////        let secondActivityItem : NSURL = NSURL(string: "https://campaignsuat.changoapp.com/\(alias)")! //live
        
        let baseUrl: String = "https://donate-uat.changoapp.com/campaign/" // uat
//        let baseUrl: String = "https://donate.changoapp.com/campaign/" // live

//        "https://campaigns.changoapp.com/" //live -- chango web display
//        let baseUrl: String = "https://campaignsuat.changoapp.com/" //uat

        if let name = URL(string: "\(baseUrl)\(campaignId)"), !name.absoluteString.isEmpty {
          let objectsToShare = [name]
          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
          self.present(activityVC, animated: true, completion: nil)
        } else {
          // show alert for not available
        }
    }
    
    
    @IBAction func reportCampaignButtonAction(_ sender: Any) {
        print("report")
        let vc: PublicReportCampaignVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "publicreport") as! PublicReportCampaignVC
        vc.campaignId = campaignId
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getApprovalBody(getApprovalBodyParameter: GetApprovalBodyParameter) {
        AuthNetworkManager.getApprovalBody(parameter: getApprovalBodyParameter) { (result) in
            self.parseGetApprovalBodyResponse(result: result)
        }
    }
    
    private func parseGetApprovalBodyResponse(result: DataResponse<[GetApprovalBodyResponse], AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            for item in response {
                Nuke.loadImage(with: URL(string: item.logo!)!, into: institutionLogo)
                guaranteeLabel.text = "\(item.message!)\(item.name!)"
            }
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
}
