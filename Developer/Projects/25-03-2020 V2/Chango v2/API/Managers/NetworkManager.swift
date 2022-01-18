//
//  APIParameters.swift
//
//  Created by Created by Hosny Ben Savage on 16/01/2019.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkingConstants{
	
//    static let baseUrl = "https://apiv2uat.changomobile.com/api/" //uat test
//    static let baseUrl = "https://apiv2pp.changomobile.com/api/" //preproduction
    
    static let baseUrl = "https://api.changoglobal.com/api/" // live
//    static let baseUrl = "https://apiuat.changoglobal.com/api/" //new uat
    
    static let register = "member/create"
    static let registerUser = "member/register" //new
    static let addMember = "group/private/member/add"
    static let addMembersToGroup = "group/private/member/add"
    static let memberExists = "member/exist"
    static let getNetworkCode = "getNetworks"
    static let createPrivateGroup = "group/private/create"
    static let createNewPrivateGroup = "group/create/private/group"
    static let getPrivateGroups = "group/private"
    static let getPublicGroups = "group/public"
    static let getAllGroups = "group/all"
    static let getMembers = "group/private/members"
    static let joinGroup = "group/private/join"
    static let joinPrivateGroup = "group/private/joinGroup"
    static let dropMember = "executeDropMember"
    static let createAdmin = "group/private/member/createAdmin"
    static let createLoanApprover = "group/private/member/createLoanApprover"
    static let makeLoanApprover = "group/private/member/makeLoanApprover"
    static let revokeLoanApprover = "group/private/revokeApprover"
    static let revokeAdmin = "group/private/revokeAdmin"
    static let isAdmin = "group/memberIsAdmin"
    static let updateRegistrationToken = "member/updateRegistrationToken"
    static let updatePrivateGroupPicture = "group/updatePicture"
    static let updateMember = "member/update"
    static let leaveGroup = "group/private/leave"
    static let campaignContributions = "group/campaign/contributions"
    static let castVote = "castVote"
    static let createCampaign = "campaign/create"
    static let getGroupCampaign = "campaign/"
    static let contribute = "contribute"
    static let makeContribution = "makeContribution"
    static let defaultCampaign = "group/campaign/default/contributions"
    static let getContributions = "group/campaign/default/contributionsPage"
    static let getCampaginContribution = "group/campaign/contribution"
    static let memberNetwork = "member/network"
    static let createVote = "group/private/createVote"
    static let getPublicGroupContributions = "getPublicGroupContributions"
    static let groupAnouncement = "group/announcement"
    static let groupLoan = "groupLoan"
    static let endCampaign = "campaign/end"
    static let pauseCampaign = "campaign/pause"
    static let startCampaign = "campaign/start"
    static let termsAndConditions = "group/termsAndConditions"
    static let memberContributions = "member/contributions"
    static let getContributionPublicGroups = "contribution/group/public"
    static let personalContributions = "member/personalContributions"
    static let groupTotals = "group/totals"
    static let sendFeedback = "group/public/feedback"
    static let createdVotes = "group/votes"
    static let publicContact = "group/public/contact"
    static let initiateCashout = "initiateCashouts"
	static let cashout = "executeCashout"
    static let requestLoan = "requestLoan"
    static let getStatement = "group/statement"
    static let grantLoan = "grantLoan"
    static let getGroupLoan = "group/private/loan"
    static let initiateLoanWithWallet = "initiateLoan/wallet"
    static let executeLoan = "executeLoan"
    static let createDevice = "mobile/add"
    static let getRecentPersonalContribution = "recent/member/personalContributions"
    static let extendCampaign = "campaign/extend"
    static let getVotes = "group/votes"
    static let recurringPayment = "contribution/recurring/complete"
    static let cancelAllMandates = "mandate/cancel"
    static let getRecurringExpiry = "campaign/expiry/recurring"
    static let getGroupPolicies = "group/policies"
    static let getGroupPolicy = "group/getPolicies"
    static let reportPrivateGroup = "group/private/reportGroup"
    static let reportPublicCampaign = "group/public/reportCampaign"
    static let editGroupName = "group/editGroupName"
    static let retrieveGroupLimits = "groupLimits/allGroupLimits"
    static let getMaxSingleContributionLimit = "groupLimits/maxSingleContributionLimit"
    static let getMaxSingleCashoutLimit = "groupLimits/maxSingleCashoutLimit"
    static let executeMakeAdmin = "executeMakeAdmin"
    static let initiateAdminCreation = "initiateAdminCreation"
    static let reactivateMandate = "reactivateMandate"
    static let initiateAdminRevokal = "initiateAdminRevokal"
    static let initiateApproverRevokal = "initiateApproverRevokal"
    static let initiateDropMember = "initiateDropMember"
    static let executeRevokeAdmin = "executeRevokeAdmin"
    static let executeRevokeApprover = "executeRevokeApprover"
    static let executeCashout = "executeCashout"
    static let registerGroupLink = "group/registerGroupLink"
    static let verifyGroupLink = "group/verifyGroupLink"
    static let saveGroupLink = "group/saveGroupLink"
    static let retrieveGroupLink = "group/retrieveGroupLink"
    static let getApprovedCashout = "group/campaign/approvedCashout"
    static let getApprovedCashouts = "group/campaign/approved/cashout"
    static let addCreditCard = "addCreditCard"
    static let addWallet = "addWallet"
    static let deleteWallet = "deleteWallet"
    static let getPaymentMethdos = "getPaymentMethods"
    static let requestACallback = "requestACallback"
    static let getSupportDetails = "getSupportDetails"
    static let activeCampaignCount = "campaign/activeCampaignCount"
    static let retrieveGroupMemberCount = "group/retrieveGroupMemberCount"
    static let archivedCampaigns = "campaign/archived"
    static let activePausedCamapaigns = "campaign/activeAndPaused"
    static let getMinVoteAllBallots = "votes/minimum/required"
    static let generateOTPForWallet = "otp/wallet/generate"
    static let verifyOTPForWallet = "otp/wallet/verify"
    static let retrieveCountryChannelsDestinations = "allDestinationsForCountryAndChannel"
    static let addKYC = "member/addKyc"
    static let deleteMemberInviteInGroup = "group/deleteMemberInviteInGroup"
    static let getMemberWallets = "get/member/wallets"
    static let getNameRegisteredOnMobileWallet = "verify/name"
    static let verifyCard = "verifyCard"
    static let verifyDebitedAmount = "verifyDebitedAmount"
    static let limitsForUnverifiedCards = "groupLimits/dailyLimitForUnverifiedCards"
    static let retrieveMember = "member/retrieveMember"
    static let maxVerificationAttempts = "maxCardVerificationAttempts"
    static let pushNotificationForChats = "notify/group"
    static let getApprovalBody = "get/ApprovalBody"
    static let getPaymentCharges = "get/payment/charges"
    static let updateEmail = "member/update/email"
    static let checkMemberDetails = "member/details/exist"
    static let checkEmailAddress = "member/details/exist-by-email"
    static let getCampaignStatement = "group/campaign/statement"
    static let getAppCurrentVersion = "version/getAppCurrentVersion"
    static let memberKycStatus = "member/member-kyc-complete"
    
    func getVoteSummary(_ groupId: String) -> String {

        return "votes/summary/group/\(groupId)"
    }
    static let getMemberActivity = "member/activity"
    
    func getNotVotedMembers(_ groupId: String, voteId: String) -> String {
        
        return "group/\(groupId)/votes/\(voteId)/notvoted/members"
    }
    
    func getVotedMembers(_ groupId: String, voteId: String) -> String {
        
        return "group/\(groupId)/votes/\(voteId)/voted/members"
    }
    
    func getCampaignBalance(_ campaignId: String) -> String {
        
        return "group/campaign/\(campaignId)/balance"
    }
    
    func deleteDevice(_ id: String) -> String {
        
        return "mobile/delete/\(id)"
    }
    
    func cancelSingleMandate(_ id: String) -> String {
        
        return "mandate/\(id)/cancel"
    }
    
    func campaignImages(_ id: String) -> String {
        
        return "campaign/\(id)/images"
    }
    
    func groupBalance(_ id: String) -> String {
        
        return "campaign/balance/\(id)"
    }
    
    func groupActivity(_ groupId: String) -> String {
        
        return "group/\(groupId)/activity"
    }
    
    func appConfiguration(_ countryId: String) -> String {
        return "config/appconfig/\(countryId)"
    }
    
    func getMemberVotedInGroup(_ groupId: String) -> String {
        return "group/\(groupId)/memberVotes"
    }
	
	static let networkErrorMessage = "Oops. Something went wrong."
}


