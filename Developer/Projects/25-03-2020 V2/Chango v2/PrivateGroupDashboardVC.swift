//
//  PrivateGroupDashboardVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 22/09/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Firebase
import FTIndicator
import Alamofire
import Nuke

class PrivateGroupDashboardVC: BaseViewController, UIImagePickerControllerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupInfo: UIButton!
    @IBOutlet weak var groupBalance: UILabel!
    @IBOutlet weak var borrowStack: UIStackView!
    @IBOutlet weak var aboutGroup: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    @IBOutlet weak var activeCampaignCountLabel: UILabel!
    @IBOutlet weak var contributionAmountLabel: UILabel!
    @IBOutlet weak var pendingVotesLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var balaceLabel: UILabel!
    
    var privateGroup: GroupResponse!
    var campaignDetails: [GetGroupCampaignsResponse] = []
    var defaultContributions: DefaultCampaignResponse!
    var contributions: [ContributionSection] = []
    var cashCampaign: GetGroupCampaignsResponse!
    var cashoutCampaigns: [GetGroupCampaignsResponse] = []
    var memberResp: MemberGroupIdResponse!
    var countryId: CountryId!
    var votesPending: [PendingVotes] = []
    var memberDeets: MembersRTDB!
    var ballotSummary: BallotSummaryRTDB!
    var check: Int = 0
    var loanFlag: Int = 0
    var allGroupsController: AllGroupsViewController!
    var membersAdminCheck: Int = 0
    var amountReceived: Double = 0.0
    var mainViewController: MainMenuViewController!
    var voteCampaignId: String = ""
    var minVote: Double = 0.0
    var groupSize: Int = 0
    var campaignBalances: [GroupBalance] = []
    var maxCashoutLimit: Int = 0
    var maxContributionLimit: Int = 0
    var maxSingleContributeLimit: Double = 0.0
    var maxSingleCashoutLimit: Double = 0.0
    var currency: String = ""
    var memberKycSuccessful: Bool = false
    var noMemberKycRespose: String = ""
    var userMemberId: String = ""

    var imageUrl: String = ""
    var adminResponse: String = ""
    var voteId: String = ""
    var groupName: String = ""
    var campaignId: String = ""
    var ballotId: String = ""
    var loanVoteId: String = ""
    var dropVoteId: String = ""
    var adminVoteId: String = ""
    var approverVoteId: String = ""
    var makeAdminVoteId: String = ""
    var makeApproverVoteId: String = ""
    var cashoutVoteId: String = ""
    var network: String = ""
    var userNumber: String = ""
    var memberId: String = ""
    var authProviderId: String = ""
    var campaignBalance: String = ""
    var groupId: String = ""
    var refreshPage: Bool = false
    var totalContributionss: String = ""
    var totalCashouts: String = ""
    var totalBorrowed: String = ""
    
    var groupNamed: String = ""
    var nameChangedd: Bool = false

    var realTimeGroupBalance: String = ""
    var realTimeGroupMemberCount: String = ""
    var realTimeGroupCampaignCount: String = ""
    var voteCount: Int = 0

    var success: Int = 0
    let picker = UIImagePickerController()

    typealias FetchAllGroupChatCompletionHandler = (_ chats: [Message]) -> Void
    typealias FetchAllPendingVotesCompletionHandler = (_ votes: [PendingVotes]) -> Void
    typealias FetchAllMembersCompletionHandler = (_ groups: MembersRTDB ) -> Void
    typealias FetchBallotSummaryCompletionHandler = (_ groups: BallotSummaryRTDB ) -> Void
    typealias FetchGroupBalanceCompletionHandler = (_ groupBalance: String ) -> Void
    typealias FetchGroupMemberCountCompletionHandler = (_ memberCount: Int ) -> Void
    typealias FetchGroupCampaignCountCompletionHandler = (_ campaignCount: Int ) -> Void
    typealias FetchGroupVoteCountCompletionHandler = (_ voteCount: Int ) -> Void


    override func viewDidLoad() {
            super.viewDidLoad()
                    
            showChatController()
            disableDarkMode()
            
        groupNameLabel.text = privateGroup.groupName
            
            picker.delegate = self
            
            groupBalance.text = ""
            
            if (success == 0) {
                groupId = privateGroup.groupId
            }
            
            //Check if user is admin
            let parameters: IsAdminParameter = IsAdminParameter(groupId: privateGroup.groupId)
            isAdmin(isAdminParameter: parameters)


            
            let parameterrr: GroupLimitsParamter = GroupLimitsParamter(groupId: privateGroup.groupId)
            retrieveGroupLimits(groupLimitsParameter: parameterrr)
        
//            let param: AppConfigurationParameter = AppConfigurationParameter(countryId: privateGroup.countryId.countryId!)
//            appConfiguration(appConfigurationParameter: param)
        balaceLabel.text = "Balance (\(privateGroup.countryId.currency))"
            
            print("loan Flag: \(loanFlag)")
            aboutGroup.text = privateGroup.description
            
            
            if (privateGroup.groupIconPath == "<null>") || (privateGroup.groupIconPath == nil) || (privateGroup.groupIconPath == ""){
                groupImage.image = UIImage(named: "defaultgroupicon")
                groupImage.contentMode = .scaleAspectFit
                
            }else {
                groupImage.contentMode = .scaleAspectFill
                Nuke.loadImage(with: URL(string: privateGroup.groupIconPath!)!, into: groupImage)
                
            }

            
            
            self.memberNetwork()
            
            let user = Auth.auth().currentUser
            
            if (loanFlag == 0){
                print("hide loan stack")
                borrowStack.isHidden = true

            }else if (loanFlag == 1){
                borrowStack.isHidden = false

            }
            
        }
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        FTIndicator.showProgress(withMessage: "reloading")
        let parameeter: GroupBalanceParameter = GroupBalanceParameter(id: groupId)
        groupBalances(getGroupBalance: parameeter)
    }

    override func viewWillAppear(_ animated: Bool) {
//        if (refreshPage) {
//
////            let parameeter: GroupBalanceParameter = GroupBalanceParameter(id: groupId)
////            groupBalances(getGroupBalance: parameeter)
//
//            votesPending = []
//            fetchAllPendingVotes { (result) in
//                self.votesPending = result
//
//                print("resutl: \(self.votesPending)")
//            }
//        }
        let parameeter: GroupBalanceParameter = GroupBalanceParameter(id: groupId)
        groupBalances(getGroupBalance: parameeter)
        
        let parameterr: CreatedVoteParameter = CreatedVoteParameter(groupId: privateGroup.groupId)
        self.getCreatedVotes(createdVoteParameter: parameterr)
        
        
//        let memberCountParameter: RetrieveGroupMemberCountParameter = RetrieveGroupMemberCountParameter(groupId: groupId)
//        retrieveGroupMemberCount(retrieveGroupMemberCountParameter: memberCountParameter)
        
//        let campParameter: ActiveCampaignCountParameter = ActiveCampaignCountParameter(groupId: privateGroup.groupId)
//        activeCampaignCount(activeCampaignCountParameter: campParameter)

        fetchGroupMemberCount { (result) in
//            self.realTimeGroupMemberCount = result
            print("real mem count: \(result)")
            self.memberCountLabel.text = "\(result)"
        }

        fetchGroupCampaignCount { (result) in
//            self.realTimeGroupCampaignCount = result
            print("real camp count: \(result)")
            self.activeCampaignCountLabel.text = "\(result)"
        }

        fetchGroupBalance { (result) in
            self.realTimeGroupBalance = result
            print("real balance: \(result)")
            self.groupBalance.text = "\(result)"
        }

        votesPending = []
        fetchAllPendingVotes { (result) in
            self.votesPending = result

            if result.count == 0 {
//                    self.votesBadge.isHidden = true
                self.pendingVotesLabel.text = "no pending votes"
            }else {
//                    self.votesBadge.isHidden = false
                self.pendingVotesLabel.text = "\(result.count)"
            }

            print("resutl: \(self.votesPending)")
        }

//        fetchGroupVoteCount { (result) in
//            if result == nil || result == 0 {
//                self.pendingVotesLabel.text = "no pending votes"
//            }else {
//                self.pendingVotesLabel.text = "\(result)"
//            }
//
//        }
    }
    
    
    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        let parameeter: GroupBalanceParameter = GroupBalanceParameter(id: groupId)
        groupBalances(getGroupBalance: parameeter)
    }


    
    @objc func clickOnButton() {
        
        let vc: GroupInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "groupinf") as! GroupInfoVC
        

        vc.groupName = privateGroup.groupName
        vc.groupDescription = privateGroup.description!
        vc.created = privateGroup.created
        vc.groupId = privateGroup.groupId
        vc.groupIconPath = privateGroup.groupIconPath!
        vc.loanFlag = loanFlag
        vc.totalContributions = totalContributionss
        vc.totalCashout = totalCashouts
        vc.totalBorrowed = totalBorrowed
        vc.creatorName = privateGroup.creatorName ?? "nil"
        vc.isAdmin = adminResponse
        vc.campaignId = privateGroup.defaultCampaignId ?? ""
        vc.campaignDetails = campaignDetails
        vc.privateGroup = privateGroup
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func fetchAllMembers(completionHandler: @escaping FetchAllMembersCompletionHandler){
        var members: MembersRTDB!
        let memberRef = Database.database().reference().child("users").child("\(authProviderId)")
        _ = memberRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            print("dict: \(snapshot)")

            if  let snapshotValue = snapshot.value as? [String:AnyObject] {
            
            print("dict: \(snapshot)")
            
            members = MembersRTDB(email_: "", memberId_: "", msisdn_: "", name_: "")
            
            if let em = snapshotValue["email"] as? String {
                print(em)
                print(snapshotValue)
                members.email = em
            }
            if let memId = snapshotValue["memberId"] as? String {
                members.memberId = memId
            }
            if let msi = snapshotValue["msisdn"] as? String {
                members.msisdn = msi
            }
            if let nam = snapshotValue["name"] as? String {
                members.name = nam
            }
            
            
            //                    }
            completionHandler(members)
            print(members)
        }
        })
            
        
    }
    
    
    func fetchBallotSummary(completionHandler: @escaping FetchBallotSummaryCompletionHandler){
        var ballots: BallotSummaryRTDB!
        let ballotsRef = Database.database().reference().child("ballot_summary").child("\(groupId)")
        _ = ballotsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshotValue = snapshot.value as? [String:AnyObject] {
            
            print("ballot dict: \(snapshot)")
            ballots = BallotSummaryRTDB(groupId_: "", minVoteCount_: 0, voteId_: "", votesCompleted_: 0, votesRemaining_: 0)
            if let grpId = snapshotValue["groupId"] as? String {
                ballots.groupId = grpId
            }
            if let minVoteCnt = snapshotValue["minVoteCount"] as? Int {
                ballots.minVoteCount = minVoteCnt
            }
            if let votId = snapshotValue["voteId"] as? String {
                ballots.voteId = votId
            }
            if let votCompltd = snapshotValue["votesCompleted"] as? Int {
                ballots.votesCompleted = votCompltd
            }
            if let votRemaining = snapshotValue["voteRemaining"] as? Int {
                ballots.votesRemaining = votRemaining
            }
            completionHandler(ballots)
            print("ballots: \(ballots)")
            }
        })
    }
    
    
    
    //Retrieving pending votes from Firebase RealTime Database
    func fetchAllPendingVotes(completionHandler: @escaping FetchAllPendingVotesCompletionHandler) {
        
        var pendingVotes: [PendingVotes] = []
        let pendingVotesRef = Database.database().reference().child("votes").child("\(groupId)")
        _ = pendingVotesRef.observe(.value, with: { (snapshot) in
            if let snapshotValue = snapshot.children.allObjects as? [DataSnapshot]{
                for snapDict in snapshotValue {
                    print("snapdict")
                    let dict = snapDict.value as! Dictionary<String, AnyObject>
                    print("vote dict: \(dict)")
                    if let votesArray = dict as? NSDictionary {
                        print("votesArray: \(votesArray.count)")

                        var amt = ""
                        if let amount = votesArray.value(forKey: "amount") as? String {
                            amt = amount
                        }
                        
                        var cmgnId = ""
                        if let campaignId = votesArray.value(forKey: "campaignId") as? String {
                            cmgnId = campaignId
                        }
                        
                        var cmgnNm = ""
                        if let campaignName = votesArray.value(forKey: "campaignName") as? String {
                            cmgnNm = campaignName
                        }
                        
                        var campBal = ""
                        if let campaignBalance = votesArray.value(forKey: "campaignBalance") as? String {
                            campBal = campaignBalance
                        }
                        
                        var ntwrk = ""
                        if let network = votesArray.value(forKey: "network") as? String {
                            ntwrk = network
                        }
                        
                        var cshDst = ""
                        if let cashoutDestination = votesArray.value(forKey: "cashoutDestination") as? String {
                            cshDst = cashoutDestination
                        }
                        
                        var cshDstCd = ""
                        if let cashoutDestinationCode = votesArray.value(forKey: "cashoutDestinationCode") as? String {
                            cshDstCd = cashoutDestinationCode
                        }
                        
                        var cshDstNmbr = ""
                        if let cashoutDestinationNumber = votesArray.value(forKey: "cashoutDestinationNumber") as? String {
                            cshDstNmbr = cashoutDestinationNumber
                        }
                        
                        var rsn = ""
                        if let reason = votesArray.value(forKey: "reason") as? String {
                            rsn = reason
                        }
                        
                        var vtCnt = ""
                        if let voteCount = votesArray.value(forKey: "voteCount") as? String {
                            vtCnt = voteCount
                        }
                        
                        var rl = ""
                        if let role = votesArray.value(forKey: "role") as? String {
                            rl = role
                        }
                        
                        var mem = ""
                        if let memberId = votesArray.value(forKey: "memberId") as? String {
                            //                        print(self.memberId)
                            mem = memberId
                        }
                        
                        var nmeMem = ""
                        if let nameOfMemberActionIsAbout = votesArray.value(forKey: "nameOfMemberActionIsAbout") as? String {
                            nmeMem = nameOfMemberActionIsAbout
                        }
                        
                        var authProvId = ""
                        if let authProviderId = votesArray.value(forKey: "authProviderId") as? String {
                            authProvId = authProviderId
                        }

                        var membRTDB = MembersRTDB(email_: "", memberId_: "", msisdn_: "", name_: "")
                        
                        self.memberId = mem
                        self.authProviderId = authProvId
                        self.voteCampaignId = cmgnId
                        
//                        if self.authProviderId == "" {
//
//                        }else {
//                            self.fetchAllMembers { (result) in
//                                self.memberDeets = result
//                                print("mem: \(self.memberDeets.name)")
                                print("pv \(pendingVotes.count)")
                        let votes = PendingVotes(amount_: amt, campaignId_: cmgnId, campaignName_: cmgnNm, campaignBalance_: campBal, groupId_: votesArray.value(forKey: "groupId") as! String, memberId_: votesArray.value(forKey: "memberId") as! String, nameOfMemberActionIsAbout_: nmeMem, authProviderId_: votesArray.value(forKey: "authProviderId") as! String, network_: ntwrk, voteId_: votesArray.value(forKey: "voteId") as! String, voteType_: votesArray.value(forKey: "voteType") as! String , cashoutDestination_: cshDst, cashoutDestinationCode_: cshDstCd, cashoutDestinationNumber_: cshDstNmbr, reason_: rsn, voteCount_: vtCnt, role_: rl, membersRTDB_: membRTDB/*, membersRTDB_: self.memberDeets, ballotSummary_: self.ballotSummary*/)
                                
                                pendingVotes.append(votes)
//                                completionHandler(pendingVotes)
                                
                                //                                }
//                            }
//                        }
                    }

                }
            }
            print("info: \(pendingVotes)")
            completionHandler(pendingVotes)
        })
    }
    
    
    
    //Retrieving chats from Firebase RealTime Database
    
    func fetchAllGroupChat(completionHandler: @escaping FetchAllGroupChatCompletionHandler) {
        
        var groupChat: [Message] = []
        //        var messages: Message!
        let groupChatRef = Database.database().reference().child("chats").child("\(privateGroup.groupId)")
        _ = groupChatRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshotValue = snapshot.children.allObjects as? [DataSnapshot]{
                for snapDict in snapshotValue{
                    print("snapdict")
                    let dict = snapDict.value as! Dictionary<String, AnyObject>
                    print(dict)
                    if let messagesArray = dict as? NSDictionary {
                        print("messagesArray: \(messagesArray)")
                        
                        let messages = Message(groupId_: messagesArray.value(forKey: "groupId") as! String, key_: messagesArray.value(forKey: "key") as! String, message_: messagesArray.value(forKey: "message") as! String, timestamp_: messagesArray.value(forKey: "timestamp") as! Int, userId_: messagesArray.value(forKey: "userId") as! String)
                        
                        groupChat.append(messages)
                    }
                    
                }
            }
            completionHandler(groupChat)
            print("info: \(groupChat)")
        })
    }


    //REAL-TIME BALANCE:
    func fetchGroupBalance(completionHandler: @escaping FetchGroupBalanceCompletionHandler){
        var balance: String = ""
        print("call balance")
        let balanceRef = Database.database().reference().child("group_balance").child("\(privateGroup.groupId)")
        print("ref: \(balanceRef)")
        _ = balanceRef.observe(.value, with: { (snapshot) in
            if let snapshotValue = snapshot.children.allObjects as? [DataSnapshot]{
                print("val: \(snapshotValue)")
                for snapDict in snapshotValue {
                    print("snnp: \(snapDict.value)")
                    if let dict = snapDict.value as? String {
                        balance = dict
                    }
                }

            }
            completionHandler(balance)
            print(balance)
        })
    }

    //REAL TIME MEMBER COUNT
    func fetchGroupMemberCount(completionHandler: @escaping FetchGroupMemberCountCompletionHandler){
        var memberCount: Int = 0
        let memberCountRef = Database.database().reference().child("group_member_count").child("\(privateGroup.groupId)")
        print("ref: \(memberCountRef)")
        _ = memberCountRef.observe(.value, with: { (snapshot) in
            if let snapshotValue = snapshot.children.allObjects as? [DataSnapshot]{
                print("val: \(snapshotValue)")
                for snapDict in snapshotValue {
                    print("snnp: \(snapDict.value)")
                    if let dict = snapDict.value as? Int {
                        memberCount = dict
                    }
                }

            }
            print("mem: \(memberCount)")
            completionHandler(memberCount)
        })
    }

    //REAL TIME MEMBER COUNT
    func fetchGroupCampaignCount(completionHandler: @escaping FetchGroupCampaignCountCompletionHandler){
        var campaignCount: Int = 0
        let campaignCountRef = Database.database().reference().child("campaign_count").child("\(privateGroup.groupId)")
        _ = campaignCountRef.observe(.value, with: { (snapshot) in
            if let snapshotValue = snapshot.children.allObjects as? [DataSnapshot]{
                print("val: \(snapshotValue)")
                for snapDict in snapshotValue {
                    print("snnp: \(snapDict.value)")
                    if let dict = snapDict.value as? Int {
                        campaignCount = dict
                    }
                }

            }
            print("camp: \(campaignCount)")
            completionHandler(campaignCount)
        })
    }

    //REAL TIME VOTE COUNT
    func fetchGroupVoteCount(completionHandler: @escaping FetchGroupVoteCountCompletionHandler){
        var voteCount: Int = 0
        let voteCountRef = Database.database().reference().child("vote_count").child("\(privateGroup.groupId)")
        print("ref: \(voteCountRef)")
        _ = voteCountRef.observe(.value, with: { (snapshot) in
            if let snapshotValue = snapshot.children.allObjects as? [DataSnapshot]{
                print("val: \(snapshotValue)")
                for snapDict in snapshotValue {
                    print("snnp: \(snapDict.value)")
                    if let dict = snapDict.value as? Int {
                        voteCount = dict
                    }
                }

            }
            print("camp: \(voteCount)")
            completionHandler(voteCount)
        })
    }
    
    @objc func back(sender: UIBarButtonItem) {
        
        let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func groupInfoButtonAction(_ sender: Any) {
        clickOnButton()
    }
    

    @IBAction func contributeButtonAction(_ sender: Any) {
        check = 4
        FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)
        let parameter: GetActivePausedCampaignsParameter = GetActivePausedCampaignsParameter(groupId: privateGroup.groupId)
        getActiveCampaigns(groupCampaignsParameter: parameter)
    }
    
    @IBAction func membersButtonAction(_ sender: Any) {
        FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)
        membersAdminCheck = 1
        let parameter: IsAdminParameter = IsAdminParameter(groupId: privateGroup.groupId)
        isAdmin(isAdminParameter: parameter)
    }
    
    @IBAction func contributionsButtonAction(_ sender: Any) {
        check = 1
        FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)
        let parameter: GetActivePausedCampaignsParameter = GetActivePausedCampaignsParameter(groupId: privateGroup.groupId)
        getActiveCampaigns(groupCampaignsParameter: parameter)
    }
    
    @IBAction func campaignsButtonAction(_ sender: Any) {
        check = 0
        FTIndicator.setIndicatorStyle(.dark)
        FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)
        membersAdminCheck = 2
        let parameter: IsAdminParameter = IsAdminParameter(groupId: privateGroup.groupId)
        isAdmin(isAdminParameter: parameter)
    }
    
    @IBAction func votesButtonAction(_ sender: Any) {
        let vc: VoteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vote") as! VoteViewController
        vc.groupId = privateGroup.groupId
        vc.voteId = voteId
        vc.adminVoteId = adminVoteId
        vc.approverVoteId = approverVoteId
        vc.dropVoteId = dropVoteId
        vc.cashoutVoteId = cashoutVoteId
        vc.makeAdminVoteId = makeAdminVoteId
        vc.makeApproverVoteId = makeApproverVoteId
        print("cashout id: \(cashoutVoteId), groupId: \(privateGroup.groupId), makeAd: \(makeAdminVoteId), makeAp: \(makeApproverVoteId)")
        vc.groupName = privateGroup.groupName
        vc.groupIcon = privateGroup.groupIconPath!
        vc.defaultCampaignId = privateGroup.defaultCampaignId ?? ""
        vc.campaignBalance = campaignBalance
        vc.currency = privateGroup.countryId.currency
        
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func cashoutButtonAction(_ sender: Any) {
        FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)
        check = 0
        membersAdminCheck = 3
        let parameter: IsAdminParameter = IsAdminParameter(groupId: privateGroup.groupId)
        isAdmin(isAdminParameter: parameter)
    }
    
    
    @IBAction func chatButtonAction(_ sender: Any) {
        
//        alertDialog(title: "Chats", message: "This feature is not available currently")
        FTIndicator.showProgress(withMessage: "loading chats", userInteractionEnable: false)
        UserDefaults.standard.set(0, forKey: "chatBadge")
        
        var chatLogController: ChatLogController? = nil
        var messagesFetcher: MessagesFetcher? = nil
        let user = Auth.auth().currentUser
        
        var messages: String = ""
        var timestamp: Int = 0
        var chatParticipants: [String] = []
        
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let conversationDictionary: [String: AnyObject] = ["chatID": privateGroup.groupId as AnyObject, "chatName": privateGroup.groupName as AnyObject,
                                                           "isGroupChat": true  as AnyObject,
                                                           "chatOriginalPhotoURL": privateGroup.groupIconPath as AnyObject,
                                                           "chatThumbnailPhotoURL": "" as AnyObject,
                                                           "chatParticipantsIDs": [chatParticipants] as AnyObject,
                                                           "lastMessage": messages as AnyObject,
                                                           "timestamp": timestamp as AnyObject]
        
        let conversation = Conversation(dictionary: conversationDictionary)
        
        chatLogController = ChatLogController(collectionViewLayout: AutoSizingCollectionViewFlowLayout())
        chatLogController?.privateGroup = privateGroup
        
        messagesFetcher = MessagesFetcher()
        messagesFetcher?.delegate = chatLogController
        messagesFetcher?.privateGroup = privateGroup
        print("messagesFetcher \(messagesFetcher)")
        print(conversation)
        chatLogController?.messagesFetcher = messagesFetcher
        messagesFetcher?.loadMessagesData(for: conversation, controller: chatLogController!, mainController: self, mainTableController: nil)
    }
    
    
    @IBAction func borrowButtonAction(_ sender: Any) {
        check = 3
        
        FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)
        let parameter: GroupCampaignsParameter = GroupCampaignsParameter(groupId: self.privateGroup.groupId)
        self.getCampaigns(groupCampaignsParameter: parameter)
    }
    
    
        //ACTIVE CAMPAIGN COUNT
        func activeCampaignCount(activeCampaignCountParameter: ActiveCampaignCountParameter) {
            AuthNetworkManager.activeCampaignCount(parameter: activeCampaignCountParameter) { (result) in
                FTIndicator.dismissProgress()
                print("active campaign count result: \(result)")
                if result == "0" {
                    self.activeCampaignCountLabel.text = "no active campaigns"
                }else {
                    self.activeCampaignCountLabel.text = result
                }
            }
        }
    
    //GROUP MEMBER COUNT
    func retrieveGroupMemberCount(retrieveGroupMemberCountParameter: RetrieveGroupMemberCountParameter) {
        AuthNetworkManager.retrieveGroupMemberCount(parameter: retrieveGroupMemberCountParameter) { (result) in
            FTIndicator.dismissProgress()
            print("member count result: \(result)")
            self.memberCountLabel.text = result
            
        }
    }
    
    //IS ADMIN
    func isAdmin(isAdminParameter: IsAdminParameter) {
        AuthNetworkManager.isAdmin(parameter: isAdminParameter) { (result) in
            FTIndicator.dismissProgress()
            print("admin result: \(result)")
            self.adminResponse = result
            
            if self.adminResponse == "true" {
//                self.changeImageButton.isHidden = false
//                self.cameraBackground.isHidden = false
                self.groupInfo.isHidden = false
            }
            
            if self.membersAdminCheck == 1 {
                let vc: MembersViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "members") as! MembersViewController
                vc.groupId = self.privateGroup.groupId
                vc.adminResponse = self.adminResponse
                vc.loanFlag = self.loanFlag
                vc.voteId = self.voteId
                print("admin status: \(self.adminResponse)")
                
                self.membersAdminCheck = 0
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)

            }else if self.membersAdminCheck == 2 {
                
                let vc: CampaignsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "campaigns") as! CampaignsViewController
                vc.adminResponse = self.adminResponse
                vc.group = self.privateGroup.groupId
                
                self.membersAdminCheck = 0
                vc.currency = self.privateGroup.countryId.currency
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)

            }else if (self.membersAdminCheck == 3) && (self.adminResponse == "true") {
                
                print(self.privateGroup.defaultCampaignId)
                print(self.privateGroup.groupName)

                let params: MemberKycCompleteParameter = MemberKycCompleteParameter(memberId: self.userMemberId)
                self.memberKycStatus(memberKycParameter: params)
                
//                self.check = 2
                

                
            }
