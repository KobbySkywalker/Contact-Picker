//
//  VoteCell.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 23/04/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class VoteCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var voteIcon: UIImageView!
    @IBOutlet weak var voteCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        voteIcon.layer.borderWidth = 1.0
        voteIcon.clipsToBounds = true
        voteIcon.layer.borderColor = UIColor(red: 61.0/255.0, green: 128.0/255.0, blue: 186.0/255.0, alpha: 1.0).cgColor
        voteIcon.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
