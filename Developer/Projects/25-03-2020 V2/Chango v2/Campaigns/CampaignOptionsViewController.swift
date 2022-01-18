//
//  CampaignOptionsViewController.swift
//  Chango v2
//
//  Created by Hosny Savage on 29/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator
import Alamofire
import Nuke

class CampaignOptionsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, FZAccordionTableViewDelegate {

    

    @IBOutlet weak var campaignImage: UIImageView!
    @IBOutlet weak var campaignDescription: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var amountRaisedLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var tableView: FZAccordionTableView!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var contributeButton: UIButton!
    
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var endCampaignView: UIView!
    @IBOutlet weak var endCampaignDate: UIButton!
    @IBOutlet weak var campaignStatusLabel: UILabel!
    @IBOutlet weak var pausePlayCampaignLabel: UILabel!
    @IBOutlet weak var campStat: UILabel!
    @IBOutlet weak var stopCampaignLabel: UILabel!
    
    fileprivate var alertStyle: UIAlertController.Style = .actionSheet
    var campaignViewController: CampaignsViewController!
    
    var campaignName: String = ""
    var campaignDesc: String = ""
    var campaignId: String = ""
    var paused: Bool = false
    var campaignStatus: String = ""
    var campaignType: String = ""
    var campaignEnd: String = ""
    var isAdmin: String = ""
    var endDate = ""
    var endDateString = ""
    var groupId: String = ""
    var currency: String = ""
    var maxSingleContributeLimit: Double = 0.0
    var expiredCampaign: Bool = true
    
    let cellReuseIdentifier = "MyCell"
    let sectionHeaderReuseIdentifier = "MySectionHeader"
    
    var campaignContributions: [ContributionSections] = []
    var campaignContribution: [GetCampaignContributionResponse] = []
    var contributions: [ContributionSections] = []
    var campaignInfo: GetGroupCampaignsResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showChatController()
        disableDarkMode()
        if campaignDesc == "null" {
            campaignDescription.text = "No Campaign Description"
        }else {
            campaignDescription.text = "The purpose of this campaign: \(campaignDesc)"
        }
        campaignNameLabel.text = campaignName
        campaignImage.image = UIImage(named: "defaulticon")
        campaignImage.contentMode = .scaleAspectFit
        amountRaisedLabel.text = "\(currency) \(campaignInfo.amountReceived!)"
        totalAmountLabel.text = "\(currency) \(campaignInfo.target!)"
        createdDateLabel.text = "Created on \(dateConversion(dateValue: campaignInfo.created))"
        
        let parameter: GroupLimitsParamter = GroupLimitsParamter(groupId: groupId)
        retrieveGroupLimits(groupLimitsParameter: parameter)
        
        var endDate = Date()
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        print("type: \(campaignInfo.campaignType)")

