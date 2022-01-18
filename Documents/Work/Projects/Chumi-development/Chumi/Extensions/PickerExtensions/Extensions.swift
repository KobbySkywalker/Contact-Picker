//
//  Extensions.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 19/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import Foundation

public extension NSError{
    static func createError(_ message: String) -> NSError {
        return NSError(domain: "Chango", code: 001, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
