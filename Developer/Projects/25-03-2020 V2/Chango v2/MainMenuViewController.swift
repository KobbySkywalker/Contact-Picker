//
//  MainMenuViewController.swift
//  
//
//  Created by Hosny Ben Savage on 05/12/2018.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Firebase
import FTIndicator
import Alamofire
import Nuke

class MainMenuViewController: BaseViewController, UIImagePickerControllerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate {
    
    
    
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
    
    var groupChatDetails: [Message] = []
        
    let picker = UIImagePickerController()
    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupDescription: UILabel!
    @IBOutlet weak var totalContributionsView: UIView!
    @IBOutlet weak var totalCashOutView: UIView!
    @IBOutlet weak var totalLoans: UIView!
    @IBOutlet weak var totalContributions: UILabel!
    @IBOutlet weak var totalCashout: UILabel!
    @IBOutlet weak var totalLoansAmount: UILabel!
    @IBOutlet weak var voteIcon: UIButton!
    @IBOutlet weak var loanStack: UIStackView!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var votesBadge: UIView!
    @IBOutlet weak var viewCampaignsButton: UIButton!
    @IBOutlet weak var memberBadge: UIView!
    @IBOutlet weak var chatBadge: UIView!
    @IBOutlet weak var campaignsBadge: UIView!
    @IBOutlet weak var contributionsBadge: UIView!
    @IBOutlet weak var TotalContributionStack: UIStackView!
    @IBOutlet weak var noLoansStack: UIStackView!
    @IBOutlet weak var cashoutAmountLabel: UILabel!
    @IBOutlet weak var contributionAmountLabel: UILabel!
    @IBOutlet weak var contributionsViewNoLoans: UIView!
    @IBOutlet weak var cashoutViewNoLoans: UIView!
    @IBOutlet weak var contributeButton: UIButton!
    @IBOutlet weak var groupBalance: UILabel!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
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
    //    var cashoutMinVote: Double = 0.0
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

    var success: Int = 0
    
    
//    var textMessages: [DemoTextMessageModel] = []
    
    
    typealias FetchAllGroupChatCompletionHandler = (_ chats: [Message]) -> Void
    typealias FetchAllPendingVotesCompletionHandler = (_ votes: [PendingVotes]) -> Void
    typealias FetchAllMembersCompletionHandler = (_ groups: MembersRTDB ) -> Void
    typealias FetchBallotSummaryCompletionHandler = (_ groups: BallotSummaryRTDB ) -> Void
    
    
    let chatB = UserDefaults.standard.integer(forKey: "chatBadge")
    let memberB = UserDefaults.standard.integer(forKey: "memberBadge")
    let contributionsB = UserDefaults.standard.integer(forKey: "contributionsBadge")
    let campaignsB = UserDefaults.standard.integer(forKey: "campaignsBadge")
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = privateGroup.groupName
        self.navigationItem.titleView?.tintColor = UIColor.white
        print(privateGroup.groupName)
        
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        button.backgroundColor = .clear
        button.setTitle("\(privateGroup.groupName)", for: .normal)
        button.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
        navigationItem.titleView = button
        
        if (chatB == 1) {
            
            chatBadge.isHidden = false
        }else {
            chatBadge.isHidden = true
        }
        
        if (memberB == 1) {
            
            memberBadge.isHidden = false
        }else {
            memberBadge.isHidden = true
        }
        
        if (contributionsB == 1) {
            
            contributionsBadge.isHidden = false
        }else {
            contributionsBadge.isHidden = true
        }
        
        if (campaignsB == 1) {
            
            campaignsBadge.isHidden = false
        }else {
            campaignsBadge.isHidden = true
        }
        
