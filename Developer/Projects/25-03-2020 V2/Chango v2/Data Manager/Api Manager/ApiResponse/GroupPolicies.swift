//
//  GroupPolicies.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 05/12/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import Foundation

struct GroupPoliciesResponse: Codable {
    var loan: Double?
    var cashout: Double?
    var makeadmin: Double?
    var TermsConditions: String?
    
    private enum CodingKeys: String, CodingKey {
        case loan
        case cashout
        case makeadmin = "makeadmin "
        case TermsConditions
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let lon = try? container.decode(Double.self, forKey: .loan) {
            loan = lon
        }
        if let csht = try? container.decode(Double.self, forKey: .cashout) {
            cashout = csht
        }
        
//        makeadmin = try container.decode(Double.self, forKey: .makeadmin)
        if let mkdmn = try? container.decode(Double.self, forKey: .makeadmin) {
            makeadmin = mkdmn
        }

        if let tnc = try? container.decode(String.self, forKey: .TermsConditions) {
            TermsConditions = tnc
        }
    }
}
