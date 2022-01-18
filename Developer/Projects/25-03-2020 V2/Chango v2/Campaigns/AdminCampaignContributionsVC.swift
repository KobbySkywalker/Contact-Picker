//
//  AdminCampaignContributionsVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 09/12/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import Nuke
import FTIndicator

class AdminCampaignContributionsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, FZAccordionTableViewDelegate {

    @IBOutlet weak var campaignImage: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var amountReceivedLabel: UILabel!
    @IBOutlet weak var amountTargetLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var tableView: FZAccordionTableView!
    
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
        
        campaignNameLabel.text = campaignName
        campaignImage.image = UIImage(named: "defaulticon")
        campaignImage.contentMode = .scaleAspectFit
        amountReceivedLabel.text = "\(currency)\(formatNumber(figure: campaignInfo.amountReceived!))"
        amountTargetLabel.text = "\(currency)\(formatNumber(figure: campaignInfo.target!))"
        createdLabel.text = "Created on \(dateConversion(dateValue: campaignInfo.created))"
        
        var endDate = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if campaignInfo.end == "" || campaignInfo.end == nil {
        
        }else {
        endDate = formatter.date(from: self.campaignInfo.end!)!
        
        
        
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

    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        formatter.locale = Locale.autoupdatingCurrent
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
}
