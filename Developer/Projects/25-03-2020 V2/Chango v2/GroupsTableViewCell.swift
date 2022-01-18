//
//  GroupsTableViewCell.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 06/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import UIKit

class GroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var groupsImage: UIImageView!
    @IBOutlet weak var groupsName: UILabel!
    @IBOutlet weak var groupsDate: UILabel!
    @IBOutlet weak var groupType: UILabel!
    @IBOutlet weak var rectangularView: UIView!
    @IBOutlet weak var memberCampaignCount: UILabel!
    @IBOutlet weak var memerCampaignLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        groupsImage.layer.borderWidth = 0.2
        groupsImage.clipsToBounds = true
        groupsImage.layer.cornerRadius = 15
        groupsImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        rectangularView.layer.borderWidth = 0.0
        rectangularView.clipsToBounds = true
        rectangularView.layer.cornerRadius = 15
        rectangularView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        groupsImage.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
