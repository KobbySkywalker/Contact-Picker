//
//  CampaignSectionHeaderViewTableViewCell.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 27/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class CampaignSectionHeaderViewTableViewCell: FZAccordionTableViewHeaderView {
    
    static let kDefaultAccordionHeaderViewHeight: CGFloat = 66;
    static let kAccordionHeaderViewReuseIdentifier = "AccordionHeaderViewReuseIdentifier";

    @IBOutlet weak var campaignImage: UIImageView!
    @IBOutlet weak var campaignName: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.campaignImage.layer.cornerRadius = 24.0
        self.campaignImage.clipsToBounds = true
        self.campaignImage.layer.borderWidth = 0.8
        self.campaignImage.layer.masksToBounds = true
        self.campaignImage.layer.borderColor = UIColor(red: 50.0/255.0, green: 54.0/255.0, blue: 65.0/255.0, alpha: 1.0).cgColor
        
    }


    
}
