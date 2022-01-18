//
//  PersonalContributionCell.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 24/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class PersonalContributionCell: UITableViewCell {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var amountContributed: UILabel!
    @IBOutlet weak var groupDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        groupImage.layer.borderWidth = 1.0
        groupImage.layer.borderColor = UIColor(red: 61.0/255.0, green: 128.0/255.0, blue: 186.0/255.0, alpha: 1.0).cgColor
        groupImage.layer.cornerRadius = 32.0
        groupImage.layer.masksToBounds = true
        groupImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
