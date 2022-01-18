//
//  PublicContributionsCell.swift
//  Chango v2
//
//  Created by Hosny Savage on 08/09/2021.
//  Copyright © 2021 IT Consortium. All rights reserved.
//

import UIKit

class PublicContributionsCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
