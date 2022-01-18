//
//  MessagesFetcher.swift
//  Pigeon-project
//
//  Created by Roman Mizin on 3/23/18.
//  Copyright © 2018 Roman Mizin. All rights reserved.
//

import UIKit
import Firebase
import Photos

protocol MessagesDelegate: class {
    func messages(shouldBeUpdatedTo messages: [FalconMessage], conversation: Conversation)
    func messages(shouldChangeMessageStatusToReadAt reference: DatabaseReference)
}

protocol CollectionDelegate: class {
    func collectionView(update message: FalconMessage, reference: DatabaseReference)
    func collectionView(updateStatus reference: DatabaseReference, message: FalconMessage)
}

typealias FetchAllGroupChatCompletionHandler = (_ chats: [Message]) -> Void


class MessagesFetcher: NSObject {
    
    var chatLogController: ChatLogController? = nil
    
    private var messages = [FalconMessage]()
    
    var userMessagesReference: DatabaseQuery!
    
    var messagesReference: DatabaseReference!
    
    var privateGroup: GroupResponse!
    
    var groupChatDetails: [Message] = []
    
    private  let messagesToLoad = 50
    
    private var chatLogAudioPlayer: AVAudioPlayer!
    
    weak var delegate: MessagesDelegate?
    
    weak var collectionDelegate: CollectionDelegate?
    
    var isInitialChatMessagesLoad = true
    
    private var   loadingMessagesGroup = DispatchGroup()
    
    private var loadingNamesGroup = DispatchGroup()
    
    
    func loadMessagesData(for conversation: Conversation, controller: ChatLogController, mainController: BaseViewController?, mainTableController: BaseTableViewController?) {
        
        var message: FalconMessage!
        var isGroupChat = Bool()
        if let groupChat = conversation.isGroupChat, groupChat { isGroupChat = true } else { isGroupChat =
            false }
        print(privateGroup.groupId)
        userMessagesReference = Database.database().reference().child("chats").child("\(privateGroup.groupId)").queryLimited(toLast: UInt(messagesToLoad))
        
        
        loadingMessagesGroup.enter()
        newLoadMessages(reference: userMessagesReference, isGroupChat: isGroupChat, controller: controller)
        
        loadingMessagesGroup.notify(queue: .main, execute: {
            print("loadingMessagesGroup finished")
            
            guard self.messages.count != 0 else {
                print("else running")
                self.isInitialChatMessagesLoad = false
                controller.messages = self.messages
                self.delegate?.messages(shouldBeUpdatedTo: self.messages, conversation: conversation)
                mainController?.navigationController?.pushViewController(controller, animated: true)
                mainTableController?.navigationController?.pushViewController(controller, animated: true)
                return
            }
            
            self.loadingNamesGroup.enter()
            self.newLoadUserames(controller: controller)
            
            controller.messages = self.messages
            self.delegate?.messages(shouldBeUpdatedTo: self.messages, conversation: conversation)
            mainController?.navigationController?.pushViewController(controller, animated: true)
            mainTableController?.navigationController?.pushViewController(controller, animated: true)
            self.loadingNamesGroup.notify(queue: .main, execute: {
                print("loadingNamesGroup finished")
                self.messages = self.sortedMessages(unsortedMessages: self.messages)
                self.isInitialChatMessagesLoad = false
                self.delegate?.messages(shouldChangeMessageStatusToReadAt: self.messagesReference)
                self.delegate?.messages(shouldBeUpdatedTo: self.messages, conversation: conversation)
            })
            
        })
        
        
    }
    
