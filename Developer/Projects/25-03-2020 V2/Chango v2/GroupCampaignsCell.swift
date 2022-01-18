//
//  GroupCampaignsCell.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 08/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class GroupCampaignsCell: UITableViewCell {

    @IBOutlet weak var campaignImage: UIImageView!
    @IBOutlet weak var campaignName: UILabel!
    @IBOutlet weak var campaignDescription: UILabel!
    @IBOutlet weak var campaignDate: UILabel!
    @IBOutlet weak var amountRaised: UILabel!
    @IBOutlet weak var raisedOut: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var daysLeft: UILabel!
    @IBOutlet weak var rectangleView: UIView!
    @IBOutlet weak var rectangularStack: UIStackView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        memberImage.layer.borderWidth = 1.0
//        memberImage.clipsToBounds = true
//        memberImage.layer.borderColor = UIColor(red: 50.0/255.0, green: 54.0/255.0, blue: 66.0/255.0, alpha: 1.0).cgColor
//        memberImage.layer.cornerRadius = 28.0
//        campaignImage.layer.borderWidth = 0.2
        
        progressBar.height = 3
        campaignImage.clipsToBounds = true
        campaignImage.layer.cornerRadius = 15
        campaignImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
//        rectangleView.layer.borderWidth = 0.2
        rectangleView.clipsToBounds = true
        rectangleView.layer.cornerRadius = 15
        rectangleView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        rectangularStack.layer.borderWidth = 0.1
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
