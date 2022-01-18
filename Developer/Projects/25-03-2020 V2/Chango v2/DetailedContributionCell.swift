//
//  DetailedContributionCell.swift
//  
//
//  Created by iMacWS 18 on 13/01/2017.
//
//

import UIKit

class DetailedContributionCell: UITableViewCell {

    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var background: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
