//
//  AuthNetworkManager.swift
//  RideAlong
//
//  Created by Hosny Ben Savage on 20/01/2019.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import Foundation
import Alamofire

protocol AuthNetworkManagerProtocol {
    func register(parameter: SignUpParameter, completion: @escaping (DataResponse<RegisterResponse, AFError>)->Void)
    //you need the protocol so you can write a mock of it
}

class AuthNetworkManager : NetworkManager{

    
    static func register(parameter: SignUpParameter, completion: @escaping (DataResponse<RegisterResponse, AFError>)->Void) {
        AF.request(AuthRouter.register(parameter: parameter))
        .responseDecodable { (response: DataResponse<RegisterResponse, AFError>) in
            print(response)
            print("response code: \(String(describing: response.response?.statusCode))")
            completion(response)
        }
    }

    static func registerUser(parameter: RegisterParameter, completion: @escaping (DataResponse<RegisterUserResponse, AFError>)->Void) {
        AF.request(AuthRouter.registerUser(parameter: parameter))
        .responseDecodable { (response: DataResponse<RegisterUserResponse, AFError>) in
            print(response)
            print("response code: \(String(describing: response.response?.statusCode))")
            completion(response)
        }
    }
    
    
    static func getNetworkCode(parameter: NetworkCodeParameter, completion: @escaping (DataResponse<[NetworkCode], AFError>)->Void) {
        AF.request(AuthRouter.getNetworkCode(parameter: parameter))
            .responseDecodable { (response: DataResponse<[NetworkCode], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")

                completion(response)
        }
    }
    
    
    static func getPrivateGroups(completion: @escaping (DataResponse<[GroupResponse], AFError>)->Void) {
        AF.request(AuthRouter.getPrivateGroups())
            .responseDecodable { (response: DataResponse<[GroupResponse], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    
    static func getPublicGroups(completion: @escaping (DataResponse<[GroupResponse], AFError>)->Void) {
        AF.request(AuthRouter.getPublicGroups())
            .responseDecodable { (response: DataResponse<[GroupResponse], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func getPublicGroupss(completion: @escaping (DataResponse<[GroupResponse], AFError>)->Void) {
        AF.request(AuthRouter.getPublicGroups())
            .responseDecodable { (response: DataResponse<[GroupResponse], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
        static func getAllGroups(completion: @escaping (DataResponse<[GroupResponse], AFError>)->Void) {
            AF.request(AuthRouter.getAllGroups())
                .responseDecodable { (response: DataResponse<[GroupResponse], AFError>) in
                    print(response)

                    print("response code: \(String(describing: response.response?.statusCode))")
                    completion(response)
            }
        }
    
    
    static func getContributionPublicGroups(completion: @escaping (DataResponse<[GroupResponse], AFError>)->Void) {
        AF.request(AuthRouter.getContributionPublicGroups())
            .responseDecodable { (response: DataResponse<[GroupResponse], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func personalContributions(parameter: PersonalContributionsParameter, completion: @escaping (DataResponse<CampaignContributionResponse, AFError>)->Void) {
        AF.request(AuthRouter.personalContributions(parameter: parameter))
            .responseDecodable { (response: DataResponse<CampaignContributionResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func groupTotals(parameter: GroupTotalsParameter, completion: @escaping (DataResponse<GroupTotalsResponse, AFError>)->Void) {
        AF.request(AuthRouter.groupTotals(parameter: parameter))
            .responseDecodable { (response: DataResponse<GroupTotalsResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func groupCreation(parameter: GroupCreationParameter, completion: @escaping (DataResponse<GroupCreationResponse, AFError>)->Void) {
        AF.request(AuthRouter.groupCreation(parameter: parameter))
            .responseDecodable { (response: DataResponse<GroupCreationResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                if (response.error?.asAFError?.responseCode == 405) {
                    print("error 405")
                    self.groupCreation(parameter: parameter, completion: completion)
                }
                completion(response)
        }
    }
    
    static func createGroup(parameter: GroupCreationParameter, completion: @escaping (DataResponse<CreateGroupResponse, AFError>)->Void) {
        AF.request(AuthRouter.createGroup(parameter: parameter))
            .responseDecodable { (response: DataResponse<CreateGroupResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                if (response.error?.asAFError?.responseCode == 405) {
                    print("error 405")
                    self.createGroup(parameter: parameter, completion: completion)
                }
                completion(response)
        }
    }
    
    
    
    static func memberExists(parameter: MemberExistsParameter ,completion: @escaping (String)->Void) {
        AF.request(AuthRouter.memberExists(parameter: parameter))
            .responseString(completionHandler: { (response: DataResponse<String, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")

                completion(response.value!)
        })
    }
    
    
    static func joinGroup(parameter: JoinGroupParameter, completion: @escaping (DataResponse<JoinGroupResponse, AFError>)->Void) {
        AF.request(AuthRouter.joinGroup(parameter: parameter))
            .responseDecodable { (response: DataResponse<JoinGroupResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
        static func joinPrivateGroup(parameter: JoinPrivateGroupParameter, completion: @escaping (DataResponse<JoinPrivateGroupResponse, AFError>)->Void) {
            AF.request(AuthRouter.joinPrivateGroup(parameter: parameter))
                .responseDecodable { (response: DataResponse<JoinPrivateGroupResponse, AFError>) in
                    print(response)

                    print("response code: \(String(describing: response.response?.statusCode))")
                    completion(response)
            }
        }
    
    

    
    
//    static func leaveGroup(parameter: LeaveGroupParameter, completion: @escaping (String)->Void) {
//        AF.request(AuthRouter.leaveGroup(parameter: parameter))
//            .responseDecodable { (response: DataResponse<String>) in
//                print(response)
//                if( response.error != nil ){
//                    if(response.error!.asAFError != nil){
//                        if(((response.error)?.asAFError)!.isResponseSerializationError){
//                            self.leaveGroup(parameter: parameter, completion: completion)
//                            return
//                        }
//                    }
//                }
//                completion(response.description)
//        }
//    }
    
    
    static func addMember(parameter: AddMemberParameter, completion: @escaping (String)->Void) {
        AF.request(AuthRouter.addMember(parameter: parameter))
            .responseString(completionHandler: {(response: DataResponse<String, AFError>) in
                print(response)
                
                if (response.error?.asAFError?.responseCode == 405) {
                    print("error 405")
                    self.addMember(parameter: parameter, completion: completion)
                }
//                if( response.error != nil ){
//                    if(response.error!.asAFError != nil){
//                        if(((response.error)?.asAFError)!.isResponseSerializationError){
//                            self.addMember(parameter: parameter, completion: completion)
//                            return
//                        }
//                    }
//                }
                print("response code: \(String(describing: response.response?.statusCode))")
                if (response.value != nil){
                    completion(response.value!)
                }        })
    }
    
    
    static func addMembersToGroup(parameter: AddMembersToGroupParameter, completion: @escaping (String)->Void) {
        AF.request(AuthRouter.addMembersToGroup(parameter: parameter))
            .responseString(completionHandler: {(response: DataResponse<String, AFError>) in
                print("response: \(response)")
                
                
//                if (response.error != nil){
//                    if(response.error!.asAFError != nil){
//                        if(((response.error)?.asAFError)!.isResponseSerializationError){
//                            self.addMembersToGroup(parameter: parameter, completion: completion)
//                            return
//                        }
//                    }
//                }
                print("response code: \(String(describing: response.response?.statusCode))")
                if (response.value != nil) {
                    if response.response?.statusCode == 405 {
                        self.addMembersToGroup(parameter: parameter, completion: completion)

                    }
                    completion(response.value!)
                    
                }
            })
    }
    
    
    static func leaveGroup(parameter: LeaveGroupParameter, completion: @escaping (String)->Void) {
        AF.request(AuthRouter.leaveGroup(parameter: parameter))
            .responseString(completionHandler: { (response: DataResponse<String, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                if (response.value != nil){
                    completion(response.value!)
                }else {
                    if( response.error != nil ){
                        if(response.error!.asAFError != nil){
                            if(((response.error)?.asAFError)!.isResponseSerializationError){
                                self.leaveGroup(parameter: parameter, completion: completion)
                                return
                            }
                        }
                    }
                }
        })
    }
    
    
    static func isAdmin(parameter: IsAdminParameter, completion: @escaping (String)->Void) {
        AF.request(AuthRouter.isAdmin(parameter: parameter))
            .responseString(completionHandler: { (response: DataResponse<String, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                if (response.value != nil){
                    completion(response.value!)
                }            })
    }
    
    
    static func deleteDevice(parameter: DeleteDeviceParameter, completion: @escaping (String)->Void) {
        AF.request(AuthRouter.deleteDevice(parameter: parameter))
            .responseString(completionHandler: {(response: DataResponse<String, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")

                if (response.response?.statusCode == 200){
                    print("delete successfully")
                }else {
                    if( response.error != nil ){
                        if(response.error!.asAFError != nil){
                            if(((response.error)?.asAFError)!.isResponseSerializationError){
                                self.deleteDevice(parameter: parameter, completion: completion)
                                return
                            }
                        }
                    }
                }
                
            })
    }
    
    
    static func extendCampaign(parameter: ExtendCampaignParameter, completion: @escaping (DataResponse<GetGroupCampaignsResponse, AFError>)->Void) {
        AF.request(AuthRouter.extendCampaign(parameter: parameter))
            .responseDecodable { (response: DataResponse<GetGroupCampaignsResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func getMembers(parameter: GetMemberParameter, completion: @escaping (DataResponse<[MemberResponse], AFError>)->Void) {
        AF.request(AuthRouter.getMembers(parameter: parameter))
            .responseDecodable { (response: DataResponse<[MemberResponse], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    
    
    
    static func createAdmin(parameter: CreateAdminParameter, completion: @escaping (DataResponse<RevokeLoanApproverResponse, AFError>)->Void) {
        AF.request(AuthRouter.createAdmin(parameter: parameter))
            .responseDecodable { (response: DataResponse<RevokeLoanApproverResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func createLoanApprover(parameter: CreateLoanApproverParameter, completion: @escaping (DataResponse<CreateLoanApproverResponse, AFError>)->Void) {
        AF.request(AuthRouter.createLoanApprover(parameter: parameter))
            .responseDecodable { (response: DataResponse<CreateLoanApproverResponse, AFError>) in
                print(response)

                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func makeLoanApprover(parameter: MakeLoanApproverParameter, completion: @escaping (DataResponse<MakeLoanApproverResponse, AFError>)->Void) {
        AF.request(AuthRouter.makeLoanApprover(parameter: parameter))
            .responseDecodable { (response: DataResponse<MakeLoanApproverResponse, AFError>) in
                print(response)

                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func revokeLoanApprover(parameter: RevokeLoanApproverParameter, completion: @escaping (DataResponse<RevokeLoanApproverResponse, AFError>)->Void) {
        AF.request(AuthRouter.revokeLoanApprover(parameter: parameter))
            .responseDecodable { (response: DataResponse<RevokeLoanApproverResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func revokeAdmin(parameter: RevokeAdminParameter, completion: @escaping (DataResponse<RevokeAdminResponse, AFError>)->Void) {
        AF.request(AuthRouter.revokeAdmin(parameter: parameter))
            .responseDecodable { (response: DataResponse<RevokeAdminResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func dropMember(parameter: DropMemberParameter, completion: @escaping (DataResponse<RevokeAdminResponse, AFError>)->Void) {
        AF.request(AuthRouter.dropMember(parameter: parameter))
            .responseDecodable { (response: DataResponse<RevokeAdminResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    

    static func updatePrivateGroupProfilePicture(parameter: UpdatePrivateGroupPictureParameter, completion: @escaping (DataResponse<UpdatePrivateGroupImageResponse, AFError>)->Void) {
        AF.request(AuthRouter.updatePrivateGroupProfilePicture(parameter: parameter))
            .responseDecodable { (response: DataResponse<UpdatePrivateGroupImageResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func updateMember(parameter: UpdateMemberParameter, completion: @escaping (DataResponse<UpdateMemberResponse, AFError>)->Void) {
        AF.request(AuthRouter.updateMember(parameter: parameter))
            .responseDecodable { (response: DataResponse<UpdateMemberResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
//    static func leaveGroup(parameter: LeaveGroupParameter, completion: @escaping (DataResponse<LeaveGroupResponse>)->Void) {
//        AF.request(AuthRouter.leaveGroup(parameter: parameter))
//            .responseDecodable { (response: DataResponse<LeaveGroupResponse>) in
//                print(response)
//                if( response.error != nil ){
//                    if(response.error!.asAFError != nil){
//                        if(((response.error)?.asAFError)!.isResponseSerializationError){
//                            self.leaveGroup(parameter: parameter, completion: completion)
//                            return
//                        }
//                    }
//                }
//                completion(response)
//        }
//    }

    static func campaignContributions(parameter: CampaignContributionsParameter, completion: @escaping (DataResponse<CampaignContributionResponse, AFError>)->Void) {
        AF.request(AuthRouter.campaignContributions(parameter: parameter))
            .responseDecodable { (response: DataResponse<CampaignContributionResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func memberContributions(parameter: memberContributionsParameter, completion: @escaping (DataResponse<[Content], AFError>)->Void) {
        AF.request(AuthRouter.memberContributions(parameter: parameter))
            .responseDecodable { (response: DataResponse<[Content], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func castVote(parameter: CastVoteParameter, completion: @escaping (DataResponse<CastVoteResponse, AFError>)->Void) {
        AF.request(AuthRouter.castVote(parameter: parameter))
            .responseDecodable { (response: DataResponse<CastVoteResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func createCampaign(parameter: CreateCampaignParameter, completion: @escaping (DataResponse<GetGroupCampaignsResponse, AFError>)->Void) {
        AF.request(AuthRouter.createCampaign(parameter: parameter))
            .responseDecodable { (response: DataResponse<GetGroupCampaignsResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func updateRegistrationToken(parameter: UpdateRegistrationTokenParameter, completion: @escaping (String)->Void) {
        AF.request(AuthRouter.updateRegistrationToken(parameter: parameter))
            .responseString(completionHandler: {(response: DataResponse<String, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                if response.value == nil {
                
                }else {
                completion(response.value!)
                }
            })
    }
    
    
    static func getGroupCampaign(parameter: GroupCampaignsParameter, completion: @escaping (DataResponse<[GetGroupCampaignsResponse], AFError>)->Void) {
        AF.request(AuthRouter.getGroupCampaign(parameter: parameter))
            .responseDecodable { (response: DataResponse<[GetGroupCampaignsResponse], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func makeContribution(parameter: MakeContributionParameter, completion: @escaping (DataResponse<ContributeResponse, AFError>)->Void) {
        AF.request(AuthRouter.makeContribution(parameter: parameter))
            .responseDecodable { (response: DataResponse<ContributeResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func contribute(parameter: ContributeParameter, completion: @escaping (DataResponse<RegularResponse, AFError>)->Void) {
        AF.request(AuthRouter.contribute(parameter: parameter))
            .responseDecodable { (response: DataResponse<RegularResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func memberNetwork(completion: @escaping (DataResponse<MemberNetworkResponse, AFError>)->Void) {
        AF.request(AuthRouter.memberNetwork())
            .responseDecodable { (response: DataResponse<MemberNetworkResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func defaultCampaign(parameter: defaultCampaignParameter, completion: @escaping (DataResponse<DefaultCampaignResponse, AFError>)->Void) {
        AF.request(AuthRouter.defaultCampaign(parameter: parameter))
            .responseDecodable { (response: DataResponse<DefaultCampaignResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func contributionsPage(parameter: GroupContributionsParameter, completion: @escaping (DataResponse<ContributionsPage, AFError>)->Void) {
        AF.request(AuthRouter.getContributions(parameter: parameter))
            .responseDecodable { (response: DataResponse<ContributionsPage, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func campaignContribution(parameter: CampaignContributionParameter, completion: @escaping (DataResponse<[GetCampaignContributionResponse], AFError>)->Void) {
        AF.request(AuthRouter.getCampaignContribution(parameter: parameter))
            .responseDecodable { (response: DataResponse<[GetCampaignContributionResponse], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func sendFeedback(parameter: FeedbackParameter, completion: @escaping (DataResponse<Feedback, AFError>)->Void) {
        AF.request(AuthRouter.sendFeedback(parameter: parameter))
            .responseDecodable { (response: DataResponse<Feedback, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func createdVotes(parameter: CreatedVoteParameter, completion: @escaping (DataResponse<CreatedVotesResponse, AFError>)->Void) {
        AF.request(AuthRouter.createdVotes(parameter: parameter))
            .responseDecodable { (response: DataResponse<CreatedVotesResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
//    static func createdVotes(parameter: CreatedVoteParameter, completion: @escaping (DataResponse<[CreatedVotes]>)->Void) {
//        AF.request(AuthRouter.createdVotes(parameter: parameter))
//            .responseDecodable { (response: DataResponse<[CreatedVotes]>) in
//                print(response)
//
//                print("response code: \(String(describing: response.response?.statusCode))")
//                completion(response)
//        }
//    }
    
    
    static func publicContact(parameter: PublicContactParameter, completion: @escaping (DataResponse<[PublicContact], AFError>)->Void) {
        AF.request(AuthRouter.publicContact(parameter: parameter))
            .responseDecodable { (response: DataResponse<[PublicContact], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }

    
    static func initiateCashout(parameter: InitiateCashoutParameter, completion: @escaping (DataResponse<RevokeLoanApproverResponse, AFError>)->Void) {
        AF.request(AuthRouter.initiateCashout(parameter: parameter))
            .responseDecodable { (response: DataResponse<RevokeLoanApproverResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func cashout(parameter: CashoutVoteParameter, completion: @escaping (DataResponse<RevokeLoanApproverResponse, AFError>)->Void) {
        AF.request(AuthRouter.cashout(parameter: parameter))
            .responseDecodable { (response: DataResponse<RevokeLoanApproverResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func requestLoan(parameter: RequestLoanParameter, completion: @escaping (String)->Void) {
        AF.request(AuthRouter.requestLoan(parameter: parameter))
            .responseString(completionHandler: {(response: DataResponse<String, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response.value!)
            })
    }
    
    
    static func getStatement(parameter: GetStatementParameter, completion: @escaping (String)->Void) {
        AF.request(AuthRouter.getStatement(parameter: parameter))
            .responseString(completionHandler: {(response: DataResponse<String, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response.value!)
            })
    }
    
    
    static func grantLoan(parameter: GrantLoanParameter, completion: @escaping (String)->Void) {
        AF.request(AuthRouter.grantLoan(parameter: parameter))
            .responseString(completionHandler: {(response: DataResponse<String, AFError>) in
                print(response)

                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response.value!)
            })
    }
    
    
    static func getGroupLoan(parameter: GetGroupLoanParameter, completion: @escaping (DataResponse<[GroupLoanResponse], AFError>)->Void) {
        AF.request(AuthRouter.getGroupLoan(parameter: parameter))
            .responseDecodable { (response: DataResponse<[GroupLoanResponse], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func getVoteSummary(parameter: GetVoteSummaryParameter, completion: @escaping (DataResponse<[BallotSummary], AFError>)->Void) {
        AF.request(AuthRouter.getVoteSummary(parameter: parameter))
            .responseDecodable { (response: DataResponse<[BallotSummary], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func getMemberActivity(completion: @escaping (DataResponse<[UserActivity], AFError>)->Void) {
        AF.request(AuthRouter.getMemberActivity())
            .responseDecodable { (response: DataResponse<[UserActivity], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func getNotVotedMembers(parameter: GetNotVotedParameter, completion: @escaping (DataResponse<[Member], AFError>)->Void) {
        AF.request(AuthRouter.getNotVotedMembers(parameter: parameter))
            .responseDecodable { (response: DataResponse<[Member], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
        
        
        static func getVotedMembers(parameter: GetVotedParameter, completion: @escaping (DataResponse<[Member], AFError>)->Void) {
            AF.request(AuthRouter.getVotedMembers(parameter: parameter))
                .responseDecodable { (response: DataResponse<[Member], AFError>) in
                    print(response)
                    print("response code: \(String(describing: response.response?.statusCode))")
                    completion(response)
            }
        }
    
    
    static func getCampaignBalance(parameter: GetCampaignBalanceParameter, completion: @escaping (String)->Void) {
        AF.request(AuthRouter.getCampaignBalance(parameter: parameter))
            .responseString(completionHandler: {(response: DataResponse<String, AFError>) in
                print(response)

                print("response code: \(String(describing: response.response?.statusCode))")
                if (response.value != nil){
                    completion(response.value!)
                }
                
            })
    }
    
    
    static func createDevice(parameter: CreateDeviceParameter, completion: @escaping (DataResponse<createDevice, AFError>)->Void) {
        AF.request(AuthRouter.createDevice(parameter: parameter))
            .responseDecodable(completionHandler: {(response: DataResponse<createDevice, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
            })
    }
    
    static func startCampaign(parameter: StartCampaignParameter, completion: @escaping (DataResponse<GetGroupCampaignsResponse, AFError>)->Void) {
        AF.request(AuthRouter.startCampaign(parameter: parameter))
            .responseDecodable { (response: DataResponse<GetGroupCampaignsResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func pauseCampaign(parameter: PauseCampaignParameter, completion: @escaping (DataResponse<GetGroupCampaignsResponse, AFError>)->Void) {
        AF.request(AuthRouter.pauseCampaign(parameter: parameter))
            .responseDecodable { (response: DataResponse<GetGroupCampaignsResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func endCampaign(parameter: EndCampaignParameter, completion: @escaping (DataResponse<GetGroupCampaignsResponse, AFError>)->Void) {
        AF.request(AuthRouter.endCampaign(parameter: parameter))
            .responseDecodable { (response: DataResponse<GetGroupCampaignsResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func recentPersonalContribution(completion: @escaping (DataResponse<[GetCampaignContributionResponse], AFError>)->Void) {
        AF.request(AuthRouter.getRecentPersonalContribution())
            .responseDecodable { (response: DataResponse<[GetCampaignContributionResponse], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
            }
        }
    
    
    static func getVotes(parameter: GetVotesParameter, completion: @escaping (DataResponse<[GetVotes], AFError>)->Void) {
        AF.request(AuthRouter.getVotes(parameter: parameter))
            .responseDecodable { (response: DataResponse<[GetVotes], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")

                completion(response)
        }
    }
    
    
    static func recurringPayment(parameter: RecurringOTPParameter, completion: @escaping (DataResponse<RecurringResponse, AFError>)->Void) {
        AF.request(AuthRouter.recurringPayment(parameter: parameter))
            .responseDecodable { (response: DataResponse<RecurringResponse, AFError>) in
                print(response)

                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func cancelSingleMandate(parameter: CancelSingleMandateParameter, completion: @escaping (DataResponse<RevokeLoanApproverResponse, AFError>)->Void) {
        AF.request(AuthRouter.cancelSingleMandate(parameter: parameter))
            .responseDecodable { (response: DataResponse<RevokeLoanApproverResponse, AFError>) in
                print(response)

                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func cancelAllMandates(parameter: [String], completion: @escaping (DataResponse<RevokeLoanApproverResponse, AFError>)->Void) {
        AF.request(AuthRouter.cancelAllMandates(parameter: parameter))
            .responseDecodable { (response: DataResponse<RevokeLoanApproverResponse, AFError>) in
                print(response)
                
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    
    static func campaignImages(parameter: CampaignImagesParameter, completion: @escaping (DataResponse<[String], AFError>)->Void) {
        AF.request(AuthRouter.campaignImages(parameter: parameter))
            .responseDecodable(completionHandler: {(response: DataResponse<[String], AFError>) in
                print(response)

                print("response code: \(String(describing: response.response?.statusCode))")

                completion(response)
            })
    }
    
    
    static func groupBalance(parameter: GroupBalanceParameter, completion: @escaping (DataResponse<[GroupBalance], AFError>)->Void) {
        AF.request(AuthRouter.groupBalance(parameter: parameter))
            .responseDecodable { (response: DataResponse<[GroupBalance], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                
                completion(response)
        }
    }
    
    
    static func recurringExpiry(parameter: RecurringExpiryParameter, completion: @escaping (DataResponse<ExpiryDate, AFError>)->Void) {
        AF.request(AuthRouter.recurringExpiry(parameter: parameter))
            .responseDecodable { (response: DataResponse<ExpiryDate, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                
                completion(response)
        }
    }
    
    
    static func getGroupPolicies(parameter: GroupPoliciesParameter, completion: @escaping (DataResponse<GroupPoliciesResponse, AFError>)->Void) {
        AF.request(AuthRouter.getGroupPolicies(parameter: parameter))
            .responseDecodable { (response: DataResponse<GroupPoliciesResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                
                completion(response)
                
        }
    }
    
    static func getGroupPolicy(parameter: GroupPoliciesParameter, completion: @escaping (DataResponse<GroupPolicyResponse, AFError>)->Void) {
        AF.request(AuthRouter.getGroupPolicy(parameter: parameter))
            .responseDecodable { (response: DataResponse<GroupPolicyResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                
                completion(response)
                
        }
    }
    
    
    static func getGroupActivity(parameter: GroupActivityParameter, completion: @escaping (DataResponse<[UserActivity], AFError>)->Void) {
        AF.request(AuthRouter.getGroupActivity(parameter: parameter))
            .responseDecodable { (response: DataResponse<[UserActivity], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                
                completion(response)
                
        }
    }
    
    
    static func reportPrivateGroup(parameter: ReportPrivateGroupParameter, completion: @escaping (DataResponse<ReportCampaign, AFError>)->Void) {
        AF.request(AuthRouter.reportPrivateGroup(parameter: parameter))
            .responseDecodable { (response: DataResponse<ReportCampaign, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                
                completion(response)
        }
    }
    
    static func reportPublicCampaign(parameter: ReportPublicCampaignParameter, completion: @escaping (DataResponse<ReportCampaign, AFError>)->Void) {
        AF.request(AuthRouter.reportPublicCampaign(parameter: parameter))
            .responseDecodable { (response: DataResponse<ReportCampaign, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                
                completion(response)
        }
    }
    
    
    static func editGroupName(parameter: EditGroupNameParameter, completion: @escaping (DataResponse<GroupResponse, AFError>)->Void) {
        AF.request(AuthRouter.editGroupName(parameter: parameter))
            .responseDecodable { (response: DataResponse<GroupResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                
                completion(response)
        }
    }
    
    
    static func retrieveGroupLimits(parameter: GroupLimitsParamter, completion: @escaping (DataResponse<GroupLimitsResponse, AFError>)->Void) {
        AF.request(AuthRouter.retrieveGroupLimits(parameter: parameter))
            .responseDecodable { (response: DataResponse<GroupLimitsResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                
                completion(response)
        }
    }
    
    static func initiateDropMember(parameter: InitiateDropMemberParameter, completion: @escaping (DataResponse<InitiateAdminCreationResponse, AFError>)->Void) {
        AF.request(AuthRouter.initiateDropMember(parameter: parameter))
            .responseDecodable { (response: DataResponse<InitiateAdminCreationResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                
                completion(response)
        }
    }
    
    static func initiateAdminCreation(parameter: InitiateAdminCreationParameter, completion: @escaping (DataResponse<InitiateAdminCreationResponse, AFError>)->Void) {
        AF.request(AuthRouter.initiateAdminCreation(parameter: parameter))
            .responseDecodable { (response: DataResponse<InitiateAdminCreationResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                
                completion(response)
        }
    }
    
    static func initiateAdminRevokal(parameter: InitiateAdminRevokalParameter, completion: @escaping (DataResponse<InitiateAdminCreationResponse, AFError>)->Void) {
        AF.request(AuthRouter.initiateAdminRevokal(parameter: parameter))
            .responseDecodable { (response: DataResponse<InitiateAdminCreationResponse, AFError>) in
                print(response)
                
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func initiateApproverRevokal(parameter: InitiateApproverRevokalParameter, completion: @escaping (DataResponse<InitiateAdminCreationResponse, AFError>)->Void) {
        AF.request(AuthRouter.initiateApproverRevokal(parameter: parameter))
            .responseDecodable { (response: DataResponse<InitiateAdminCreationResponse, AFError>) in
                print(response)
                
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func executeMakeAdmin(parameter: ExecuteMakeAdminParameter, completion: @escaping (DataResponse<ExecuteMakeAdminResponse, AFError>)->Void) {
        AF.request(AuthRouter.executeMakeAdmin(parameter: parameter))
            .responseDecodable { (response: DataResponse<ExecuteMakeAdminResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func executeRevokeAdmin(parameter: ExecuteRevokeAdminParameter, completion: @escaping (DataResponse<ExecuteMakeAdminResponse, AFError>)->Void) {
        AF.request(AuthRouter.executeRevokeAdmin(parameter: parameter))
            .responseDecodable { (response: DataResponse<ExecuteMakeAdminResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func executeRevokeApprover(parameter: ExecuteRevokeApproverParameter, completion: @escaping (DataResponse<ExecuteMakeAdminResponse, AFError>)->Void) {
        AF.request(AuthRouter.executeRevokeApprover(parameter: parameter))
            .responseDecodable { (response: DataResponse<ExecuteMakeAdminResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func reactivateMandate(parameter: ReactivateMandateParameter, completion: @escaping (DataResponse<RevokeLoanApproverResponse, AFError>)->Void) {
        AF.request(AuthRouter.reactivateMandate(parameter: parameter))
            .responseDecodable { (response: DataResponse<RevokeLoanApproverResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func registerGroupLink(parameter: RegisterGroupLinkParameter, completion: @escaping (DataResponse<RegisterGroupLinkResponse, AFError>)->Void) {
        AF.request(AuthRouter.registerGroupLink(parameter: parameter))
            .responseDecodable { (response: DataResponse<RegisterGroupLinkResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func saveGroupLink(parameter: SaveGroupLinkParameter, completion: @escaping (DataResponse<RevokeLoanApproverResponse, AFError>)->Void) {
        AF.request(AuthRouter.saveGroupLink(parameter: parameter))
            .responseDecodable { (response: DataResponse<RevokeLoanApproverResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func verifyGroupLink(parameter: VerifyGroupLinkParameter, completion: @escaping (DataResponse<VerifyGroupLinkResponse, AFError>)->Void) {
        AF.request(AuthRouter.verifyGroupLink(parameter: parameter))
            .responseDecodable { (response: DataResponse<VerifyGroupLinkResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func retrieveGroupLink(parameter: RetrieveGroupLinkParameter, completion: @escaping (DataResponse<RetrieveGroupLinkResponse, AFError>)->Void) {
        AF.request(AuthRouter.retrieveGroupLink(parameter: parameter))
            .responseDecodable { (response: DataResponse<RetrieveGroupLinkResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func appConfiguration(parameter: AppConfigurationParameter, completion: @escaping (DataResponse<AppConfiguratonResponse, AFError>)->Void) {
        AF.request(AuthRouter.appConfiguration(parameter: parameter))
            .responseDecodable { (response: DataResponse<AppConfiguratonResponse, AFError>) in
                print(response)
                
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func approvedCashout(parameter: ApprovedCashoutParameter, completion: @escaping (DataResponse<ApprovedCashoutResponse, AFError>)->Void) {
        AF.request(AuthRouter.approvedCashout(parameter: parameter))
            .responseDecodable { (response: DataResponse<ApprovedCashoutResponse, AFError>) in
                print(response)
                
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func addCreditCard(parameter: AddCreditCardParameter, completion: @escaping (DataResponse<AddWalletResponse, AFError>)->Void) {
        AF.request(AuthRouter.addCreditCard(parameter: parameter))
            .responseDecodable { (response: DataResponse<AddWalletResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func addWallet(parameter: AddWalletParameter, completion: @escaping (DataResponse<AddWalletResponse, AFError>)->Void) {
        AF.request(AuthRouter.addWallet(parameter: parameter))
            .responseDecodable { (response: DataResponse<AddWalletResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func deleteWallet(parameter: DeleteWalletParameter, completion: @escaping (DataResponse<RegularResponse, AFError>)->Void) {
        AF.request(AuthRouter.deleteWallet(parameter: parameter))
            .responseDecodable { (response: DataResponse<RegularResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func getPaymentMethods(completion: @escaping (DataResponse<[GetPaymentMethodsResponse], AFError>)->Void) {
        AF.request(AuthRouter.getPaymentMethods())
            .responseDecodable { (response: DataResponse<[GetPaymentMethodsResponse], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func requestACallback(parameter: RequestACallbackParameter, completion: @escaping (DataResponse<RevokeLoanApproverResponse, AFError>)->Void) {
        AF.request(AuthRouter.requestACallback(parameter: parameter))
            .responseDecodable { (response: DataResponse<RevokeLoanApproverResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func getSupportDetails(parameter: GetSupportDetailsParameter, completion: @escaping (DataResponse<GetSupportDetailsResponse, AFError>)->Void) {
        AF.request(AuthRouter.getSupportDetails(parameter: parameter))
            .responseDecodable { (response: DataResponse<GetSupportDetailsResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func activeCampaignCount(parameter: ActiveCampaignCountParameter, completion: @escaping (String)->Void) {
        AF.request(AuthRouter.activeCampaignCount(parameter: parameter))
            .responseString(completionHandler: { (response: DataResponse<String, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                if (response.value != nil){
                    completion(response.value!)
                }else {
                    if( response.error != nil ){
                        if(response.error!.asAFError != nil){
                            if(((response.error)?.asAFError)!.isResponseSerializationError){
                                self.activeCampaignCount(parameter: parameter, completion: completion)
                                return
                            }
                        }
                    }
                }
            })
    }
    
    static func retrieveGroupMemberCount(parameter: RetrieveGroupMemberCountParameter, completion: @escaping (String)->Void) {
        AF.request(AuthRouter.retrieveGroupMemberCount(parameter: parameter))
            .responseString(completionHandler: { (response: DataResponse<String, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                if (response.value != nil){
                    completion(response.value!)
                }else {
                    if( response.error != nil ){
                        if(response.error!.asAFError != nil){
                            if(((response.error)?.asAFError)!.isResponseSerializationError){
                                self.retrieveGroupMemberCount(parameter: parameter, completion: completion)
                                return
                            }
                        }
                    }
                }
            })
    }
    
    static func getMemberVotedInGroup(parameter: GetMemberVotedInGroupParameter, completion: @escaping (DataResponse<[GetMemberVotedInGroupResponse], AFError>)->Void) {
        AF.request(AuthRouter.getMemberVotedInGroup(parameter: parameter))
            .responseDecodable { (response: DataResponse<[GetMemberVotedInGroupResponse], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func getArchivedCampaigns(parameter: GetArchivedCampaignsParameter, completion: @escaping (DataResponse<[GetGroupCampaignsResponse], AFError>)->Void) {
        AF.request(AuthRouter.getArchivedCampaigns(parameter: parameter))
            .responseDecodable { (response: DataResponse<[GetGroupCampaignsResponse], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func getActivePausedCampaigns(parameter: GetActivePausedCampaignsParameter, completion: @escaping (DataResponse<[GetGroupCampaignsResponse], AFError>)->Void) {
        AF.request(AuthRouter.getActivePausedCampaigns(parameter: parameter))
            .responseDecodable { (response: DataResponse<[GetGroupCampaignsResponse], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func getMinVoteAllBallots(parameter: MinVotesAllBallotsParameter, completion: @escaping (DataResponse<[MinVoteRequiredAllBallots], AFError>)->Void) {
        AF.request(AuthRouter.getMinVoteAllBallots(parameter: parameter))
            .responseDecodable { (response: DataResponse<[MinVoteRequiredAllBallots], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func generateOTPForWallet(parameter: WalletOTPGenerationParameter, completion: @escaping (DataResponse<ResponseMessage, AFError>)->Void) {
        AF.request(AuthRouter.walletOTPGeneration(parameter: parameter))
            .responseDecodable { (response: DataResponse<ResponseMessage, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func verifyOTPForWallet(parameter: WalletOTPVerificationParameter, completion: @escaping (DataResponse<ResponseMessage, AFError>)->Void) {
        AF.request(AuthRouter.walletOTPVerification(parameter: parameter))
            .responseDecodable { (response: DataResponse<ResponseMessage, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func retrieveCountryChannelDestinations(parameter: countryChannelsParameter, completion: @escaping (DataResponse<[RetrieveCountryChannelDestinations], AFError>)->Void) {
        AF.request(AuthRouter.retrieveCountryChannelDestinations(parameter: parameter))
            .responseDecodable { (response: DataResponse<[RetrieveCountryChannelDestinations], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func addKYC(parameter: AddKYCParameter, completion: @escaping (DataResponse<AddKYCResponse, AFError>)->Void) {
        AF.request(AuthRouter.addKYC(parameter: parameter))
            .responseDecodable { (response: DataResponse<AddKYCResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func deleteMemberInviteInGroup(parameter: DeleteMemberInviteInGroupParameter, completion: @escaping (DataResponse<RegularResponse, AFError>)->Void) {
        AF.request(AuthRouter.deleteMemberInviteInGroup(parameter: parameter))
            .responseDecodable { (response: DataResponse<RegularResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func getMemberWallets(parameter: GetMemberWalletsParameter, completion: @escaping (DataResponse<MemberWalletResponse, AFError>)->Void) {
        AF.request(AuthRouter.getMemberWallets(parameter: parameter))
            .responseDecodable { (response: DataResponse<MemberWalletResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func getNameRegisteredOnMobileWallet(parameter: GetNameRegisteredOnWalletParameter, completion: @escaping (DataResponse<GetNameRegisteredOnMobileWalletResponse, AFError>)->Void) {
        AF.request(AuthRouter.getNameRegisteredOnMobileWallet(parameter: parameter))
            .responseDecodable { (response: DataResponse<GetNameRegisteredOnMobileWalletResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func verifyCard(parameter: VerifyCardParameter, completion: @escaping (DataResponse<VerifyCardResponse, AFError>)->Void) {
        AF.request(AuthRouter.verifyCard(parameter: parameter))
            .responseDecodable { (response: DataResponse<VerifyCardResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func verifyDebitedAmount(parameter: VerifyDebitedAmountParameter, completion: @escaping (DataResponse<RegularResponse, AFError>)->Void) {
        AF.request(AuthRouter.verifyAmountDebited(parameter: parameter))
            .responseDecodable { (response: DataResponse<RegularResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func limitsForUnverifiedCards(parameter: LimitsForUnverifiedCardsParameter, completion: @escaping (DataResponse<LimitForUnverifiedCardsResponse, AFError>)->Void) {
        AF.request(AuthRouter.limitsForUnverifiedCards(parameter: parameter))
            .responseDecodable { (response: DataResponse<LimitForUnverifiedCardsResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func retrieveMember(completion: @escaping (DataResponse<RetrieveMemberResponse, AFError>)->Void) {
        AF.request(AuthRouter.retrieveMember())
            .responseDecodable { (response: DataResponse<RetrieveMemberResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func maxVerificationAttempts(completion: @escaping (DataResponse<Int, AFError>)->Void) {
        AF.request(AuthRouter.maxVerificationAttempts())
            .responseDecodable { (response: DataResponse<Int, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func initiateLoanWithWallet(parameter: InitiateLoanWithWalletParameter, completion: @escaping (DataResponse<InitiateLoanWithWalletResponse, AFError>)->Void) {
        AF.request(AuthRouter.initiateLoanWithWallet(parameter: parameter))
            .responseDecodable { (response: DataResponse<InitiateLoanWithWalletResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func executeLoan(parameter: ExecuteLoanParameter, completion: @escaping (DataResponse<RegularResponse, AFError>)->Void) {
        AF.request(AuthRouter.executeLoan(parameter: parameter))
            .responseDecodable { (response: DataResponse<RegularResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func pushNotificationForChats(parameter: PushNotificationParameter, completion: @escaping (DataResponse<RegularResponse, AFError>)->Void) {
        AF.request(AuthRouter.pushNotificationForChats(parameter: parameter))
            .responseDecodable { (response: DataResponse<RegularResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func getApprovalBody(parameter: GetApprovalBodyParameter, completion: @escaping (DataResponse<[GetApprovalBodyResponse], AFError>)->Void) {
        AF.request(AuthRouter.getApprovalBody(parameter: parameter))
            .responseDecodable { (response: DataResponse<[GetApprovalBodyResponse], AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func getPaymentCharge(parameter: GetPaymentChargeParameter, completion: @escaping (DataResponse<GetPaymentChargeResponse, AFError>)->Void) {
        AF.request(AuthRouter.getPaymentCharge(parameter: parameter))
            .responseDecodable { (response: DataResponse<GetPaymentChargeResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func updateEmail(completion: @escaping (DataResponse<RegularResponse, AFError>)->Void) {
        AF.request(AuthRouter.updateEmail)
            .responseDecodable { (response: DataResponse<RegularResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func checkMemberDetails(parameter: CheckMemberDetailsParameter ,completion: @escaping (DataResponse<CheckMemberDetailsResponse, AFError>)->Void) {
        AF.request(AuthRouter.checkMemberDetail(parameter: parameter))
            .responseDecodable { (response: DataResponse<CheckMemberDetailsResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }
    
    static func checkEmailAddress(parameter: CheckMemberDetailsParameter ,completion: @escaping (DataResponse<Bool, AFError>)->Void) {
        AF.request(AuthRouter.checkEmailAddress(parameter: parameter))
            .responseDecodable { (response: DataResponse<Bool, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
        }
    }

    static func getCampaignStatement(parameter: GetCampaignStatementParameter, completion: @escaping (String)->Void) {
        AF.request(AuthRouter.getCampaignStatement(parameter: parameter))
            .responseString(completionHandler: {(response: DataResponse<String, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response.value!)
            })
    }

    static func getCurrentAppVersion(completion: @escaping (DataResponse<GetCurrentAppVersionResponse, AFError>)->Void) {
        AF.request(AuthRouter.getAppCurrentVersion())
            .responseDecodable(completionHandler: {(response: DataResponse<GetCurrentAppVersionResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
            })
    }

    static func memberKycStatus(parameter: MemberKycCompleteParameter ,completion: @escaping (DataResponse<MemberKycStatusResponse, AFError>)->Void) {
        AF.request(AuthRouter.memberKycStatus(parameter: parameter))
            .responseDecodable(completionHandler: {(response: DataResponse<MemberKycStatusResponse, AFError>) in
                print(response)
                print("response code: \(String(describing: response.response?.statusCode))")
                completion(response)
            })
    }
}
