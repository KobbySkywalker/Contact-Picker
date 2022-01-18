//
//  CampaignsCell.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 07/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class CampaignsCell: UITableViewCell {

    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var memberAmount: UILabel!
    @IBOutlet weak var memberDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        memberImage.layer.borderWidth = 1.0
        memberImage.clipsToBounds = true
        memberImage.layer.borderColor = UIColor(red: 50.0/255.0, green: 54.0/255.0, blue: 66.0/255.0, alpha: 1.0).cgColor
        memberImage.layer.cornerRadius = 28.0
        memberAmount.layer.cornerRadius = 13.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
