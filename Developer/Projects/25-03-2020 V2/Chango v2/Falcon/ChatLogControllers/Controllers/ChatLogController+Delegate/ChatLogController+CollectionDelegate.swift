//
//  ChatLogController+CollectionDelegate.swift
//  Pigeon-project
//
//  Created by Roman Mizin on 3/23/18.
//  Copyright © 2018 Roman Mizin. All rights reserved.
//

import UIKit
import Firebase

extension ChatLogController: CollectionDelegate {
  
  func collectionView(updateStatus reference: DatabaseReference, message: FalconMessage) {

    reference.observe(.childChanged, with: { (snapshot) in
        print("collect 1")
      guard snapshot.exists(), snapshot.key == "status", let newMessageStatus = snapshot.value  else { return }
      message.status = newMessageStatus as? String
        print("collect 2")
      self.updateMessageStatusUI(sentMessage: message)
    })
    print("collect 3")
    self.updateMessageStatus(messageRef: reference)
    print("collect 4")
    self.updateMessageStatusUI(sentMessage: message)
  }
  
  func sortedMessages(unsortedMessages: [FalconMessage]) -> [FalconMessage] {
    print("collect 5")
    let sortedMessages = unsortedMessages.sorted(by: { (message1, message2) -> Bool in
        print("collect 6")
      return message1.timestamp!.int32Value < message2.timestamp!.int32Value
        print("collect 7")
    })
    return sortedMessages
  }
  
  func collectionView(update message: FalconMessage, reference: DatabaseReference) {
    print("collection 1")
    let insertionIndex = messages.insertionIndexOf(elem: message, isOrderedBefore: { (message1, message2) -> Bool in
      return Int(truncating: message1.timestamp!) < Int(truncating: message2.timestamp!)
        print("collection 2")
    })
    self.messages.insert(message, at: insertionIndex)
    print("collection 3")
    self.collectionView?.performBatchUpdates ({
        print("collection 4")
      let indexPath = IndexPath(item: insertionIndex, section: 0)
        print("collection 5")
      self.collectionView?.insertItems(at: [indexPath])
        print("collection 6")
      
      if self.messages.count - 2 >= 0 {
        print("collection 7")
        self.collectionView?.reloadItems(at: [IndexPath (row: self.messages.count - 2, section: 0)])
      }
      print("collection 8")
      if self.messages.count - 1 >= 0 && self.isScrollViewAtTheBottom {
        print("collection 9")
        let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
        print("collection 10")
        DispatchQueue.main.async {
            print("collection 11")
          self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
      }
    }, completion: { (_) in
      self.updateMessageStatus(messageRef: reference)
    })
  }
}
