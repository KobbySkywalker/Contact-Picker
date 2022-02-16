//
//  AuthEndpoints.swift
//  RideAlong
//
//  Created by Created by Hosny Ben Savage on 20/01/2019.
//  Copyright © 2019 RideAlong. All rights reserved.
//

import Foundation
import Alamofire

enum AuthRouter : APIConfiguration {
    
    case register(parameter: SignUpParameter)
    case getNetworkCode(parameter: NetworkCodeParameter)
    case getPrivateGroups()
    case getPublicGroups()
    case getAllGroups()
    case groupCreation(parameter: GroupCreationParameter)
    case createGroup(parameter: GroupCreationParameter)
    case memberExists(parameter: MemberExistsParameter)
    case joinGroup(parameter: JoinGroupParameter)
    case joinPrivateGroup(parameter: JoinPrivateGroupParameter)
    case addMember(parameter: AddMemberParameter)
    case addMembersToGroup(parameter: AddMembersToGroupParameter)
    case getMembers(parameter: GetMemberParameter)
    case createAdmin(parameter: CreateAdminParameter)
    case createLoanApprover(parameter: CreateLoanApproverParameter)
    case makeLoanApprover(parameter: MakeLoanApproverParameter)
    case revokeLoanApprover(parameter: RevokeLoanApproverParameter)
    case revokeAdmin(parameter: RevokeAdminParameter)
    case dropMember(parameter: DropMemberParameter)
    case isAdmin(parameter: IsAdminParameter)
    case updatePrivateGroupProfilePicture(parameter: UpdatePrivateGroupPictureParameter)
    case updateMember(parameter: UpdateMemberParameter)
    case leaveGroup(parameter: LeaveGroupParameter)
    case getGroupCampaign(parameter: GroupCampaignsParameter)
    case makeContribution(parameter: MakeContributionParameter)
    case contribute(parameter: ContributeParameter)
    case campaignContributions(parameter: CampaignContributionsParameter)
    case getCampaignContribution(parameter: CampaignContributionParameter)
    case memberNetwork()
    case defaultCampaign(parameter: defaultCampaignParameter)
    case getContributions(parameter: GroupContributionsParameter)
    case castVote(parameter: CastVoteParameter)
    case createCampaign(parameter: CreateCampaignParameter)
    case createVote(parameter: CreateVoteParameter)
    case updateRegistrationToken(parameter: UpdateRegistrationTokenParameter)
    case memberContributions(parameter: memberContributionsParameter)
    case getContributionPublicGroups()
    case personalContributions(parameter: PersonalContributionsParameter)
    case groupTotals(parameter: GroupTotalsParameter)
    case sendFeedback(parameter: FeedbackParameter)
    case createdVotes(parameter: CreatedVoteParameter)
    case publicContact(parameter: PublicContactParameter)
    case initiateCashout(parameter: InitiateCashoutParameter)
    case cashout(parameter: CashoutVoteParameter)
    case requestLoan(parameter: RequestLoanParameter)
    case getStatement(parameter: GetStatementParameter)
    case grantLoan(parameter: GrantLoanParameter)
    case getGroupLoan(parameter: GetGroupLoanParameter)
    case getVoteSummary(parameter: GetVoteSummaryParameter)
    case getMemberActivity()
    case getNotVotedMembers(parameter: GetNotVotedParameter)
    case getVotedMembers(parameter: GetVotedParameter)
    case getCampaignBalance(parameter: GetCampaignBalanceParameter)
    case createDevice(parameter: CreateDeviceParameter)
    case deleteDevice(parameter: DeleteDeviceParameter)
    case startCampaign(parameter: StartCampaignParameter)
    case pauseCampaign(parameter: PauseCampaignParameter)
    case endCampaign(parameter: EndCampaignParameter)
    case getRecentPersonalContribution()
    case extendCampaign(parameter: ExtendCampaignParameter)
    case getVotes(parameter: GetVotesParameter)
    case recurringPayment(parameter: RecurringOTPParameter)
    case cancelSingleMandate(parameter: CancelSingleMandateParameter)
    case cancelAllMandates(parameter: [String])
    case campaignImages(parameter: CampaignImagesParameter)
    case groupBalance(parameter: GroupBalanceParameter)
    case recurringExpiry(parameter: RecurringExpiryParameter)
    case getGroupPolicies(parameter: GroupPoliciesParameter)
    case getGroupPolicy(parameter: GroupPoliciesParameter)
    case getGroupActivity(parameter: GroupActivityParameter)
    case reportPrivateGroup(parameter: ReportPrivateGroupParameter)
    case reportPublicCampaign(parameter: ReportPublicCampaignParameter)
    case editGroupName(parameter: EditGroupNameParameter)
    case retrieveGroupLimits(parameter: GroupLimitsParamter)
    case getMaxSingleContributionLimit(parameter: GroupLimitsParamter)
    case getMaxSingleCashoutLimit(parameter: GroupLimitsParamter)
    case initiateAdminCreation(parameter: InitiateAdminCreationParameter)
    case executeMakeAdmin(parameter: ExecuteMakeAdminParameter)
    case reactivateMandate(parameter: ReactivateMandateParameter)
    case initiateAdminRevokal(parameter: InitiateAdminRevokalParameter)
    case initiateApproverRevokal(parameter: InitiateApproverRevokalParameter)
    case initiateDropMember(parameter: InitiateDropMemberParameter)
    case executeRevokeAdmin(parameter: ExecuteRevokeAdminParameter)
    case executeRevokeApprover(parameter: ExecuteRevokeApproverParameter)
    case registerGroupLink(parameter: RegisterGroupLinkParameter)
    case verifyGroupLink(parameter: VerifyGroupLinkParameter)
    case saveGroupLink(parameter: SaveGroupLinkParameter)
    case retrieveGroupLink(parameter: RetrieveGroupLinkParameter)
    case appConfiguration(parameter: AppConfigurationParameter)
    case approvedCashout(parameter: ApprovedCashoutParameter)
    case addCreditCard(parameter: AddCreditCardParameter)
    case addWallet(parameter: AddWalletParameter)
    case deleteWallet(parameter: DeleteWalletParameter)
    case getPaymentMethods()
    case requestACallback(parameter: RequestACallbackParameter)
    case getSupportDetails(parameter: GetSupportDetailsParameter)
    case activeCampaignCount(parameter: ActiveCampaignCountParameter)
    case retrieveGroupMemberCount(parameter: RetrieveGroupMemberCountParameter)
    case getMemberVotedInGroup(parameter: GetMemberVotedInGroupParameter)
    case getArchivedCampaigns(parameter: GetArchivedCampaignsParameter)
    case getActivePausedCampaigns(parameter: GetActivePausedCampaignsParameter)
    case getMinVoteAllBallots(parameter: MinVotesAllBallotsParameter)
    case walletOTPGeneration(parameter: WalletOTPGenerationParameter)
    case walletOTPVerification(parameter: WalletOTPVerificationParameter)
    case retrieveCountryChannelDestinations(parameter: countryChannelsParameter)
    case addKYC(parameter: AddKYCParameter)
    case deleteMemberInviteInGroup(parameter: DeleteMemberInviteInGroupParameter)
    case getMemberWallets(parameter: GetMemberWalletsParameter)
    case getNameRegisteredOnMobileWallet(parameter: GetNameRegisteredOnWalletParameter)
    case verifyCard(parameter: VerifyCardParameter)
    case verifyAmountDebited(parameter: VerifyDebitedAmountParameter)
    case limitsForUnverifiedCards(parameter: LimitsForUnverifiedCardsParameter)
    case retrieveMember()
    case maxVerificationAttempts()
    case initiateLoanWithWallet(parameter: InitiateLoanWithWalletParameter)
    case executeLoan(parameter: ExecuteLoanParameter)
    case pushNotificationForChats(parameter: PushNotificationParameter)
    case getApprovalBody(parameter: GetApprovalBodyParameter)
    case getPaymentCharge(parameter: GetPaymentChargeParameter)
    case updateEmail
    case checkMemberDetail(parameter: CheckMemberDetailsParameter)
    case checkEmailAddress(parameter: CheckMemberDetailsParameter)
    case getCampaignStatement(parameter: GetCampaignStatementParameter)
    case getAppCurrentVersion()
    case memberKycStatus(parameter: MemberKycCompleteParameter)
    case registerUser(parameter: RegisterParameter)
    case initiateCashoutPolicyChange(parameter: CashoutPolicyChangeParameter)
    
