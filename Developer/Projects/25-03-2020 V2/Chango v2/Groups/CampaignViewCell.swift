//
//  CampaignViewCell.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 28/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class CampaignViewCell: UITableViewCell {

    @IBOutlet weak var campaignImage: UIImageView!
    @IBOutlet weak var campaignName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        campaignImage.layer.borderWidth = 1.0
        campaignImage.clipsToBounds = true
        campaignImage.layer.borderColor = UIColor(red: 61.0/255.0, green: 128.0/255.0, blue: 186.0/255.0, alpha: 1.0).cgColor
        campaignImage.layer.cornerRadius = 32.0    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
