//
//  CampaignsTableViewCell.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 16/07/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class CampaignsTableViewCell: UITableViewCell {

    @IBOutlet weak var campaignImage: UIImageView!
    @IBOutlet weak var campaignName: UILabel!
    @IBOutlet weak var campaignDescription: UILabel!
    @IBOutlet weak var amountRaised: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var wholeview: UIView!
    @IBOutlet weak var dateModified: UILabel!
    @IBOutlet weak var endDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        wholeview.borderColor = UIColor.gray
//        wholeview.cornerRadius = 5.00
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 5)
        progressBar.clipsToBounds = true
        progressBar.layer.cornerRadius = 2.5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
