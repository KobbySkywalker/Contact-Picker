//
//  GroupLimitsResponse.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 11/03/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import Foundation

struct GroupLimitsResponse: Codable {
    var maxCashoutPerDay: Double?
    var maxCashoutPerMonth: Double?
    var maxContributionPerDay: Double?
    var maxContributionPerMonth: Double?
    var maxSingleCashout: Double?
    var maxSingleContribution: Double?
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let mxCshtPrDy = try? container.decode(Double.self, forKey: .maxCashoutPerDay) {
            maxCashoutPerDay = mxCshtPrDy
        }
        if let mxCshtPrMnth = try? container.decode(Double.self, forKey: .maxCashoutPerMonth) {
            maxCashoutPerMonth = mxCshtPrMnth
        }

        if let mxCntrbtnPrDy = try? container.decode(Double.self, forKey: .maxContributionPerDay) {
            maxContributionPerDay = mxCntrbtnPrDy
        }
            
            if let mxCntrbtnPrMnth = try? container.decode(Double.self, forKey: .maxContributionPerMonth) {
                maxContributionPerMonth = mxCntrbtnPrMnth
        }
        
            if let mxSnglCsht = try? container.decode(Double.self, forKey: .maxSingleCashout) {
                maxSingleCashout = mxSnglCsht
        }
        
            if let msSnglCntrbtn = try? container.decode(Double.self, forKey: .maxSingleContribution) {
                maxSingleContribution = msSnglCntrbtn
        }
    }
    
}


    struct AppConfiguratonResponse: Codable {
        var campaignMax: Int?
        var configId: Int?
        var countryId: String?
        var currency: String?
        var groupSize: Int?
        var maxBankCashout: Int?
        var maxMobileCashout: Int?
        var maxPrivateContribution: Int?
        var maxPrivateMonthlyContribution: Int?
        var maxPublicContribution: Int?
        var maxPublicMonthlyContribution: Int?
}


struct ApprovedCashoutResponse: Codable {
    var content: [Contents]
    var empty: Bool
    var first: Bool
    var last: Bool
    var number: Int
    var numberOfElements: Int
    var pageable: Pageables
    var size: Int
    var sort: Sorts
    var totalElements: Int
    var totalPages: Int
}

struct Contents: Codable {
    var amount: Double
    var created: String
    var destinationNumber: String
    var destinationAccountName: String
    var cashoutDestinationCode: String
    var cashoutId: String
    var campaignId: String
    var cashoutDestination: String
}

struct Sorts: Codable {
    var sorted: Bool
    var unsorted: Bool
    var empty: Bool
}

struct Pageables: Codable {
    var sort: Sorts
    var pageSize: Int
    var pageNumber: Int
    var offset: Int
    var unpaged: Bool
    var paged: Bool
}


struct AddCreditCardResponse: Codable {
    var data: CardData
    var responseCode: String
    var responseMessage: String
}


struct CardData: Codable {
    var cardName: String
    var id: String
    var token: String
}


struct AddWalletResponse: Codable {
    var paymentWallet: PaymentWallet?
    var responseCode: String?
    var responseMessage: String?
}

struct MemberWalletResponse: Codable {
    var paymentWallets: [PaymentWallet]
    var responseCode: String?
    var responseMessage: String?
}


struct WalletData: Codable {
    var id: String
    var msisdn: String
    var network: String
}

struct PaymentWallet: Codable {
    var accountHolderName: String?
    var channelId: String?
    var created: String?
    var destinationCode: String?
    var memberId: String?
    var modified: String?
    var nickName: String?
    var paymentDestinationNumber: String?
    var status: String?
    var walletId: String?
    var verificationAmount: Double?
    var verificationAttempts: Int?
    var verificationInitiationDate: String?
    var verified: Bool
}

struct GetPaymentMethodsResponse: Codable {
    var accountHolderName: String?
    var channelId: String?
    var created: String?
    var destinationCode: String?
    var memberId: String?
    var modified: String?
    var nickName: String?
    var paymentDestinationNumber: String?
    var status: String?
    var walletId: String?
    var verificationAmount: Double?
    var verificationAttempts: Int?
    var verificationInitiationDate: String?
    var verified: Bool
}

