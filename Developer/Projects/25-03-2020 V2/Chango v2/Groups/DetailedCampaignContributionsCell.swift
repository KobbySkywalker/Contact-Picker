//
//  DetailedCampaignContributionsCell.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 27/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class DetailedCampaignContributionsCell: UITableViewCell {

    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
