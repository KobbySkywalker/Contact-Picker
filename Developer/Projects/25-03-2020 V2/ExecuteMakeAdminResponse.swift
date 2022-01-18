//
//  ExecuteMakeAdminResponse.swift
//  Chango v2
//
//  Created by Hosny Savage on 27/03/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import Foundation

struct ExecuteMakeAdminResponse: Codable {
    var responseMessage: String?
    var responseCode: String?
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let responseMsg = try? container.decode(String.self, forKey: .responseMessage) {
            responseMessage = responseMsg
        }
        if let responseCd = try? container.decode(String.self, forKey: .responseCode) {
            responseCode = responseCd
        }
        
    }
}
