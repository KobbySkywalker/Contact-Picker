//
//  ChatLogController+MessageSenderDelegate.swift
//  Pigeon-project
//
//  Created by Roman Mizin on 9/19/18.
//  Copyright © 2018 Roman Mizin. All rights reserved.
//

import UIKit

extension ChatLogController: MessageSenderDelegate {

    func update(mediaSending progress: Double, animated: Bool) {
        uploadProgressBar.setProgress(Float(progress), animated: animated)
    }

    func update(with values: [String: AnyObject]) {
        updateDataSource(with: values)
    }

    //TO REFACTOR
    fileprivate func updateDataSource(with values: [String: AnyObject]) {
        var values = values
        if let isGroupChat = conversation?.isGroupChat, isGroupChat {
            print("\(values)", "\(isGroupChat)")
            values = messagesFetcher.preloadCellData(to: values, isGroupChat: true)
        }
        self.collectionView?.performBatchUpdates ({
            let message = FalconMessage(dictionary: values)
            self.messages.append(message)
            let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
            self.messages[indexPath.item].status = messageStatusSending
            self.messages.removeDuplicates()
        }, completion: { (bool) in
            self.collectionView.scrollToLast()
        })
    }
}


extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

extension UICollectionView {
    func scrollToLast() {
        guard numberOfSections > 0 else {
            return
        }
        let lastSection = numberOfSections - 1
        guard numberOfItems(inSection: lastSection) > 0 else {
            return
        }
        let lastItemIndexPath = IndexPath(item: numberOfItems(inSection: lastSection) - 1, section: lastSection)
        scrollToItem(at: lastItemIndexPath, at: .bottom, animated: true)
    }
}

