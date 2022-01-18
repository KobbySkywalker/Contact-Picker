//
//  Message.swift
//  Avalon-print
//
//  Created by Roman Mizin on 3/25/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import Firebase

struct MessageSubtitle {
  static let video = "Attachment: Video"
  static let image = "Attachment: Image"
  static let audio = "Audio message"
  static let empty = "No messages here yet."
}

class FalconMessage: NSObject  {
  
    var messageUID: String?
    var isInformationMessage: Bool?

    var fromId: String?
    var text: String?
    var toId: String?
    var groupName: String?
    var timestamp: NSNumber?
    var convertedTimestamp: String?
  
    var status: String?
    var seen: Bool?
  
    var imageUrl: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
  
    var localImage: UIImage?
  
    var localVideoUrl: String?
  
    var voiceData: Data?
    var voiceDuration: String?
    var voiceStartTime: Int?
    var voiceEncodedString: String?

    var videoUrl: String?
  
    var estimatedFrameForText:CGRect?
    var imageCellHeight: NSNumber?
  
    var senderName: String? //local only, group messages only
      
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
  
    init(dictionary: [String: AnyObject]) {
        super.init()
//        print("NEW MESSAGE: \(dictionary)")
        messageUID = dictionary["key"] as? String
		print("Message UID: \(messageUID)")
        isInformationMessage = dictionary["isInformationMessage"] as? Bool
        if dictionary[messageUID!] != nil {
        fromId = dictionary[messageUID!]!["userId"] as? String
		text = dictionary[messageUID!]!["message"] as? String
        toId = dictionary[messageUID!]!["groupId"] as? String
        groupName = dictionary[messageUID!]!["groupName"] as? String
        timestamp = dictionary[messageUID!]!["timestamp"] as? NSNumber
        senderName = dictionary[messageUID!]!["senderName"] as? String
        imageUrl = dictionary[messageUID!]!["imageUrl"] as? String
        imageHeight = dictionary[messageUID!]!["imageHeight"] as? NSNumber
        imageWidth = dictionary[messageUID!]!["imageWidth"] as? NSNumber
        status = dictionary[messageUID!]!["status"] as? String
        }else {
            fromId = dictionary["userId"] as? String
            text = dictionary["message"] as? String
            toId = dictionary["groupId"] as? String
            timestamp = dictionary["timestamp"] as? NSNumber
        }
        convertedTimestamp = dictionary["convertedTimestamp"] as? String
      
        status = dictionary["status"] as? String
        seen = dictionary["seen"] as? Bool
        

        
        videoUrl = dictionary["videoUrl"] as? String
      
        localImage = dictionary["localImage"] as? UIImage
        localVideoUrl = dictionary["localVideoUrl"] as? String
      
        voiceEncodedString = dictionary["voiceEncodedString"] as? String
        voiceData = dictionary["voiceData"] as? Data //unused
        voiceDuration = dictionary["voiceDuration"] as? String
        voiceStartTime = dictionary["voiceStartTime"] as? Int
      
        estimatedFrameForText = dictionary["estimatedFrameForText"] as? CGRect
        imageCellHeight = dictionary["imageCellHeight"] as? NSNumber
      
        senderName = dictionary["senderName"] as? String
		
		print("Text: \(text)")
    }
}
