//
//  FAQsHeaderCell.swift
//  Chango v2
//
//  Created by Hosny Savage on 09/11/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit

class FAQsHeaderCell: FZAccordionTableViewHeaderView {
    
    static let kDefaultAccordionHeaderViewHeight: CGFloat = 60;
    static let kAccordionHeaderViewReuseIdentifier = "AccordionHeaderViewReuseIdentifier";
    
    @IBOutlet weak var faqsTitle: UILabel!
    @IBOutlet weak var backgroundViewColor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundViewColor.backgroundColor = .white
    }

    
}
