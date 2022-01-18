//
//  DetailedCampaignViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 22/07/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class DetailedCampaignViewController: BaseViewController {
    
    @IBOutlet weak var campaignImage: UIImageView!
    @IBOutlet weak var publicGroupDescription: UILabel!
    @IBOutlet weak var amountRaised: UILabel!
    @IBOutlet weak var targetAmount: UILabel!
    @IBOutlet weak var progressiveBar: UIProgressView!
    @IBOutlet weak var campaignEndDate: UILabel!
    @IBOutlet weak var campaignStatus: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var campaignView: UIView!
    @IBOutlet weak var dateCreatedValue: UILabel!
    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var endDateValue: UILabel!
    
    
    var campaignStatusLabel: String = ""
    var campaignEndDateLabel: String = ""
    var dateCreated: String = ""
    var targetAmountLabel: Double = 0.0
    var amountReceived: Double = 0.0
    var publicGroupDescriptionLabel: String = ""
    var campaignId: String = ""
    var groupId: String = ""
    var campaignName: String = ""
    var publicGroup: GroupResponse!

    override func viewDidLoad() {
        super.viewDidLoad()

        showChatController()
        disableDarkMode()
        
        publicGroupDescription.text = publicGroupDescriptionLabel
//        targetAmount.text = "\(targetAmountLabel)"
        campaignStatus.text = campaignStatusLabel
        dateCreatedValue.text = dateCreated
        campaignNameLabel.text = campaignName
        
        campaignView.layer.cornerRadius = 10
        campaignView.layer.shadowColor = UIColor.black.cgColor
        campaignView.layer.shadowOffset = CGSize(width: 2, height: 4)
        campaignView.layer.shadowRadius = 8
        campaignView.layer.shadowOpacity = 0.2
        
        
        amountRaised.text = "\(amountReceived) raised of \(targetAmountLabel)"
        
        print("bar value: \(Float(amountReceived/targetAmountLabel))")
        progressiveBar.progress = Float(amountReceived/targetAmountLabel)
        
        if campaignEndDateLabel == "" {
            endDateLabel.isHidden = true
            endDateValue.isHidden = true
            
        }else {
            endDateValue.text = campaignEndDateLabel

        }
        
        if dateCreated == "" {
            dateCreatedLabel.isHidden = true
            dateCreatedValue.isHidden = true
        }else {
            
            dateCreatedValue.text = dateCreated
        }
        
        let parameter : CampaignImagesParameter = CampaignImagesParameter(id: campaignId)
        self.campaignImages(campaignImageParameter: parameter)
    }

    @IBAction func contributeBtn(_ sender: UIBarButtonItem) {
        let vc: PublicCampaginContributeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "campaigncontributes") as! PublicCampaginContributeViewController
        
        vc.campaignId = campaignId
        vc.publicGroup = publicGroup
        vc.campaignName = campaignName
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func contributeButton(_ sender: UIButton) {
        
        let vc: PublicCampaginContributeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "campaigncontributes") as! PublicCampaginContributeViewController
        
        vc.campaignId = campaignId
        vc.publicGroup = publicGroup
        vc.campaignName = campaignName
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func campaignImages(campaignImageParameter: CampaignImagesParameter) {
        AuthNetworkManager.campaignImages(parameter: campaignImageParameter) { (result) in
            //            self.parseGetCampaignBalance(result: result)
            print(result)
            print("Result: \(result)")
            
            //            self.campaignBalance = result
            //
            //            self.groupBalance.text = result
            
        }
        
    }
}
