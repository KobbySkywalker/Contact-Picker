//
//  AllGroupsViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 13/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator
import Nuke
import Alamofire
import FirebaseAuth
import FirebaseDatabase
import ESPullToRefresh
import FirebaseMessaging

var easySlideNavigationController: ESNavigationController?
var allGroups: [GroupResponse] = []

class AllGroupsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    
    typealias FetchAllGroupsCompletionHandler = (_ groups: [GroupInviteResponse]) -> Void
    
    @IBOutlet weak var allGroupstableView: UITableView!
    @IBOutlet weak var createGroup: UIButton!
    @IBOutlet weak var emptyView: UIView!
    var leftGroup: Bool = false
    @IBOutlet weak var emptyViewText: UILabel!
    @IBOutlet weak var groupInvites: UILabel!
    @IBOutlet weak var invitesStack: UIStackView!
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var createGroupMainButton: UIButton!
    @IBOutlet weak var createGroupSmallButton: UIButton!
    @IBOutlet weak var searchBarItem: UISearchBar!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var groupOptionsStack: UIStackView!
    @IBOutlet weak var allGroupsButton: UIButton!
    @IBOutlet weak var privateGroupsButton: UIButton!
    @IBOutlet weak var publicGroupsButton: UIButton!
    @IBOutlet weak var privateGroupsTableView: UITableView!
    @IBOutlet weak var allPublicGroupsTableView: UITableView!
    @IBOutlet weak var noGroupLabel: UILabel!
    @IBOutlet weak var groupSearchEmptyView: UIView!
    
    var allGroups: [GroupResponse] = []
    var privateGroups: [GroupResponse] = []
    var searchGroups: [GroupResponse] = []
    var allPublicGroups: [GroupResponse] = []
    var groupDates: [String] = []
    var indexes: [String] = []
    var searchIndexes: [String] = []
    var searched: Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    var filtered_groups: [GroupResponse] = []
    var filtered_private: [GroupResponse] = []
    var filtered_public: [GroupResponse] = []
    var areaCode: String = ""
    var memberId: String = ""
    var groupInvite: [GroupInviteResponse] = []
    let user = Auth.auth().currentUser
    var initial: Bool = false
    var checkGroups: Int = 0
    var loanFlag: Int = 0
    var leftMenuVC: LeftMenuTableViewController!
    var phoneNumber: String = ""
    var memberExists: String = ""
    var invites: String = ""
    var reloadGroupTable: Bool = false
    var groupColorWays: [String] = ["#F14439", "#F8B52A", "#228CC7", "#034371"]
    var check: Int = 0
    var kycMemberId: String = ""
    var activatedTable: UITableView!
    
    let currentUser = Auth.auth().currentUser
    let cell = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FTIndicator.dismissProgress()
        showChatController()
        disableDarkMode()
        let user = Auth.auth().currentUser
//        emptyViewText.text = "Create a group with your family and friends"
        
        //manual update
        