        if campaignInfo.campaignType == "perpetual" {
            daysLeftLabel.text = "Perpetual"
        }else{
            
            if campaignInfo.end == nil {
                print("end date nil")
            }else{
        endDate = formatter.date(from: self.campaignInfo.end!)!
            }
        
        
        formatter.dateStyle = DateFormatter.Style.medium
        _ = formatter.string(from: endDate as! Date)
        daysLeftLabel.text = "\(daysLeft(endDate)) left"
        
        print("end: \(campaignInfo.end) \(campaignInfo.created)")
        }
        progressBar.progress = Float(campaignInfo.amountReceived!/campaignInfo.target!)
        
        
        tableView.allowMultipleSectionsOpen = true
        tableView.register(UINib(nibName: "MenuSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: MenuSectionHeaderView.kAccordionHeaderViewReuseIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: "DetailedContributionCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.tableFooterView = UIView()
        
        campaignComputation(campaignContribution: campaignContribution)
        
        if expiredCampaign == true {
            contributeButton.isHidden = true
        }

    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func contributeButtonAction(_ sender: Any) {
//        let vc: ContributeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contribute") as! ContributeViewController
        
        let vc: WalletsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wallets") as! WalletsVC
                
        vc.campaignId = campaignInfo.campaignId
//        vc.voteId = cashoutVoteId
//        vc.network = network
        vc.groupNamed = campaignInfo.campaignName
        vc.currency = currency
        vc.groupId = groupId
        vc.maxSingleContributionLimit = maxSingleContributeLimit
        vc.contribution = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sendStatementButtonAction(_ sender: UIButton) {
        let vc: SendStatementViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "send") as! SendStatementViewController
            vc.groupId = groupId
            vc.groupName = campaignName
            vc.statementType = "MEMBER"
            vc.campaignStatement = true
            vc.campaignId = campaignInfo.campaignId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

    }
        
    @IBAction func extendDatePicker(_ sender: UIButton) {
        let alert = UIAlertController(style: self.alertStyle, title: "Extend Campaign", message: "Select Date")
        let minDate = Date()
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: minDate, maximumDate: nil)
        { new in
            self.endCampaignDate.setTitle(new.dateString(ofStyle: .medium), for: .normal)
            var day = ""
            var month = ""
            var hour = ""
            var min = ""
            var sec = ""
            //MONTH
            //            var month = ""
            var monthValue = new.month
            if(monthValue < 10){
                month = "0\(monthValue)"
            }else{
                month = "\(monthValue)"
            }
            //DAY
            var dayValue = new.day
            if(dayValue < 10){
                day = "0\(dayValue)"
            }else{
                day = "\(dayValue)"
            }
            //HOUR
            let hourValue = new.hour
            if(hourValue < 10){
                hour = "0\(hourValue)"
            }else{
                hour = "\(hourValue)"
            }
            //MINUTES
            let minuteValue = new.minute
            if(minuteValue < 10){
                min = "0\(minuteValue)"
            }else{
                min = "\(minuteValue)"
            }
            //SECONDS
            let secondValue = new.second
            if(secondValue < 10){
                sec = "0\(secondValue)"
            }else{
                sec = "\(secondValue)"
            }

            let year = new.year
            let dateString = "\(year)-\(month)-\(day)"
            self.endDateString = "\(year)-\(month)-\(day)"
            self.endDate = dateString
            print(self.endDate)
            print("dateString \(dateString)")
        }
        alert.addAction(title: "Done", style: .cancel)
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let result = formatter.string(from: date)
            self.endDate = result
            print("date: \(result)")
            formatter.dateStyle = .medium
            print("resu: \(result)")
            self.endCampaignDate.setTitle(date.dateString(ofStyle: .medium), for: .normal)
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as! UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func extendCampaignButtonAction(_ sender: UIButton) {
        if endDate == "" {
            showAlert(title: "Campaigns", message: "Please select extension date.")
        }else {
            let parameter : ExtendCampaignParameter = ExtendCampaignParameter(campaignId: campaignId, endDate: self.endDate, groupId: groupId)
        extendCampaign(extendCampaignParameter: parameter)
        FTIndicator.showProgress(withMessage: "extending date")
        }
    }
    
    @IBAction func stopButtonAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Stop Campaign", message: "Are you sure you want to stop this campaign?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "YES", style: .default) { (action: UIAlertAction!) in
            FTIndicator.showProgress(withMessage: "stopping")
            let parameter : EndCampaignParameter = EndCampaignParameter(campaignId: self.campaignId)
            self.endCampaign(endCampaignParameter: parameter)
        }
        let noAction = UIAlertAction(title: "NO", style: .default) { (action: UIAlertAction!) in
        }
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func pauseButtonAction(_ sender: UIButton) {
        if campaignStatus == "running" {
            let alert = UIAlertController(title: "Pause Campaign", message: "Are you sure you want to pause this campaign?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "YES", style: .default) { (action: UIAlertAction!) in
                let parameter : PauseCampaignParameter = PauseCampaignParameter(campaignId: self.campaignId)
                self.pauseCampaign(pauseCampaignParameter: parameter)
            }
            let noAction = UIAlertAction(title: "NO", style: .default) { (action: UIAlertAction!) in
            }
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }else if campaignStatus == "pause" {
            let alert = UIAlertController(title: "Resume Campaign", message: "Are you sure you want to resume this campaign?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "YES", style: .default) { (action: UIAlertAction!) in
                let parameterr: StartCampaignParameter = StartCampaignParameter(campaignId: self.campaignId)
                self.startCampaign(startCampaignParameter: parameterr)
            }
            let noAction = UIAlertAction(title: "NO", style: .default) { (action: UIAlertAction!) in
            }
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contributions[section].contribution.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contributions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MenuSectionHeaderView.kDefaultAccordionHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.tableView(tableView, heightForHeaderInSection:section)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailedContributionCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! DetailedContributionCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        
        cell.amount.text = "\(contributions[indexPath.section].contribution[indexPath.row].amount)"
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let date = formatter.date(from: self.contributions[indexPath.section].contribution[indexPath.row].created)
        
        let dates = dayDifference(from: date!)

        formatter.dateStyle = DateFormatter.Style.medium
        
        cell.date.text = dates
                
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: MenuSectionHeaderView.kAccordionHeaderViewReuseIdentifier) as! MenuSectionHeaderView
        
        let url = URL(string: contributions[section].memberIconPath)
        print("url: \(String(describing: url))")
        sectionHeader.img.image = nil
        if(contributions[section].memberIconPath == "nil"){
            if(contributions[section].memberIconPath == ""){
                print("ha")
                print(contributions[section].memberIconPath+" : No Image")
                sectionHeader.img.image = UIImage(named: "individual")
            }
        }else {
            if url == nil {
                sectionHeader.img.image = UIImage(named: "individual")
            }else {
                Nuke.loadImage(with: url!, into: sectionHeader.img)
                print("url: \(url!)")
            }
        }
        let user: String! = UserDefaults.standard.string(forKey: "users")
        if user == "\(contributions[section].firstName) \(contributions[section].lastName)" {
            sectionHeader.sectionTitleLabel.text = "You"
        }else {
            sectionHeader.sectionTitleLabel.text = "\(contributions[section].firstName) \(contributions[section].lastName)"
        }
        sectionHeader.amount.text = String(format: "%0.2f", contributions[section].totalAmount)
        print("arrow changed")
        return sectionHeader
    }
    
    //START CAMPAIGN
    func startCampaign(startCampaignParameter: StartCampaignParameter) {
        AuthNetworkManager.startCampaign(parameter: startCampaignParameter) { (result) in
            self.parseStartCampaignResponse(result: result)
        }
    }
    
    private func parseStartCampaignResponse(result: DataResponse<GetGroupCampaignsResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            pauseButton.setImage(UIImage(named: "paused"), for: .normal)
            pausePlayCampaignLabel.text = "Pause Campaign"
            campaignStatus = "running"
            campStat.text = "Active"
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: CampaignsViewController.self){
                    (controller as! CampaignsViewController).groupCreated = true
                    break
                }
            }
            break
        case .failure(let error):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    
    //PAUSE CAMPAIGN
    func pauseCampaign(pauseCampaignParameter: PauseCampaignParameter) {
        AuthNetworkManager.pauseCampaign(parameter: pauseCampaignParameter) { (result) in
            self.parsePauseCampaignResponse(result: result)
        }
    }
    