class APIParameter : Codable {
	
}
class DictionaryEncoder {
	private let jsonEncoder = JSONEncoder()
	
	/// Encodes given Encodable value into an array or dictionary
	func encode<T>(_ value: T) throws -> Any where T: Encodable {
		let jsonData = try jsonEncoder.encode(value)
		return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
	}
}

class DictionaryDecoder {
	private let jsonDecoder = JSONDecoder()
	
	/// Decodes given Decodable type from given array or dictionary
	func decode<T>(_ type: T.Type, from json: Any) throws -> T where T: Decodable {
		let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
		return try jsonDecoder.decode(type, from: jsonData)
	}
}

protocol APIConfiguration: URLRequestConvertible {
	var method: HTTPMethod { get }
	var path: String { get }
	var body: [String: Any] { get }
	var headers: HTTPHeaders { get }
	var parameters: [String: Any] { get }
}


struct BaseError: Error {
	let data: Data?
	let httpUrlResponse: HTTPURLResponse
}

enum ApiError: Error {
	case invalidApiKey
	case deactivatedUser
	case userNotFound
	case internalServer
	case badRequest
	case forbidden
	case notFound
	case unauthorized
	case networkError
    case failed
    case sizeFull
}

struct NetworkRequestError: Error {
	let error: Error?
	