//        let usersRef = Database.database().reference().child("users")
//        let userMemberId = usersRef.child("ldxwJZp14cUAzdUR3EyvY6uqzqO2")
//        userMemberId.child("authProviderId").setValue("ldxwJZp14cUAzdUR3EyvY6uqzqO2")
//        userMemberId.child("email").setValue("lawpabby@gmail.com")
//        userMemberId.child("memberId").setValue("5da15a2b-7079-4e14-a9a7-735dda3b6853")
//        userMemberId.child("msisdn").setValue("233203411204")
//        userMemberId.child("name").setValue("Lawrencia Pabby")
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 20)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        self.allGroupstableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.allGroupstableView.register(UINib(nibName: "GroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupsTableViewCell")
        self.allGroupstableView.register(UINib(nibName: "GroupsViewController", bundle: nil), forCellReuseIdentifier: "GroupsViewController")
        self.allGroupstableView.tableFooterView = UIView()
        
        self.privateGroupsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.privateGroupsTableView.register(UINib(nibName: "GroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupsTableViewCell")
        self.privateGroupsTableView.register(UINib(nibName: "GroupsViewController", bundle: nil), forCellReuseIdentifier: "GroupsViewController")
        self.privateGroupsTableView.tableFooterView = UIView()
        
        self.allPublicGroupsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.allPublicGroupsTableView.register(UINib(nibName: "GroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupsTableViewCell")
        self.allPublicGroupsTableView.register(UINib(nibName: "GroupsViewController", bundle: nil), forCellReuseIdentifier: "GroupsViewController")
        self.allPublicGroupsTableView.tableFooterView = UIView()
        
        activatedTable = allGroupstableView
        
        fetchAllGroups { (result) in
            self.groupInvite = result
            print("result: \(self.groupInvite)")
            var score = 5
            score = score > result.count ? result.count : score
            
            for i in 0 ..< score {
                self.invites = "\(self.invites) \(i + 1). \(result[i].groupName) \n"
            }
            print("under 5: \(self.invites)")
//            self.groupInvites.text = self.invites
            
//            if result.count == 0
        }
//        getPrivateGroups()
        retrieveMember()
        getAllGroups()
        memberId = (user?.uid)!
        FTIndicator.showProgress(withMessage: "Getting groups")
//        searchBar.placeholder = "Search Group"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]

        self.definesPresentationContext = true
        searchController.delegate = self
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        }
        searchBarItem.delegate = self
        self.searchBarItem.backgroundColor = UIColor.clear
//        self.searchBarItem.barTintColor = UIColor.clear
        let phone = user?.phoneNumber
        let phoneUtil = NBPhoneNumberUtil()
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(phone, defaultRegion: nil)
            areaCode = phoneUtil.getRegionCode(for: phoneNumber)
            print("code: \(areaCode)")
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        print("did load count: \(self.privateGroups.count)")
        if (self.privateGroups.count > 0){
            self.emptyView.isHidden = true
            print("hidden")
        }else{
            print("show")
            print(initial)
        }
        
        if (self.allPublicGroups.count > 0){
            self.emptyView.isHidden = true
            print("hidden")
        }else{
            print("show")
            print(initial)
        }
        
        
        self.allGroupstableView.es.addPullToRefresh {
            [unowned self] in
            self.getPrivateGroups()
            self.getAllGroups()
            self.getPublicGroups()
            self.retrieveMember()
            self.allGroupstableView.es.stopPullToRefresh()
            self.allGroupstableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
        }
    }

    @IBAction func allGroupsButtonAction(_ sender: Any) {
        allGroupsButton.setTitleColor(UIColor(hexString: "#228CC7"), for: .normal)
        privateGroupsButton.setTitleColor(UIColor(hexString: "#727272"), for: .normal)
        publicGroupsButton.setTitleColor(UIColor(hexString: "#727272"), for: .normal)
        privateGroupsTableView.isHidden = true
        allGroupstableView.isHidden = false
        allPublicGroupsTableView.isHidden = true
        activatedTable  = allGroupstableView
    }
    
    @IBAction func privateGroupsActionButton(_ sender: Any) {
        privateGroupsButton.setTitleColor(UIColor(hexString: "#228CC7"), for: .normal)
        allGroupsButton.setTitleColor(UIColor(hexString: "#727272"), for: .normal)
        publicGroupsButton.setTitleColor(UIColor(hexString: "#727272"), for: .normal)
        check = 1
        getPrivateGroups()
        privateGroupsTableView.isHidden = false
        allGroupstableView.isHidden = true
        allPublicGroupsTableView.isHidden = true
        activatedTable  = privateGroupsTableView
    }
    
    @IBAction func publicGroupActionButton(_ sender: Any) {
        publicGroupsButton.setTitleColor(UIColor(hexString: "#228CC7"), for: .normal)
        allGroupsButton.setTitleColor(UIColor(hexString: "#727272"), for: .normal)
        privateGroupsButton.setTitleColor(UIColor(hexString: "#727272"), for: .normal)
//        getPublicGroups()
        getContributionPublicGroups()
        privateGroupsTableView.isHidden = true
        allGroupstableView.isHidden = true
        allPublicGroupsTableView.isHidden = false
        activatedTable  = allPublicGroupsTableView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //used to be in view did load

        if reloadGroupTable == true {
            self.getPrivateGroups()
            self.getAllGroups()
            getPublicGroups()
        }
        
        if #available(iOS 13.0, *) {
            let statusBar1 =  UIView()
            statusBar1.frame = UIApplication.shared.keyWindow?.windowScene?.statusBarManager!.statusBarFrame as! CGRect
            statusBar1.backgroundColor = UIColor(red: 3/255, green: 67/255, blue: 113/255, alpha: 1.0)
            UIApplication.shared.keyWindow?.addSubview(statusBar1)
        } else {
            let statusBar1: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            statusBar1.backgroundColor = UIColor(red: 3/255, green: 67/255, blue: 113/255, alpha: 1.0)
        }

        //check versioning
    }
    
    func fetchAllGroups(completionHandler: @escaping FetchAllGroupsCompletionHandler) {
        var groups: [GroupInviteResponse] = []
        let groupsRef = Database.database().reference().child("invites")
        let uid = groupsRef.child("\((user?.uid)!)")
        _ = uid.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshotValue = snapshot.children.allObjects as? [DataSnapshot]{
                for snapDict in snapshotValue{
                    print("snapdict")
                    let dict = snapDict.value as! Dictionary<String, AnyObject>
                    print(dict)
                    if let groupArray = dict as? NSDictionary {
                        var gip = ""
                        if let groupIconPath = groupArray.value(forKey: "groupIconPath") as? String {
                            gip = groupIconPath
                        }
                        var tmstmp = ""
                        if let timestamp = groupArray.value(forKey: "timestamp") as? String {
                            tmstmp = timestamp
                        }
                        let groupDetails = GroupInviteResponse(countryId_: CountryId(countryId_: "", countryName_: "", created_: "", currency_: "", modified_: ""), groupId_: groupArray.value(forKey: "groupId") as! String, groupName_: groupArray.value(forKey: "groupName") as! String, groupType_: "", groupIconPath_: gip, tnc_: groupArray.value(forKey: "tnc") as! String, status_: "", created_: "", modified_:  "", description_: groupArray.value(forKey: "description") as! String, messageBody_: groupArray.value(forKey: "messageBody") as! String, timestamp_: tmstmp)
                        groups.append(groupDetails)
                    }
                }
            }
            completionHandler(groups)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (leftGroup) {
            print("reload cos leave group happened")
            self.getPrivateGroups()
            self.getAllGroups()
            getPublicGroups()
        }
    }
    
    @IBAction func leftMenuView(_ sender: Any) {
        self.getEasySlide().openMenu(.leftMenu, animated: true, completion: {})
        
    }
    
    @IBAction func createGroupButtonAction(_ sender: UIButton) {
//        if (areaCode == "GH") || (areaCode == "KE") {
//            let vc: NewGroupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "new") as! NewGroupViewController
            let vc: SelectCountryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectcountry") as! SelectCountryViewController
//            vc.areaCode = areaCode
            self.navigationController?.pushViewController(vc, animated: true)
//        }else {
//            showAlert(title: "Chango", message: "Group creation is not available for your country yet.")
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Searched?: \(searched)")
        if (searched) && (tableView == privateGroupsTableView) {
            return self.filtered_private.count
        }else if (tableView ==  privateGroupsTableView) {
            return privateGroups.count
        }else if (tableView == allPublicGroupsTableView){
            return allPublicGroups.count
        }else if (searched) && (tableView == allPublicGroupsTableView) {
            print("show public filter")
            return self.filtered_public.count
        }else if (searched) && (tableView == allGroupstableView){
            return self.filtered_groups.count
        }else {
            print("show all filter")
        return allGroups.count
        }
    }
    
    func setupGroups(){
        self.allGroupstableView.reloadData()
    }
    func setupPrivateGroups(){
        self.privateGroupsTableView.reloadData()
    }
    func setupPublicGroups(){
        self.allPublicGroupsTableView.reloadData()
    }
    
    func searchMethod(searchText: String, tableView: UITableView){
        filtered_groups.removeAll()
        filtered_private.removeAll()
        filtered_public.removeAll()
        searchIndexes.removeAll()
        print("search text: \(searchText)")
        if(searchText.isEmpty){
            searched = false
            print("search is empty")
            self.setupGroups()
            self.setupPrivateGroups()
            self.setupPublicGroups()
            return
        }else if(!(searchText.isEmpty)){
            print("search is active")
            if tableView == privateGroupsTableView  {
                filtered_private = privateGroups.filter({ (group : GroupResponse) -> Bool in
                    return (group.groupName.lowercased().contains(searchText.lowercased()))
                })
                searched = true
                print("search is true: \(filtered_private)")
                if filtered_private.isEmpty {
                    groupSearchEmptyView.isHidden = false
                }else {
                    groupSearchEmptyView.isHidden = true
                }
                self.setupPrivateGroups()
            }else if tableView == allPublicGroupsTableView {
                filtered_public = allPublicGroups.filter({ (group : GroupResponse) -> Bool in
                    return (group.groupName.lowercased().contains(searchText.lowercased()))
                })
                searched = true
                print("search is true")
                if filtered_public.isEmpty {
                    groupSearchEmptyView.isHidden = false
                }else {
                    groupSearchEmptyView.isHidden = true
                }
                self.setupPublicGroups()
            }else {
                filtered_groups = allGroups.filter({ (group : GroupResponse) -> Bool in
                    return (group.groupName.lowercased().contains(searchText.lowercased()))
                })
                searched = true
                print("search is true")
                if filtered_groups.isEmpty {
                    groupSearchEmptyView.isHidden = false
                }else {
                    groupSearchEmptyView.isHidden = true
                }
                self.setupGroups()
            }
        }
    }
    
    
    func filterContentForSearchText(_ searchText: String, tableView: UITableView) {
        filtered_groups.removeAll(keepingCapacity: false)
        filtered_private.removeAll(keepingCapacity: false)
        filtered_public.removeAll(keepingCapacity: false)
        print("remove all")
        if tableView == privateGroupsTableView {
            let array = privateGroups.filter ({
                print("case insensitive")
                return $0.groupName.localizedCaseInsensitiveContains(searchText)
            })
            filtered_private = array
            print("filter groups")
            if filtered_private.isEmpty {
                //display group not found
            }
            self.privateGroupsTableView.reloadData()
        }else if tableView == allPublicGroupsTableView {
            let array = allPublicGroups.filter ({
                print("case insensitive")
                return $0.groupName.localizedCaseInsensitiveContains(searchText)
            })
            filtered_public = array
            print("filter groups")
            if filtered_public.isEmpty {
                //display no group foud
                print("show me something")

            }
            self.allPublicGroupsTableView.reloadData()
        }else {
            let array = allGroups.filter ({
                print("case insensitive")
                return $0.groupName.localizedCaseInsensitiveContains(searchText)
            })
            filtered_groups = array
            print("filter groups")
            if filtered_groups.isEmpty {
                //display group not found
            }
            self.allGroupstableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        filterContentForSearchText(searchBar.text!)
        searchMethod(searchText: searchBar.text!, tableView: activatedTable)
        print("text: \(searchBar.text!)")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("update search results")
        searchMethod(searchText: searchController.searchBar.text!, tableView: activatedTable)
    }
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text did change")
        searchMethod(searchText: searchText, tableView: activatedTable)
    }
    
    @IBAction func leftMenu(_ sender: UIBarButtonItem) {
        self.getEasySlide().openMenu(.leftMenu, animated: true, completion: {})
    }
    
    @IBAction func PendingInvitesBtnAction(_ sender: UIButton) {
        let vc: InvitationsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "invite") as! InvitationsViewController
        vc.newUser = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func createGroupBtnAction(_ sender: UIButton) {
//        if (areaCode == "GH") || (areaCode == "KE") {
            let vc: NewGroupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "new") as! NewGroupViewController
            vc.areaCode = areaCode
            self.navigationController?.pushViewController(vc, animated: true)