    private func parsePauseCampaignResponse(result: DataResponse<GetGroupCampaignsResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            pauseButton.setImage(UIImage(named: "played"), for: .normal)
            pausePlayCampaignLabel.text = "Start Campaign"
            campaignStatus = "pause"
            campStat.text = "pause"
//            groupCreated = true
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: CampaignsViewController.self){
                    (controller as! CampaignsViewController).groupCreated = true
//                    self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
            }
            break
        case .failure(let error):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    //END CAMPAIGN
    func endCampaign(endCampaignParameter: EndCampaignParameter) {
        AuthNetworkManager.endCampaign(parameter: endCampaignParameter) { (result) in
            self.parseEndCampaignResponse(result: result)
        }
    }
    
    private func parseEndCampaignResponse(result: DataResponse<GetGroupCampaignsResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            let alert = UIAlertController(title: "Chango", message: "This campaign has been stopped successfully.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: CampaignsViewController.self){
                        (controller as! CampaignsViewController).groupCreated = true
                        break
                    }
                }
            self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            break
        case .failure( _):
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
    
    
    //EXTEND CAMPAIGN
    func extendCampaign(extendCampaignParameter: ExtendCampaignParameter) {
        AuthNetworkManager.extendCampaign(parameter: extendCampaignParameter) { (result) in
            self.parseExtendCampaignResponse(result: result)
        }
    }
    
