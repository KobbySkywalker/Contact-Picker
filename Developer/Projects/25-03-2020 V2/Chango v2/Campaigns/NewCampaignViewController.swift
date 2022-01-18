//
//  NewCampaignViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 12/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class NewCampaignViewController: BaseViewController {
    
    @IBOutlet weak var campaignName: ACFloatingTextfield!
    @IBOutlet weak var campaignDescription: ACFloatingTextfield!
    
    
    var campaignInfo: [GetGroupCampaignsResponse] = []
    var campaign: GetGroupCampaignsResponse!
    var group = ""
    var mainViewController: MainMenuTableViewController!
    var currency: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        showChatController()
        disableDarkMode()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if (campaignName.text?.isEmpty)! {
            showAlert(title: "Create Campaign", message: "Please enter a campaign name.")
        }else  if (campaignName.text!.count > 50) {
            showAlert(title: "Create Campaign", message: "Campaign Name should not exceed 50 characters.")
        }else if (campaignDescription.text?.isEmpty)! {
                showAlert(title: "Create Campaign", message: "Campaign description cannot be empty and should be more than 10 characters")
        }else if campaignDescription.text?.count < 10 {
            showAlert(title: "Create Campaign", message: "Campaign description should be more than 20 characters")
        }else{
            let vc: GroupTypeTargetViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "type") as! GroupTypeTargetViewController
            vc.campaignName = campaignName.text!
            vc.campaignDescription = campaignDescription.text!
            vc.campaignInfo = campaignInfo
            vc.campaign = campaign
            vc.group = group
            vc.mainViewController = mainViewController
            vc.currency = currency
            print("currency: \(currency)")
            print(group)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