	internal var method: HTTPMethod {
		switch self {
        case .register:
            return .post
        case .getNetworkCode:
            return .get
        case .getPrivateGroups:
            return .get
        case .getPublicGroups:
            return .get
        case .getAllGroups:
            return .get
        case .groupCreation:
            return .post
        case .createGroup:
            return .post
        case .memberExists:
            return .get
        case .joinGroup:
            return .get
        case .joinPrivateGroup:
            return .get
        case .addMember:
            return .post
        case .addMembersToGroup:
            return .post
        case .getMembers:
            return .get
        case .createAdmin:
            return .post
        case .createLoanApprover:
            return .post
        case .makeLoanApprover:
                return .post
        case .revokeLoanApprover:
            return .post
        case .revokeAdmin:
            return .post
        case .dropMember:
            return .post
        case .isAdmin:
            return .get
        case .updatePrivateGroupProfilePicture:
            return .post
        case .updateMember:
            return .get
        case .updateRegistrationToken:
            return .get
        case .leaveGroup:
            return .get
        case .getGroupCampaign:
            return .get
        case .makeContribution:
            return .post
        case .contribute:
            return .post
        case .campaignContributions:
            return .post
        case .getCampaignContribution:
            return .get
        case .memberNetwork:
            return .get
        case .defaultCampaign:
            return .get
        case .getContributions:
            return .post
        case .castVote:
            return .post
        case .createCampaign:
            return .post
        case .createVote:
            return .post
        case .memberContributions:
            return .get
        case .getContributionPublicGroups:
            return .get
        case .personalContributions:
            return .post
        case .groupTotals:
            return .post
        case .sendFeedback:
            return .post
        case .createdVotes:
            return .get
        case .publicContact:
            return .get
        case .initiateCashout:
            return .post
        case .cashout:
            return .post
        case .requestLoan:
            return .post
        case .getStatement:
            return .post
        case .grantLoan:
            return .post
        case .getGroupLoan:
            return .get
        case .getVoteSummary:
            return .get
        case .getMemberActivity:
            return .get
        case .getNotVotedMembers:
            return .get
        case .getVotedMembers:
            return .get
        case .getCampaignBalance:
            return .get
        case .createDevice:
            return .post
        case .deleteDevice:
            return .get
        case .startCampaign:
            return .get
        case .pauseCampaign:
            return .get
        case .endCampaign:
            return .get
        case .getRecentPersonalContribution:
            return .post
        case .extendCampaign:
            return .post
        case .getVotes:
            return .get
        case .recurringPayment:
            return .post
        case .cancelSingleMandate:
            return .get
        case .cancelAllMandates:
            return .post
        case .campaignImages:
            return .get
        case .groupBalance:
            return .get
        case .recurringExpiry:
            return .post
        case .getGroupPolicies:
            return .get
        case .getGroupPolicy:
            return .get
        case .getGroupActivity:
            return .get
        case .reportPrivateGroup:
            return .post
        case .reportPublicCampaign:
            return .post
        case .editGroupName:
            return .post
        case .retrieveGroupLimits:
            return .get
        case .getMaxSingleContributionLimit:
            return .get
        case .getMaxSingleCashoutLimit:
            return .get
        case .initiateAdminCreation:
            return .post
        case .executeMakeAdmin:
            return .post
        case .reactivateMandate:
            return .get
        case .initiateAdminRevokal:
            return .post
        case .initiateApproverRevokal:
            return .post
        case .initiateDropMember:
            return .post
        case .executeRevokeAdmin:
            return .post
        case .executeRevokeApprover:
            return .post
        case .registerGroupLink:
           return .post
        case .saveGroupLink:
            return .post
        case .verifyGroupLink:
            return .get
        case .retrieveGroupLink:
            return .get
        case .appConfiguration:
                return .get
        case .approvedCashout:
            return .post
        case .addCreditCard:
            return .post
        case .addWallet:
            return .post
        case .deleteWallet:
            return .post
        case .getPaymentMethods:
            return .post
        case .requestACallback:
            return .get
        case .getSupportDetails:
            return .get
        case .activeCampaignCount:
            return .get
        case .retrieveGroupMemberCount:
            return .get
        case .getMemberVotedInGroup:
            return .get
        case .getArchivedCampaigns:
            return .get
        case .getActivePausedCampaigns:
            return .get
        case .getMinVoteAllBallots:
            return .get
        case .walletOTPGeneration:
            return .get
        case .walletOTPVerification:
            return .get
        case .retrieveCountryChannelDestinations:
            return .get
        case .addKYC:
            return .post
        case .deleteMemberInviteInGroup:
            return .get
        case .getMemberWallets:
            return .post
        case .getNameRegisteredOnMobileWallet:
            return .post
        case .verifyCard:
            return .get
        case .verifyAmountDebited:
            return .get
        case .limitsForUnverifiedCards:
            return .get
        case .retrieveMember:
            return .get
        case .maxVerificationAttempts:
            return .get
        case .initiateLoanWithWallet:
            return .post
        case .executeLoan:
            return .post
        case .pushNotificationForChats:
            return .post
        case .getApprovalBody:
            return .post
        case .getPaymentCharge:
            return .post
        case .updateEmail:
            return .get
        case .checkMemberDetail:
            return .post
        case .checkEmailAddress:
            return .post
        case .getCampaignStatement:
            return .post
        case .getAppCurrentVersion:
            return .get
        case .memberKycStatus:
            return .get
        case .registerUser:
            return .post
        case .initiateCashoutPolicyChange:
            return .post
		}
	}
	
