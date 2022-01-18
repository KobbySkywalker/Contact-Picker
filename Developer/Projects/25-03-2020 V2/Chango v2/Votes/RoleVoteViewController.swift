//
//  RoleVoteViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 23/04/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import PopupDialog
import FTIndicator
import Alamofire
import MultiProgressView
import FirebaseDatabase
import FirebaseAuth
import Nuke

class RoleVoteViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var voteSummaryButton: UIButton!
    @IBOutlet weak var votersButton: UIButton!
    @IBOutlet weak var circularProgress: CircularProgressBar!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var voteNoStack: UIStackView!
    @IBOutlet weak var voteYesStack: UIStackView!
    @IBOutlet weak var votesRequiredLabel: UILabel!
    @IBOutlet weak var voteDescriptionLabel: UILabel!
    @IBOutlet weak var voteImageView: UIImageView!
    @IBOutlet weak var initiatorNameLabel: UILabel!
    
    @IBOutlet weak var voteYesButton: UIButton!
    @IBOutlet weak var voteNoButton: UIButton!
    //voters view
    @IBOutlet weak var votersView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var votedTableView: UITableView!
    @IBOutlet weak var notVotedTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var voteStack: UIStackView!
    @IBOutlet weak var confirmVoteButton: UIButton!
    
    var easySlideNavigationController: ESNavigationController?
    
    var groupName: String = ""
    var groupIcon: String = ""
    var groupId: String = ""
    var voteId: String = ""
    var admin: Int = 0
    var approver: Int = 0
    var drop: Int = 0
    var role: String = ""
    var name: String = ""
    var memberId: String = ""
    var campaignId: String = ""
    var voteType: String = ""
    var initiatorName: String = ""
    var pendingVotes: [PendingVotes] = []
    var makeAdmin: Int = 0
    var authProviderId: String = ""
    var voteCount: Double = 0.0
    
    var revokeVotesCompleted: Int = 0
    var revokeVotesRemaining: Int = 0
    
    var finalComp: Double = 0.0
    var finalRem: Double = 0.0
    
    var votescompleted: String = ""
    var votesRequired: String = ""
    
    var voteSelected: String = ""
    var minVoteCount: String = ""
    
    var ballotSummary: BallotSummaryRTDB!
    typealias FetchBallotSummaryCompletionHandler = (_ groups: BallotSummaryRTDB ) -> Void
    
    var votedMembers: [Member] = []
    var notVotedMembers: [Member] = []
    let cell = "cellId"
    
    var viewOnly: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        //        view.backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 242)
        //        view.addSubview(backgroundView)
        //        backgroundView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 20)
        
        //voters view
        if viewOnly == true {
            voteYesStack.isHidden = true
            voteNoStack.isHidden = true
            confirmVoteButton.isHidden = true
        }
        
        let parameter: GetVotedParameter = GetVotedParameter(groupId: groupId, voteId: voteId)
        self.getVotedMembers(getVotedMembersParameter: parameter)
        
        let parameters: GetNotVotedParameter = GetNotVotedParameter(groupId: groupId, voteId: voteId)
        self.getNotVotedMembers(getNotVotedMembersParameter: parameters)
        
        self.votedTableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.votedTableView.register(UINib(nibName: "VoteCell", bundle: nil), forCellReuseIdentifier: "VoteCell")
        
        
        self.notVotedTableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.notVotedTableView.register(UINib(nibName: "VoteCell", bundle: nil), forCellReuseIdentifier: "VoteCell")
        
        self.fetchBallotSummary{ (result) in
            print("result: \(result)")
            print("ball: \(result.minVoteCount), \(result.votesRemaining), \(result.votesCompleted)")
            
            self.revokeVotesCompleted = result.votesCompleted
            self.revokeVotesRemaining = result.minVoteCount
            
            self.finalRem = Double(self.revokeVotesRemaining)/10
            self.finalComp = Double(self.revokeVotesCompleted)/10
            
            print(self.finalRem)
            print(self.finalComp)
            
            self.votescompleted = "Total Voted(\(self.revokeVotesCompleted))"
            self.votesRequired = "Total no. of required voters(\(self.revokeVotesRemaining))"
            
            //                self.setupLabels()
            //                self.setupProgressBar()
            //                self.setupStackView()
            //                self.animateProgress()
            
            self.votesRequiredLabel.text = "Total number of required votes: \(self.minVoteCount)"
        }
        
        initiatorNameLabel.text = name
        
        //        setupButtons()
        
        if (voteType == "makeapprover") {
            
            let attributedText = NSMutableAttributedString(string: "Are you sure you want to make \(name) an \(role), this action cannot be undone?", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
            attributedText.append(NSAttributedString(string: role, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]))
            
        }else if voteType == "makeadmin" {
            
            let attributedText = NSMutableAttributedString(string: "Are you sure you want to make \(name) an \(role), this action cannot be undone?", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
            attributedText.append(NSAttributedString(string: role, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]))
        }else {
            
            let attributedText = NSMutableAttributedString(string: "Are you sure you want to revoke \(name) as an \(role), this action cannot be undone?", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
            attributedText.append(NSAttributedString(string: role, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]))
        }
        
        if (voteType == "makeapprover") {
            
            role = "Approver"
            self.navigationItem.title = "Make Approver"
            
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to make")
            formattedString.bold(" \(name)")
            formattedString.normal(" an")
            formattedString.bold(" \(role)?")
            formattedString.normal(" This action cannot be undone!")
            
            actionLabel.text = "Vote to Make Approver"
            voteDescriptionLabel.text = "Make \(name) Approver"
            //            revokeDescription.attributedText = formattedString
            
        } else if (voteType == "makeadmin") {
            
            role = "Admin"
            self.navigationItem.title = "Make Admin"
            
            
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to make")
            formattedString.bold(" \(name)")
            formattedString.normal(" an")
            formattedString.bold(" \(role)?")
            formattedString.normal(", this action cannot be undone!")
            
            actionLabel.text = "Vote to Make Group Admin"
            voteDescriptionLabel.text = "Make \(name) Admin"
            //            revokeDescription.attributedText = formattedString
            
        }else if (voteType == "revokeadmin") {
            self.navigationItem.title = "Revoke Admin"
            
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to revoke")
            formattedString.bold(" \(name)'s")
            formattedString.normal(" rights as an")
            formattedString.bold(" \(role)?")
            formattedString.normal(" This action cannot be undone!")
            
            actionLabel.text = "Vote to Revoke Group Admin"
            voteDescriptionLabel.text = "Revoke \(name)"
            //            revokeDescription.attributedText = formattedString
        }
        else if (voteType == "revokeapprover") {
            self.navigationItem.title = "Revoke Approver"
            
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to revoke")
            formattedString.bold(" \(name)'s")
            formattedString.normal(" rights as an")
            formattedString.bold(" \(role)?")
            formattedString.normal(" This action cannot be undone!")
            
            actionLabel.text = "Vote to Revoke Approver"
            voteDescriptionLabel.text = "Revoke \(name)"
            //            revokeDescription.attributedText = formattedString
        }else if (voteType == "dropmember") {
            self.navigationItem.title = "Remove Member"
            
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to remove")
            formattedString.bold(" \(name)")
            formattedString.normal(" from this group?")
            formattedString.normal(" This action cannot be undone!")
            
            actionLabel.text = "Vote to Remove Member"
            voteDescriptionLabel.text = "Remove \(name)"
            
            //            revokeDescription.attributedText = formattedString
        }
        
        
        var i_progress = voteCount
        self.circularProgress.showProgressText = true
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {_ in
            //            i_progress = 0.5
            
            self.circularProgress.innerProgress = CGFloat(i_progress)
            self.circularProgress.progress = CGFloat(i_progress)
        })
    }
    

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func voteSummaryButtonAction(_ sender: Any) {
        voteSummaryButton.setTitleColor(UIColor(hexString: "#F14439"), for: .normal)
        votersButton.setTitleColor(UIColor(hexString: "#05406F"), for: .normal)
        votersView.isHidden = true
        
    }
    
    @IBAction func votersButtonAction(_ sender: Any) {
        votersButton.setTitleColor(UIColor(hexString: "#F14439"), for: .normal)
        voteSummaryButton.setTitleColor(UIColor(hexString: "#05406F"), for: .normal)
        votersView.isHidden = false
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
                
        let user = Auth.auth().currentUser

        if (user!.displayName == name) && (user!.uid == authProviderId) {
            voteStack.isHidden = true
        }
        
        if voteType == "dropMemer" {
            if UserDefaults.standard.bool(forKey: "dropmember\(campaignId)-\(voteId)") || (user?.displayName == name) {
                voteNoStack.isHidden = true
                voteYesStack.isHidden = true
                print("hide drop member votes")
            }
        }else if voteType == "makeadmin" {
            if UserDefaults.standard.bool(forKey: "makeadmin\(campaignId)-\(voteId)") || (user?.displayName == name) {
                voteNoStack.isHidden = true
                voteYesStack.isHidden = true
            }
        }else if voteType == "revokeapprover" {
            if UserDefaults.standard.bool(forKey: "revokeapprover\(campaignId)-\(voteId)") || (user?.displayName == name) {
                voteNoStack.isHidden = true
                voteYesStack.isHidden = true
            }
        }else if voteType == "revokeadmin" {
            if UserDefaults.standard.bool(forKey: "revokeadmin\(campaignId)-\(voteId)") || (user?.displayName == name) {
                voteNoStack.isHidden = true
                voteYesStack.isHidden = true
            }
        }
    }
    
    
    @IBAction func segmentedControlAction(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            votedTableView.isHidden = false
            notVotedTableView.isHidden = true
            
            print("count: \(votedMembers.count)")
            if (self.votedMembers.count > 0){
                self.emptyView.isHidden = true
                print("segmented voted hidden")
            }else {
                self.emptyView.isHidden = false
                print("segmented not hidden for not voted")
            }
            
            break
        case 1:
            notVotedTableView.isHidden = false
            votedTableView.isHidden = true
            
            if (self.notVotedMembers.count > 0){
                self.emptyView.isHidden = true
                print("segmented not voted hidden")
            }else {
                self.emptyView.isHidden = false
                print("segmented not hidden for not voted")
            }
            break
        default:
            break
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == votedTableView){
            return votedMembers.count
        }else {
            return notVotedMembers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == votedTableView){
            let cell: VoteCell = tableView.dequeueReusableCell(withIdentifier: "VoteCell", for: indexPath) as! VoteCell
            cell.selectionStyle = .none
            cell.voteButton.isHidden = true
            cell.memberName.isHidden = true
            
            let members: Member = self.votedMembers[indexPath.row]
            
            cell.groupName.text = "\(members.firstName) \(members.lastName)"
            cell.voteIcon.image = nil
            cell.voteIcon.image = UIImage(named: "defaulticon")
            if(members.memberIconPath == "<null>") || (members.memberIconPath == nil) || (members.memberIconPath == "") {
                cell.voteIcon.image = UIImage(named: "defaulticon")
                
            }else {
                let url = URL(string: members.memberIconPath!)
                
                Nuke.loadImage(with: url!, into: cell.voteIcon)
            }
            //            cell.memberStatus.backgroundColor = UIColor(red: 50/255, green: 54/255, blue: 66/255, alpha: 1)
            
            return cell
        } else if (tableView == notVotedTableView){
            
            let cell: VoteCell = tableView.dequeueReusableCell(withIdentifier: "VoteCell", for: indexPath) as! VoteCell
            cell.selectionStyle = .none
            cell.voteButton.isHidden = true
            cell.memberName.isHidden = true
            
            let members: Member = self.notVotedMembers[indexPath.row]
            
            cell.groupName.text = "\(members.firstName) \(members.lastName)"
            cell.voteIcon.image = nil
            cell.voteIcon.image = UIImage(named: "defaulticon")
            if(members.memberIconPath == "<null>") || (members.memberIconPath == nil) || (members.memberIconPath == "") {
                cell.voteIcon.image = UIImage(named: "defaulticon")
                
            }else {
                let url = URL(string: members.memberIconPath!)
                
                Nuke.loadImage(with: url!, into: cell.voteIcon)
            }
            //            cell.memberStatus.backgroundColor = UIColor(red: 50/255, green: 54/255, blue: 66/255, alpha: 1)
            return cell
        }else {
            let cell: MemberCell = self.notVotedTableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func getVotedMembers(getVotedMembersParameter: GetVotedParameter) {
        AuthNetworkManager.getVotedMembers(parameter: getVotedMembersParameter) { (result) in
            self.parseGetVotedMembersResponse(result: result)
        }
    }
    
    
    private func parseGetVotedMembersResponse(result: DataResponse<[Member], AFError>){
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            for item in response {
                self.votedMembers.append(item)
                print(response.count)
                
                
            }
            self.votedTableView.reloadData()
            print("member count: \(self.votedMembers.count)")
            if (self.votedMembers.count > 0){
                self.emptyView.isHidden = true
                print("hidden")
            }else {
                self.emptyView.isHidden = false
                print("not hidden for voted")
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
    
    
    func getNotVotedMembers(getNotVotedMembersParameter: GetNotVotedParameter) {
        AuthNetworkManager.getNotVotedMembers(parameter: getNotVotedMembersParameter) { (result) in
            self.parseGetNotVotedMembersResponse(result: result)
        }
    }
    
    
    private func parseGetNotVotedMembersResponse(result: DataResponse<[Member], AFError>){
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            
            for item in response {
                self.notVotedMembers.append(item)
            }
            
            self.notVotedTableView.reloadData()
            if (self.notVotedMembers.count > 0){
                self.emptyView.isHidden = true
                print("hidden")
            }else {
                self.emptyView.isHidden = false
                print("not hidden for not voted")
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
    
    
    func fetchBallotSummary(completionHandler: @escaping FetchBallotSummaryCompletionHandler){
        var ballots: BallotSummaryRTDB!
        if voteType == "makeAdmin" {
        }
        let ballotsRef = Database.database().reference().child("ballot_summary").child("\(groupId)").child("\(voteId)")
        print("voteId \(voteId)")
        _ = ballotsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshotValue = snapshot.value as? [String:AnyObject] {
                
                print("ballot dict: \(snapshot)")
                
                
                var grpId = ""
                if let groupId = snapshotValue["groupId"] as? String {
                    print("groupId: \(groupId)")
                    grpId = groupId
                }
                
                var minVoteCnt = 0
                if let minVoteCount = snapshotValue["minVoteCount"] as? Int {
                    minVoteCnt = minVoteCount
                    print("min vote count: \(minVoteCount)")
                }
                
                var votId = ""
                if let voteId = snapshotValue["voteId"] as? String {
                    votId = voteId
                    print("vote id: \(voteId)")
                }
                
                var votCompltd = 0
                if let votesCompleted = snapshotValue["votesCompleted"] as? Int {
                    //                ballots.votesCompleted = votCompltd
                    votCompltd = votesCompleted
                    print("votes Completed: \(votesCompleted)")
                    self.revokeVotesCompleted = Int(votesCompleted)
                }
                
                var votRemaining = 0
                if let votesRemaining = snapshotValue["votesRemaining"] as? Int {
                    //                ballots.votesRemaining = votCompltd
                    votRemaining = votesRemaining
                    print("votes Remaining: \(votesRemaining)")
                    self.revokeVotesRemaining = Int(votesRemaining)
                }
                
                let ballots = BallotSummaryRTDB(groupId_: grpId, minVoteCount_: minVoteCnt, voteId_: votId, votesCompleted_: votCompltd, votesRemaining_: votRemaining)
                
                self.ballotSummary = ballots
                
                
                print("vot comp: \(votCompltd), vot rem: \(votRemaining)")
                completionHandler(ballots)
                print("ballots: \(ballots.minVoteCount)")
            }else {
                
                let ballots = BallotSummaryRTDB(groupId_: "", minVoteCount_: 0, voteId_: "", votesCompleted_: 0, votesRemaining_: 0)
                
                completionHandler(ballots)
            }
        })
    }
    
    
    private let buttonImage: UIButton = {
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "view"), for: .normal)
        btn2.frame = CGRect(x: 300, y: 12, width: 33, height: 25)
//        btn2.addTarget(self, action: #selector(RoleVoteViewController.toView(_:)), for: .touchUpInside)
        return btn2
    }()
    
    //    private let votedLabel: UILabel = {
    //        let label = UILabel()
    //        label.text = "Voted"
    //        label.frame = CGRect(x: 30, y: 200, width: 100, height: 25)
    //        return label
    //    }
    
//    @objc func toView(_ sender:UIBarButtonItem){
//        
//        let vc: VotedViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "voted") as! VotedViewController
//        
//        vc.voteId = voteId
//        vc.groupId = groupId
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.rgb(red: 189, green: 189, blue: 189).cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .equalSpacing
        sv.alignment = .center
        return sv
    }()
    
    private let iPhoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Vote Summary"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //eye button icon
    //    private let buttonIcon: UIButton = {
    //        let icon = UIImage(named: "visible")!
    //        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
    //        button.frame = CGRectMake(33, 25, 100, 100)
    //        button.setImage(image, forState: .normal)
    //        button.addTarget(self, action: "buttonTouched", for: .touchUpInside)
    //        self.view.addSubview(button)
    //        return button
    //    }()
    
    private let dataUsedLabel: UILabel = {
        let label = UILabel()
        label.text = "0 of 5 Members Voted"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let padding: CGFloat = 15
    private let progressViewHeight: CGFloat = 20
    
    private lazy var progressView: MultiProgressView = {
        let progress = MultiProgressView()
        progress.trackBackgroundColor = .progressBackground
        progress.trackTitleAlignment = .left
        progress.lineCap = .round
        //        progress.cornerRadius = progressViewHeight / 4
        return progress
    }()
    
    private func setupLabels() {
        
        
        backgroundView.addSubview(iPhoneLabel)
        iPhoneLabel.anchor(top: backgroundView.topAnchor, left: backgroundView.leftAnchor, paddingTop: padding, paddingLeft: padding)
        
        backgroundView.addSubview(buttonImage)
        //        buttonImage.anchor(top: backgroundView.topAnchor, right: backgroundView.rightAnchor, paddingTop: padding, paddingRight: padding)
    }
    
    private func setupProgressBar() {
        backgroundView.addSubview(progressView)
        progressView.anchor(top: iPhoneLabel.bottomAnchor, left: backgroundView.leftAnchor, right: backgroundView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding, height: progressViewHeight)
        progressView.dataSource = self
    }
    
    private func setupStackView() {
        backgroundView.addSubview(stackView)
        stackView.anchor(top: progressView.bottomAnchor, left: backgroundView.leftAnchor, bottom: backgroundView.bottomAnchor, right: backgroundView.rightAnchor, paddingTop: padding, paddingLeft: padding, paddingBottom: padding, paddingRight: padding)
        for type in StorageType.allTypes {
            //            if type != .unknown {
            stackView.addArrangedSubview(StorageStackView(storageType: type, votesCompleted: votescompleted, votesRequired: votesRequired))
            //            }
        }
        stackView.addArrangedSubview(UIView())
    }
    
    
    private func animateProgress() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0,
                       options: .curveLinear,
                       animations: {
                        self.progressView.setProgress(section: 0, to: Float(self.finalComp))
                        self.progressView.setProgress(section: 1, to: Float(self.finalRem))
                        //                        self.progressView.setProgress(section: 2, to: 0.1)
                        //                        self.progressView.setProgress(section: 3, to: 0.1)
                        //                        self.progressView.setProgress(section: 4, to: 0.05)
                        //                        self.progressView.setProgress(section: 5, to: 0.03)
                        //                        self.progressView.setProgress(section: 6, to: 0.03)
        })
        //        dataUsedLabel.text = "56.5 GB of 64 GB Used"
    }
    
    
    @IBAction func showChart(_ sender: UIButton) {
        
        //        let vc = HorizontalBarChartViewController()
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func yesVoteButtonAction(_ sender: UIButton) {
        
        
        //        showVoteYes(name: name, groupId: groupId, memberId: memberId)
        print(name)
        print(groupId)
        print(memberId)
        voteSelected = "yes"
        voteYesButton.setImage(UIImage(named: "yesvotecheckicon"), for: .normal)
        voteNoButton.setImage(UIImage(named: "voteno"), for: .normal)

    }
    
    @IBAction func noVoteButtonAction(_ sender: UIButton) {
        
        voteSelected = "no"
        voteNoButton.setImage(UIImage(named: "novotecheckicon"), for: .normal)
        voteYesButton.setImage(UIImage(named: "yesvote"), for: .normal)
    }
    
    
    @IBAction func confirmVoteButtonAction(_ sender: Any) {
        
        if voteSelected == "yes"  {
            if self.voteType == "makeadmin" {
                FTIndicator.showProgress(withMessage: "voting")
                let parameterr: ExecuteMakeAdminParameter = ExecuteMakeAdminParameter(status: "1", voteId: self.voteId)
                self.executeMakeAdmin(executeMakeAdminParameter: parameterr)
            }else if self.voteType == "makeApprover"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: RevokeLoanApproverParameter = RevokeLoanApproverParameter(groupId: groupId, memberId: memberId, status: "1")
                self.revokeLoanApprover(revokeLoanApproverParameter: parameter)
            }else if self.voteType == "dropmember"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: DropMemberParameter = DropMemberParameter(voteId: self.voteId, status: "1")
                self.dropMember(dropMemberParameter: parameter)
            }else if self.voteType == "revokeapprover"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: ExecuteRevokeApproverParameter = ExecuteRevokeApproverParameter(status: "1", voteId: self.voteId)
                self.executeRevokeApprvoer(executeRevokeApproverParameter: parameter)
            }else if self.voteType == "revokeadmin"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: ExecuteRevokeAdminParameter = ExecuteRevokeAdminParameter(status: "1", voteId: self.voteId)
                self.executeRevokeAdmin(executeRevokeAdminParameter: parameter)
            }
        }else {
            
            if self.voteType == "makeadmin" {
                FTIndicator.showProgress(withMessage: "voting")
                let parameterr: ExecuteMakeAdminParameter = ExecuteMakeAdminParameter(status: "0", voteId: self.voteId)
                self.executeMakeAdmin(executeMakeAdminParameter: parameterr)
            }else if self.voteType == "makeApprover"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: RevokeLoanApproverParameter = RevokeLoanApproverParameter(groupId: groupId, memberId: memberId, status: "0")
                self.revokeLoanApprover(revokeLoanApproverParameter: parameter)
            }else if self.voteType == "dropmember"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: DropMemberParameter = DropMemberParameter(voteId: self.voteId, status: "0")
                self.dropMember(dropMemberParameter: parameter)
            }else if self.voteType == "revokeapprover"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: ExecuteRevokeApproverParameter = ExecuteRevokeApproverParameter(status: "0", voteId: self.voteId)
                self.executeRevokeApprvoer(executeRevokeApproverParameter: parameter)
            }else if self.voteType == "revokeadmin"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: ExecuteRevokeAdminParameter = ExecuteRevokeAdminParameter(status: "0", voteId: self.voteId)
                self.executeRevokeAdmin(executeRevokeAdminParameter: parameter)
            }
        }
    }
    
    
    //POP UP DIALOG
    func showVoteYes(animated: Bool = true, name: String, groupId: String, memberId: String) {
        
        //create a custom view controller
        let voteVC = VoteOptionDialogViewController(nibName: "VoteOptionDialogViewController", bundle: nil)
        
        //create the dialog
        let popup = PopupDialog(viewController: voteVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
        
        if voteType == "makeadmin" {
            voteVC.voteTitle.text = "Cast vote to approve"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to make")
            formattedString.bold(" \(name)")
            formattedString.normal(" as an admin?")
            formattedString.normal("This action cannot be undone?")
            
            voteVC.voteDescription.attributedText = formattedString
            //                "Are you sure you want to vote to make \(name) an admin? This action cannot be undone."
            print("alert else")
        }else if voteType == "makeapprover" {
            
            voteVC.voteTitle.text = "Cast vote to approve"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to make")
            formattedString.bold(" \(name)")
            formattedString.normal(" as an approver?")
            formattedString.normal("This action cannot be undone?")
            voteVC.voteDescription.attributedText = formattedString
            
        }else if voteType == "dropmember" {
            voteVC.voteTitle.text = "Cast vote to approve"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to remove")
            formattedString.bold(" \(name)")
            formattedString.normal(" from this group?")
            formattedString.normal("This action cannot be undone.")
            voteVC.voteDescription.attributedText = formattedString
        }else if voteType == "revokeapprover" {
            voteVC.voteTitle.text = "Cast vote to reject"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to revoke")
            formattedString.bold(" \(name)")
            formattedString.normal(" as an approver?")
            formattedString.normal("This action cannot be undone.")
            voteVC.voteDescription.attributedText = formattedString
        }else if voteType == "revokeadmin" {
            voteVC.voteTitle.text = "Cast vote to reject"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to revoke")
            formattedString.bold(" \(name)")
            formattedString.normal(" as an admin?")
            formattedString.normal(" This action cannot be undone.")
            voteVC.voteDescription.attributedText = formattedString
        }
        
        //create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            
        }
        DefaultButton.appearance().titleColor = .gray
        //            UIColor(red: 0.00, green: 1.00, blue: 0.00, alpha: 1.00)
        CancelButton.appearance().titleColor = .gray
        
        
        //create second button
        let buttonTwo = DefaultButton(title: "YES", height: 60) {
            
            
            if self.voteType == "makeadmin" {
                FTIndicator.showProgress(withMessage: "voting")
                let parameterr: ExecuteMakeAdminParameter = ExecuteMakeAdminParameter(status: "1", voteId: self.voteId)
                self.executeMakeAdmin(executeMakeAdminParameter: parameterr)
            }else if self.voteType == "makeApprover"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: RevokeLoanApproverParameter = RevokeLoanApproverParameter(groupId: groupId, memberId: memberId, status: "1")
                self.revokeLoanApprover(revokeLoanApproverParameter: parameter)
            }else if self.voteType == "dropmember"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: DropMemberParameter = DropMemberParameter(voteId: self.voteId, status: "1")
                self.dropMember(dropMemberParameter: parameter)
            }else if self.voteType == "revokeapprover"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: ExecuteRevokeApproverParameter = ExecuteRevokeApproverParameter(status: "1", voteId: self.voteId)
                self.executeRevokeApprvoer(executeRevokeApproverParameter: parameter)
            }else if self.voteType == "revokeadmin"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: ExecuteRevokeAdminParameter = ExecuteRevokeAdminParameter(status: "1", voteId: self.voteId)
                self.executeRevokeAdmin(executeRevokeAdminParameter: parameter)
            }
        }
        
        buttonTwo.tintColor = UIColor.green
        //Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        //Present dialog
        present(popup, animated: animated, completion: nil)
        
    }
    
    
    
    func showVoteNo(animated: Bool = true, name: String, groupId: String, memberId: String) {
        
        //create a custom view controller
        let voteVC = VoteOptionDialogViewController(nibName: "VoteOptionDialogViewController", bundle: nil)
        
        //create the dialog
        let popup = PopupDialog(viewController: voteVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
        
        
        
        if voteType == "makeadmin" {
            voteVC.voteTitle.text = "Cast vote to reject"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to reject")
            formattedString.bold(" \(name)")
            formattedString.normal(" as an admin?")
            formattedString.normal("This action cannot be undone.")
            
            voteVC.voteDescription.attributedText = formattedString
            //                "Are you sure you want to vote to make \(name) an admin? This action cannot be undone."
            print("alert else")
        }else if voteType == "makeapprover" {
            voteVC.voteTitle.text = "Cast vote to reject"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to reject")
            formattedString.bold(" \(name)")
            formattedString.normal(" as an approver?")
            formattedString.normal("This action cannot be undone.")
            voteVC.voteDescription.attributedText = formattedString
        }else if voteType == "dropmember" {
            voteVC.voteTitle.text = "Cast vote to reject"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to reject removing")
            formattedString.bold(" \(name)")
            formattedString.normal(" from this group?")
            formattedString.normal("This action cannot be undone.")
            voteVC.voteDescription.attributedText = formattedString
        }else if voteType == "revokeapprover" {
            voteVC.voteTitle.text = "Cast vote to reject"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to reject revoking")
            formattedString.bold(" \(name)")
            formattedString.normal(" as an approver?")
            formattedString.normal("This action cannot be undone.")
            voteVC.voteDescription.attributedText = formattedString
        }else if voteType == "revokeadmin" {
            voteVC.voteTitle.text = "Cast vote to reject"
            let formattedString = NSMutableAttributedString()
            formattedString.normal("Are you sure you want to vote to reject revoking")
            formattedString.bold(" \(name)")
            formattedString.normal(" as an admin?")
            formattedString.normal(" This action cannot be undone.")
            voteVC.voteDescription.attributedText = formattedString
        }
        
        //create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            
            popup.dismiss(animated: true, completion: nil)
            
        }
        DefaultButton.appearance().titleColor = .gray
        //            UIColor(red: 0.00, green: 1.00, blue: 0.00, alpha: 1.00)
        CancelButton.appearance().titleColor = .gray
        
        
        //create second button
        
        let buttonTwo = DefaultButton(title: "YES", height: 60) {
            
            if self.voteType == "makeadmin" {
                FTIndicator.showProgress(withMessage: "voting")

                let parameterr: ExecuteMakeAdminParameter = ExecuteMakeAdminParameter(status: "0", voteId: self.voteId)
                self.executeMakeAdmin(executeMakeAdminParameter: parameterr)
            }else if self.voteType == "makeApprover"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: RevokeLoanApproverParameter = RevokeLoanApproverParameter(groupId: groupId, memberId: memberId, status: "0")
                self.revokeLoanApprover(revokeLoanApproverParameter: parameter)
                
            }else if self.voteType == "dropmember"{
                FTIndicator.showProgress(withMessage: "voting")
                let parameter: DropMemberParameter = DropMemberParameter(voteId: self.voteId, status: "0")
                self.dropMember(dropMemberParameter: parameter)
            }else if self.voteType == "revokeapprover"{
                FTIndicator.showProgress(withMessage: "voting")

                let parameter: ExecuteRevokeApproverParameter = ExecuteRevokeApproverParameter(status: "0", voteId: self.voteId)
                self.executeRevokeApprvoer(executeRevokeApproverParameter: parameter)
            }else if self.voteType == "revokeadmin"{
                FTIndicator.showProgress(withMessage: "voting")
                //                let parameter: RevokeAdminParameter = RevokeAdminParameter(groupId: groupId, memberId: memberId, status: "0")
                //                self.revokeAdmin(revokeAdminParameter: parameter)
                let parameter: ExecuteRevokeAdminParameter = ExecuteRevokeAdminParameter(status: "0", voteId: self.voteId)
                self.executeRevokeAdmin(executeRevokeAdminParameter: parameter)
            }
            
        }
        
        buttonTwo.tintColor = UIColor.green
        //Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        //Present dialog
        present(popup, animated: animated, completion: nil)
        
    }
    
    
    //REVOKE LOAN APPROVER
    func revokeLoanApprover(revokeLoanApproverParameter: RevokeLoanApproverParameter) {
        AuthNetworkManager.revokeLoanApprover(parameter: revokeLoanApproverParameter) { (result) in
            self.parseRevokeLoanApproverResponse(result: result)
        }
    }
    
    
    
    
    private func parseRevokeLoanApproverResponse(result: DataResponse<RevokeLoanApproverResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            if result.response!.statusCode == 200 {
                
                UserDefaults.standard.set(1, forKey: "revokeapprover\(campaignId)-\(voteId)")
                
            }
            let alert = UIAlertController(title: "Vote", message: response.responseMessage , preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            break
        case .failure(let error):
            
            if result.response?.statusCode == 400 {
                
                sessionTimeout()
                
            }

            else {
                let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    //REVOKE ADMIN
    func revokeAdmin(revokeAdminParameter: RevokeAdminParameter) {
        AuthNetworkManager.revokeAdmin(parameter: revokeAdminParameter) { (result) in
            self.parseRevokeAdminResponse(result: result)
        }
    }
    
    
    private func parseRevokeAdminResponse(result: DataResponse<RevokeAdminResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            if result.response!.statusCode == 200 {
                
                UserDefaults.standard.set(1, forKey: "revokeadmin\(campaignId)-\(voteId)")
                
            }
            //            self.remove(child: self.groupId)
            let alert = UIAlertController(title: "Vote", message: response.responseMessage , preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            break
        case .failure(let error):
            
            if result.response?.statusCode == 400 {
                
                sessionTimeout()
                
            }

            else {
                let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    //DROP MEMBER
    func dropMember(dropMemberParameter: DropMemberParameter) {
        AuthNetworkManager.dropMember(parameter: dropMemberParameter) { (result) in
            self.parseDropMemberResponse(result: result)
        }
    }
    
    
    
    
    private func parseDropMemberResponse(result: DataResponse<RevokeAdminResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            if result.response!.statusCode == 200 {
                
                print("save vote")
                UserDefaults.standard.set(1, forKey: "dropmember\(campaignId)-\(voteId)")
                
            }
            //            self.remove(child: self.groupId)
            let alert = UIAlertController(title: "Vote", message: response.responseMessage , preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.navigationController?.popViewController(animated: true)
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            break
        case .failure(let error):
            
            if result.response?.statusCode == 400 {
                
                sessionTimeout()
                
            }

            else {
                let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    //EXECUTE MAKE ADMIN
    func executeMakeAdmin(executeMakeAdminParameter: ExecuteMakeAdminParameter) {
        AuthNetworkManager.executeMakeAdmin(parameter: executeMakeAdminParameter) { (result) in
            self.parseExecuteMakeAdmin(result: result)
        }
    }
    
    
    
    
    private func parseExecuteMakeAdmin(result: DataResponse<ExecuteMakeAdminResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
            
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
    
    
    //EXECUTE REVOKE ADMIN
    func executeRevokeAdmin(executeRevokeAdminParameter: ExecuteRevokeAdminParameter) {
        AuthNetworkManager.executeRevokeAdmin(parameter: executeRevokeAdminParameter) { (result) in
            self.parseExecuteRevokeAdmin(result: result)
        }
    }
    
    
    
    
    private func parseExecuteRevokeAdmin(result: DataResponse<ExecuteMakeAdminResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
            
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
    
    
    //EXECUTE REVOKE APPROVER
    func executeRevokeApprvoer(executeRevokeApproverParameter: ExecuteRevokeApproverParameter) {
        AuthNetworkManager.executeRevokeApprover(parameter: executeRevokeApproverParameter) { (result) in
            self.parseExecuteRevokeApprover(result: result)
        }
    }
    
    
    
    
    private func parseExecuteRevokeApprover(result: DataResponse<ExecuteMakeAdminResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
            
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
    
    
    //CREATE ADMIN
    func createAdmin(createAdminParameter: CreateAdminParameter) {
        AuthNetworkManager.createAdmin(parameter: createAdminParameter) { (result) in
            self.parseCreateAdminResponse(result: result)
        }
    }
    
    
    
    
    private func parseCreateAdminResponse(result: DataResponse<RevokeLoanApproverResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            if result.response!.statusCode == 200 {
                
                UserDefaults.standard.set(1, forKey: "createadmin\(campaignId)-\(voteId)")
                
            }
            
            let alert = UIAlertController(title: "Vote", message: response.responseMessage , preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.navigationController?.popViewController(animated: true)
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            break
        case .failure(let error):
            
            if result.response?.statusCode == 400 {
                
                sessionTimeout()
                
            }

            else {
                let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    
    //CREATE LOAN APPROVER
    func createLoanApprover(createLoanApproverParameter: CreateLoanApproverParameter) {
        AuthNetworkManager.createLoanApprover(parameter: createLoanApproverParameter) { (result) in
            self.parseCreateLoanApproverResponse(result: result)
        }
    }
    
    
    
    
    private func parseCreateLoanApproverResponse(result: DataResponse<CreateLoanApproverResponse, AFError>){
        FTIndicator.dismissProgress()
        
        switch result.result {
        case .success(let response):
            print(response)

            break
        case .failure(let error):
            
            if result.response?.statusCode == 400 {
                
                sessionTimeout()
                
            }else {
                let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                    if (NetworkManager().getErrorMessage(response: result) == "Your session has timed out.") {
                        
                        let vc: ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "walkthrough") as! ViewController
                        
                        
                        
                        if let slideController = self.easySlideNavigationController{
                            slideController.setBodyViewController(vc, closeOpenMenu: true, ignoreClassMatch: true)
                        }
                    }
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    
    //MAKE LOAN APPROVER
    func makeLoanApprover(makeLoanApproverParameter: MakeLoanApproverParameter) {
        AuthNetworkManager.makeLoanApprover(parameter: makeLoanApproverParameter) { (result) in
            self.parseMakeLoanApproverResponse(result: result)
        }
    }
    
    
    
    
    private func parseMakeLoanApproverResponse(result: DataResponse<MakeLoanApproverResponse, AFError>){
        FTIndicator.dismissProgress()
        
        switch result.result {
        case .success(let response):
            print(response)

            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
            
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
                    
                    if (NetworkManager().getErrorMessage(response: result) == "Your session has timed out.") {
                        
                        let vc: ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "walkthrough") as! ViewController
                        
                        
                        
                        if let slideController = self.easySlideNavigationController{
                            slideController.setBodyViewController(vc, closeOpenMenu: true, ignoreClassMatch: true)
                        }
                    }
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }

    
}



extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "HelveticaNeue-Bold", size: 17)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}


extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let progressRed = UIColor.rgb(red: 251, green: 16, blue: 68)
    static let progressGreen = UIColor.rgb(red: 67, green: 213, blue: 82)
    static let progressPurple = UIColor.rgb(red: 70, green: 58, blue: 205)
    static let progressYellow = UIColor.rgb(red: 252, green: 196, blue: 9)
    static let progressBlue = UIColor.rgb(red: 10, green: 96, blue: 253)
    static let progressOrange = UIColor.rgb(red: 251, green: 128, blue: 7)
    static let progressGray = UIColor.rgb(red: 188, green: 186, blue: 194)
    static let progressBluey = UIColor.rgb(red: 81, green: 130, blue: 183)
    static let progressNavy = UIColor.rgb(red: 104, green: 169, blue: 239)
    
    static let progressBackground = UIColor.rgb(red: 224, green: 224, blue: 224)
}


extension UIViewController: MultiProgressViewDataSource {
    public func numberOfSections(in progressBar: MultiProgressView) -> Int {
        return 2
    }
    
    public func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let bar = StorageProgressSection()
        switch section {
        case 0:
            bar.configure(storageType: .app)
        case 1:
            bar.configure(storageType: .message)
//        case 2:
//            bar.configure(storageType: .media)
//        case 3:
//            bar.configure(storageType: .photo)
//        case 4:
//            bar.configure(storageType: .mail)
//        case 5:
//            bar.configure(storageType: .unknown)
//        case 6:
//            bar.configure(storageType: .other)
        default:
            break
        }
        return bar
    }
}


enum StorageType {
    
    static var allTypes: [StorageType] = [.app, .message/*, .media, .photo, .mail, .unknown, .other*/]
    
    case app
    case message
    //    case media
    //    case photo
    //    case mail
    //    case unknown
    //    case other
    
    func description(votesCompleted: String, votesRequired: String) -> String {

        switch self {
        case .app:
            return votesCompleted
        case .message:
            return votesRequired
            //        case .media:
            //            return "Media"
            //        case .photo:
            //            return "Photos"
            //        case .mail:
            //            return "Mail"
            //        case .unknown:
            //            return ""
            //        case .other:
            //            return "Other"
        }
    }
    
    var color: UIColor {
        switch self {
        case .app:
            return .progressBluey
        case .message:
            return .progressNavy
            //        case .media:
            //            return .progressPurple
            //        case .photo:
            //            return .progressYellow
            //        case .mail:
            //            return .progressBlue
            //        case .unknown:
            //            return .progressOrange
            //        case .other:
            //            return .progressGray
        }
    }
}
