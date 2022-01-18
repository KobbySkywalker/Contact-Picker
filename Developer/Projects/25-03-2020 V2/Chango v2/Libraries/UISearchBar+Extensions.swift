//
//  UISearchBar+Extensions.swift
//  Chango v2
//
//  Created by Hosny Savage on 13/07/2021.
//  Copyright © 2021 IT Consortium. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    var textField: UITextField? {
        return value(forKey: "searchField") as? UITextField
    }
    
    func setSearchIcon(image: UIImage) {
        setImage(image, for: .search, state: .normal)
    }
    
    func setClearIcon(image: UIImage) {
        setImage(image, for: .clear, state: .normal)
    }
}
