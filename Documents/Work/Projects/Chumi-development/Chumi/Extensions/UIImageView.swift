//
//  UIImageView.swift
//  Chumi
//
//  Created by Fitzgerald Afful on 02/02/2021.
//

import Foundation
import Nuke

extension UIImageView {
    func setImage(_ imageUrl: String?) {
        if imageUrl == nil {
            return
        }
        if let url = URL(string: imageUrl!) {
            Nuke.loadImage(with: url, into: self)
        }
    }
}