	internal var path: String {

		switch self {
        case .register:
            return NetworkingConstants.register
        case .getNetworkCode:
            return NetworkingConstants.getNetworkCode
        case .getPrivateGroups:
            return NetworkingConstants.getPrivateGroups
        case .getPublicGroups:
            return NetworkingConstants.getPublicGroups
        case .getAllGroups:
            return NetworkingConstants.getAllGroups
        case .groupCreation:
            return NetworkingConstants.createPrivateGroup
        case .createGroup:
            return NetworkingConstants.createNewPrivateGroup
        case .memberExists:
            return NetworkingConstants.memberExists
        case .joinGroup:
            return NetworkingConstants.joinGroup
//            return "https://apiv2uat.changoglobal.com/api/group/group/private/join"
        case .joinPrivateGroup:
            return NetworkingConstants.joinPrivateGroup
//            return "https://apiv2uat.changoglobal.com/api/group/private/joinGroup"
        case .addMember:
            return NetworkingConstants.addMember
//            return "https://apiv2uat.changoglobal.com/api/group/private/member/add"
        case .addMembersToGroup:
            return NetworkingConstants.addMembersToGroup
//            return "https://apiv2uat.changoglobal.com/api/group/private/member/add"
        case .getMembers:
            return NetworkingConstants.getMembers
        case .createAdmin:
            return NetworkingConstants.createAdmin
        case .createLoanApprover:
            return NetworkingConstants.createLoanApprover
        case .makeLoanApprover:
            return NetworkingConstants.makeLoanApprover
        case .revokeLoanApprover:
            return NetworkingConstants.revokeLoanApprover
        case .revokeAdmin:
            return NetworkingConstants.revokeAdmin
        case .dropMember:
            return NetworkingConstants.dropMember
        case .isAdmin:
            return NetworkingConstants.isAdmin
        case .updatePrivateGroupProfilePicture:
            return NetworkingConstants.updatePrivateGroupPicture
        case .updateMember:
            return NetworkingConstants.updateMember
        case .updateRegistrationToken:
            return NetworkingConstants.updateRegistrationToken
        case .leaveGroup:
            return NetworkingConstants.leaveGroup
        case .getGroupCampaign:
            return NetworkingConstants.getGroupCampaign
        case .makeContribution:
            return NetworkingConstants.makeContribution
        case .contribute:
            return NetworkingConstants.contribute
        case .memberNetwork:
            return NetworkingConstants.memberNetwork
        case .defaultCampaign:
            return NetworkingConstants.defaultCampaign
        case .getContributions:
            return NetworkingConstants.getContributions
        case .campaignContributions:
            return NetworkingConstants.campaignContributions
        case .getCampaignContribution:
            return NetworkingConstants.getCampaginContribution
        case .castVote:
            return NetworkingConstants.castVote
        case .createCampaign:
            return NetworkingConstants.createCampaign
        case .createVote:
            return NetworkingConstants.createVote
        case .memberContributions:
            return NetworkingConstants.memberContributions
        case .getContributionPublicGroups:
            return NetworkingConstants.getContributionPublicGroups
        case .personalContributions:
            return NetworkingConstants.personalContributions
        case .groupTotals:
            return NetworkingConstants.groupTotals
        case .sendFeedback:
            return NetworkingConstants.sendFeedback
        case .createdVotes:
            return NetworkingConstants.createdVotes
        case .publicContact:
            return NetworkingConstants.publicContact
        case .initiateCashout:
            return NetworkingConstants.initiateCashout
        case .cashout:
            return NetworkingConstants.cashout
        case .requestLoan:
            return NetworkingConstants.requestLoan
        case .getStatement:
            return NetworkingConstants.getStatement
        case .grantLoan:
            return NetworkingConstants.grantLoan
        case .getGroupLoan:
            return NetworkingConstants.getGroupLoan
        case .getVoteSummary(let groupId):
            return NetworkingConstants().getVoteSummary(groupId.groupId)
        case .getMemberActivity:
            return NetworkingConstants.getMemberActivity
        case .getVotedMembers(let groupId):
            return NetworkingConstants().getVotedMembers(groupId.groupId, voteId: groupId.voteId)
        case .getNotVotedMembers(let groupId):
            return NetworkingConstants().getNotVotedMembers(groupId.groupId, voteId: groupId.voteId)
        case .getCampaignBalance(let campaignId):
            return NetworkingConstants().getCampaignBalance(campaignId.campaignId)
        case .createDevice:
            return NetworkingConstants.createDevice
        case .deleteDevice(let id):
            return NetworkingConstants().deleteDevice(id.id)
        case .startCampaign:
            return NetworkingConstants.startCampaign
        case .pauseCampaign:
            return NetworkingConstants.pauseCampaign
        case .endCampaign:
            return NetworkingConstants.endCampaign
        case .getRecentPersonalContribution:
            return NetworkingConstants.getRecentPersonalContribution
        case .extendCampaign:
            return NetworkingConstants.extendCampaign
        case .getVotes:
            return NetworkingConstants.getVotes
        case .recurringPayment:
            return NetworkingConstants.recurringPayment
        case .cancelSingleMandate(let id):
            return NetworkingConstants().cancelSingleMandate(id.id)
        case .cancelAllMandates:
            return NetworkingConstants.cancelAllMandates
        case .campaignImages(let id):
            return NetworkingConstants().campaignImages(id.id)
        case .groupBalance(let id):
            return NetworkingConstants().groupBalance(id.id)
        case .recurringExpiry:
            return NetworkingConstants.getRecurringExpiry
        case .getGroupPolicies:
            return NetworkingConstants.getGroupPolicies
        case .getGroupPolicy:
            return NetworkingConstants.getGroupPolicy
        case .getGroupActivity(let groupId):
            return NetworkingConstants().groupActivity(groupId.groupId)
        case .reportPrivateGroup:
            return NetworkingConstants.reportPrivateGroup
        case .reportPublicCampaign:
            return NetworkingConstants.reportPublicCampaign
        case .editGroupName:
            return NetworkingConstants.editGroupName
        case .retrieveGroupLimits:
            return NetworkingConstants.retrieveGroupLimits
        case .getMaxSingleContributionLimit:
            return NetworkingConstants.getMaxSingleContributionLimit
        case .getMaxSingleCashoutLimit:
            return NetworkingConstants.getMaxSingleCashoutLimit
        case .initiateAdminCreation:
            return NetworkingConstants.initiateAdminCreation
        case .executeMakeAdmin:
            return NetworkingConstants.executeMakeAdmin
        case .reactivateMandate:
            return NetworkingConstants.reactivateMandate
        case .initiateAdminRevokal:
            return NetworkingConstants.initiateAdminRevokal
        case .initiateApproverRevokal:
            return NetworkingConstants.initiateApproverRevokal
        case .initiateDropMember:
            return NetworkingConstants.initiateDropMember
        case .executeRevokeAdmin:
            return NetworkingConstants.executeRevokeAdmin
        case .executeRevokeApprover:
            return NetworkingConstants.executeRevokeApprover
        case .registerGroupLink:
            return NetworkingConstants.registerGroupLink
        case .saveGroupLink:
            return NetworkingConstants.saveGroupLink
        case .verifyGroupLink:
            return NetworkingConstants.verifyGroupLink
        case .retrieveGroupLink:
            return NetworkingConstants.retrieveGroupLink
        case .appConfiguration(let countryId):
                return NetworkingConstants().appConfiguration(countryId.countryId)
        case .approvedCashout:
            return NetworkingConstants.getApprovedCashout
        case .addCreditCard:
            return NetworkingConstants.addCreditCard
        case .addWallet:
            return NetworkingConstants.addWallet
        case .deleteWallet:
            return NetworkingConstants.deleteWallet
        case .getPaymentMethods:
            return NetworkingConstants.getPaymentMethdos
        case .requestACallback:
            return NetworkingConstants.requestACallback
        case .getSupportDetails:
            return NetworkingConstants.getSupportDetails
        case .activeCampaignCount:
            return NetworkingConstants.activeCampaignCount
        case .retrieveGroupMemberCount:
            return NetworkingConstants.retrieveGroupMemberCount
        case .getMemberVotedInGroup(let groupId):
            return NetworkingConstants().getMemberVotedInGroup(groupId.groupId)
        case .getArchivedCampaigns:
            return NetworkingConstants.archivedCampaigns
        case .getActivePausedCampaigns:
            return NetworkingConstants.activePausedCamapaigns
        case .getMinVoteAllBallots:
            return NetworkingConstants.getMinVoteAllBallots
        case .walletOTPGeneration:
            return NetworkingConstants.generateOTPForWallet
        case .walletOTPVerification:
            return NetworkingConstants.verifyOTPForWallet
        case .retrieveCountryChannelDestinations:
            return NetworkingConstants.retrieveCountryChannelsDestinations
        case .addKYC:
            return NetworkingConstants.addKYC
        case .deleteMemberInviteInGroup:
            return NetworkingConstants.deleteMemberInviteInGroup
        case .getMemberWallets:
            return NetworkingConstants.getMemberWallets
        case .getNameRegisteredOnMobileWallet:
            return NetworkingConstants.getNameRegisteredOnMobileWallet
        case .verifyCard:
            return NetworkingConstants.verifyCard
        case .verifyAmountDebited:
            return NetworkingConstants.verifyDebitedAmount
        case .limitsForUnverifiedCards:
            return NetworkingConstants.limitsForUnverifiedCards
        case .retrieveMember:
            return NetworkingConstants.retrieveMember
        case .maxVerificationAttempts:
            return NetworkingConstants.maxVerificationAttempts
        case .initiateLoanWithWallet:
            return NetworkingConstants.initiateLoanWithWallet
        case .executeLoan:
            return NetworkingConstants.executeLoan
        case .pushNotificationForChats:
            return NetworkingConstants.pushNotificationForChats
        case .getApprovalBody:
            return NetworkingConstants.getApprovalBody
        case .getPaymentCharge:
            return NetworkingConstants.getPaymentCharges
        case .updateEmail:
            return NetworkingConstants.updateEmail
        case .checkMemberDetail:
            return NetworkingConstants.checkMemberDetails
        case .checkEmailAddress:
            return NetworkingConstants.checkEmailAddress
        case .getCampaignStatement:
            return NetworkingConstants.getCampaignStatement
        case .getAppCurrentVersion:
            return NetworkingConstants.getAppCurrentVersion
        case .memberKycStatus:
            return NetworkingConstants.memberKycStatus
        case .registerUser:
            return NetworkingConstants.registerUser
        case .initiateCashoutPolicyChange:
            return NetworkingConstants.initiateCashoutPolicyChange
		}
	}
    
    
    internal var parameters: [String : Any] {
        switch self {
            
        case .register(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getNetworkCode(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
        case .getPrivateGroups:
            return [:]
            
            
        case .getPublicGroups:
            return [:]
            
        case .getAllGroups:
                return [:]
            
        case .groupCreation(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
//        case .groupCreation(countryId: String, groupName: String, description: String, ballotDetail: [BallotDetail], tnc: String, msisdn: [String], loanFlag: String)
//
//            
//            let parameters: Parameters = ["countryId": countryId,
//                                          "groupName": ,
//                                          "description": description,
//                                          "ballotDetail": [BallotDetail],
//                                          "tnc": tnc,
//                                          "msisdn": msisdn,
//                                          "loanFlag": loanFlag]
        case .createGroup(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param

        case .memberExists(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
            
        case .joinGroup(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .joinPrivateGroup(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .addMember:
            return [:]
            
        case .addMembersToGroup:
            return [:]
            
        case .getMembers(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .createAdmin(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .createLoanApprover(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .makeLoanApprover(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .revokeLoanApprover(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .revokeAdmin(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .dropMember(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .isAdmin(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .updatePrivateGroupProfilePicture(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .updateRegistrationToken(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .updateMember(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .leaveGroup(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getGroupCampaign(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .makeContribution(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .contribute(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
            
        case .memberNetwork:
            return [:]
            
        case .defaultCampaign(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getContributions(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .campaignContributions(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getCampaignContribution(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .castVote(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .createCampaign(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .createVote(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .memberContributions(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getContributionPublicGroups:
            return [:]
            
        case .personalContributions(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .groupTotals(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .sendFeedback(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .createdVotes(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .publicContact(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .initiateCashout(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .cashout(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .requestLoan(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getStatement(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .grantLoan(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getGroupLoan(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getVoteSummary:
            return [:]
            
        case .getMemberActivity:
            return [:]
            
        case .getNotVotedMembers(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getVotedMembers(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getCampaignBalance(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .createDevice(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .deleteDevice(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .startCampaign(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .pauseCampaign(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .endCampaign(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getRecentPersonalContribution:
            return [:]
            
        case .extendCampaign(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getVotes(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .recurringPayment(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .cancelSingleMandate:
            return [:]
            
        case .cancelAllMandates:
            return [:]
            
        case .campaignImages:
            return [:]
            
        case .groupBalance:
            return [:]
            
        case .recurringExpiry(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getGroupPolicies(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getGroupPolicy(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getGroupActivity(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
            case .reportPrivateGroup(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .reportPublicCampaign(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
        case .editGroupName(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
            case .retrieveGroupLimits(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .getMaxSingleContributionLimit(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .getMaxSingleCashoutLimit(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .initiateAdminCreation(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
                
        case .initiateDropMember(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
            case .executeMakeAdmin(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .reactivateMandate(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .initiateAdminRevokal(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .initiateApproverRevokal(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .executeRevokeAdmin(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .executeRevokeApprover(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .registerGroupLink(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .saveGroupLink(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .verifyGroupLink(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .retrieveGroupLink(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .approvedCashout(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .appConfiguration:
                return [:]
            
            case .addCreditCard(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .addWallet(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
                
        case .deleteWallet(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
            case .getPaymentMethods:
                return [:]
            
            case .requestACallback(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .getSupportDetails(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .activeCampaignCount(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .retrieveGroupMemberCount(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .getMemberVotedInGroup(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
                
        case .getArchivedCampaigns(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getActivePausedCampaigns(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param

        case .getMinVoteAllBallots(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .walletOTPGeneration(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .walletOTPVerification(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .retrieveCountryChannelDestinations(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .addKYC(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .deleteMemberInviteInGroup(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getMemberWallets(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getNameRegisteredOnMobileWallet(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .verifyCard(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .verifyAmountDebited(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .limitsForUnverifiedCards(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .retrieveMember:
            return [:]
            
        case .maxVerificationAttempts:
            return [:]
            
        case .initiateLoanWithWallet(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .executeLoan(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .pushNotificationForChats(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getApprovalBody(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getPaymentCharge(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .updateEmail:
            return [:]
            
        case .checkMemberDetail(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .checkEmailAddress(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param

        case .getCampaignStatement(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param

        case .getAppCurrentVersion():
            return [:]

        case .memberKycStatus(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param

        case .registerUser(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param

        case .initiateCashoutPolicyChange(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
        }
    }
	
	
	internal var body: [String : Any] {
		switch self {
		
        case .register(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getNetworkCode(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param

        case .groupCreation(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .createGroup(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .memberExists(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param

        case .addMember(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .addMembersToGroup(let parameter):
            var param: [String: Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String: Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .createAdmin(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .createLoanApprover(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .makeLoanApprover(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .revokeLoanApprover(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .revokeAdmin(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .dropMember(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .updatePrivateGroupProfilePicture(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param

        case .updateRegistrationToken(let parameter):  
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
        
        case .makeContribution(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .contribute(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param

        case .getContributions(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .campaignContributions(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param

        case .castVote(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
        case .createCampaign(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .createVote(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .personalContributions(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .groupTotals(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .sendFeedback(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .initiateCashout(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .cashout(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .requestLoan(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getStatement(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .grantLoan(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param

        case .getCampaignBalance(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .createDevice(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .deleteDevice(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .extendCampaign(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .recurringPayment(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param

        case .cancelAllMandates:

            return [:]
            
        case .recurringExpiry(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param

            case .reportPrivateGroup(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .reportPublicCampaign(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .editGroupName(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param

            case .getMaxSingleContributionLimit(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .getMaxSingleCashoutLimit(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .initiateAdminCreation(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
                
        case .initiateDropMember(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
            case .executeMakeAdmin(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .initiateAdminRevokal(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .initiateApproverRevokal(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .executeRevokeAdmin(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .executeRevokeApprover(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .registerGroupLink(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .saveGroupLink(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                print("Couldn't parse parameter")
                }
                return param
            
            case .approvedCashout(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .addCreditCard(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
            
            case .addWallet(let parameter):
                var param: [String:Any] = [:]
                do{
                    let param1 = try DictionaryEncoder().encode(parameter)
                    print("Param1: \(param1)")
                    param = param1 as! [String : Any]
                }catch {
                    print("Couldn't parse parameter")
                }
                return param
                
            case .deleteWallet(let parameter):
                var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param12: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
                
            case .addKYC(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
                
        case .getMemberWallets(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getNameRegisteredOnMobileWallet(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .initiateLoanWithWallet(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .executeLoan(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .pushNotificationForChats(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getApprovalBody(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .getPaymentCharge(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .checkMemberDetail(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
        case .checkEmailAddress(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param

        case .getCampaignStatement(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param

        case .registerUser(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param

        case .initiateCashoutPolicyChange(let parameter):
            var param: [String:Any] = [:]
            do{
                let param1 = try DictionaryEncoder().encode(parameter)
                print("Param1: \(param1)")
                param = param1 as! [String : Any]
            }catch {
                print("Couldn't parse parameter")
            }
            return param
            
            default:
                return [:]
		}
    }
 

    
    
    
    
    
	
	
	
	internal var headers: HTTPHeaders {
		switch self {
        case .getNetworkCode, .appConfiguration, .checkEmailAddress, .deleteDevice, .retrieveCountryChannelDestinations:
            return ["Content-Type":"application/json"]
		default:
            let api_token = UserDefaults.standard.string(forKey: "idToken")
            if(api_token != nil){
                return ["idToken" : "\(api_token!)","Content-Type":"application/json", "Accept":"application/json"]
            }
			return ["Content-Type":"application/json", "Accept":"application/json"]
		}
	}
	
	
	
    func asURLRequest() throws -> URLRequest {
        var urlComponents: URLComponents
//        switch self {
//        case .addMembersToGroup, .joinPrivateGroup:
//            urlComponents = URLComponents(string: path)!
//        default:
            urlComponents = URLComponents(string: NetworkingConstants.baseUrl + path)!
//        }
        var queryItems:[URLQueryItem] = []
        for item in parameters {
            queryItems.append(URLQueryItem(name: item.key, value: "\(item.value)"))
        }
        if(!(queryItems.isEmpty)){
            urlComponents.queryItems = queryItems
            print("Query Items: \(queryItems)")
            print(parameters)
        }
        let url = urlComponents.url!
        print("Full URL: \(url)")
        print("headers: \(headers.dictionary)")
        print("body: \(body)")
        print(path)
        print("parameters: \(parameters)")
        
        
        
        
        var urlRequest = URLRequest(url: url)
        
        var jsonData1: Data! = nil
        
        switch self {
            
        case .cancelAllMandates(let param):
            
            jsonData1 = try JSONSerialization.data(withJSONObject: param)
            
            urlRequest.httpBody = jsonData1
            print("body: \(jsonData1)")
            break
        default:
            jsonData1 = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            
        }
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers.dictionary
        if(!body.isEmpty) {
            urlRequest.httpBody = jsonData1
            //                    let show =  try URLEncoding.methodDependent.encode(urlRequest, with: body)
            print("body: \(jsonData1)")
        }
        
        return urlRequest
    }
}






//************************************** AUTH MANAGER PARAMETERS **********************************************//




struct SignUpParameter: Codable {
//    var networkCode: String
    var countryId: String
    var email: String
    var firstName: String
    var lastName: String
    var msisdn: String
    var language: String
    var registrationToken: String
    
}


struct NetworkCodeParameter: Codable {
    var countryId: String
}

struct MemberExistsParameter: Codable {
    var phone: String
}

struct BallotDetail: Codable {
    var ballotId: String
    var minVote: String
    
}
struct BallotDetailLoans: Codable {
    var ballotId: String
    var minVote: String
}

struct GroupCreationParameter: Codable {
    var countryId: String
    var groupName: String
    var description: String
    var ballotDetail: [BallotDetail]
    var tnc: String
    var msisdn: [String]
    var loanFlag: String
    
    private enum CodingKeys: String, CodingKey {
        case countryId
        case groupName
        case description
        case ballotDetail
        case tnc
        case msisdn
        case loanFlag
    }
}


struct JoinGroupParameter: Codable {
    var groupId: String
    
}

struct JoinPrivateGroupParameter: Codable {
    var groupId: String
    
}

struct AddMemberParameter: Codable {
    var groupId: String
    var msisdnList: [String]
}


struct AddMembersToGroupParameter: Codable {
    var groupId: String
    var msisdnList: [String]
}

struct GetMemberParameter: Codable {
    var groupId: String
}


struct CreateAdminParameter: Codable {
    var groupId: String
    var memberId: String
    var status: String
    
    private enum CodingKeys: String, CodingKey {
        case groupId
        case memberId
        case status
    }
}

struct CreateLoanApproverParameter: Codable {
    var groupId: String
    var memberId: String
    var status: String
    
    private enum CodingKeys: String, CodingKey {
        
        case groupId
        case memberId
        case status
    }
    
}


struct MakeLoanApproverParameter: Codable {
    var groupId: String
    var memberId: String
    var status: String
    
}

struct RevokeLoanApproverParameter: Codable {
    var groupId: String
    var memberId: String
    var status: String
    
    
    private enum CodingKeys: String, CodingKey {
        
        case groupId
        case memberId
        case status
    }
}

struct RevokeAdminParameter: Codable {
    var groupId: String
    var memberId: String
    var status: String
    
    private enum CodingKeys: String, CodingKey {
        
        case groupId
        case memberId
        case status
    }
}

struct DropMemberParameter: Codable {
    var voteId: String
    var status: String
}

struct IsAdminParameter: Codable {
    var groupId: String
}

struct UpdatePrivateGroupPictureParameter: Codable {
    var groupIconPath: String
    var groupId: String
}


struct UpdateMemberParameter: Codable {
    var image: String
}


struct LeaveGroupParameter: Codable {
    var groupId: String
}

struct CampaignContributionsParameter: Codable {
    var campaignId: String
    var offset: String
    var pageSize: String
}

struct GroupContributionsParameter: Codable {
    var groupId: String
    var offset: String
    var pageSize: String
}

struct CampaignContributionParameter: Codable {
    var campaignId: String
}

struct CastVoteParameter: Codable {
    var groupId: String
    var memberId: String
    var role: String
    var status: String
    var voteId: String
}

struct CreateCampaignParameter: Codable {
    var amountReceived: String
    var campaignId: String
    var campaignName: String
    var description: String
    var campaignType: String
    var end: String
    var groupId: String
    var start: String
    var target: String
    
    private enum CodingKeys: String, CodingKey {
        case amountReceived
        case campaignId
        case campaignName
        case description
        case campaignType
        case end
        case groupId
        case start
        case target
    }
}

struct CreateVoteParameter: Codable {
    var ballotDetail: [BallotDetail]
    var groupId: String
    var rejectMemberId: String
    var role: String
    var score: String
    var status: String
}


struct UpdateRegistrationTokenParameter: Codable {
    var registrationToken: String
    
    private enum CodingKeys: String, CodingKey {

        case registrationToken
    }
}

struct GroupCampaignsParameter: Codable {
    var groupId: String
}

struct ContributeParameter: Codable {
    var amount: Double
    var anonymous: String
    var campaignId: String
    var currency: String
    var duration: String
    var freqType: String
    var groupId: String
    var narration: String
    var othersMemberId: String
    var recurring: String
    var walletId: String

}

struct MakeContributionParameter: Codable {
    var amount: Double
    var campaignId: String
    var currency: String
    var destination: String
    var groupId: String
    var invoiceId: String
    var duration: String
    var freqType: String
    var msisdn: String
    var narration: String
    var network: String
    var recurring: String
    var voucher: String
    var othersMsisdn: String
    var othersMemberId: String
    var anonymous: String
    
    private enum CodingKeys: String, CodingKey {
        case amount
        case campaignId
        case currency
        case destination
        case groupId
        case invoiceId
        case duration
        case freqType
        case msisdn
        case narration
        case network
        case recurring
        case voucher
        case othersMsisdn
        case othersMemberId
        case anonymous
    }
}

struct RecurringOTPParameter: Codable {
//    var otp: String
    var phone: String
    var thirdPartyReferenceNo: String
}

struct defaultCampaignParameter: Codable {
    var groupId: String
}

struct memberContributionsParameter: Codable {
    var campaignId: String
}

struct PersonalContributionsParameter: Codable {
    var offset: String
    var pageSize: String
}

struct GroupTotalsParameter: Codable {
    var groupId: String
}

struct FeedbackParameter: Codable {
    var anonymous: String
    var campaignId: String
    var groupId: String
    var message: String
}

struct CreatedVoteParameter: Codable {
    var groupId: String
}

struct PublicContactParameter: Codable {
    var groupId: String
}

struct InitiateCashoutParameter: Codable {
    var amount: String
    var campaignId: String
    var cashoutDestination: String
    var cashoutDestinationCode: String
    var cashoutDestinationNumber: String
    var cashoutRecipientName: String
    var groupId: String
    var reason: String
    
}

struct CashoutVoteParameter: Codable {
    var campaignId: String
    var status: String
    var voteId: String
}

struct RequestLoanParameter: Codable {
    var amount: String
    var reason: String
    var campaignId: String
    var groupId: String
    var memberId: String
    var status: String
    var voteId: String
    var cashoutDestination: String = ""
    var cashoutDestinationCode: String = ""
    var cashoutDestinationNumber: String = ""
}

struct GetStatementParameter: Codable {
    var email: String
    var end: String
    var groupId: String
    var start: String
    var format: String
    var statementType: String
    var memberId: String
}

struct GrantLoanParameter: Codable {
    var amount: String
    var cashoutDestination: String
    var cashoutDestinationCode: String
    var cashoutDestinationNumber: String
    var campaignId: String
    var groupId: String
    var memberId: String
    var reason: String
    var status: String
    var voteId: String
}

struct GetGroupLoanParameter: Codable {
    var groupId: String
}

struct GetVoteSummaryParameter: Codable {
    var groupId: String
}

struct GetNotVotedParameter: Codable {
    var groupId: String
    var voteId: String
}

struct GetVotedParameter: Codable {
    var groupId: String
    var voteId: String
}

struct GetCampaignBalanceParameter: Codable {
    var campaignId: String
}

struct CreateDeviceParameter: Codable {
    var memberId: String
    var regToken: String
}

struct DeleteDeviceParameter: Codable {
    var id: String
}

struct StartCampaignParameter: Codable {
    var campaignId: String
}

struct PauseCampaignParameter: Codable {
    var campaignId: String
}

struct EndCampaignParameter: Codable {
    var campaignId: String
}

struct ExtendCampaignParameter: Codable {
    var campaignId: String
    var endDate: String
    var groupId: String
}

struct GetVotesParameter: Codable {
    var groupId: String
}


struct CancelSingleMandateParameter: Codable {
    var id: String
}

struct CancelAllMandatesParameter: Codable {
    var mandateIds: [String]
}

struct CampaignImagesParameter: Codable {
    var id: String
}

struct GroupBalanceParameter: Codable {
    var id: String
}

struct RecurringExpiryParameter: Codable {
    var expiry: String
}

struct GroupPoliciesParameter: Codable {
    var groupId: String
}

struct GroupActivityParameter: Codable {
    var groupId: String
}

struct ReportPrivateGroupParameter: Codable {
    var anonymous: String
    var groupId: String
    var message: String
}

struct ReportPublicCampaignParameter: Codable {
    var anonymous: String
    var campaignId: String
    var message: String
}

struct EditGroupNameParameter: Codable {
    var groupId: String
    var groupName: String
}

struct GroupLimitsParamter: Codable {
    var groupId: String
}

struct ExecuteMakeAdminParameter: Codable {
    var status: String
    var voteId: String
}

struct InitiateAdminCreationParameter: Codable {
    var groupId: String
    var memberIdOnAction: String
}


struct ReactivateMandateParameter: Codable {
    var thirdPartyReference: String
}

struct InitiateAdminRevokalParameter: Codable {
    var groupId: String
    var memberIdOnAction: String
}

struct InitiateApproverRevokalParameter: Codable {
    var groupId: String
    var memberIdOnAction: String
}

struct InitiateDropMemberParameter: Codable {
    var groupId: String
    var memberIdOnAction: String
}

struct ExecuteRevokeAdminParameter: Codable {
    var status: String
    var voteId: String
}

struct ExecuteRevokeApproverParameter: Codable {
    var status: String
    var voteId: String
}

struct RegisterGroupLinkParameter: Codable {
    var duration: Int
    var groupId: String
    var timeUnits: String
}

struct VerifyGroupLinkParameter: Codable {
    var id: String
}

struct RetrieveGroupLinkParameter: Codable {
    var groupId: String
}

struct SaveGroupLinkParameter: Codable {
    var generatedLink: String
    var id: String
}

struct AppConfigurationParameter: Codable {
    var countryId: String
}

struct ApprovedCashoutParameter: Codable {
    var campaignId: String
    var offset: Int
    var pageSize: Int
}

struct AddCreditCardParameter: Codable {
    var body: String
    var alias: String
}

struct AddWalletParameter: Codable {
    var channelId: String
    var destinationCode: String
    var paymentDestinationNumber: String
    var walletName: String
}

struct DeleteWalletParameter: Codable {
    var walletId: String
}

struct RequestACallbackParameter: Codable {
    var contactNumber: String
}

struct GetSupportDetailsParameter: Codable {
    var countryId: String
}

struct ActiveCampaignCountParameter: Codable {
    var groupId: String
}

struct RetrieveGroupMemberCountParameter: Codable {
    var groupId: String
}

struct GetMemberVotedInGroupParameter: Codable {
    var groupId: String
}

struct GetArchivedCampaignsParameter: Codable {
    var groupId: String
}

struct GetActivePausedCampaignsParameter: Codable {
    var groupId: String
}

struct MinVotesAllBallotsParameter: Codable {
    var groupId: String
}

struct WalletOTPGenerationParameter: Codable {
    var msisdn: String
}

struct WalletOTPVerificationParameter: Codable {
    var msisdn: String
    var enteredPin: String
}

struct countryChannelsParameter: Codable {
    var channelId: String
    var countryId: String
}

struct AddKYCParameter: Codable {
    var dob: String
    var idCardUrl: String
    var idNumber: String
    var idType: String
    var photoUrl: String
}

struct DeleteMemberInviteInGroupParameter: Codable {
    var groupId: String
}

struct GetMemberWalletsParameter: Codable {
    var memberId: String
}

struct GetNameRegisteredOnWalletParameter: Codable {
    var channelId: String
    var msisdn: String
    var network: String
    var countryId: String
}

struct VerifyCardParameter: Codable {
    var walletId: String
}

struct VerifyDebitedAmountParameter: Codable {
    var walletId: String
    var code: String
}

struct LimitsForUnverifiedCardsParameter: Codable {
    var countryId: String
}

struct InitiateLoanWithWalletParameter: Codable {
    var amount: String
    var campaignId: String
    var groupId: String
    var memberId: String
    var reason: String
    var status: String
    var walletId: String
}

struct ExecuteLoanParameter: Codable {
    var campaignId: String
    var status: String
    var voteId: String
}

struct PushNotificationParameter: Codable {
    var groupId: String
    var notificationType: String
    var senderAuthProviderId: String
}

struct GetApprovalBodyParameter: Codable {
    var countryId: String
}

struct GetPaymentChargeParameter: Codable {
    var countryId: String
}

struct CheckMemberDetailsParameter: Codable {
    var email: String
    var msisdn: String
}

struct GetCampaignStatementParameter: Codable {
    var email: String
    var end: String
    var campaignId: String
    var groupId: String
    var start: String
    var format: String
    var statementType: String
    var memberId: String
}

struct MemberKycCompleteParameter: Codable {
    var memberId: String
}

struct RegisterParameter: Codable {
    var countryId: String
    var email: String
    var firstName: String
    var lastName: String
    var msisdn: String
    var language: String
    var registrationToken: String
    var userIconPath: String
}

struct CashoutPolicyChangeParameter: Codable {
    var ballotDetail: BallotDetail
    var groupId: String
}
