//
//  GroupActivityVC.swift
//  Alamofire
//
//  Created by Hosny Ben Savage on 11/12/2019.
//

import UIKit
import Nuke
import FirebaseDatabase

class GroupActivityVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    
    typealias FetchAllMembersCompletionHandler = (_ groups: MembersRTDB ) -> Void
    
    var groupActivites: [UserActivity] = []
    var groupName: String = ""
    var groupIconPath: String = ""
    var creatorInfo: String = ""
    var creatorName: String = ""
    let cell = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableView.register(UINib(nibName: "MemberActivityCell", bundle: nil), forCellReuseIdentifier: "MemberActivityCell")
        
        self.navigationItem.title = "Group Activities"
        
        if (creatorInfo == "") {
            createdLabel.text = ""
        }else {
            createdLabel.text = "\(creatorInfo)"
        }
        
        if groupActivites.count > 0 {
            emptyView.isHidden = true
        }else {
            emptyView.isHidden = false
        }
        groupNameLabel.text = groupName
        
        if (groupIconPath == "<null>") || (groupIconPath == nil) || (groupIconPath == ""){
            groupImage.image = UIImage(named: "defaultgroupicon")
                    print(groupIconPath)
            groupImage.contentMode = .scaleAspectFit
            
        }else {
            groupImage.contentMode = .scaleAspectFill
            Nuke.loadImage(with: URL(string: groupIconPath)!, into: groupImage)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupActivites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell: MemberActivityCell = self.tableView.dequeueReusableCell(withIdentifier: "MemberActivityCell", for: indexPath) as! MemberActivityCell
        cell.selectionStyle = .none
        
        let activity: UserActivity = self.groupActivites[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let date = formatter.date(from: activity.created)
        
        
        
        formatter.dateStyle = DateFormatter.Style.medium
        
        _ = formatter.string(from: date as! Date)
        
        cell.notificationName.text = activity.action
        cell.notificationDate.text = timeAgoSinceDate(date!)
        cell.notificationImage.image = nil
        cell.notificationImage.image = UIImage(named: "people")
        if (activity.groupIconPath == nil) || (activity.groupIconPath! == "") {
            cell.notificationImage.image = UIImage(named: "people")
        }else {
            Nuke.loadImage(with: URL(string: activity.groupIconPath!)!, into: cell.notificationImage)
        }
        
//        fetchAllMembers(completionHandler: { (result) in
        if activity.anonymous == true {
        cell.notificationMessage.text = "Anonymous\(activity.message)"
        }else {
            cell.notificationMessage.text = "\(activity.memberName!) \(activity.message)"
    }
//        }, authProviderId: activity.authProviderId)
        
        return cell
    }
    
    
    func fetchAllMembers(completionHandler: @escaping FetchAllMembersCompletionHandler, authProviderId: String){
        var members: MembersRTDB!
        let memberRef = Database.database().reference().child("users").child("\(authProviderId)")
        _ = memberRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as? [String:AnyObject]
            
//            print("dict: \(snapshot)")
            
            members = MembersRTDB(email_: "", memberId_: "", msisdn_: "", name_: "")
            
            if let em = snapshotValue?["email"] as? String {
                print(em)
                print(snapshotValue)
                members.email = em
            }
            if let memId = snapshotValue?["memberId"] as? String {
                members.memberId = memId
            }
            if let msi = snapshotValue?["msisdn"] as? String {
                members.msisdn = msi
            }
            if let nam = snapshotValue?["name"] as? String {
                members.name = nam
            }
            
            
            completionHandler(members)
            
        })
        
    }
    
    
}
