//
//  MemberContributeCell.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 22/07/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class MemberContributeCell: UITableViewCell {

    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var memberNumber: UILabel!
    @IBOutlet weak var contribute: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.memberImage.clipsToBounds = true
        self.memberImage.layer.masksToBounds = true
        self.memberImage.layer.borderWidth = 0.0
//        self.memberImage.layer.borderColor = UIColor(red: 61.0/255.0, green: 128.0/255.0, blue: 186.0/255.0, alpha: 1.0).cgColor
        self.memberImage.layer.cornerRadius = 10.0
        
        contribute.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
