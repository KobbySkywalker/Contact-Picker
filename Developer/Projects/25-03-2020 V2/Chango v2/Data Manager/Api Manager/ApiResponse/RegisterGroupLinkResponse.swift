//
//  RegisterGroupLinkResponse.swift
//  Chango v2
//
//  Created by Hosny Savage on 07/05/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import Foundation

struct RegisterGroupLinkResponse: Codable {
    var responseMessage: String?
    var responseCode: String?
    var data: RegisterData?
}


struct RegisterData: Codable {
    var expiredEpoch: Int?
    var id: String?
}


struct VerifyGroupLinkResponse: Codable {
    var responseMessage: String?
    var responseCode: String?
    var data: VerifyData?
}


struct VerifyData: Codable {
    var cashoutPolicy: Double?
    var groupDescription: String?
    var groupId: String?
    var groupName: String?
    var tnc: String?
    var groupIconPath: String?
}


struct RetrieveGroupLinkResponse: Codable {
    var responseMessage: String?
    var responseCode: String?
    var data: RetrieveData?
}


struct RetrieveData: Codable {
    var created: String?
    var creatorId: String?
    var duration: Int?
    var expired: String?
    var expiredEpoch: Int?
    var generatedLink: String?
    var groupId: String?
    var timeUnits: String?
    var isExpired: Bool?
}

struct MakeLoanApproverResponse: Codable {
    var groupMember: MemberResponse?
    var responseCode: String?
    var responseMessage: String?
    
}

struct RegularResponse: Codable {
    var responseCode: String?
    var responseMessage: String?
}

struct VerifyCardResponse: Codable {
    var responseCode: String?
    var responseMessage: String?
    var verificationInitiationDate: String?
}

struct LimitForUnverifiedCardsResponse: Codable {
    var currency: String?
    var amount: Double
    var displayAmount: String?
}

struct GetApprovalBodyResponse: Codable {
    var id: Int?
    var name: String?
    var message: String?
    var logo: String?
    var countryId: String?
    var created: String?
    var modified: String?
}

struct GetPaymentChargeResponse: Codable {
    var bankCashout: String?
    var cardContribution: String?
    var walletCashout: String?
    var walletContribution: String?
}

struct CheckMemberDetailsResponse: Codable {
    var email: Bool?
    var msisdn: Bool?
}

struct GetCurrentAppVersionResponse: Codable {
    var androidCurrentVersion: String
    var iosCurrentVersion: String
    var created: String
    var forcedUpdate: Bool
    var forcedUpdateMessage: String
    var id: Int
    var updated: String
}

struct MemberKycStatusResponse: Codable {
    var responseCode: String?
    var responseMessage: String?
    var successful: Bool
}

struct RegisterdMemberResponse: Codable {
    var authProviderId: String?
    var countryId: String?
    var created: String?
    var email: String?
    var firstName: String?
    var language: String?
    var lastName: String?
    var memberIconPath: String?
    var memberId: String?
    var modified: String?
    var msisdn: String?
    var networkCode: String?
    var status: String?
}

struct RegisterUserResponse: Codable {
    var member: RegisterdMemberResponse?
    var responseCode: String?
    var responseMessage: String?
}

struct CreateGroupCampaignResponse: Codable {
    var campaign: GetCampaignContributionResponse?
    var responseCode: String?
    var responseMessage: String?
}
