
//
//  GroupsViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 06/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import UIKit
import DropDown
import ESPullToRefresh
import Alamofire
import Nuke
import FTIndicator
import FirebaseAuth
//import libPhoneNumberiOS

class GroupsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var createGroup: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    @IBOutlet weak var emptyView: UIView!
    let textField = UITextField()
    
    var privateGroups: [GroupResponse] = []
    var publicGroups: [GroupResponse] = []
    var searchGroups: [GroupResponse] = []
    var indexes: [String] = []
    var searchIndexes: [String] = []
    var searched: Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    var memberId: String = ""
    var loanFlag: Int = 0
    
    let dropDown = DropDown()
    let cell = "cellId"
    var data = [""]
    var areaCode: String = ""
    var filtered_groups: [GroupResponse] = []
    //Sidebar
    fileprivate var currentMenu: MenuType = .leftMenu
    fileprivate var leftRevealType: RevealType = .slideOver
    fileprivate var leftSpeed: CGFloat = 0.35
    fileprivate var leftCanPan: Bool = true
    fileprivate var leftShadowEnabled: Bool = true
    fileprivate var leftEnabled: Bool = true
    fileprivate var rightEnabled: Bool = false
    fileprivate var leftWidth: CGFloat = 250
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showChatController()
        disableDarkMode()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 20)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableView.register(UINib(nibName: "GroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupsTableViewCell")
        self.tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        createGroup.layer.shadowColor = UIColor.black.cgColor
        createGroup.layer.shadowRadius = 8.0
        createGroup.layer.shadowOpacity = 0.2
        view.addSubview(textField)
        //SearchBar
        searchController.searchBar.placeholder = "Search Group"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        }
        self.tableView.register(UINib(nibName: "GroupsViewController", bundle: nil), forCellReuseIdentifier: "GroupsViewController")
        let user = Auth.auth().currentUser
        memberId = (user?.uid)!
        getPrivateGroups()
        FTIndicator.showProgress(withMessage: "Getting groups")
        self.tableView.es.addPullToRefresh {
            [unowned self] in
            //Do anything you want...
            self.getPrivateGroups()
            self.tableView.es.stopPullToRefresh()
            self.tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
        }
        self.tableView.reloadData()
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
        if (self.privateGroups.count > 0){
            self.emptyView.isHidden = true
        }else{
            self.emptyView.isHidden = false
        }
    }
    
    @IBAction func leftMenuView(_ sender: UIBarButtonItem) {
        self.getEasySlide().openMenu(.leftMenu, animated: true, completion: {})
    }
    
    func convertDateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        let dateFormatter1 = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: date)
        dateFormatter1.dateFormat = "MMM dd"
        dateFormatter1.timeZone = TimeZone.autoupdatingCurrent
        let timeStamp = dateFormatter1.string(from: date!)
        print(timeStamp)
        return timeStamp
    }
    
    @IBAction func createGroupButtonAction(_ sender: UIButton) {
        if (areaCode == "GH") || (areaCode == "KE") {
            let vc: NewGroupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "new") as! NewGroupViewController
            vc.areaCode = areaCode
//            self.navigationController?.pushViewController(vc, animated: true)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }else {
            showAlert(title: "Chango", message: "Group creation is not available for your country yet.")
        }
    }
    
    func setupGroups(){
        self.tableView.reloadData()
    }
    
    func searchMethod(searchText: String){
        filtered_groups.removeAll()
        searchIndexes.removeAll()
        if(searchText.isEmpty){
            searched = false
            self.setupGroups()
            return
        }else if(searchController.isActive && !(searchText.isEmpty)){
            filtered_groups = privateGroups.filter({ (group : GroupResponse) -> Bool in
                return (group.groupName.lowercased().contains(searchText.lowercased()))
            })
            searched = true
            self.setupGroups()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filtered_groups.removeAll(keepingCapacity: false)
        let array = privateGroups.filter ({
            $0.groupName.localizedCaseInsensitiveContains(searchText)
        })
        filtered_groups = array
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("update search results")
        searchMethod(searchText: searchController.searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text did change")
        searchMethod(searchText: searchText)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searched) {
            return self.filtered_groups.count
        }
        return privateGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = formatter.date(from: self.privateGroups[indexPath.row].modified!)
        formatter.dateStyle = DateFormatter.Style.medium
        _ = formatter.string(from: date as! Date)
        if (searched) {
            let dates = timeAgoSinceDate(date!)
            let cell: GroupsTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
            cell.selectionStyle = .none
            //configure the search cell
            let myGroup: GroupResponse = self.filtered_groups[indexPath.row]
            cell.groupsImage.image = nil
            cell.groupsImage.image = UIImage(named: "people")
            let url = URL(string: myGroup.groupIconPath!)
            if(myGroup.groupIconPath == "<null>") || (myGroup.groupIconPath == nil) || (myGroup.groupIconPath == "") {
                cell.groupsImage.image = UIImage(named: "people")
                cell.groupsName.text = self.filtered_groups[indexPath.row].groupName
                cell.groupsDate.text = dates
            }else {
                Nuke.loadImage(with: url!, into: cell.groupsImage)
                cell.groupsName.text = self.filtered_groups[indexPath.row].groupName
                cell.groupsDate.text = dates
            }
            return cell
        }else {
            let dates = timeAgoSinceDate(date!)
            let cell: GroupsTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
            cell.selectionStyle = .none
            let myGroup: GroupResponse = self.privateGroups[indexPath.row]
            cell.groupsImage.image = nil
            cell.groupsImage.image = UIImage(named: "people")
            if(myGroup.groupIconPath == "<null>") || (myGroup.groupIconPath == nil) || (myGroup.groupIconPath == "") {
                cell.groupsImage.image = UIImage(named: "people")
                cell.groupsName.text = self.privateGroups[indexPath.row].groupName
                cell.groupsDate.text = dates
            }else {
                Nuke.loadImage(with: URL(string: myGroup.groupIconPath!)!, into: cell.groupsImage)
                cell.groupsName.text = self.privateGroups[indexPath.row].groupName
                cell.groupsDate.text = dates
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (searched) {
            print("if")
            let group = filtered_groups[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller: MainMenuTableViewController = storyboard.instantiateViewController(withIdentifier: "main1") as! MainMenuTableViewController
            controller.privateGroup = group
            controller.groupName = group.groupName
            controller.campaignId = group.defaultCampaignId ?? ""
            print(group.groupName)
            controller.loanFlag = group.loanFlag
            self.navigationController!.pushViewController(controller, animated: true)
            return
        }
        let group = privateGroups[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: MainMenuTableViewController = storyboard.instantiateViewController(withIdentifier: "main1") as! MainMenuTableViewController
        controller.privateGroup = group
        controller.loanFlag = group.loanFlag
        print(group.groupName)
        print(group.groupId)
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func signupServer(signupParameter: SignUpParameter) {
        AuthNetworkManager.register(parameter: signupParameter) { (result) in
            self.parseSignupResponse(result: result)
        }
    }
    
    private func parseSignupResponse(result: DataResponse<RegisterResponse, AFError>){
        switch result.result {
        case .success(let response):
            print(response)
            let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
            break
        case .failure(_ ):
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
        switch result.result {
        case .success(let response):
            FTIndicator.dismissProgress()
            print("response: \(response)")
            self.privateGroups.removeAll()
            for item in response {
                self.privateGroups.append(item)
                if (self.privateGroups.count > 0){
                    self.emptyView.isHidden = true
                    print("hidden")
                }else{
                    self.emptyView.isHidden = false
                    print("show")
                }
                self.tableView.reloadData()
            }
            print(self.privateGroups)
            self.tableView.reloadData()
            break
        case .failure(_ ):
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
            print(response)
            for item in response {
                self.publicGroups.append(item)
            }
            print("public: \(self.publicGroups)")
            self.tableView.reloadData()
            break
        case .failure(_ ):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    // EASY SLIDE
    fileprivate func getEasySlide() -> ESNavigationController {
        return self.navigationController as! ESNavigationController
    }
    
    @objc internal func openLeftView(){
        self.getEasySlide().openMenu(.leftMenu, animated: true, completion: {})
    }
    // MARK: Getting
    internal func getMenuRevealType(_ menu: MenuType) -> RevealType{
        return self.leftRevealType
    }
    
    internal func getMenuSpeed(_ menu: MenuType) -> CGFloat{
        return self.leftSpeed
    }
    
    internal func getMenuPan(_ menu: MenuType) -> Bool{
        return self.leftCanPan
    }
    
    internal func getMenuShadow(_ menu: MenuType) -> Bool{
        return (self.currentMenu == .leftMenu)
    }
    
    internal func getMenuDisable(_ menu: MenuType) -> Bool{
        return (self.currentMenu == .leftMenu) ? self.leftEnabled : self.rightEnabled
    }
    
    internal func getMenuWidth(_ menu: MenuType) -> CGFloat{
        return leftWidth
    }
    
    // MARK: Setting
    
    internal func setMenuRevealType(_ menu: MenuType, value: RevealType){
        if(menu == .leftMenu){
            self.leftRevealType = value
        }
    }
    
    internal func setMenuSpeed(_ menu: MenuType, value: CGFloat){
        if(menu == .leftMenu){
            self.leftSpeed = value
        }
    }
    
    internal func setMenuPan(_ menu: MenuType, value: Bool){
        if(menu == .leftMenu){
            self.leftCanPan = value
        }
    }
    
    internal func setMenuShadow(_ menu: MenuType, value: Bool){
        if(menu == .leftMenu){
            self.leftShadowEnabled = value
        }
    }
    
    internal func setMenuDisable(_ menu: MenuType, value: Bool){
        if(menu == .leftMenu){
            self.leftEnabled = value
        } else {
            self.rightEnabled = value
        }
    }
    
    internal func setMenuWidth(_ menu: MenuType, value: CGFloat){
        if(menu == .leftMenu){
            self.leftWidth = value
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

