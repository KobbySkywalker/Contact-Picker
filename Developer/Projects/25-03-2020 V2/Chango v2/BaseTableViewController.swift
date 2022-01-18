//
//  BaseTableViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 24/07/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth

class BaseTableViewController: UITableViewController {

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
            
            messagesFetcher?.loadMessagesData(for: conversation, controller: chatLogController!, mainController: nil, mainTableController: self)
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
    
    func baseTableSessionTimeout() {
        
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


}