//            else if (self.membersAdminCheck == 3) && (self.adminResponse == "true") && (self.memberKycSuccessful == false) {
//                let alert = UIAlertController(title: "Chango", message: "\(self.noMemberKycRespose)", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "Go to Settings", style: .default) { (action: UIAlertAction!) in
//                    let vc2: SettingsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersettings") as! SettingsVC
//                    vc2.allGroups = allGroups
//                    vc2.movedFromWallet = false
//                    self.navigationController?.pushViewController(vc2, animated: true)
//                }
//                alert.addAction(okAction)
//                self.present(alert, animated: true, completion: nil)
//
//            }
            else if (self.membersAdminCheck == 3) && (self.adminResponse == "false"){
                
                let alert = UIAlertController(title: "Chango", message: "Only admins of this group can initiate Cashout.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    
        //ACTIVE CAMPAIGN
        func getActiveCampaigns(groupCampaignsParameter: GetActivePausedCampaignsParameter) {
            AuthNetworkManager.getActivePausedCampaigns(parameter: groupCampaignsParameter) { (result) in
                self.parseGetActivePausedCampaignsResponse(result: result)
            }
        }
        
        private func parseGetActivePausedCampaignsResponse(result: DataResponse<[GetGroupCampaignsResponse], AFError>){
            FTIndicator.dismissProgress()
            switch result.result {
            case .success(let response):
                campaignDetails.removeAll()
                cashoutCampaigns = []
                print("response: \(response)")
                if check == 1 {
                    // CONTRIBUTE VIEW

                    let vc: SelectCampaignVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scampaign") as! SelectCampaignVC

                    countryId = CountryId(countryId_: "", countryName_: "", created_: "", currency_: "", modified_: "")
                    var gip = ""
                    if (privateGroup.groupIconPath == "") || (privateGroup.groupIconPath == nil) || (privateGroup.groupIconPath == "nil") {
                        gip = ""
                    }else {
                        gip = privateGroup.groupIconPath!
                        print("gip: \(gip)")
                    }

                    memberResp = MemberGroupIdResponse(countryId_: countryId, created_: "", defaultCampaignId_: "", description_: "", groupIconPath_: gip, groupId_: "", groupName_: "", groupType_: "", modified_: "", status_: "", tnc_: "")

                    cashCampaign = GetGroupCampaignsResponse(campaignId_: privateGroup.defaultCampaignId ?? "", groupId_: memberResp, campaignName_: privateGroup.groupName, campaignType_: "", start_: "", end_: "", target_: 0.0, status_: "", campaignRef_: "", campaignFlag_: "", amountReceived_: Double(campaignBalance) ?? 0.0, created_: privateGroup.created, modified_: "", description_: privateGroup.description ?? "", alias_: "", defaultCampaignIconPath_: privateGroup.groupIconPath ?? "")
                    print("did: \(privateGroup.defaultCampaignId)")

                    cashoutCampaigns.append(cashCampaign)
                    print("cash: \(cashoutCampaigns)")
                    for item in response {
                        self.cashoutCampaigns.append(item)

                    }

                    if cashoutCampaigns.count == 1 {
                    let vc: MakeContributionsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "make") as! MakeContributionsViewController

                    for item in response {
                        self.campaignDetails.append(item)
                        vc.campaign = item
                    }
                    vc.groupName = privateGroup.groupName
                    vc.currency = privateGroup.countryId.currency
                    vc.campaignInfo = campaignDetails
                    vc.group = privateGroup.groupId
                    vc.privateGroup = privateGroup
                    vc.campaignId = privateGroup.defaultCampaignId ?? ""
                    vc.defaultContributions = defaultContributions

                    UserDefaults.standard.set(0, forKey: "contributionsBadge")
                    FTIndicator.dismissProgress()
                    vc.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(vc, animated: true)

                    } else {

                    vc.campaignNameArray = cashoutCampaigns
                    vc.groupId = privateGroup.groupId
                    vc.voteId = cashoutVoteId
                    vc.network = network
                    vc.groupCampaignBalance = campaignBalance
                    vc.groupName = privateGroup.groupName
                    vc.groupCampaignId = privateGroup.defaultCampaignId ?? ""
                    vc.countryId = privateGroup.countryId.countryId!
                    vc.currency = privateGroup.countryId.currency
                    vc.campaignBalances = campaignBalances
                    vc.contribute = 4 // campaign contributions
                    vc.activeCampaignResponse = response
                    vc.privateGroup = privateGroup
                    vc.groupIcon = gip
                    vc.maxContributionLimitPerDay = maxSingleContributeLimit

                    vc.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(vc, animated: true)

                    }

                } else if check == 0 {
                    
                    let vc: CampaignsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "campaigns") as! CampaignsViewController
                    
                    for item in response {
                        self.campaignDetails.append(item)
                        vc.campaign = item
                    }
                    vc.campaignInfo = campaignDetails
                    vc.group = privateGroup.groupId
                    vc.currency = privateGroup.countryId.currency
                    print("currency: \(self.privateGroup.countryId.currency)")
                    print(privateGroup.groupId)
                    
                    UserDefaults.standard.set(0, forKey: "campaignsBadge")
                    vc.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(vc, animated: true)

                }else if check == 3 {
                    FTIndicator.dismissProgress()
                    
                    let vc: SegmentedLoanViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "segmented") as! SegmentedLoanViewController
                    
                    countryId = CountryId(countryId_: "", countryName_: "", created_: "", currency_: "", modified_: "")
                    
                    memberResp = MemberGroupIdResponse(countryId_: countryId, created_: "", defaultCampaignId_: "", description_: "", groupIconPath_: "", groupId_: "", groupName_: "", groupType_: "", modified_: "", status_: "", tnc_: "")
                    
                    cashCampaign = GetGroupCampaignsResponse(campaignId_: privateGroup.defaultCampaignId ?? "", groupId_: memberResp, campaignName_: privateGroup.groupName, campaignType_: "", start_: "", end_: "", target_: 0.0, status_: "", campaignRef_: "", campaignFlag_: "", amountReceived_: 0.0, created_: "", modified_: "", description_: "", alias_: "", defaultCampaignIconPath_: "")
                    print("did: \(privateGroup.defaultCampaignId)")
                    
                    cashoutCampaigns.append(cashCampaign)
                    print("cash: \(cashoutCampaigns)")
                    for item in response {
                        self.cashoutCampaigns.append(item)
                    }
                    print("defa: \(cashoutCampaigns)")
                    
                    vc.groupId = privateGroup.groupId
                    vc.campaignId = privateGroup.defaultCampaignId ?? ""
                    vc.voteId = loanVoteId
                    vc.loanVoteId = loanVoteId
                    vc.cashoutCampaigns = cashoutCampaigns
                    vc.campaigns = cashoutCampaigns
                    vc.campaignBalance = campaignBalance
                    vc.campaignBalances = campaignBalances
                    vc.currency = privateGroup.countryId.currency
                    vc.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if check == 4 {
                    
                    //CONTRIBUTE
                    let vc: SelectCampaignVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scampaign") as! SelectCampaignVC
                    
                    countryId = CountryId(countryId_: "", countryName_: "", created_: "", currency_: "", modified_: "")
                    var gip = ""
                    if (privateGroup.groupIconPath == "") || (privateGroup.groupIconPath == nil) || (privateGroup.groupIconPath == "nil") {
                        gip = ""
                    }else {
                        gip = privateGroup.groupIconPath!
                        print("gip: \(gip)")
                    }
                    
                    memberResp = MemberGroupIdResponse(countryId_: countryId, created_: "", defaultCampaignId_: "", description_: "", groupIconPath_: gip, groupId_: "", groupName_: "", groupType_: "", modified_: "", status_: "", tnc_: "")
                    
                    cashCampaign = GetGroupCampaignsResponse(campaignId_: privateGroup.defaultCampaignId ?? "", groupId_: memberResp, campaignName_: privateGroup.groupName, campaignType_: "", start_: "", end_: "", target_: 0.0, status_: "", campaignRef_: "", campaignFlag_: "", amountReceived_: Double(campaignBalance) ?? 0.0, created_: privateGroup.created, modified_: "", description_: privateGroup.description ?? "", alias_: "", defaultCampaignIconPath_: privateGroup.groupIconPath ?? "")
                    print("did: \(privateGroup.defaultCampaignId)")
                    
                    cashoutCampaigns.append(cashCampaign)
                    print("cash: \(cashoutCampaigns)")
                    for item in response {
                        self.cashoutCampaigns.append(item)
                        
                    }
                    
                    if cashoutCampaigns.count == 1 {
                        
//                        let vc: ContributeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contribute") as! ContributeViewController
                        
                        let vc: WalletsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wallets") as! WalletsVC
                        
                        vc.campaignId = privateGroup.defaultCampaignId ?? ""
                        vc.groupId = privateGroup.groupId
                        vc.voteId = cashoutVoteId
                        vc.network = network
                        vc.groupNamed = privateGroup.groupName
                        vc.currency = privateGroup.countryId.currency
                        vc.maxSingleContributionLimit = maxSingleContributeLimit
                        vc.groupIconPath = privateGroup.groupIconPath ?? ""
                        vc.contribution = true
                        vc.countryId = privateGroup.countryId.countryId!
                        print("currency:\(privateGroup.countryId.currency)")
                        vc.modalPresentationStyle = .fullScreen
                        self.navigationController?.pushViewController(vc, animated: true)


                    }else {
                        
                        vc.campaignNameArray = cashoutCampaigns
                        vc.groupId = privateGroup.groupId
                        vc.voteId = cashoutVoteId
                        vc.network = network
                        vc.groupCampaignBalance = campaignBalance
                        vc.groupName = privateGroup.groupName
                        vc.groupCampaignId = privateGroup.defaultCampaignId ?? ""
                        vc.countryId = privateGroup.countryId.countryId!
                        vc.currency = privateGroup.countryId.currency
                        vc.campaignBalances = campaignBalances
                        vc.contribute = 1
                        vc.groupIcon = gip
                        vc.maxContributionLimitPerDay = maxSingleContributeLimit
                        
                        vc.modalPresentationStyle = .fullScreen
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }
                    
                }
                
                break
            case .failure(let error):
                
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
    
    
    
    //ALL CAMPAIGN
    func getCampaigns(groupCampaignsParameter: GroupCampaignsParameter) {
        AuthNetworkManager.getGroupCampaign(parameter: groupCampaignsParameter) { (result) in
            self.parseGetCampaignResponse(result: result)
        }
    }
    
    private func parseGetCampaignResponse(result: DataResponse<[GetGroupCampaignsResponse], AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            campaignDetails.removeAll()
            cashoutCampaigns = []
            print("response: \(response)")
            
            if check == 3 {
                FTIndicator.dismissProgress()
                
                let vc: SegmentedLoanViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "segmented") as! SegmentedLoanViewController
                
                countryId = CountryId(countryId_: "", countryName_: "", created_: "", currency_: "", modified_: "")
                
                memberResp = MemberGroupIdResponse(countryId_: countryId, created_: "", defaultCampaignId_: "", description_: "", groupIconPath_: "", groupId_: "", groupName_: "", groupType_: "", modified_: "", status_: "", tnc_: "")
                
                cashCampaign = GetGroupCampaignsResponse(campaignId_: privateGroup.defaultCampaignId ?? "", groupId_: memberResp, campaignName_: privateGroup.groupName, campaignType_: "", start_: "", end_: "", target_: 0.0, status_: "", campaignRef_: "", campaignFlag_: "", amountReceived_: 0.0, created_: "", modified_: "", description_: "", alias_: "", defaultCampaignIconPath_: "")
                print("did: \(privateGroup.defaultCampaignId)")
                
                cashoutCampaigns.append(cashCampaign)
                print("cash: \(cashoutCampaigns)")
                for item in response {
                    self.cashoutCampaigns.append(item)
                }
                print("defa: \(cashoutCampaigns)")
                
                vc.groupId = privateGroup.groupId
                vc.campaignId = privateGroup.defaultCampaignId ?? ""
                vc.voteId = loanVoteId
                vc.loanVoteId = loanVoteId
                vc.cashoutCampaigns = cashoutCampaigns
                vc.campaigns = cashoutCampaigns
                vc.campaignBalance = campaignBalance
                vc.campaignBalances = campaignBalances
                vc.currency = privateGroup.countryId.currency
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
            
            let vc: SelectCampaignVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scampaign") as! SelectCampaignVC
            
            countryId = CountryId(countryId_: "", countryName_: "", created_: "", currency_: "", modified_: "")
            var gip = ""
            if privateGroup.groupIconPath == "" || privateGroup.groupIconPath == nil {
                gip = ""
            }else {
                privateGroup.groupIconPath = gip
            }
            
            memberResp = MemberGroupIdResponse(countryId_: privateGroup.countryId, created_: "", defaultCampaignId_: "", description_: "", groupIconPath_: "", groupId_: "", groupName_: "", groupType_: "", modified_: "", status_: "", tnc_: "")
            
                cashCampaign = GetGroupCampaignsResponse(campaignId_: privateGroup.defaultCampaignId ?? "", groupId_: memberResp, campaignName_: privateGroup.groupName, campaignType_: "", start_: "", end_: "", target_: 0.0, status_: "", campaignRef_: "", campaignFlag_: "", amountReceived_: Double(campaignBalance) ?? 0.0, created_: privateGroup.created, modified_: "", description_: privateGroup.description ?? "", alias_: "", defaultCampaignIconPath_: privateGroup.groupIconPath ?? "")
            print("did: \(privateGroup.defaultCampaignId)")
            
            cashoutCampaigns.append(cashCampaign)
            print("cash: \(cashoutCampaigns)")
            for item in response {
                self.cashoutCampaigns.append(item)
                
                print("status: \(String(describing: item.status))")
                print("balance: \(String(describing: item.amountReceived))")
            }
            print("defa: \(cashoutCampaigns)")
            if cashoutCampaigns.count == 1 {
                
                let vc: CashoutTypeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cashouttype") as! CashoutTypeVC
                
                vc.campaignId = privateGroup.defaultCampaignId ?? ""
                vc.groupId = privateGroup.groupId
                vc.voteId = voteId
                vc.network = network
                vc.groupBalance = campaignBalance
                vc.groupSize = groupSize
                vc.minVote = minVote
                vc.campaignBalances = campaignBalances
                vc.maxCashoutLimitPerDay = maxSingleCashoutLimit
                vc.currency = privateGroup.countryId.currency
                vc.countryId = privateGroup.countryId.countryId!
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)

            }else {
                
                vc.campaignNameArray = cashoutCampaigns
                vc.groupId = privateGroup.groupId
                vc.voteId = voteId
                vc.network = network
                vc.groupCampaignBalance = campaignBalance
                vc.groupName = privateGroup.groupName
                vc.groupCampaignId = privateGroup.defaultCampaignId ?? ""
                vc.groupSize = groupSize
                vc.minVote = minVote
                vc.groupIcon = gip
                vc.campaignBalances = campaignBalances
                vc.maxCashoutLimitPerDay = maxSingleCashoutLimit
                vc.currency = privateGroup.countryId.currency
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            break
        case .failure(let error):
            
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
    
    
        //GROUP TOTALS
        func getGroupTotals(groupTotalsParameter: GroupTotalsParameter) {
            AuthNetworkManager.groupTotals(parameter: groupTotalsParameter) { (result) in
                self.parseGetGroupTotalsResponse(result: result)
            }
        }
        
        
        private func parseGetGroupTotalsResponse(result: DataResponse<GroupTotalsResponse, AFError>){
            FTIndicator.dismissProgress()
            switch result.result {
            case .success(let response):
                print("response: \(response)")
                
                totalContributionss = response.totalContributions
                totalCashouts = response.totalCashouts
                totalBorrowed = response.totalGroupLoans
                print("cashout: \(response.totalCashouts)")
    //            cashoutAmountLabel.text = response.totalCashouts
                print("contributions: \(response.totalContributions)")
//                contributionAmountLabel.text = "\(privateGroup.countryId.currency)\(response.totalContributions)"
                
                break
            case .failure(let error):
                
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
    
        //GROUP LIMITS
        func retrieveGroupLimits(groupLimitsParameter: GroupLimitsParamter) {
            AuthNetworkManager.retrieveGroupLimits(parameter: groupLimitsParameter) { (result) in
                self.parseGroupLimitsResponse(result: result)
            }
        }
        
        
        private func parseGroupLimitsResponse(result: DataResponse<GroupLimitsResponse, AFError>){
            FTIndicator.dismissProgress()
            switch result.result {
            case .success(let response):
                
    //            maxCashoutLimit = response.mobileLimitPerCashout ?? 0.0
    //            maxContributionLimit = response.maxContributionPerDay ?? 0.0
                maxSingleContributeLimit = response.maxSingleContribution ?? 0.0
                maxSingleCashoutLimit = response.maxSingleCashout ?? 0.0
                
                
                break
            case .failure(let error):
                
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

        
        //APP CONFIGURATION
        func appConfiguration(appConfigurationParameter: AppConfigurationParameter) {
            AuthNetworkManager.appConfiguration(parameter: appConfigurationParameter) { (result) in
                self.parseAppConfigurationResponse(result: result)
            }
        }
        
        
        private func parseAppConfigurationResponse(result: DataResponse<AppConfiguratonResponse, AFError>){
            FTIndicator.dismissProgress()
            switch result.result {
            case .success(let response):
                
                maxCashoutLimit = response.maxMobileCashout!
                maxContributionLimit = response.maxPrivateContribution!
                currency = response.currency!
                
                break
            case .failure(let error):
                
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
    
    
    //    GET CREATED VOTES
    func getCreatedVotes(createdVoteParameter: CreatedVoteParameter) {
        AuthNetworkManager.createdVotes(parameter: createdVoteParameter) { (result) in
            self.parseCreatedVotesResponse(result: result)
        }
    }


    private func parseCreatedVotesResponse(result: DataResponse<CreatedVotesResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")

            for item in response.votes {
                print("ballot id: \(item.ballotId)")
                ballotId = "\(item.ballotId.ballotId)"
                if (ballotId == "cashout") {
                    voteId = item.voteId
                    cashoutVoteId = item.voteId
                    minVote = item.minVotes
                }else if (ballotId == "loan"){
                    loanVoteId = item.voteId
                    print("loan Id: \(loanVoteId)")

                }else if (ballotId == "dropmember"){
                    dropVoteId = item.voteId
                    print("drop Id: \(dropVoteId)")
                }else if (ballotId == "revokeapprover"){
                    approverVoteId = item.voteId
                }else if (ballotId == "revokeadmin"){
                    adminVoteId = item.voteId
                }else if (ballotId == "makeadmin"){
                    makeAdminVoteId == item.voteId
                }else if (ballotId == "makeapprover"){
                    makeApproverVoteId == item.voteId
                }
                print("vote Id: \(voteId)")
                print("group size: \(response.groupSize)")
                groupSize = response.groupSize

            }

            break
        case .failure(let error):

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
    

    func defaultCampaign(defaultCampaignParameter: defaultCampaignParameter){
        AuthNetworkManager.defaultCampaign(parameter: defaultCampaignParameter) { (result) in
            self.parseDefaultCampaignResponse(result: result)
        }
    }
    
    private func parseDefaultCampaignResponse(result: DataResponse<DefaultCampaignResponse, AFError>){
        switch result.result {
        case .success(let response):
            print(response)
            
            defaultContributions = response
            print("def: \(defaultContributions)")
            
            
            
            for i in 0 ..< defaultContributions.contributions.count {
                let contributors = contributions.map { return $0.firstName }
                let contributorsLast = contributions.map { return $0.lastName }
                
                if (contributors.contains(defaultContributions.contributions[i].memberId.firstName) && contributorsLast.contains(defaultContributions.contributions[i].memberId.lastName)) {
                    let filteredArray = contributions.filter { $0.firstName == defaultContributions.contributions[i].memberId.firstName && $0.lastName == defaultContributions.contributions[i].memberId.lastName}
                    
                    let item = filteredArray.first!
                    item.contributions.append(defaultContributions.contributions[i])
                    
                    print("item: \(item)")
                    
                }else {
                    var section = ContributionSection()
                    
                    section.firstName = defaultContributions.contributions[i].memberId.firstName
                    section.lastName = defaultContributions.contributions[i].memberId.lastName
                    section.contributions.append(defaultContributions.contributions[i])
                    section.totalAmount = defaultContributions.contributions[i].amount
                    contributions.append(section)
                }
            }
            
            
            break
        case .failure(let error):
            
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
    
    
    func memberNetwork() {
        AuthNetworkManager.memberNetwork { (result) in
            self.parsememberNetworkResponse(result: result)
        }
    }
    
    
    private func parsememberNetworkResponse(result: DataResponse<MemberNetworkResponse, AFError>){
        switch result.result {
        case .success(let response):
            print(response)
            userNumber = response.msisdn
            network = response.network
            print("member network to push: \(response.network)")
            break
        case .failure(let error):
            if result.response?.statusCode == 400 {
                
                sessionTimeout()
            }
            print(NetworkManager().getErrorMessage(response: result))
        }
    }
    
    
    //GROUP BALANCE
    func groupBalances(getGroupBalance: GroupBalanceParameter) {
        AuthNetworkManager.groupBalance(parameter: getGroupBalance) { (result) in
            self.parseGroupBalanceResponse(result: result)
        }
    }
    
    
    private func parseGroupBalanceResponse(result: DataResponse<[GroupBalance], AFError>){
        switch result.result {
        case .success(let response):
//            refreshControl?.endRefreshing()
            FTIndicator.dismissProgress()
            print(response)
            var balances: [Double] = []
            campaignBalances = response

            for item in response {
                
                print(item.balance)
                
                balances.append(item.balance)
                
                if item.campaignId == privateGroup.defaultCampaignId {
                    print("default contribution: \(item.balance)")
                    contributionAmountLabel.text = "\(item.balance)"
                    contributionAmountLabel.isHidden = true

                }
            }
            let sum = balances.reduce(0, +)
            print("sum: \(sum)")
            
            let largeNumber = sum
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.minimumFractionDigits = 2
            let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber))
            
//            self.groupBalance.text = "\(formattedNumber!)"

            
            break
        case .failure(let error):
//            refreshControl?.endRefreshing()
            if result.response?.statusCode == 400 {
                
                sessionTimeout()
            }
            print(NetworkManager().getErrorMessage(response: result))
        }
    }
    
    
    
    func getCampaignBalance(getCampaignBalanceParameter: GetCampaignBalanceParameter) {
        AuthNetworkManager.getCampaignBalance(parameter: getCampaignBalanceParameter) { (result) in
            print(result)
            print("Result balance: \(result)")
            
            self.campaignBalance = result
            
        }
        
    } 
    
    private func parseGetCampaignBalance(result: DataResponse<String, AFError>){
        switch result.result {
        case .success(let response):
            print(response)
            let alert = UIAlertController(title: "Chango", message: "\(result)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in

                self.navigationController?.popViewController(animated: true)
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            break
        case .failure(let error):
            
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

    // MEMBER KYC COMPLETE
    func memberKycStatus(memberKycParameter: MemberKycCompleteParameter) {
        AuthNetworkManager.memberKycStatus(parameter: memberKycParameter) { (result) in
            self.parseMemberKycStatusResponse(result: result)
        }
    }


    private func parseMemberKycStatusResponse(result: DataResponse<MemberKycStatusResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            memberKycSuccessful = response.successful
//            if let responseMessage = response.responseMessage {
//                noMemberKycRespose = responseMessage
//            }
            if response.successful == true {
//                check = 0
            let parameter: GroupCampaignsParameter = GroupCampaignsParameter(groupId: self.privateGroup.groupId)
            self.getCampaigns(groupCampaignsParameter: parameter)
            } else {
                let alert = UIAlertController(title: "Chango", message: "\(response.responseMessage!)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Go to Settings", style: .default) { (action: UIAlertAction!) in
                    let vc2: SettingsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersettings") as! SettingsVC
                    vc2.allGroups = allGroups
                    vc2.movedFromWallet = false
                    self.navigationController?.pushViewController(vc2, animated: true)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            break
        case .failure(let error):
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
}
