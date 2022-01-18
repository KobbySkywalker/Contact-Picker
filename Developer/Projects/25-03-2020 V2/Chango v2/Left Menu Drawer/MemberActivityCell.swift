//
//  MemberActivityCell.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 08/04/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class MemberActivityCell: UITableViewCell {

    @IBOutlet weak var notificationImage: UIImageView!
    @IBOutlet weak var notificationName: UILabel!
    @IBOutlet weak var notificationMessage: UILabel!
    @IBOutlet weak var notificationDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        notificationImage.layer.borderWidth = 0.0
        notificationImage.clipsToBounds = true
        notificationImage.layer.borderColor = UIColor(red: 61.0/255.0, green: 128.0/255.0, blue: 186.0/255.0, alpha: 1.0).cgColor
        notificationImage.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
