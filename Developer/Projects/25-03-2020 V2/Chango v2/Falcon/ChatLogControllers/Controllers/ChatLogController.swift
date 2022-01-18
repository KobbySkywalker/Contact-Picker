//
//  ChatLogController.swift
//  Pigeon-project
//
//  Created by Roman Mizin on 8/8/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import Firebase
import Photos
import AudioToolbox
import FTPopOverMenu_Swift
import CropViewController
import FTIndicator
import Alamofire



protocol DeleteAndExitDelegate: class {
  func deleteAndExit(from conversationID: String)
}

class ChatLogController: UICollectionViewController, MessagesDelegate {
    
    var conversation: Conversation?
    var messagesFetcher: MessagesFetcher!
    let chatLogHistoryFetcher = ChatLogHistoryFetcher()
    let groupMembersManager = GroupMembersManager()
    
    let reference = Database.database().reference()
    var membersReference: DatabaseReference!
    var typingIndicatorReference: DatabaseReference!
    var userStatusReference: DatabaseReference!
    
    var privateGroup: GroupResponse!
    
    
    var messages = [FalconMessage]()
    var sections = ["Messages"]
    
    let messagesToLoad = 50
    
    var mediaPickerController: MediaPickerControllerNew! = nil
    var voiceRecordingViewController: VoiceRecordingViewController! = nil
    weak var deleteAndExitDelegate: DeleteAndExitDelegate?
    
    var chatLogAudioPlayer: AVAudioPlayer!
    var inputTextViewTapGestureRecognizer = UITapGestureRecognizer()
    var uploadProgressBar = UIProgressView(progressViewStyle: .bar)
    
    let incomingTextMessageCellID = "incomingTextMessageCellID"
    let outgoingTextMessageCellID = "outgoingTextMessageCellID"
    let typingIndicatorCellID = "typingIndicatorCellID"
    let photoMessageCellID = "photoMessageCellID"
    let outgoingVoiceMessageCellID = "outgoingVoiceMessageCellID"
    let incomingVoiceMessageCellID = "incomingVoiceMessageCellID"
    let typingIndicatorDatabaseID = "typingIndicator"
    let typingIndicatorStateDatabaseKeyID = "Is typing"
    let incomingPhotoMessageCellID = "incomingPhotoMessageCellID"
    let informationMessageCellID = "informationMessageCellID"
    
    lazy var inputContainerView: ChatInputContainerView = {
        var chatInputContainerView = ChatInputContainerView()
        chatInputContainerView.chatLogController = self
        chatInputContainerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 50)
        
