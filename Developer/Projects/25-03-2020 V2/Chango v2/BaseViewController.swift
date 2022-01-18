//
//  BasicViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 18/07/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class BaseViewController: UIViewController {

    typealias FetchAllPendingVotesCompletionHandler = (_ votes: [PendingVotes]) -> Void
    typealias FetchAllMembersCompletionHandler = (_ groups: MembersRTDB ) -> Void
    
//    var groupId: String = ""
//    var votesPending: [PendingVotes] = []
//    var memberDeets: MembersRTDB!
//    var memberId: String = ""
//    var authProviderId: String = ""
//    var voteCampaignId: String = ""
    
    func showChatController() {
        
        print("Welcome to this chat method")
        
        _ = SwiftEventBus.onMainThread(self, name: "chats", handler: { result in
            let event: ChatEvent = result?.object as! ChatEvent
            print("start chats segue")

            self.chatMessageSegue(event)
        })
        
        _ = SwiftEventBus.onMainThread(self, name: "campaign", handler: { result in
            let event: CampaignEvent = result?.object as! CampaignEvent
            print("start chats segue")
            
            self.goToCampaigns(event)
        })
        
        _ = SwiftEventBus.onMainThread(self, name: "votes", handler: { result in
            let event: VoteEvent = result?.object as! VoteEvent
            print("start chats segue")
//            self.groupId = event.groupId
            self.goToVotes(event)
        })
        
    }
    
    func chatMessageSegue(_ event: ChatEvent){
        //do message stuff here
        let groupId: String = event.groupId

        
        if groupId == "" {
            
        }else {
        print("\(groupId),\(event.groupId)")


        var chatLogController: ChatLogController? = nil
        var messagesFetcher: MessagesFetcher? = nil
        //        var conversation: Conversation!
        let user = Auth.auth().currentUser

        var messages: String = ""
        var timestamp: Int = 0
        var chatParticipants: [String] = []

        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let conversationDictionary: [String: AnyObject] = ["chatID": event.groupId as AnyObject, "chatName": "privateGroup.groupName" as AnyObject,
                                                           "isGroupChat": true  as AnyObject,
                                                           "chatOriginalPhotoURL": "privateGroup.groupIconPath" as AnyObject,
                                                           "chatThumbnailPhotoURL": "" as AnyObject,
                                                           "chatParticipantsIDs": [chatParticipants] as AnyObject,
                                                           "lastMessage": messages as AnyObject,
                                                           "timestamp": timestamp as AnyObject]

        let conversation = Conversation(dictionary: conversationDictionary)

        chatLogController = ChatLogController(collectionViewLayout: AutoSizingCollectionViewFlowLayout())
        chatLogController?.privateGroup = GroupResponse(countryId_: CountryId(countryId_: "", countryName_: "", created_: "", currency_: "", modified_: ""), groupId_: event.groupId, groupName_: "", groupType_: "", loanFlag_: 0, groupIconPath_: "", tnc_: "", status_: "", created_: "", defaultCampaignId_: "", modified_: "", description_: "", approve_: "", creatorId_: "", creatorName_: "", isUsingGroupLimits_: "", campaignCount_: 0, groupMemberCount_: 0)

        messagesFetcher = MessagesFetcher()
        messagesFetcher?.delegate = chatLogController
        messagesFetcher?.privateGroup = GroupResponse(countryId_: CountryId(countryId_: "", countryName_: "", created_: "", currency_: "", modified_: ""), groupId_: event.groupId, groupName_: "", groupType_: "", loanFlag_: 0, groupIconPath_: "", tnc_: "", status_: "", created_: "", defaultCampaignId_: "", modified_: "", description_: "", approve_: "", creatorId_: "", creatorName_: "", isUsingGroupLimits_: "", campaignCount_: 0, groupMemberCount_: 0)
        print("messagesFetcher \(messagesFetcher)")
        print(conversation)
        chatLogController?.messagesFetcher = messagesFetcher
        print("print before load messages")
            messagesFetcher?.loadMessagesData(for: conversation, controller: chatLogController!, mainController: self, mainTableController: nil)
        print("run load messages data")

        }
    }
    
    func goToCampaigns(_ event: CampaignEvent) {
        print("user will be directed to campaigns here")
    }
    
    func goToVotes(_ event: VoteEvent) {
        
        let groupId: String = event.groupId
        
        let vc: VoteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vote") as! VoteViewController
        
        vc.groupId = groupId
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        //        votesPending = []
        //        fetchAllPendingVotes { (result) in
        //            self.votesPending = result
        //
        //            print("resutl: \(self.votesPending)")
        //        }
    }
    