    private func parseExtendCampaignResponse(result: DataResponse<GetGroupCampaignsResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            let alert = UIAlertController(title: "Chango", message: "Campaign has been extended successfully.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in

                let formatter = DateFormatter()
                formatter.timeZone = NSTimeZone(name: "UTC") as? TimeZone
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let date = formatter.date(from: response.end!)
                
                formatter.dateStyle = DateFormatter.Style.medium
                _ = formatter.string(from: date!)
                let dates = timeFromDate(date!)
                self.endCampaignDate.setTitle(dates, for: .normal)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
                
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    
    func campaignComputation(campaignContribution: [GetCampaignContributionResponse]){
        for i in 0 ..< campaignContribution.count {
            let contributorsFirstName = contributions.map { return $0.firstName }
            let contributorsLastName = contributions.map { return $0.lastName }
            let memId = contributions.map { return $0.memberId }

            
            print(contributorsLastName)
            print(contributorsFirstName)
            
            if (contributorsFirstName.contains(campaignContribution[i].memberId.firstName) && contributorsLastName.contains(campaignContribution[i].memberId.lastName ?? "null") && memId.contains(campaignContribution[i].memberId.memberId!)) {
                let filteredArray = contributions.filter { $0.firstName  == campaignContribution[i].memberId.firstName && $0.lastName == campaignContribution[i].memberId.lastName && $0.memberId == campaignContribution[i].memberId.memberId!}
                
                if (filteredArray.count != 0) {
                    let item = filteredArray.first!
                    item.contribution.append(campaignContribution[i])
                    if (campaignContribution[i].memberId.memberIconPath) == nil {
                        item.memberIconPath.append("")
                    }else {
                        item.memberIconPath = (campaignContribution[i].memberId.memberIconPath!)
                    }
                    var totalAmount: Double = 0.0
                    for i in 0 ..< item.contribution.count {
                        totalAmount = totalAmount + item.contribution[i].amount
                    }
                    item.totalAmount = totalAmount
                    print("C C: \(item)")
                    print(totalAmount)
                }
            }else {
                let section = ContributionSections()
                section.firstName = campaignContribution[i].memberId.firstName
                section.lastName = campaignContribution[i].memberId.lastName ?? "null"
                section.memberId = campaignContribution[i].memberId.memberId!
                section.contribution.append(campaignContribution[i])
                section.totalAmount = campaignContribution[i].amount
                if (campaignContribution[i].memberId.memberIconPath) == nil {
                    section.memberIconPath = ""
                }else {
                    section.memberIconPath = (campaignContribution[i].memberId.memberIconPath!)
                }
                contributions.append(section)
                print("campaignContributions: \(contributions)")
            }
//            if campaignContribution[i].campaignId.amountReceived == nil {
//                totalContributions.text = "\(privateGroup.countryId.currency)0.00"
//                emptyView.isHidden = false
//            }else {
//                totalContributions.text = "\(privateGroup.countryId.currency) \(String(format:"%0.2f",  campaignContribution[i].campaignId.amountReceived!))"
//            }
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
