//
//  AboutCampaignViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 12/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class AboutCampaignViewController: BaseViewController {
    
    @IBOutlet weak var campaignDescription: ACFloatingTextfield!
    var campaignInfo: [GetGroupCampaignsResponse] = []
    var campaign: GetGroupCampaignsResponse!
    var group = ""
    var mainViewController: MainMenuTableViewController!
    var campaignName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showChatController()
        disableDarkMode()
    }
    
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if (campaignDescription.text?.isEmpty)! {
            showAlert(title: "Create Campaign", message: "Please enter a campaign description.")
        }else {
            let vc: GroupTypeTargetViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "type") as! GroupTypeTargetViewController
            vc.campaignName = campaignName
            vc.campaignDescription = campaignDescription.text!
            vc.campaignInfo = campaignInfo
            vc.campaign = campaign
            vc.group = group
            vc.mainViewController = mainViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }    
}