    func newLoadMessages(reference: DatabaseQuery, isGroupChat: Bool, controller: ChatLogController) {
        var loadedMessages = [FalconMessage]()
        let loadedMessagesGroup = DispatchGroup()
        
        reference.observeSingleEvent(of: .value) { (snapshot) in
            for _ in 0 ..< snapshot.childrenCount { loadedMessagesGroup.enter() }
            print("new msg: \(snapshot)")
            
            loadedMessagesGroup.notify(queue: .main, execute: {
                print("loaded messages group finished initial loading messages")
                self.messages = loadedMessages
                self.loadingMessagesGroup.leave()
            })
            reference.observe(.childAdded, with: { (snapshot) in
                let messageUID = snapshot.key
                self.messagesReference = Database.database().reference().child("chats").child("\(self.privateGroup.groupId)")/*.child(messageUID)*/
                self.messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    //            print("snapshot: \(snapshot)")
                    guard var dictionary = snapshot.value as? [String: AnyObject] else { return }
                    dictionary.updateValue(messageUID as AnyObject, forKey: "key")
                    print("message UID: \(messageUID)")
                    dictionary = self.preloadCellData(to: dictionary, isGroupChat: isGroupChat)
                    
                    guard self.isInitialChatMessagesLoad else {
                        print("not initial")
                        self.handleMessageInsertionInRuntime(newDictionary: dictionary, controller: controller)
                        controller.messages.append(self.messages)
                        
                        return
                    }
                    print("initial")
                    loadedMessages.append(FalconMessage(dictionary: dictionary))
                    loadedMessagesGroup.leave()
                })
            })
        }
        
    }
    
    
    func handleMessageInsertionInRuntime(newDictionary: [String:AnyObject], controller: ChatLogController) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let message = FalconMessage(dictionary: newDictionary)
        let isOutBoxMessage = message.fromId == currentUserID || message.fromId == message.toId
        print("message from id: \(message.fromId)")
        self.loadUserNameForOneMessage(message: message) { [unowned self] (_, messageWithName) in
            if !isOutBoxMessage {
                print("outbox message")
                print(messageWithName.senderName)
                print("mess: \(message)")
                
                //        self.collectionDelegate?.collectionView(update: messageWithName, reference: self.messagesReference)
                controller.messages.append(messageWithName)
                var indexPath = IndexPath(row: controller.messages.count - 1, section: 0)
                
                controller.collectionView.reloadData()
                controller.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
                print(message.text)
                print("controller: \(controller)")
                
                
            } else {
                if let isInformationMessage = message.isInformationMessage, isInformationMessage {
                    self.collectionDelegate?.collectionView(update: messageWithName, reference: self.messagesReference)
                    print("iformation message")
                    
                } else {
                    self.collectionDelegate?.collectionView(updateStatus: self.messagesReference, message: messageWithName)
                    print("messageref: \(self.messagesReference)")
                    
                }
            }
        }
        
        
    }
    
    
    typealias LoadNameCompletionHandler = (_ success: Bool, _ message: FalconMessage) -> Void
    func loadUserNameForOneMessage(message: FalconMessage, completion: @escaping LoadNameCompletionHandler) {
        guard let senderID = message.fromId else { completion(true, message); return }
        print("fromId: \(message.fromId)")
        let reference = Database.database().reference().child("users").child(senderID)/*.child(senderID)*///.child("name")
        print("after reference")
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            print("snap \(snapshot)")
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            print("dic: \(dictionary)")
            let user = FalconUser(dictionary: dictionary)
            for (key, value) in dictionary {
                print("\(key) -> \(value)")
            }
            
            
            let name = user.name
            print("nam: \(user.name), \(name)")
            message.senderName = name!
            print("name: \(name)")
            completion(true, message)
        })
    }
    
    
    func newLoadUserames(controller: ChatLogController) {
        let loadedUserNamesGroup = DispatchGroup()
        
        for _ in messages {
            loadedUserNamesGroup.enter()
            print("names entering")
        }
        
        loadedUserNamesGroup.notify(queue: .main, execute: {
            print("loadedUserNamesGroup group finished ")
            self.loadingNamesGroup.leave()
        })
        
        for index in 0...messages.count - 1 {
            print("msg: \(messages[index].fromId)")
            guard let senderID = messages[index].fromId else { print("continuing"); continue }
            let reference = Database.database().reference().child("users").child(senderID)//.child("name")
            reference.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                let user = FalconUser(dictionary: dictionary)
                print("falcon name: \(user.name)")
                guard let name = user.name else {
                    loadedUserNamesGroup.leave(); return }
                self.messages[index].senderName = name
                controller.collectionView.reloadData()
                loadedUserNamesGroup.leave()
                print("names leaving")
            })
        }
    }
    
    
    
    func sortedMessages(unsortedMessages: [FalconMessage]) -> [FalconMessage] {
        let sortedMessages = unsortedMessages.sorted(by: { (message1, message2) -> Bool in
            return message1.timestamp?.int32Value < message2.timestamp?.int32Value
        })
        return sortedMessages
    }
    
    func preloadCellData(to dictionary: [String: AnyObject], isGroupChat: Bool) -> [String: AnyObject] {
        var dictionary = dictionary
        if let messageText = FalconMessage(dictionary: dictionary).text { /* pre-calculateCellSizes */
            dictionary.updateValue(estimateFrameForText(messageText) as AnyObject, forKey: "estimatedFrameForText" )
        } else if let imageWidth = FalconMessage(dictionary: dictionary).imageWidth?.floatValue,
            let imageHeight = FalconMessage(dictionary: dictionary).imageHeight?.floatValue {
            let cellHeight = CGFloat(imageHeight / imageWidth * 200).rounded()
            dictionary.updateValue(cellHeight as AnyObject, forKey: "imageCellHeight")
        }
        
        if let voiceEncodedString = FalconMessage(dictionary: dictionary).voiceEncodedString,
            let decoded = Data(base64Encoded: voiceEncodedString) { /* pre-encoding voice messages */
            let duration = self.getAudioDurationInHours(from: decoded) as AnyObject
            let startTime = self.getAudioDurationInSeconds(from: decoded) as AnyObject
            dictionary.updateValue(decoded as AnyObject, forKey: "voiceData")
            dictionary.updateValue(duration, forKey: "voiceDuration")
            dictionary.updateValue(startTime, forKey: "voiceStartTime")
        }
        
        if let messageTimestamp = FalconMessage(dictionary: dictionary).timestamp {  /* pre-converting timeintervals into dates */
            let newMessageTimeStamp: NSNumber = Int(truncating: messageTimestamp)/1000 as! NSNumber
            let date = Date(timeIntervalSince1970: TimeInterval(truncating: newMessageTimeStamp))
            let convertedTimestamp = timestampOfChatLogMessage(date) as AnyObject
            dictionary.updateValue(convertedTimestamp, forKey: "convertedTimestamp")
        }
        
        return dictionary
    }
    
    
    func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 10000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
        return text.boundingRect(with: size, options: options, attributes: attributes, context: nil).integral
    }
    
    func estimateFrameForText(width: CGFloat, text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: width, height: 10000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: font]
        return text.boundingRect(with: size, options: options, attributes: attributes, context: nil).integral
    }
    
    func getAudioDurationInHours(from data: Data) -> String? {
        do {
            chatLogAudioPlayer = try AVAudioPlayer(data: data)
            let duration = Int(chatLogAudioPlayer.duration)
            let hours = Int(duration) / 3600
            let minutes = Int(duration) / 60 % 60
            let seconds = Int(duration) % 60
            return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        } catch {
            print("error playing")
            return String(format: "%02i:%02i:%02i", 0, 0, 0)
        }
    }
    
    func getAudioDurationInSeconds(from data: Data) -> Int? {
        do {
            chatLogAudioPlayer = try AVAudioPlayer(data: data)
            let duration = Int(chatLogAudioPlayer.duration)
            return duration
        } catch {
            print("error playing")
            return nil
        }
    }
}
