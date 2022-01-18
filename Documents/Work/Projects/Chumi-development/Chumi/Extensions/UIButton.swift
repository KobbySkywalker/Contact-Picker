//
//  UIButton.swift
//  Chumi
//
//  Created by Fitzgerald Afful on 02/02/2021.
//

import Foundation
import UIKit

extension UIButton {

    open override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }

}