struct GetCampaignContributionResponse: Codable {
    var amount: Double
    var displayAmount: String
    var anonymous: Bool
    var campaignId: GetGroupCampaignsResponse
    var created: String
    var currency: String
    var groupId: MemberGroupIdResponse
    var id: String
    var memberId: MemberIdResponse
    var modified: String?
}


struct GetSupportDetailsResponse: Codable {
    var countryId: String?
    var email: String?
    var phone: String?
}

struct GetMemberVotedInGroupResponse: Codable {
    var ballotType: String?
    var hasMemberVoted: Bool
    var memberVoteIsAbout: String?
    var voteId: String?
}

struct GroupPolicyResponse: Codable {
    var dropMember: String?
    var termsAndConditions: String?
    var loan: String?
    var makeAdmin: String?
    var cashout: String?
    var cashoutPercentage: String?
}

public struct UpdatePrivateGroupImageResponse: Codable {
    var countryId: CountryId
    var approve: String?
    var groupId: String
    var groupName: String
    var groupType: String
    var groupIconPath: String?
    var tnc: String?
    var status: String
    var created: String
    var creatorId: String?
    var defaultCampaignId: String?
    var loanFlag: Int
    var creatorName: String
    var modified: String?
    var description: String?
}

struct MinVoteRequiredAllBallots: Codable {
    var ballotId: String?
    var groupId: String?
    var minVoteRequired: Int
}

struct ResponseMessage: Codable {
    var responseCode: String?
    var responseMessage: String?
}

struct RetrieveCountryChannelDestinations: Codable {
    var channelId: String?
    var countryId: String?
    var created: String?
    var destinationCode: String?
    var destinationIconPath: String?
    var destinationName: String?
    var id: Int?
    var modified: String?
}

struct IdInfo: Codable {
    var age: String?
    var cardSerial: String?
    var certificateDate: String?
    var certifcateOfCompetence: String?
    var classOfLicence: String?
    var dateOfBirth: String?
    var dateOfIssue: String?
    var expiryDate: String?
    var firstName: String?
    var fssNo: String?
    var fullName: String?
    var gender: String?
    var idNumber: String?
    var lastName: String?
    var message: String?
    var middleName: String?
    var nationality: String?
    var picture: String?
    var pin: String?
    var placeOfBirth: String?
    var placeOfIssue: String?
    var pollingStation: String?
    var processingCenter: String?
    var regDate: String?
    var responceCode: String?
    var signature: String?
}

struct AddKYCResponse: Codable {
    var idInfo: IdInfo?
    var responseCode: String?
    var responseMessage: String?
}

struct ContributeParameters: Codable {
    var campaignId: String
    var groupId: String
    var voteId: String
    var network: String
    var groupName: String
    var currency: String
    var campaignExpiry: String
    var maxSingleContributionLimit: Double
    var groupIconPath: String
    var walletNumber: String
    var walletId: String
    var publicGroupCheck: Int
}

struct GetNameRegisteredOnMobileWalletResponse: Codable {
    var name: String?
    var responseCode: String?
    var responseMessage: String?
}

struct RetrieveMemberResponse: Codable {
    var authProviderId: String
    var countryId: String
    var created: String?
    var email: String
    var firstName: String
    var language: String?
    var lastName: String
    var memberIconPath: String?
    var memberId: String
    var modified: String?
    var msisdn: String
    var networkCode: String?
    var status: String?
}

struct InitiateLoanWithWalletResponse: Codable {
    var responseCode: String?
    var responseMessage: String?
    var walletId: String?
}

struct CreateGroupResponse: Codable {
    var countryId: CountryId?
    var group: GroupObjectResponse?
    var responseCode: String?
    var responseMessage: String?
}

struct GroupObjectResponse: Codable {
    var approve: String?
    var created: String?
    var creatorId: String?
    var  creatorName: String?
    var description: String?
    var defaultCampaignId: String
    var groupIconPath: String?
    var groupId: String?
    var groupName: String
    var groupType: String
    var loanFlag: Int
    var modified: String?
    var status: String
    var tnc: String?
}

struct RealtimeGroupBalance: Codable {
    var groupId: String
}
