//
//  PublicGroupsTableViewCell.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 27/09/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class PublicGroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var groupsImage: UIImageView!
    @IBOutlet weak var groupsName: UILabel!
    @IBOutlet weak var groupsDate: UILabel!
    @IBOutlet weak var groupType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        groupsImage.layer.borderWidth = 1.0
        groupsImage.clipsToBounds = true
        groupsImage.layer.borderColor = UIColor(red: 61.0/255.0, green: 128.0/255.0, blue: 186.0/255.0, alpha: 1.0).cgColor
        groupsImage.layer.cornerRadius = 49.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
