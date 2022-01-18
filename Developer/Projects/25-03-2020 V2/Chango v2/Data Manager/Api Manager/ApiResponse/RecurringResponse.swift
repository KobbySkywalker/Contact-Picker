//
//  RecurringResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 02/09/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct RecurringResponse: Codable {
    var responseCode: String?
    var responseMessage: String?
    
    
    
    private enum CodingKeys: String, CodingKey {
        case responseCode
        case responseMessage
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let respCode = try? container.decode(String.self, forKey: .responseCode) {
            responseCode = respCode
        }
        
        if let respMsg = try? container.decode(String.self, forKey: .responseMessage) {
            responseMessage = respMsg
        }
        
        
    }
}