        return chatInputContainerView
    }()
    
    lazy var inputBlockerContainerView: InputBlockerContainerView = {
        var inputBlockerContainerView = InputBlockerContainerView()
        inputBlockerContainerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 50)
        inputBlockerContainerView.backButton.addTarget(self, action: #selector(inputBlockerAction), for: .touchUpInside)
        
        return inputBlockerContainerView
    }()
    
    var refreshControl: UIRefreshControl = {
        var refreshControl = UIRefreshControl()
        refreshControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        refreshControl.tintColor = ThemeManager.currentTheme().generalTitleColor
        refreshControl.addTarget(self, action: #selector(performRefresh), for: .valueChanged)
        
        return refreshControl
    }()
    
    @objc func inputBlockerAction() {
        guard let chatID = conversation?.chatID else { return }
        navigationController?.popViewController(animated: true)
        deleteAndExitDelegate?.deleteAndExit(from: chatID)
    }
    
    func scrollToBottom(at position: UICollectionView.ScrollPosition) {
        if self.messages.count - 1 <= 0 {
            return
        }
        let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
        DispatchQueue.main.async {
            self.collectionView?.scrollToItem(at: indexPath, at: position, animated: true)
        }
    }
    
    func scrollToBottomOfTypingIndicator() {
        if collectionView?.numberOfSections != 2 {
            return
        }
        let indexPath = IndexPath(item: 0, section: 1)
        DispatchQueue.main.async {
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private var localTyping = false
    
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            let typingData: NSDictionary = [Auth.auth().currentUser!.uid: newValue] //??
            if localTyping {
                sendTypingStatus(data: typingData)
            } else {
                if let isGroupChat = conversation?.isGroupChat, isGroupChat {
                    guard let currentUserID = Auth.auth().currentUser?.uid, let conversationID = conversation?.chatID else {
                        return
                    }
                    let userIsTypingRef = reference.child("groupChatsTemp").child(conversationID).child(typingIndicatorDatabaseID).child(currentUserID)
                    userIsTypingRef.removeValue()
                }
                //        else {
                //          guard let currentUserID = Auth.auth().currentUser?.uid, let conversationID = conversation?.chatID else {
                //            return
                //          }
                //          let userIsTypingRef = reference.child("user-messages").child(currentUserID).child(conversationID).child(typingIndicatorDatabaseID)
                //          userIsTypingRef.removeValue()
                //        }
            }
        }
    }
    
    func sendTypingStatus(data: NSDictionary) {
        guard let currentUserID = Auth.auth().currentUser?.uid, let conversationID = conversation?.chatID, currentUserID != conversationID else { return }
        
        if let isGroupChat = conversation?.isGroupChat, isGroupChat {
            let userIsTypingRef = reference.child("groupChatsTemp").child(conversationID).child(typingIndicatorDatabaseID)
            guard let data = data as? [AnyHashable: Any] else {
                return
            }
            userIsTypingRef.updateChildValues(data)
        }
        //    else {
        //      let userIsTypingRef = reference.child("user-messages").child(currentUserID).child(conversationID).child(typingIndicatorDatabaseID)
        //      userIsTypingRef.setValue(data)
        //    }
    }
    
    func observeTypingIndicator () {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        guard let conversationID = conversation?.chatID, currentUserID != conversationID else { return }
        
        if let isGroupChat = conversation?.isGroupChat, isGroupChat {
            let indicatorRemovingReference = reference.child("groupChatsTemp").child(conversationID).child(typingIndicatorDatabaseID).child(currentUserID)
            indicatorRemovingReference.onDisconnectRemoveValue()
            typingIndicatorReference = reference.child("groupChatsTemp").child(conversationID).child(typingIndicatorDatabaseID)
            typingIndicatorReference.observe(.value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject], let firstKey = dictionary.first?.key else {
                    self.handleTypingIndicatorAppearance(isEnabled: false)
                    return
                }
                
                if firstKey == currentUserID && dictionary.count == 1 {
                    self.handleTypingIndicatorAppearance(isEnabled: false)
                    return
                }
                
                self.handleTypingIndicatorAppearance(isEnabled: true)
            })
            
        }
        //    else {
        //      let indicatorRemovingReference = reference.child("user-messages").child(currentUserID).child(conversationID).child(typingIndicatorDatabaseID)
        //      indicatorRemovingReference.onDisconnectRemoveValue()
        //      typingIndicatorReference = reference.child("user-messages").child(conversationID).child(currentUserID).child(typingIndicatorDatabaseID).child(conversationID)
        //      typingIndicatorReference.onDisconnectRemoveValue()
        //      typingIndicatorReference.observe(.value, with: { (isTyping) in
        //        guard let isParticipantTyping = isTyping.value! as? Bool, isParticipantTyping else {
        //          self.handleTypingIndicatorAppearance(isEnabled: false)
        //          return
        //        }
        //        self.handleTypingIndicatorAppearance(isEnabled: true)
        //      })
        //    }
    }
    
    func messages(shouldBeUpdatedTo messages: [FalconMessage], conversation: Conversation) {
        print("My Messages I : \(messages)")
        
    }
    
    func messages(shouldChangeMessageStatusToReadAt reference: DatabaseReference) {
        
    }
    
    func handleTypingIndicatorAppearance(isEnabled: Bool) {
        
        let sectionsIndexSet: IndexSet = [1]
        
        if isEnabled {
            guard sections.count < 2 else { return }
            self.collectionView?.performBatchUpdates ({
                self.sections = ["Messages", "TypingIndicator"]
                self.collectionView?.insertSections(sectionsIndexSet)
            }, completion: { (_) in
                if self.collectionView!.contentOffset.y >= (self.collectionView!.contentSize.height - self.collectionView!.frame.size.height - 200) {
                    if self.collectionView!.contentSize.height < self.collectionView!.bounds.height  {
                        return
                    }
                    
                    if #available(iOS 11.0, *) {
                        let currentContentOffset = self.collectionView?.contentOffset
                        let newContentOffset = CGPoint(x: 0, y: currentContentOffset!.y + 40)
                        self.collectionView?.setContentOffset(newContentOffset, animated: true)
                    } else {
                        self.scrollToBottomOfTypingIndicator()
                    }
                }
            })
        } else {
            
            guard sections.count == 2 else { return }
            self.collectionView?.performBatchUpdates ({
                
                self.sections = ["Messages"]
                
                if self.collectionView!.numberOfSections > 1 {
                    self.collectionView?.deleteSections(sectionsIndexSet)
                    let indexPath = IndexPath(item: 0, section: 1 )
                    guard let cell = self.collectionView?.cellForItem(at: indexPath) as? TypingIndicatorCell else {
                        return
                    }
                    
                    cell.typingIndicator.animatedImage = nil
                    guard let contentHeight = collectionView?.contentSize.height,
                          let frameHeight = collectionView?.frame.size.height,
                          let yOffset = collectionView?.contentOffset.y else {
                        return
                    }
                    
                    if yOffset >= (contentHeight - frameHeight + 200) {
                        self.scrollToBottom(at: .bottom)
                    }
                }
            }, completion: nil)
        }
    }
    
    func updateMessageStatus(messageRef: DatabaseReference) {
        
        guard let uid = Auth.auth().currentUser?.uid, currentReachabilityStatus != .notReachable else { return }
        
        var senderID: String?
        
        messageRef.child("fromId").observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() { return }
            
            senderID = snapshot.value as? String
            
            guard uid != senderID, self.navigationController?.visibleViewController is ChatLogController else {
                senderID = nil
                return
            }
            
            messageRef.updateChildValues(["seen": true, "status": messageStatusRead], withCompletionBlock: { (_, _) in
                self.resetBadgeForSelf()
            })
        })
    }
    
    fileprivate func resetBadgeForSelf() {
        guard let toId = conversation?.chatID, let fromId = Auth.auth().currentUser?.uid else { return }
        let badgeRef = Database.database().reference().child("user-messages").child(fromId).child(toId).child(messageMetaDataFirebaseFolder).child("badge")
        badgeRef.runTransactionBlock({ (mutableData) -> TransactionResult in
            var value = mutableData.value as? Int
            value = 0
            mutableData.value = value!
            return TransactionResult.success(withValue: mutableData)
        })
    }
    
    func updateMessageStatusUI(sentMessage: FalconMessage) {
        DispatchQueue.global(qos: .default).async {
            guard let index = self.messages.firstIndex(where: { (message) -> Bool in
                return message.messageUID == sentMessage.messageUID
            }) else { return }
            
            guard index >= 0 else { return }
            self.messages[index].status = sentMessage.status
            
            DispatchQueue.main.async {
                self.collectionView?.performBatchUpdates({
                    self.collectionView?.reloadItems(at: [IndexPath(row: index, section: 0)])
                }, completion: nil)
            }
            
            guard sentMessage.status == messageStatusDelivered, self.messages[index].messageUID == self.messages.last?.messageUID,
                  userDefaults.currentBoolObjectState(for: userDefaults.inAppSounds) else { return }
            SystemSoundID.playFileNamed(fileName: "sent", withExtenstion: "caf")
        }
    }
    
    
    func indexPathIsValid(indexPath: IndexPath) -> Bool {
        if indexPath.section >= (numberOfSections(in: collectionView)) {
            return false
        }
        if indexPath.row >= collectionView.numberOfItems(inSection: indexPath.section) {
            return false
        }
        return true
    }
    
    func updateMessageStatusUIAfterDeletion(sentMessage: FalconMessage) {
        guard let uid = Auth.auth().currentUser?.uid, currentReachabilityStatus != .notReachable,
              let lastMessageUID = messages.last?.messageUID, self.messages.count >= 0 else { return }
        
        if messages.last!.toId == uid && self.messages.last?.status != messageStatusRead {
            let messagesRef = Database.database().reference().child("messages").child(lastMessageUID)
            messagesRef.updateChildValues(["seen": true, "status": messageStatusRead], withCompletionBlock: { (_, _) in
                self.messages.last?.status = messageStatusRead
                self.collectionView?.reloadItems(at: [IndexPath(row: self.messages.count - 1, section: 0)])
            })
        } else {
            self.collectionView?.reloadItems(at: [IndexPath(row: self.messages.count - 1, section: 0)])
        }
    }
    
    func createRectangularView() {
        let imageName = "Rectangle 3.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.contentMode = .scaleToFill
        imageView.frame = CGRect(x: 0, y: 185, width: self.view.frame.size.width, height: self.view.frame.height)
        view.addSubview(imageView)
        self.view.bringSubviewToFront(imageView)
        
    }
    
    func createThemeView() {
        let imageName = "Group 1849.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 145, y: -55, width: 380, height: 292)
        
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    
    
    func createBackButton() {
        let button = UIButton(frame: CGRect(x: 39, y: 50, width: 24, height: 24))
        let image = UIImage(named: "icons-dark-back") as UIImage?
        button.imageView?.image = UIImage(named: "icons-dark-back")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(button)
        self.view.bringSubviewToFront(button)
    }
    
    func createGroupChatLabel() {
        let label = UILabel(frame: CGRect(x: 35, y: 130, width: 200, height: 36))
        label.textAlignment = .left
        label.text = "Group Chat"
        label.font = UIFont(name: "Sora-Bold", size: 25)
        label.textColor = .white
        self.view.addSubview(label)
        self.view.bringSubviewToFront(label)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        createRectangularView()
        //    createBlueBlackBackground()
        createThemeView()
        createBackButton()
        createGroupChatLabel()
        setupCollectionView()
        setRightBarButtonItem()
        setupTitleName()
        FTIndicator.dismissProgress()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if topViewController(rootViewController: self) is CropViewController {
            return
        }
        
        if messagesFetcher.userMessagesReference != nil {
            messagesFetcher.userMessagesReference.removeAllObservers()
        }else {
            print("user reference is nil")
        }
        
        if messagesFetcher.messagesReference != nil {
            messagesFetcher.messagesReference.removeAllObservers()
        }
        
        messagesFetcher.collectionDelegate = nil
        messagesFetcher.delegate = nil
        messagesFetcher = nil
        
        if typingIndicatorReference != nil {
            typingIndicatorReference.removeAllObservers()
        }
        
        if userStatusReference != nil {
            userStatusReference.removeObserver(withHandle: userHandler)
        }
        
        groupMembersManager.removeAllObservers()
        
        isTyping = false
        
        guard voiceRecordingViewController != nil, voiceRecordingViewController.recorder != nil else { return }
        voiceRecordingViewController.stop()
        voiceRecordingViewController.deleteAllRecordings()
    }
    
    deinit {
        print("\n CHATLOG CONTROLLER DE INIT \n")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureProgressBar()
        print("MY MESSAGES: \(messages)")
        guard inputContainerView.inputTextView.isFirstResponder else { return }
        UIView.performWithoutAnimation {
            self.inputContainerView.inputTextView.resignFirstResponder()
        }
    }
    
    func startCollectionViewAtBottom () { // start chat log at bottom for iOS 10
        let collectionViewInsets: CGFloat = (collectionView!.contentInset.bottom + collectionView!.contentInset.top)
        guard let contentHeight = collectionView?.collectionViewLayout.collectionViewContentSize.height,
              let collectionHeight = collectionView?.bounds.size.height else {
            return
        }
        guard Double(contentHeight) > Double(collectionHeight) else {
            return
        }
        let offsetY = contentHeight - (collectionHeight - collectionViewInsets - inputContainerView.frame.height)
        let targetContentOffset = CGPoint(x: 0.0, y: offsetY)
        collectionView?.contentOffset = targetContentOffset
    }
    
    private var didLayoutFlag: Bool = false
    override func viewDidLayoutSubviews() { // start chat log at bottom for iOS 11
        super.viewDidLayoutSubviews()
        
        if #available(iOS 11.0, *) {
            guard let collectionView = collectionView, !didLayoutFlag else {
                return
            }
            
            if messages.count - 1 >= 0 {
                UIView.performWithoutAnimation {
                    if collectionView.contentSize.height < collectionView.bounds.height {
                        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                    } else {
                        let targetContentOffset = CGPoint(x: 0.0, y: collectionView.contentSize.height - (collectionView.bounds.size.height - 40 - inputContainerView.frame.height + 70))
                        self.collectionView?.setContentOffset(targetContentOffset, animated: false)
                    }
                }
            }
            didLayoutFlag = true
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
        inputContainerView.inputTextView.invalidateIntrinsicContentSize()
        inputContainerView.invalidateIntrinsicContentSize()
        DispatchQueue.main.async {
            self.inputContainerView.attachedImages.frame.size.width = self.inputContainerView.inputTextView.frame.width
            self.collectionView?.reloadData()
        }
    }
    
    fileprivate func configureProgressBar() {
        guard navigationController?.navigationBar != nil else { return }
        guard !uploadProgressBar.isDescendant(of: navigationController!.navigationBar) else { return }
        
        navigationController?.navigationBar.addSubview(uploadProgressBar)
        uploadProgressBar.translatesAutoresizingMaskIntoConstraints = false
        uploadProgressBar.bottomAnchor.constraint(equalTo: navigationController!.navigationBar.bottomAnchor).isActive = true
        uploadProgressBar.leftAnchor.constraint(equalTo: navigationController!.navigationBar.leftAnchor).isActive = true
        uploadProgressBar.rightAnchor.constraint(equalTo: navigationController!.navigationBar.rightAnchor).isActive = true
    }
    
    fileprivate func setupCollectionView () {
        inputTextViewTapGestureRecognizer = UITapGestureRecognizer(target: inputContainerView.chatLogController,
                                                                   action: #selector(ChatLogController.toggleTextView))
        inputTextViewTapGestureRecognizer.delegate = inputContainerView
        
        chatLogHistoryFetcher.delegate = self
        groupMembersManager.delegate = self
        groupMembersManager.observeMembersChanges(conversation)
        
        view.backgroundColor = UIColor(hexString: "#05406F")
        collectionView?.indicatorStyle = ThemeManager.currentTheme().scrollBarStyle
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.delaysContentTouches = false
        collectionView?.alwaysBounceVertical = true
        collectionView?.isPrefetchingEnabled = true
        
        if #available(iOS 11.0, *) {
            collectionView?.translatesAutoresizingMaskIntoConstraints = false
            extendedLayoutIncludesOpaqueBars = true
            automaticallyAdjustsScrollViewInsets = false
            navigationItem.largeTitleDisplayMode = .never
            
            collectionView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: 200).isActive = true
            //      collectionView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            collectionView?.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            collectionView?.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            collectionView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                    constant: -inputContainerView.frame.height).isActive = true
        } else {
            let frameHeight = view.frame.height - inputContainerView.frame.height
            collectionView?.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: frameHeight)
            automaticallyAdjustsScrollViewInsets = true
            extendedLayoutIncludesOpaqueBars = true
        }
        collectionView?.addSubview(refreshControl)
        collectionView?.register(IncomingTextMessageCell.self, forCellWithReuseIdentifier: incomingTextMessageCellID)
        collectionView?.register(OutgoingTextMessageCell.self, forCellWithReuseIdentifier: outgoingTextMessageCellID)
        collectionView?.register(TypingIndicatorCell.self, forCellWithReuseIdentifier: typingIndicatorCellID)
        collectionView?.register(PhotoMessageCell.self, forCellWithReuseIdentifier: photoMessageCellID)
        collectionView?.register(IncomingPhotoMessageCell.self, forCellWithReuseIdentifier: incomingPhotoMessageCellID)
        collectionView?.register(OutgoingVoiceMessageCell.self, forCellWithReuseIdentifier: outgoingVoiceMessageCellID)
        collectionView?.register(IncomingVoiceMessageCell.self, forCellWithReuseIdentifier: incomingVoiceMessageCellID)
        collectionView?.register(InformationMessageCell.self, forCellWithReuseIdentifier: informationMessageCellID)
        collectionView?.registerNib(UINib(nibName: "TimestampView", bundle: nil), forRevealableViewReuseIdentifier: "timestamp")
        self.view.bringSubviewToFront(collectionView)
        configureRefreshControlInitialTintColor()
        configureCellContextMenuView()
    }
    
    fileprivate func configureCellContextMenuView() {
        let config = FTConfiguration.shared
        config.backgoundTintColor = UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1.0)
        config.borderColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 0.0)
        config.menuWidth = 100
        config.menuSeparatorColor = ThemeManager.currentTheme().generalSubtitleColor
        config.menuRowHeight = 40
        config.cornerRadius = 25
    }
    
    /* fixes bug of not setting refresh control tint color on initial refresh */
    fileprivate func configureRefreshControlInitialTintColor() {
        collectionView?.contentOffset = CGPoint(x: 0, y: -refreshControl.frame.size.height)
        refreshControl.beginRefreshing()
        refreshControl.endRefreshing()
    }
    
    fileprivate var userHandler: UInt = 01
    fileprivate var onlineStatusInString: String?
    
    func setupTitleName() {
        guard let currentUserID = Auth.auth().currentUser?.uid, let toId = conversation?.chatID else { return }
        if currentUserID == toId {
            self.navigationItem.setTitle(title: NameConstants.personalStorage, subtitle: "")
        } else {
            self.navigationItem.setTitle(title: conversation?.chatName ?? "", subtitle: "")
        }
    }
    
    func configureTitleViewWithOnlineStatus() {
        
        
        if let isGroupChat = conversation?.isGroupChat, isGroupChat, let title = conversation?.chatName,
           let membersCount = conversation?.chatParticipantsIDs?.count {
            let subtitle = "\(membersCount) members"
            self.navigationItem.setTitle(title: title, subtitle: subtitle)
            return
        }
        
        guard let currentUserID = Auth.auth().currentUser?.uid, let toId = conversation?.chatID else { return }
        
        if currentUserID == toId {
            print(currentUserID, toId)
            self.navigationItem.title = NameConstants.personalStorage
            return
        }
        
        userStatusReference = Database.database().reference().child("chats").child("\(privateGroup.groupId)")
        userHandler = userStatusReference.observe(.value, with: { (snapshot) in
            guard snapshot.exists() else { print("snapshot not exists returning"); return }
            print("exists")
            
            let value = snapshot.value as? NSDictionary
            let status = value?["OnlineStatus"] as AnyObject
            self.onlineStatusInString = self.manageNavigationItemTitle(onlineStatusObject: status)
        })
    }
    
    fileprivate func manageNavigationItemTitle(onlineStatusObject: AnyObject) -> String {
        
        guard let title = conversation?.chatName else { return "" }
        if let onlineStatusStringStamp = onlineStatusObject as? String {
            if onlineStatusStringStamp == statusOnline { // user online
                self.navigationItem.setTitle(title: title, subtitle: statusOnline)
                return statusOnline
            } else { // user got a timstamp converted to string (was in earlier versions of app)
                let date = Date(timeIntervalSince1970: TimeInterval(onlineStatusStringStamp)!)
                let subtitle = "Last seen " + timeAgoSinceDate(date)
                self.navigationItem.setTitle(title: title, subtitle: subtitle)
                return subtitle
            }
        } else if let onlineStatusTimeIntervalStamp = onlineStatusObject as? TimeInterval {
            //user got server timestamp in miliseconds
            let date = Date(timeIntervalSince1970: onlineStatusTimeIntervalStamp/1000)
            let subtitle = "Last seen " + timeAgoSinceDate(date)
            self.navigationItem.setTitle(title: title, subtitle: subtitle)
            return subtitle
        }
        return ""
    }
    
    func setRightBarButtonItem () {
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(getInfoAction), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        guard let uid = Auth.auth().currentUser?.uid, let conversationID = conversation?.chatID, uid != conversationID else { return }
        navigationItem.rightBarButtonItem = infoBarButtonItem
        if isCurrentUserMemberOfCurrentGroup() {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc func getInfoAction() {
        
    }
    
    var canRefresh = true
    var isScrollViewAtTheBottom = true
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let contentOffsetY = collectionView?.contentOffset.y else { return }
        guard let contentHeight = collectionView?.contentSize.height else { return }
        guard let frameHeight = collectionView?.frame.size.height else { return }
        if contentOffsetY >= (contentHeight - frameHeight - 200) {
            isScrollViewAtTheBottom = true
        } else {
            isScrollViewAtTheBottom = false
        }
        
        if scrollView.contentOffset.y < 0 { //change 100 to whatever you want
            if collectionView!.contentSize.height < UIScreen.main.bounds.height - 50 {
                canRefresh = false
            }
            
            if canRefresh && !refreshControl.isRefreshing {
                canRefresh = false
                refreshControl.beginRefreshing()
                performRefresh()
            }
        } else if scrollView.contentOffset.y >= 0 {
            canRefresh = true
        }
    }
    
    @objc func performRefresh() {
        guard let conversation = self.conversation else { return }
        
        if let isGroupChat = conversation.isGroupChat, isGroupChat {
            chatLogHistoryFetcher.loadPreviousMessages(messages, conversation, messagesToLoad, true)
        }
        //    else {
        //      chatLogHistoryFetcher.loadPreviousMessages(messages, conversation, messagesToLoad, false)
        //    }
    }
    
    override var inputAccessoryView: UIView? {
        //    get {
        //      if let membersIDs = conversation?.chatParticipantsIDs,
        //        let uid = Auth.auth().currentUser?.uid, membersIDs.contains(uid) {
        //         return inputContainerView
        //      }
        //      return inputBlockerContainerView
        //    }
        return inputContainerView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func handleSend() {
        guard currentReachabilityStatus != .notReachable else {
            basicErrorAlertWith(title: basicErrorTitleForAlert, message: noInternetError, controller: self)
            return
        }
        
        isTyping = false
        let text = inputContainerView.inputTextView.text
        let media = inputContainerView.selectedMedia
        if mediaPickerController != nil {
            mediaPickerController.collectionView.deselectAllItems()
        }
        inputContainerView.prepareForSend()
        let messageSender = MessageSender(conversation, text: text, media: media)
        let conversationObj = Conversation(dictionary: ["key": "" as AnyObject,
                                                        "groupId": privateGroup.groupId as AnyObject,
                                                        "status": "" as AnyObject,
                                                        "seen": "" as AnyObject,
                                                        "isGroupChat": true  as AnyObject,
                                                        "userId": Auth.auth().currentUser?.uid as AnyObject,
                                                        "timestamp": Date() as AnyObject,
                                                        "message": text as AnyObject])
        messageSender.groupId = privateGroup.groupId
        messageSender.groupName = privateGroup.groupName
        messageSender.conversation = conversationObj
        messageSender.conversation?.chatID = privateGroup.groupId
        conversation = conversationObj
        messageSender.delegate = self
        messageSender.sendMessage()
        let parameter: PushNotificationParameter = PushNotificationParameter(groupId: privateGroup.groupId, notificationType: "chat", senderAuthProviderId: Auth.auth().currentUser!.uid)
        pushNotificationsForChat(pushNotificationParameter: parameter)
    }
    
    
    func pushNotificationsForChat(pushNotificationParameter: PushNotificationParameter) {
        AuthNetworkManager.pushNotificationForChats(parameter: pushNotificationParameter) { (result) in
            self.parsePushNotificationsForChat(result: result)
        }
    }
    
    private func parsePushNotificationsForChat(result: DataResponse<RegularResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            
            break
        case .failure(_):
            FTIndicator.dismissProgress()
            
            if result.response?.statusCode == 400 {
                
                sessionTimeout()
                
            }else {
                
                let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
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
    
}
