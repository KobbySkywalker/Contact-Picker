//
//  UIViewController+Extensions.swift
//  Chango v2
//
//  Created by Hosny Savage on 13/07/2021.
//  Copyright © 2021 IT Consortium. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var alertController: UIAlertController? {
        guard let alert = UIApplication.topViewController() as? UIAlertController else { return nil }
        return alert
    }
}