//    func pendingVotes(){
//
//        let vc: VoteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vote") as! VoteViewController
//        vc.groupId = groupId
//        vc.voteId = voteId
//        vc.adminVoteId = adminVoteId
//        vc.approverVoteId = approverVoteId
//        vc.dropVoteId = dropVoteId
//        vc.cashoutVoteId = cashoutVoteId
//        vc.makeAdminVoteId = makeAdminVoteId
//        vc.makeApproverVoteId = makeApproverVoteId
//        print("cashout id: \(cashoutVoteId), groupId: \(privateGroup.groupId), makeAd: \(makeAdminVoteId), makeAp: \(makeApproverVoteId)")
//        vc.groupName = privateGroup.groupName
//        vc.groupIcon = privateGroup.groupIconPath!
//        vc.pendingVotes = votesPending
//        vc.defaultCampaignId = privateGroup.defaultCampaignId
//        vc.campaignBalance = campaignBalance
//        vc.currency = privateGroup.countryId.currency
//        self.navigationController?.pushViewController(vc, animated: true)
//
//    }

    
    func sessionTimeout() {
        
        let alert = UIAlertController(title: "Chango", message: "Your session has timed out. Please login.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            
            if UserDefaults.standard.bool(forKey: "touchID"){
                
                let vc: LoginTouchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "touch") as! LoginTouchVC
                UserDefaults.standard.set(false, forKey: "authenticated")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                print("touchID")
                
            }else {
                let vc: LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "in") as! LoginVC
                UserDefaults.standard.set(false, forKey: "authenticated")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            
            
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func serverError() {
        
        let alert = UIAlertController(title: "Chango", message: "Internal Server Error", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            
            
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func alertDialog(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
//    func fetchAllPendingVotes(completionHandler: @escaping FetchAllPendingVotesCompletionHandler) {
//
//        var pendingVotes: [PendingVotes] = []
//
//        let pendingVotesRef = Database.database().reference().child("votes").child("\(groupId)")
//        _ = pendingVotesRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let snapshotValue = snapshot.children.allObjects as? [DataSnapshot]{
//                for snapDict in snapshotValue {
//                    print("snapdict")
//                    let dict = snapDict.value as! Dictionary<String, AnyObject>
//                    print(dict)
//                    if let votesArray = dict as? NSDictionary {
//                        print("votesArray: \(votesArray)")
//
//                        var amt = ""
//                        if let amount = votesArray.value(forKey: "amount") as? String {
//                            amt = amount
//                        }
//
//                        var cmgnId = ""
//                        if let campaignId = votesArray.value(forKey: "campaignId") as? String {
//                            cmgnId = campaignId
//                        }
//
//                        var cmgnNm = ""
//                        if let campaignName = votesArray.value(forKey: "campaignName") as? String {
//                            cmgnNm = campaignName
//                        }
//
//                        var campBal = ""
//                        if let campaignBalance = votesArray.value(forKey: "campaignBalance") as? String {
//                            campBal = campaignBalance
//                        }
//
//                        var ntwrk = ""
//                        if let network = votesArray.value(forKey: "network") as? String {
//                            ntwrk = network
//                        }
//
//                        var cshDst = ""
//                        if let cashoutDestination = votesArray.value(forKey: "cashoutDestination") as? String {
//                            cshDst = cashoutDestination
//                        }
//
//                        var cshDstCd = ""
//                        if let cashoutDestinationCode = votesArray.value(forKey: "cashoutDestinationCode") as? String {
//                            cshDstCd = cashoutDestinationCode
//                        }
//
//                        var cshDstNmbr = ""
//                        if let cashoutDestinationNumber = votesArray.value(forKey: "cashoutDestinationNumber") as? String {
//                            cshDstNmbr = cashoutDestinationNumber
//                        }
//
//                        var rsn = ""
//                        if let reason = votesArray.value(forKey: "reason") as? String {
//                            rsn = reason
//                        }
//
//                        var vtCnt = ""
//                        if let voteCount = votesArray.value(forKey: "voteCount") as? String {
//                            vtCnt = voteCount
//                        }
//
//                        var rl = ""
//                        if let role = votesArray.value(forKey: "role") as? String {
//                            rl = role
//                        }
//
//                        var mem = ""
//                        if let memberId = votesArray.value(forKey: "memberId") as? String {
//                            //                        print(self.memberId)
//                            mem = memberId
//                        }
//                        var authProvId = ""
//                        if let authProviderId = votesArray.value(forKey: "authProviderId") as? String {
//                            authProvId = authProviderId
//                        }
//                        self.memberId = mem
//                        self.authProviderId = authProvId
//                        self.voteCampaignId = cmgnId
//
//                        if self.authProviderId == "" {
//
//                        }else {
//                            self.fetchAllMembers { (result) in
//                                self.memberDeets = result
//                                print("mem: \(self.memberDeets.name)")
//
//                                let votes = PendingVotes(amount_: amt, campaignId_: cmgnId, campaignName_: cmgnNm, campaignBalance_: campBal, groupId_: votesArray.value(forKey: "groupId") as! String, memberId_: votesArray.value(forKey: "memberId") as! String, authProviderId_: votesArray.value(forKey: "authProviderId") as! String, network_: ntwrk, voteId_: votesArray.value(forKey: "voteId") as! String, voteType_: votesArray.value(forKey: "voteType") as! String , cashoutDestination_: cshDst, cashoutDestinationCode_: cshDstCd, cashoutDestinationNumber_: cshDstNmbr, reason_: rsn, voteCount_: vtCnt, role_: rl, membersRTDB_: self.memberDeets/*, ballotSummary_: self.ballotSummary*/)
//
//                                pendingVotes.append(votes)
//                                completionHandler(pendingVotes)
//
//                                //                                }
//                            }
//                        }
//                    }
//                }
//            }
//            print("info: \(pendingVotes)")
//            completionHandler(pendingVotes)
//        })
//    }
    
    
//    func fetchAllMembers(completionHandler: @escaping FetchAllMembersCompletionHandler){
//        var members: MembersRTDB!
//        let memberRef = Database.database().reference().child("users").child("\(authProviderId)")
//        _ = memberRef.observeSingleEvent(of: .value, with: { (snapshot) in
//
//            let snapshotValue = snapshot.value as! [String:AnyObject]
//
//            print("dict: \(snapshot)")
//
//            members = MembersRTDB(email_: "", memberId_: "", msisdn_: "", name_: "")
//
//            if let em = snapshotValue["email"] as? String {
//                print(em)
//                print(snapshotValue)
//                members.email = em
//            }
//            if let memId = snapshotValue["memberId"] as? String {
//                members.memberId = memId
//            }
//            if let msi = snapshotValue["msisdn"] as? String {
//                members.msisdn = msi
//            }
//            if let nam = snapshotValue["name"] as? String {
//                members.name = nam
//            }
//
//
//            //                    }
//            completionHandler(members)
//            print(members)
//        })
//
//    }

}


extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithPopView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        }) )
        self.present(alert, animated: true, completion: nil)
    }
}
