//
//  DefaultContributionCell.swift
//  
//
//  Created by Hosny Ben Savage on 07/02/2019.
//

import UIKit

class DefaultContributionCell: UITableViewCell {

    @IBOutlet var memberImage: UIImageView!
    @IBOutlet var memberName: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        memberImage.layer.borderWidth = 1.0
        memberImage.clipsToBounds = true
        memberImage.layer.borderColor = UIColor(red: 61.0/255.0, green: 128.0/255.0, blue: 186.0/255.0, alpha: 1.0).cgColor
        memberImage.layer.cornerRadius = 32.0

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
