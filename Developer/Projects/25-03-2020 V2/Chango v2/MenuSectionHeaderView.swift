//
//  MenuSectionHeader.swift
//  Example-Swift
//
//  Created by Robert Nash on 22/09/2015.
//  Copyright © 2015 Robert Nash. All rights reserved.
//

import UIKit

class MenuSectionHeaderView: FZAccordionTableViewHeaderView {
	
	static let kDefaultAccordionHeaderViewHeight: CGFloat = 60;
	static let kAccordionHeaderViewReuseIdentifier = "AccordionHeaderViewReuseIdentifier";
	
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var sectionTitleLabel: UILabel!
	@IBOutlet weak var arrowImageView: UIImageView!
	@IBOutlet weak var img: UIImageView!
    @IBOutlet weak var destinationNumber: UILabel!
    @IBOutlet weak var backgroundViewColor: UIView!
    
	
	// MARK: - Base Class Overrides
	
	override func awakeFromNib() {
		super.awakeFromNib()
        self.img.clipsToBounds = true
        self.backgroundViewColor.backgroundColor = .white
		//arrowImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchedHeaderView)))
		//arrowImageView.isUserInteractionEnabled = true
	}
		
		
	
}