        if (refreshPage) {
            
//            let parameter: GroupTotalsParameter = GroupTotalsParameter(groupId: privateGroup.groupId)
//            self.getGroupTotals(groupTotalsParameter: parameter)
            let parameeter: GroupBalanceParameter = GroupBalanceParameter(id: groupId)
            groupBalances(getGroupBalance: parameeter)
            
            votesPending = []
            fetchAllPendingVotes { (result) in
                self.votesPending = result
                
                if self.votesPending.isEmpty {
                    self.votesBadge.isHidden = true
                }else {
                    self.votesBadge.isHidden = false
                }
                
                print("resutl: \(self.votesPending)")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        showChatController()
        disableDarkMode()
        
        picker.delegate = self
        
        groupBalance.text = ""
        
        if (success == 0) {
            groupId = privateGroup.groupId
        }
        
        //Check if user is admin
        let parameters: IsAdminParameter = IsAdminParameter(groupId: privateGroup.groupId)
        isAdmin(isAdminParameter: parameters)
        
        votesPending = []
        fetchAllPendingVotes { (result) in
            self.votesPending = result
            
            if self.votesPending.isEmpty {
                self.votesBadge.isHidden = true
            }else {
                self.votesBadge.isHidden = false
            }
            
            print("resutl: \(self.votesPending)")
        }
        
        print("loan Flag: \(loanFlag)")
        
        
        if (privateGroup.groupIconPath == "<null>") || (privateGroup.groupIconPath == nil) || (privateGroup.groupIconPath == ""){
            groupImage.image = UIImage(named: "people")
            groupImage.contentMode = .scaleAspectFit
            
        }else {
            groupImage.contentMode = .scaleAspectFill
            Nuke.loadImage(with: URL(string: privateGroup.groupIconPath!)!, into: groupImage)
            
        }
        
//        let paramter: GetCampaignBalanceParameter = GetCampaignBalanceParameter(campaignId: groupId)
//        getCampaignBalance(getCampaignBalanceParameter: paramter)
        
        let parameeter: GroupBalanceParameter = GroupBalanceParameter(id: groupId)
        groupBalances(getGroupBalance: parameeter)
        
        
        self.memberNetwork()
        
        let user = Auth.auth().currentUser
        
        
        let parameter: GroupTotalsParameter = GroupTotalsParameter(groupId: privateGroup.groupId)
        self.getGroupTotals(groupTotalsParameter: parameter)
        
        let parameterr: CreatedVoteParameter = CreatedVoteParameter(groupId: privateGroup.groupId)
        self.getCreatedVotes(createdVoteParameter: parameterr)

        
        contributeButton.cornerRadius = 10
        
        // Do any additional setup after loading the view.
        
        if (loanFlag == 0){
            print("hide loan stack")
            loanStack.isHidden = true

        }else if (loanFlag == 1){
            loanStack.isHidden = false

        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ⓘ", style: .plain, target: self, action: #selector(clickOnButton))
        

    }


    
    @objc func clickOnButton() {
        
//        let vc: GroupInfoTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "groupinfo") as! GroupInfoTableViewController
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func fetchAllMembers(completionHandler: @escaping FetchAllMembersCompletionHandler){
        var members: MembersRTDB!
        let memberRef = Database.database().reference().child("users").child("\(authProviderId)")
        _ = memberRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! [String:AnyObject]
            
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
        })
        
    }
    
    
    func fetchBallotSummary(completionHandler: @escaping FetchBallotSummaryCompletionHandler){
        var ballots: BallotSummaryRTDB!
        let ballotsRef = Database.database().reference().child("ballot_summary").child("\(groupId)")
        _ = ballotsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! [String:AnyObject]
            
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
        })
    }
    
    
    
    //Retrieving pending votes from Firebase RealTime Database
    func fetchAllPendingVotes(completionHandler: @escaping FetchAllPendingVotesCompletionHandler) {
        
        var pendingVotes: [PendingVotes] = []
        
        let pendingVotesRef = Database.database().reference().child("votes").child("\(groupId)")
        _ = pendingVotesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshotValue = snapshot.children.allObjects as? [DataSnapshot]{
                for snapDict in snapshotValue {
                    print("snapdict")
                    let dict = snapDict.value as! Dictionary<String, AnyObject>
                    print(dict)
                    if let votesArray = dict as? NSDictionary {
                        print("votesArray: \(votesArray)")
                        
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
                        self.memberId = mem
                        self.authProviderId = authProvId
                        self.voteCampaignId = cmgnId
                        
                        if self.authProviderId == "" {
                            
                        }else {
                            self.fetchAllMembers { (result) in
                                self.memberDeets = result
                                print("mem: \(self.memberDeets.name)")
                                
                                let votes = PendingVotes(amount_: amt, campaignId_: cmgnId, campaignName_: cmgnNm, campaignBalance_: campBal, groupId_: votesArray.value(forKey: "groupId") as! String, memberId_: votesArray.value(forKey: "memberId") as! String, nameOfMemberActionIsAbout_: votesArray.value(forKey: "nameOfMemberActionIsAbout") as! String, authProviderId_: votesArray.value(forKey: "authProviderId") as! String, network_: ntwrk, voteId_: votesArray.value(forKey: "voteId") as! String, voteType_: votesArray.value(forKey: "voteType") as! String , cashoutDestination_: cshDst, cashoutDestinationCode_: cshDstCd, cashoutDestinationNumber_: cshDstNmbr, reason_: rsn, voteCount_: vtCnt, role_: rl, membersRTDB_: self.memberDeets/*, ballotSummary_: self.ballotSummary*/)
                                
                                pendingVotes.append(votes)
                                completionHandler(pendingVotes)
                                
                                //                                }
                            }
                        }
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
    
    
    @objc func back(sender: UIBarButtonItem) {
        
        let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func memberButtonAction(_ sender: UIButton) {
        
        FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)
        membersAdminCheck = 1
        let parameter: IsAdminParameter = IsAdminParameter(groupId: privateGroup.groupId)
        isAdmin(isAdminParameter: parameter)
        
        UserDefaults.standard.set(0, forKey: "memberBadge")
        
        
    }
    
    //MAKE CONTRIBUTION
    @IBAction func ContributionsButtonAction(_ sender: UIButton) {
        check = 1
        FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)
        let parameter: GroupCampaignsParameter = GroupCampaignsParameter(groupId: privateGroup.groupId)
        getGroupCampaign(groupCampaignsParameter: parameter)
        
        
    }
    
    @IBAction func VotesButtonAction(_ sender: UIButton) {
        
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
        vc.pendingVotes = votesPending
        vc.defaultCampaignId = privateGroup.defaultCampaignId ?? ""
        vc.campaignBalance = campaignBalance
        vc.currency = privateGroup.countryId.currency
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    //VIEW CAMPAIGNS
    @IBAction func campaignsButtonAction(_ sender: UIButton) {
        check = 0
        FTIndicator.setIndicatorStyle(.dark)
        
        
        FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)
        membersAdminCheck = 2
        let parameter: IsAdminParameter = IsAdminParameter(groupId: privateGroup.groupId)
        isAdmin(isAdminParameter: parameter)
        
    }
    
    @IBAction func statementButtonAction(_ sender: UIButton) {
        let vc: SendStatementViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "send") as! SendStatementViewController
        
        vc.groupId = privateGroup.groupId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cashoutButtonAction(_ sender: UIButton) {
        FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)
        
        
        membersAdminCheck = 3
        let parameter: IsAdminParameter = IsAdminParameter(groupId: privateGroup.groupId)
        isAdmin(isAdminParameter: parameter)
        
    }
    
    
    @IBAction func exitGroup(_ sender: UIButton) {
        
//        let vc: GroupInfoTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "groupinfo") as! GroupInfoTableViewController
        let vc: GroupInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "groupinf") as! GroupInfoVC
        
        vc.groupName = privateGroup.groupName
        vc.groupDescription = privateGroup.description!
        vc.created = privateGroup.created
        vc.groupId = privateGroup.groupId
        vc.groupIconPath = privateGroup.groupIconPath!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func groupChats(_ sender: UIButton) {
        
        
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
    
    
    @IBAction func loanButtonAction(_ sender: UIButton) {
        
        check = 3
        
        FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)
        let parameter: GroupCampaignsParameter = GroupCampaignsParameter(groupId: privateGroup.groupId)
        getGroupCampaign(groupCampaignsParameter: parameter)
    }
    
    
    @IBAction func contribute(_ sender: UIButton) {
        
        check = 4
        FTIndicator.showProgress(withMessage: "loading", userInteractionEnable: false)
        let parameter: GroupCampaignsParameter = GroupCampaignsParameter(groupId: privateGroup.groupId)
        getGroupCampaign(groupCampaignsParameter: parameter)
    }
    
    
    
    
    //IS ADMIN
    func isAdmin(isAdminParameter: IsAdminParameter) {
        AuthNetworkManager.isAdmin(parameter: isAdminParameter) { (result) in
            FTIndicator.dismissProgress()
            print("admin result: \(result)")
            self.adminResponse = result
            
            if self.adminResponse == "false" {
                self.changeImageButton.isHidden = true
            }else if self.adminResponse == "true" {
                self.changeImageButton.isHidden = false
            }
            
            //                let vc: MembersViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "members") as! MembersViewController
            //                vc.groupId = self.privateGroup.groupId
            //                vc.adminResponse = self.adminResponse
            //                self.navigationController?.pushViewController(vc, animated: true)
            
            if self.membersAdminCheck == 1 {
                let vc: MembersViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "members") as! MembersViewController
                vc.groupId = self.privateGroup.groupId
                vc.adminResponse = self.adminResponse
                vc.loanFlag = self.loanFlag
                print("admin status: \(self.adminResponse)")
                
                self.membersAdminCheck = 0
                self.navigationController?.pushViewController(vc, animated: true)
            }else if self.membersAdminCheck == 2 {
                
                let vc: CampaignsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "campaigns") as! CampaignsViewController
                vc.adminResponse = self.adminResponse
                vc.group = self.privateGroup.groupId
                
                self.membersAdminCheck = 0
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if (self.membersAdminCheck == 3) && (self.adminResponse == "true") {
                
                print(self.privateGroup.defaultCampaignId)
                print(self.privateGroup.groupName)
                //        cashCampaign.campaignName = "\(privateGroup.groupName)"
                //        cashCampaign.campaignId = "\(privateGroup.defaultCampaignId)"
                
                self.check = 2
                
                let parameter: GroupCampaignsParameter = GroupCampaignsParameter(groupId: self.privateGroup.groupId)
                self.getGroupCampaign(groupCampaignsParameter: parameter)
                
            }else if (self.membersAdminCheck == 3) && (self.adminResponse == "false"){
                
                let alert = UIAlertController(title: "Chango", message: "Only admins of this group can initiate Cashout.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    private func parseIsAdmin(result: DataResponse<String, AFError>){
        
        switch result.result {
        case .success(let response):
            print("admin response: \(response)")
            
            adminResponse = response
            
            
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
    
    @IBAction func changeGroupPhoto(_ sender: UIButton) {
        let actionSheet: UIActionSheet = UIActionSheet(title: "", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take Picture", "Choose Existing Photo")
        actionSheet.delegate = self
        actionSheet.tag = 2
        actionSheet.show(in: self.view)
        
    }
    
    
    
    
    func updatePrivateGroupProfilePicture(updatePrivateGroupPictureParameter: UpdatePrivateGroupPictureParameter){
        AuthNetworkManager.updatePrivateGroupProfilePicture(parameter: updatePrivateGroupPictureParameter) { (result) in
            self.parseUpdatePrivateGroupProfilePicture(result: result)
        }
    }
    
    private func parseUpdatePrivateGroupProfilePicture(result: DataResponse<UpdatePrivateGroupImageResponse, AFError>){
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            FTIndicator.dismissProgress()
            break
        case .failure(let error):
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
    
    
    
    
    func encodeImage(_ dataImage:UIImage) -> String{
        let imageData = dataImage.pngData()
        return imageData!.base64EncodedString(options: [])
    }
    
    func details(_ sender:AnyObject) {
        
        let actionSheet: UIActionSheet = UIActionSheet(title: "", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take Picture", "Choose Existing Photo")
        actionSheet.delegate = self
        actionSheet.tag = 2
        actionSheet.show(in: self.view)
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        if(buttonIndex == 1){//Report Post
            self.shootPhoto()
        } else if(buttonIndex == 2){
            self.photoFromLibrary()
        }else {
            actionSheet.dismiss(withClickedButtonIndex: 3, animated: true)
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
    
    
    //UAT
//    //GET CREATED VOTES
//    func getCreatedVotes(createdVoteParameter: CreatedVoteParameter) {
//        AuthNetworkManager.createdVotes(parameter: createdVoteParameter) { (result) in
//            self.parseCreatedVotesResponse(result: result)
//        }
//    }
//
//
//    private func parseCreatedVotesResponse(result: DataResponse<[CreatedVotes]>){
//        FTIndicator.dismissProgress()
//        switch result.result {
//        case .success(let response):
//            print("response: \(response)")
//
//            for item in response {
//                print("ballot id: \(item.ballotId)")
//                ballotId = "\(item.ballotId.ballotId)"
//                if (ballotId == "cashout") {
//                    voteId = item.voteId
//                    cashoutVoteId = item.voteId
//                }else if (ballotId == "loan"){
//                    loanVoteId = item.voteId
//                    print("loan Id: \(loanVoteId)")
//
//                }else if (ballotId == "dropmember"){
//                    dropVoteId = item.voteId
//                    print("drop Id: \(dropVoteId)")
//                }else if (ballotId == "revokeapprover"){
//                    approverVoteId = item.voteId
//                }else if (ballotId == "revokeadmin"){
//                    adminVoteId = item.voteId
//                }else if (ballotId == "makeadmin"){
//                    makeAdminVoteId == item.voteId
//                }else if (ballotId == "makeapprover"){
//                    makeApproverVoteId == item.voteId
//                }
//                print("vote Id: \(voteId)")
//
//                //                if loanVoteId == "" {
//                //                    loanStack.isHidden = true
//                //                }else {
//                //                    loanStack.isHidden = false
//                //                }
//            }
//
//            break
//        case .failure(let error):
//
//            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
//
//            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//            }
//
//            alert.addAction(okAction)
//
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
    
    
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
//            cashoutAmountLabel.text = response.totalCashouts
//            contributionAmountLabel.text = response.totalContributions
            
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
    
    
    //GROUP CAMPAIGN
    func getGroupCampaign(groupCampaignsParameter: GroupCampaignsParameter) {
        AuthNetworkManager.getGroupCampaign(parameter: groupCampaignsParameter) { (result) in
            self.parseGetGroupCampaignResponse(result: result)
        }
    }
    
    private func parseGetGroupCampaignResponse(result: DataResponse<[GetGroupCampaignsResponse], AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            campaignDetails.removeAll()
            cashoutCampaigns = []
            print("response: \(response)")
            if check == 1 {
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
                vc.defaultContributions = defaultContributions
                
                UserDefaults.standard.set(0, forKey: "contributionsBadge")
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if check == 2 {
                
                let vc: SelectCampaignVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scampaign") as! SelectCampaignVC
                
                countryId = CountryId(countryId_: "", countryName_: "", created_: "", currency_: "", modified_: "")
                var gip = ""
                if privateGroup.groupIconPath == "" || privateGroup.groupIconPath == nil {
                    gip = ""
                }else {
                    privateGroup.groupIconPath = gip
                }
                
                memberResp = MemberGroupIdResponse(countryId_: countryId, created_: "", defaultCampaignId_: "", description_: "", groupIconPath_: "", groupId_: "", groupName_: "", groupType_: "", modified_: "", status_: "", tnc_: "")
                
                cashCampaign = GetGroupCampaignsResponse(campaignId_: privateGroup.defaultCampaignId ?? "", groupId_: memberResp, campaignName_: privateGroup.groupName, campaignType_: "", start_: "", end_: "", target_: 0.0, status_: "", campaignRef_: "", campaignFlag_: "", amountReceived_: Double(campaignBalance) as? Double ?? 0.0, created_: "", modified_: "", description_: "", alias_: "", defaultCampaignIconPath_: "")
                print("did: \(privateGroup.defaultCampaignId)")
                
                cashoutCampaigns.append(cashCampaign)
                print("cash: \(cashoutCampaigns)")
                for item in response {
                    self.cashoutCampaigns.append(item)
                    
                    print("status: \(item.status)")
                    print("balance: \(item.amountReceived)")
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

                    
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }else if check == 0 {
                
                let vc: CampaignsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "campaigns") as! CampaignsViewController
                
                for item in response {
                    self.campaignDetails.append(item)
                    vc.campaign = item
                }
                vc.campaignInfo = campaignDetails
                vc.group = privateGroup.groupId
//                vc.mainViewController = mainViewController
                print(privateGroup.groupId)
                
                UserDefaults.standard.set(0, forKey: "campaignsBadge")
                
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
                
                self.navigationController?.pushViewController(vc, animated: true)
            }else if check == 4 {
                
                //CONTRIBUTE
                let vc: SelectCampaignVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scampaign") as! SelectCampaignVC
                
                countryId = CountryId(countryId_: "", countryName_: "", created_: "", currency_: "", modified_: "")
                var gip = ""
                if privateGroup.groupIconPath == "" || privateGroup.groupIconPath == nil {
                    gip = ""
                }else {
                    gip = privateGroup.groupIconPath!
                    print("gip: \(gip)")
                }
                
                memberResp = MemberGroupIdResponse(countryId_: countryId, created_: "", defaultCampaignId_: "", description_: "", groupIconPath_: gip, groupId_: "", groupName_: "", groupType_: "", modified_: "", status_: "", tnc_: "")
                
                cashCampaign = GetGroupCampaignsResponse(campaignId_: privateGroup.defaultCampaignId ?? "", groupId_: memberResp, campaignName_: privateGroup.groupName, campaignType_: "", start_: "", end_: "", target_: 0.0, status_: "", campaignRef_: "", campaignFlag_: "", amountReceived_: Double(campaignBalance) as? Double ?? 0.0, created_: "", modified_: "", description_: "", alias_: "", defaultCampaignIconPath_: "")
                print("did: \(privateGroup.defaultCampaignId)")
                
                cashoutCampaigns.append(cashCampaign)
                print("cash: \(cashoutCampaigns)")
                for item in response {
                    self.cashoutCampaigns.append(item)
                    
                }
                
                if cashoutCampaigns.count == 1 {
                    
                    let vc: ContributeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contribute") as! ContributeViewController
                    
                    vc.campaignId = privateGroup.defaultCampaignId ?? ""
                    vc.groupId = privateGroup.groupId
                    vc.voteId = cashoutVoteId
                    vc.network = network
                    vc.groupNamed = privateGroup.groupName
                    vc.currency = privateGroup.countryId.currency
                    vc.privateGroup = privateGroup
                    if (privateGroup.groupIconPath == "") || (
                        privateGroup.groupIconPath == nil){
                        vc.groupIconPath = ""
                    }else {
                    vc.groupIconPath = privateGroup.groupIconPath!
                        print("gip: \(privateGroup.groupIconPath!)")
                    }
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else {
                    
                    vc.campaignNameArray = cashoutCampaigns
                    vc.groupId = privateGroup.groupId
                    vc.privateGroup = privateGroup
                    vc.voteId = cashoutVoteId
                    vc.network = network
                    vc.groupCampaignBalance = campaignBalance
                    vc.groupName = privateGroup.groupName
                    vc.groupCampaignId = privateGroup.defaultCampaignId ?? ""
                    vc.currency = privateGroup.countryId.currency
                    vc.campaignBalances = campaignBalances
                    vc.contribute = 1
                    vc.groupIcon = gip
                    
                    
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
            print(response)
            var balances: [Double] = []
            campaignBalances = response

            for item in response {
                
                print(item.balance)
                
                balances.append(item.balance)
            }
            let sum = balances.reduce(0, +)
            print("sum: \(sum)")
            
            let largeNumber = sum
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.minimumFractionDigits = 2
            let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber))
            
            self.groupBalance.text = "\(self.privateGroup.countryId.currency) \(formattedNumber!)"

            break
        case .failure(let error):
            if result.response?.statusCode == 400 {
                
                sessionTimeout()
            }
            print(NetworkManager().getErrorMessage(response: result))
        }
    }
    
    
    
    func getCampaignBalance(getCampaignBalanceParameter: GetCampaignBalanceParameter) {
        AuthNetworkManager.getCampaignBalance(parameter: getCampaignBalanceParameter) { (result) in
            //            self.parseGetCampaignBalance(result: result)
            print(result)
            print("Result balance: \(result)")
            
            self.campaignBalance = result
            
//            self.groupBalance.text = "\(self.privateGroup.countryId.currency) \(result)"
            
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
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        groupImage.image = image
        picker.dismiss(animated: true, completion: nil)
        
        //Loading indicator here
        imageUrl = "\(image)"
        uploadImagePic(img1: image)
        //Api call here
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Shit got picked")
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        groupImage.image = chosenImage
        picker.dismiss(animated: true, completion: nil)
        
        //Loading indicator here
        
        uploadImagePic(img1: chosenImage)
    }
    
    fileprivate func makingRoundedImageProfileWithRoundedBorder() {
        
        self.groupImage.layer.cornerRadius = 53.5
        self.groupImage.clipsToBounds = true
        self.groupImage.layer.borderWidth = 0.8
        self.groupImage.layer.borderColor = UIColor.white.cgColor
    }
    
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message:"Sorry, this device has no camera", preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK",comment:"OK"), style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    //get a photo from the library. We present as! a popover on iPad, and fullscreen on smaller devices.
    func photoFromLibrary() {
        picker.allowsEditing = true //2
        picker.sourceType = .photoLibrary //3
        //picker.modalPresentationStyle = .Popover
        present(picker, animated: true, completion: nil)//4
        //picker.popoverPresentationController?.barButtonItem = sender
    }
    
    
    //take a picture, check if we have a camera first.
    func shootPhoto() {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            present(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    
    func uploadImagePic(img1 :UIImage){
        FTIndicator.showProgress(withMessage: "saving")
        
        var data = NSData()
        data = img1.jpegData(compressionQuality: 0.8)! as NSData
        // set upload path
        let filePath = "group_images/\(privateGroup.groupId)" // path where you wanted to store img in storage
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let storageRef = Storage.storage().reference()
        storageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print("Error while uploading image to firebase")
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                var myURL: URL!
                _ = storageRef.child((metaData?.path)!).downloadURL(completion: { (url, error) in
                    if(!(error != nil)){
                        myURL = url
                        print(myURL)
                        if(myURL != nil){
                            print("UPDATE PROFILE SUCCESSFUL")
                            //Api Call for change group image
                            let parameter: UpdatePrivateGroupPictureParameter = UpdatePrivateGroupPictureParameter(groupIconPath: (String(describing: myURL!)), groupId: self.privateGroup.groupId)
                            print("imageUrl: \(self.imageUrl)")
                            print("imageUrl: \(myURL)")
                            
                            self.updatePrivateGroupProfilePicture(updatePrivateGroupPictureParameter: parameter)
                            
                        }
                    }else{
                        print("Error: \(error!)")
                    }
                })
            }
        }
        
    }
    
    
}


import Foundation


extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    enum UIUserInterfaceIdiom : Int {
        
        case unspecified
        case phone
        case pad
    }
    
    enum ScreenType: String {
        case iPhone4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS_11Pro = "iPhone X or iPhone XS or Iphone 11 Pro"
        case iPhone_XR_11 = "iPhone XR or iPhone 11"
        case iPhone_XSMax_ProMax = "iPhone XS Max or iPhone Pro Max"
        case iPad = "iPad"
        case iPad_Air = "iPad Air"
        case iPad_Pro_9 = "iPad Pro 9.5"
        case iPad_Pro_10 = "iPad Pro 10.7"
        case iPad_Pro_11 = "iPad Pro 11"
        case iPad_Pro_12 = "iPad Pro 12.9 inches"

        case unknown
    }

    
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 1792:
            return .iPhone_XR_11
        case 2436:
            return .iPhones_X_XS_11Pro
        case 2688:
            return .iPhone_XSMax_ProMax
        case 1366, 1024, 2732:
            return .iPad_Pro_12
        default:
            return .unknown
        }
    }

}


extension UIViewController {


    func disableDarkMode(){
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
    }
}