//        }else {
//            showAlert(title: "Chango", message: "Group creation is not available for your country yet.")
//        }
    }
    
    @IBAction func contributePublicGroupButtonAction(_ sender: Any) {
            let vc: PublicGroupsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "public") as! PublicGroupsViewController
        vc.newUser = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func dateFormatter(dateFrom: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        var dates = ""
        if let date = formatter.date(from: dateFrom) {
        formatter.dateStyle = DateFormatter.Style.medium
            _ = formatter.string(from: date)
        dates = timeAgoSinceDate(date)
        }
        return dates
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == privateGroupsTableView) {
            //Private Groups
            if (searched) {
                let cell: GroupsTableViewCell = self.privateGroupsTableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
                cell.selectionStyle = .none
                //configure the search cell
                let myGroup: GroupResponse = self.filtered_private[indexPath.row]
                cell.groupsImage.image = nil
                cell.groupsImage.image = UIImage(named: "defaultgroupicon")
                let url = URL(string: myGroup.groupIconPath!)
                if(myGroup.groupIconPath == "<null>") || (myGroup.groupIconPath == nil) || (myGroup.groupIconPath == "") {
                    cell.groupsImage.image = UIImage(named: "defaultgroupicon")
                    cell.groupsName.text = self.filtered_private[indexPath.row].groupName
                    cell.groupsDate.text = "Last Activity: \(dateFormatter(dateFrom: self.filtered_private[indexPath.row].modified!))"
                }else {
                    cell.groupsImage.contentMode = .scaleAspectFill
                    Nuke.loadImage(with: url!, into: cell.groupsImage)
                    cell.groupsName.text = self.filtered_private[indexPath.row].groupName
                    cell.groupsDate.text = "Last Activity: \(dateFormatter(dateFrom: self.filtered_private[indexPath.row].modified!))"
                }
                cell.rectangularView.backgroundColor = UIColor(hexString: groupColorWays[indexPath.row % groupColorWays.count])

                return cell
            }else {
                    let cell: GroupsTableViewCell = self.privateGroupsTableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
                    cell.selectionStyle = .none
                    let myGroup: GroupResponse = self.privateGroups[indexPath.row]
                    cell.groupsImage.image = nil
                    cell.groupsImage.image = UIImage(named: "defaultgroupicon")
                    if(myGroup.groupIconPath == "<null>") || (myGroup.groupIconPath == nil) || (myGroup.groupIconPath == "") {
                        cell.groupsImage.image = UIImage(named: "defaultgroupicon")
                        cell.groupsName.text = self.privateGroups[indexPath.row].groupName
                        cell.groupsDate.text = "Last Activity: \(dateFormatter(dateFrom: self.privateGroups[indexPath.row].modified!))"
                        print(myGroup.groupType)
                        print(self.privateGroups[indexPath.row].groupName)
                    }else {
                        cell.groupsImage.contentMode = .scaleAspectFill
                        Nuke.loadImage(with: URL(string: myGroup.groupIconPath!)!, into: cell.groupsImage)
                        cell.groupsName.text = self.privateGroups[indexPath.row].groupName
                        cell.groupsDate.text = "Last Activity: \(dateFormatter(dateFrom: self.privateGroups[indexPath.row].modified!))"
                        cell.groupType.isHidden = false
                    }
                    if (myGroup.groupType == "public") {
                        cell.groupType.isHidden = false
                        cell.groupType.text = "Public"
                        cell.memberCampaignCount.text = "\(self.privateGroups[indexPath.row].campaignCount!)"
                        cell.memerCampaignLabel.text = "Campaigns"
                    }else if (myGroup.groupType == "private"){
                        cell.groupType.isHidden = false
                        cell.groupType.text = "Private"
                        cell.memberCampaignCount.text = "\(self.privateGroups[indexPath.row].groupMemberCount!)"
                        cell.memerCampaignLabel.text = "Members"
                    }
                    print("remainder: \(privateGroups.count % groupColorWays.count)")
                    cell.rectangularView.backgroundColor = UIColor(hexString: groupColorWays[indexPath.row % groupColorWays.count])

                    return cell
            }
        } else if (tableView == allPublicGroupsTableView) {

            if (searched) {
                let cell: GroupsTableViewCell = self.allPublicGroupsTableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
                cell.selectionStyle = .none
                print("filtered: \(self.filtered_public[indexPath.row].modified)")
                //configure the search cell
                let myGroup: GroupResponse = self.filtered_public[indexPath.row]
                cell.groupsImage.image = nil
                cell.groupsImage.image = UIImage(named: "defaultgroupicon")
                let url = URL(string: myGroup.groupIconPath!)
                if(myGroup.groupIconPath == "<null>") || (myGroup.groupIconPath == nil) || (myGroup.groupIconPath == "") {
                    cell.groupsImage.image = UIImage(named: "defaultgroupicon")
                    cell.groupsName.text = self.filtered_public[indexPath.row].groupName
                    cell.groupsDate.text = "Last Activity: \(dateFormatter(dateFrom: self.filtered_public[indexPath.row].modified!))"
                }else {
                    cell.groupsImage.contentMode = .scaleAspectFill
                    Nuke.loadImage(with: url!, into: cell.groupsImage)
                    cell.groupsName.text = self.filtered_public[indexPath.row].groupName
                    cell.groupsDate.text = "Last Activity: \(dateFormatter(dateFrom: self.filtered_public[indexPath.row].modified!))"
                }
                cell.rectangularView.backgroundColor = UIColor(hexString: groupColorWays[indexPath.row % groupColorWays.count])

                return cell
            }else {
            let cell: GroupsTableViewCell = self.allPublicGroupsTableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
            cell.selectionStyle = .none
            let myGroup: GroupResponse = self.allPublicGroups[indexPath.row]
            cell.groupsImage.image = nil
            cell.groupsImage.image = UIImage(named: "defaultgroupicon")
            if(myGroup.groupIconPath == "<null>") || (myGroup.groupIconPath == nil) || (myGroup.groupIconPath == "") {
                cell.groupsImage.image = UIImage(named: "defaultgroupicon")
                cell.groupsName.text = self.allPublicGroups[indexPath.row].groupName
                cell.groupsDate.text = "Last Activity: \(dateFormatter(dateFrom: self.allPublicGroups[indexPath.row].modified!))"
                print(myGroup.groupType)
                print(self.allPublicGroups[indexPath.row].groupName)
            }else {
                Nuke.loadImage(with: URL(string: myGroup.groupIconPath!)!, into: cell.groupsImage)
                cell.groupsName.text = self.allPublicGroups[indexPath.row].groupName
                cell.groupsDate.text = "Last Activity: \(dateFormatter(dateFrom: self.allPublicGroups[indexPath.row].modified!))"
                cell.groupType.isHidden = false
            }
            if (myGroup.groupType == "public") {
                cell.groupType.isHidden = false
                cell.groupType.text = "Public"
                cell.memberCampaignCount.text = "\(self.allPublicGroups[indexPath.row].campaignCount!)"
                cell.memerCampaignLabel.text = "Campaigns"
                //                cell.groupType.textColor = UIColor.red
            }else if (myGroup.groupType == "private"){
                cell.groupType.isHidden = false
                cell.groupType.text = "Private"
                cell.memberCampaignCount.text = "\(self.allPublicGroups[indexPath.row].groupMemberCount!)"
                cell.memerCampaignLabel.text = "Members"
            }
            cell.rectangularView.backgroundColor = UIColor(hexString: groupColorWays[indexPath.row % groupColorWays.count])
            return cell
            }
        }else {
            if (searched) {
                let cell: GroupsTableViewCell = self.allGroupstableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
                cell.selectionStyle = .none
                //configure the search cell
                let myGroup: GroupResponse = self.filtered_groups[indexPath.row]
                cell.groupsImage.image = nil
                cell.groupsImage.image = UIImage(named: "defaultgroupicon")
                let url = URL(string: myGroup.groupIconPath!)
                if(myGroup.groupIconPath == "<null>") || (myGroup.groupIconPath == nil) || (myGroup.groupIconPath == "") {
                    cell.groupsImage.image = UIImage(named: "defaultgroupicon")
                    cell.groupsName.text = self.filtered_groups[indexPath.row].groupName
                    cell.groupsDate.text = "Last Activity: \(dateFormatter(dateFrom: self.filtered_groups[indexPath.row].modified!))"
                }else {
                    cell.groupsImage.contentMode = .scaleAspectFill
                    Nuke.loadImage(with: url!, into: cell.groupsImage)
                    cell.groupsName.text = self.filtered_groups[indexPath.row].groupName
                    cell.groupsDate.text = "Last Activity: \(dateFormatter(dateFrom: self.filtered_groups[indexPath.row].modified!))"
                }
                if (myGroup.groupType == "public") {
                    cell.groupType.isHidden = false
                    cell.groupType.text = "Public"
                    cell.memberCampaignCount.text = "\(self.filtered_groups[indexPath.row].campaignCount!)"
                    cell.memerCampaignLabel.text = "Campaigns"
                }else if (myGroup.groupType == "private"){
                    cell.groupType.isHidden = false
                    cell.groupType.text = "Private"
                    cell.memberCampaignCount.text = "\(self.filtered_groups[indexPath.row].groupMemberCount!)"
                    cell.memerCampaignLabel.text = "Members"
                }
                cell.rectangularView.backgroundColor = UIColor(hexString: groupColorWays[indexPath.row % groupColorWays.count])
                return cell
            }else {
            let cell: GroupsTableViewCell = self.allGroupstableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
            cell.selectionStyle = .none
            let myGroup: GroupResponse = self.allGroups[indexPath.row]
            cell.groupsImage.image = nil
            cell.groupsImage.image = UIImage(named: "defaultgroupicon")
            if(myGroup.groupIconPath == "<null>") || (myGroup.groupIconPath == nil) || (myGroup.groupIconPath == "") {
                cell.groupsImage.image = UIImage(named: "defaultgroupicon")
                cell.groupsName.text = self.allGroups[indexPath.row].groupName
                cell.groupsDate.text = "Last Activity: \(dateFormatter(dateFrom: self.allGroups[indexPath.row].modified!))"
                print(myGroup.groupType)
                print(self.allGroups[indexPath.row].groupName)
            }else {
                cell.groupsImage.contentMode = .scaleAspectFill
                Nuke.loadImage(with: URL(string: myGroup.groupIconPath!)!, into: cell.groupsImage)
                cell.groupsName.text = self.allGroups[indexPath.row].groupName
                cell.groupsDate.text = "Last Activity: \(dateFormatter(dateFrom: self.allGroups[indexPath.row].modified!))"
                cell.groupType.isHidden = false
            }
            if (myGroup.groupType == "public") {
                cell.groupType.isHidden = false
                cell.groupType.text = "Public"
                cell.memberCampaignCount.text = "\(self.allGroups[indexPath.row].campaignCount!)"
                cell.memerCampaignLabel.text = "Campaigns"
            }else if (myGroup.groupType == "private"){
                cell.groupType.isHidden = false
                cell.groupType.text = "Private"
                cell.memberCampaignCount.text = "\(self.allGroups[indexPath.row].groupMemberCount!)"
                cell.memerCampaignLabel.text = "Members"
            }
            print("remainder: \(allGroups.count % groupColorWays.count)")
            cell.rectangularView.backgroundColor = UIColor(hexString: groupColorWays[indexPath.row % groupColorWays.count])
            Messaging.messaging().subscribe(toTopic: myGroup.groupId) { error in
                print("Subscribed to \(myGroup.groupName), \(myGroup.created)")
                print(myGroup.loanFlag)
            }
            return cell
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == privateGroupsTableView) {
                let privateGroup: GroupResponse = self.privateGroups[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller: PrivateGroupDashboardVC = storyboard.instantiateViewController(withIdentifier: "privatedashboard") as! PrivateGroupDashboardVC
            if (searched) {
                let group = filtered_private[indexPath.row]

                controller.privateGroup = group
                controller.groupName = group.groupName
                controller.campaignId = group.defaultCampaignId ?? ""
                controller.loanFlag = group.loanFlag
                controller.userMemberId = kycMemberId
                controller.allGroupsController = self
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }else {
                print("didn't search 8")
                controller.privateGroup = privateGroup
                controller.groupName = privateGroup.groupName
                controller.campaignId = privateGroup.defaultCampaignId ?? ""
                controller.loanFlag = privateGroup.loanFlag
                controller.userMemberId = kycMemberId
                controller.allGroupsController = self
                controller.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
        }else if (tableView == allPublicGroupsTableView)  {
            let allPubGroups: GroupResponse = self.allPublicGroups[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller: PublicCampaignsViewController = storyboard.instantiateViewController(withIdentifier: "publiccampaigns") as! PublicCampaignsViewController
            let controller: PublicGroupDashboardVC = storyboard.instantiateViewController(withIdentifier: "publicdash") as! PublicGroupDashboardVC
            if (searched) {
                let group = filtered_public[indexPath.row]
                controller.publicGroup = group
                self.navigationController?.pushViewController(controller, animated: true)
            }else {
                controller.publicGroup = allPubGroups
                controller.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(controller, animated: true)
            }

        }else {
            //All Groups
            let myGroup: GroupResponse = self.allGroups[indexPath.row]
            if (myGroup.groupType == "public"){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let controller: PublicCampaignsViewController = storyboard.instantiateViewController(withIdentifier: "publiccampaigns") as! PublicCampaignsViewController
                let controller: PublicGroupDashboardVC = storyboard.instantiateViewController(withIdentifier: "publicdash") as! PublicGroupDashboardVC
                if (searched) {
                    let group = filtered_groups[indexPath.row]
                    controller.publicGroup = group
                    self.navigationController?.pushViewController(controller, animated: true)
                }else {
                    let group = allGroups[indexPath.row]
                    controller.publicGroup = group
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }else {
                if (searched) {
                    print("searched here 8")
                    let group = filtered_groups[indexPath.row]
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let controller: PrivateGroupDashboardVC = storyboard.instantiateViewController(withIdentifier: "privatedashboard") as! PrivateGroupDashboardVC
                    controller.privateGroup = group
                    controller.groupName = group.groupName
                    controller.campaignId = group.defaultCampaignId ?? ""
                    controller.loanFlag = group.loanFlag
                    controller.userMemberId = kycMemberId
                    controller.allGroupsController = self
                    controller.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(controller, animated: true)
                    return
                }else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller: PrivateGroupDashboardVC = storyboard.instantiateViewController(withIdentifier: "privatedashboard") as! PrivateGroupDashboardVC
                    controller.privateGroup = myGroup
                    controller.groupName = myGroup.groupName
                    controller.campaignId = myGroup.defaultCampaignId ?? ""
                    controller.loanFlag = myGroup.loanFlag
                    controller.userMemberId = kycMemberId
                    controller.allGroupsController = self
                    controller.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99.0
    }
    
    func createDevice(createDeviceParameter: CreateDeviceParameter){
        AuthNetworkManager.createDevice(parameter: createDeviceParameter) { (result) in
            self.parseCreateDevice(result: result)
        }
    }
    
    private func parseCreateDevice(result: DataResponse<createDevice, AFError>){
        switch result.result {
        case .success(let response):
            print(response)
            break
        case .failure(let error):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    func getPrivateGroups(){
        AuthNetworkManager.getPrivateGroups { (result) in
            self.parseGetPrivateGroupsResponse(result: result)
        }
    }
    
    private func parseGetPrivateGroupsResponse(result: DataResponse<[GroupResponse], AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            FTIndicator.dismissProgress()

            if check == 1 {
                print("private response: \(response)")
                self.privateGroups.removeAll()
                for item in response {
                    self.privateGroups.append(item)
                    self.groupDates.append(item.modified!)
                }
                print(self.privateGroups)
//                allGroups = privateGroups
                self.allGroupstableView.reloadData()
                self.privateGroupsTableView.reloadData()
            }else {
            self.getContributionPublicGroups()
            print("response: \(response)")
            self.privateGroups.removeAll()
                self.allGroups.removeAll()
            for item in response {
                self.privateGroups.append(item)
                self.groupDates.append(item.modified!)
            }
            print(self.privateGroups)
            allGroups = privateGroups
            self.allGroupstableView.reloadData()
            self.privateGroupsTableView.reloadData()
            }
            break
        case .failure:
            FTIndicator.dismissProgress()
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    
        func getAllGroups(){
            AuthNetworkManager.getAllGroups { (result) in
                self.parseGetAllGroupsResponse(result: result)
            }
        }
        
        private func parseGetAllGroupsResponse(result: DataResponse<[GroupResponse], AFError>){
            FTIndicator.dismissProgress()
            switch result.result {
            case .success(let response):
                FTIndicator.dismissProgress()

                    print("private response: \(response)")
                    self.allGroups.removeAll()
                    for item in response {
                        self.allGroups.append(item)
                        self.groupDates.append(item.modified!)
                    }
                    print(self.allGroups)
                self.allGroups = allGroups.sorted(by: {$0.modified > $1.modified})
                    self.allGroupstableView.reloadData()
//                    self.privateGroupsTableView.reloadData()
                print(allGroups.count)
                if allGroups.isEmpty {
                    print(allGroups.count)
                    print("show empty view")
                    emptyView.isHidden = false
                    groupOptionsStack.isHidden = true
                    createGroupMainButton.isHidden = true
                    searchBarView.isHidden = true
                    pageTitleLabel.text = "Welcome To Chango"
                    let longString = "You are not in any groups yet, you can only do the following for now"
                    let longestWord = "You are not in any groups yet"
                    let longestWordRange = (longString as NSString).range(of: longestWord)

                    let attributedString = NSMutableAttributedString(string: longString, attributes: [NSAttributedString.Key.font : UIFont(name: "Sora", size: 17.0)!])

                    attributedString.setAttributes([NSAttributedString.Key.font : UIFont(name: "Sora-SemiBold", size: 17.0) as Any], range: longestWordRange)
                    noGroupLabel.attributedText = attributedString
                }else {
                    emptyView.isHidden = true
                    groupOptionsStack.isHidden = false
                    createGroupMainButton.isHidden = false
                    searchBarView.isHidden = false
                }
                break
            case .failure:
                FTIndicator.dismissProgress()
                if result.response?.statusCode == 400 {
                    sessionTimeout()
                }else {
                    showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
                }
            }
        }
    
    func getPublicGroups(){
        AuthNetworkManager.getPublicGroups { (result) in
            self.parseGetPublicGroupsResponse(result: result)
        }
    }
    
    private func parseGetPublicGroupsResponse(result: DataResponse<[GroupResponse], AFError>){
        switch result.result {
        case .success(let response):
            FTIndicator.dismissProgress()
            print(response)
            self.allPublicGroups.removeAll()
            for item in response {
                self.allPublicGroups.append(item)
                self.groupDates.append(item.modified!)
            }
            self.allPublicGroups = allPublicGroups.sorted(by: {$0.modified > $1.modified})
            print(self.allPublicGroups)
            self.allPublicGroupsTableView.reloadData()
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
    
    
    func memberExists(memberExistsParameter: MemberExistsParameter) {
        AuthNetworkManager.memberExists(parameter: memberExistsParameter) { (result) in
            FTIndicator.dismissProgress()
            print("member exists: \(result)")
            self.memberExists = result
            if (self.memberExists == "true") {
            }else {
                print("member does not ex")
            }
        }
    }

    //RETRIEVE MEMBER
    func retrieveMember() {
        AuthNetworkManager.retrieveMember() { (result) in
            self.parseRetrieveMemberResponse(result: result)
        }
    }

    private func parseRetrieveMemberResponse(result: DataResponse<RetrieveMemberResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            kycMemberId = response.memberId
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }

    func getContributionPublicGroups(){
        AuthNetworkManager.getContributionPublicGroups { (result) in
            self.parseGetContributionPublicGroupsResponse(result: result)
        }
    }
    
    private func parseGetContributionPublicGroupsResponse(result: DataResponse<[GroupResponse], AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
                case .success(let response):
                    FTIndicator.dismissProgress()
                    print(response)
                    self.allPublicGroups.removeAll()
                    for item in response {
                        self.allPublicGroups.append(item)
                        self.groupDates.append(item.modified!)
                    }
                    self.allPublicGroups = allPublicGroups.sorted(by: {$0.modified > $1.modified})
                    print(self.allPublicGroups)
                    self.allPublicGroupsTableView.reloadData()
        //            if (self.allPublicGroups.count > 0){
        //                self.emptyView.isHidden = true
        //                print("hidden")
        //            }else{
        //                self.emptyView.isHidden = false
        //                self.emptyViewText.text = "There are no public groups."
        //                print("show")
        //            }
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
    
    // EASY SLIDE
    fileprivate func getEasySlide() -> ESNavigationController {
        return self.navigationController as! ESNavigationController
    } 
}