	var localizedDescription: String {
		return error?.localizedDescription ?? "Please check your internet connection and try again."
	}
}

class NetworkManager {
	func handleError(_ error: Error) throws {
		if error is BaseError{
			let baseError = error as! BaseError
			let statusCode = baseError.httpUrlResponse.statusCode
			switch statusCode{
			case 401:
				throw ApiError.unauthorized
			case 404:
				throw ApiError.notFound
			case 400:
				throw ApiError.badRequest
			case 99:
				throw ApiError.invalidApiKey
			case 98:
				throw ApiError.userNotFound
			case 97:
				throw ApiError.deactivatedUser
            case 405:
                throw ApiError.failed
            case 500:
                throw ApiError.internalServer
            case 403:
                throw ApiError.sizeFull
            case 502:
                throw ApiError.notFound
			default:
				print("Default Error")
				throw ApiError.notFound
			}
		}else if error is NetworkRequestError{
			throw ApiError.networkError
		}
	}
	
//    func getErrorMessage(error: Error)->String{
//        var message = NetworkingConstants.networkErrorMessage
//        if let apiError = error as? AFError {
//        message = apiError.errorDescription ?? NetworkingConstants.networkErrorMessage
//        }
//        return message
//    }
    
    func getErrorMessage<T>(response: DataResponse<T, AFError>)->String where T: Codable {
        var message = NetworkingConstants.networkErrorMessage
        if let data = response.data {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] {
                print(json)
                if let error = json["errors"] as? NSDictionary {
                    message = error["message"] as! String
                }else if let error = json["error"] as? NSDictionary {
                    if let message1 = error["message"] as? String {
                        message = message1
                    }
                }else if let messages = json["message"] as? String {
                    message = messages
                }else if response.response!.statusCode == 400 {
                    message = "Your session has timed out."
                }else if response.response!.statusCode == 502 {
                    message = "Internal Server Error"
                }

            }
        }
        print("Error Desc: \(response.error?.localizedDescription)")
        print("Error Code0: \(response.error?.asAFError?.failureReason) \(response.response) \(response.response?.statusCode)")
        return message
    }
}

typealias GetPhoneNumberCompletionHandler = (_ phone: String?) -> Void
