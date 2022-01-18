//
//  MyRecentContributionsViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 17/06/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Nuke

class MyRecentContributionsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, FZAccordionTableViewDelegate {

    
    @IBOutlet weak var fzTableView: FZAccordionTableView!

    @IBOutlet weak var emptyView: UIView!
    
    let cellReuseIdentifier = "MyCell"
    let sectionHeaderReuseIdentifier = "MySectionHeader"
    
    var myRecentContributions: [GetCampaignContributionResponse] = []
    var groupContribution: [GetCampaignContributionResponse] = []
    var contributions: [RecentContributionSections] = []
    var contribution: [contribution] = []
    var group: [String] = []
    var contributionsCount: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        showChatController()
        disableDarkMode()
        fzTableView.allowMultipleSectionsOpen = true
        fzTableView.register(UINib(nibName: "MenuSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: MenuSectionHeaderView.kAccordionHeaderViewReuseIdentifier)
        fzTableView.register(UINib(nibName: "DetailedContributionCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        fzTableView.register(UINib(nibName: "RecentPersonalDetails", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        fzTableView.tableFooterView = UIView(frame: .zero)
        myRecentContributions = myRecentContributions.sorted(by: {$0.modified > $1.modified})
        campaignComputation(campaignContribution: myRecentContributions)
    }
    
    @IBAction func menuButtonAction(_ sender: Any) {
        self.getEasySlide().openMenu(.leftMenu, animated: true, completion: {})
    }
    
    // EASY SLIDE
    fileprivate func getEasySlide() -> ESNavigationController {
        return self.navigationController as! ESNavigationController
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contributions[section].contribution.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contributions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50.0
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
        
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        contributions[indexPath.section].contribution = contributions[indexPath.section].contribution.sorted(by: {$0.created > $1.created})

        let date = formatter.date(from: self.contributions[indexPath.section].contribution[indexPath.row].created)

        let dates = dayDifference(from: date!)
        
        formatter.dateStyle = DateFormatter.Style.medium
        
//        let cell: DetailedContributionCell = self.fzTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! DetailedContributionCell

        let cell: RecentPersonalDetails = self.fzTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! RecentPersonalDetails
        cell.campaignAmount.text = "\(contributions[indexPath.section].contribution[indexPath.row].displayAmount)"
        cell.campaignName.text = "\(contributions[indexPath.section].contribution[indexPath.row].campaignId.campaignName)"
        print("campaign name: \(contributions[indexPath.section].contribution[indexPath.row].campaignId.campaignName)")
        cell.date.text = dates
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = fzTableView.dequeueReusableHeaderFooterView(withIdentifier: MenuSectionHeaderView.kAccordionHeaderViewReuseIdentifier) as! MenuSectionHeaderView
        sectionHeader.sectionTitleLabel.text = contributions[section].groupName
        if(contributions[section].groupIconPath == nil) || (contributions[section].groupIconPath == "nil") || (contributions[section].groupIconPath == ""){
                sectionHeader.img.image = UIImage(named: "defaulticon")
        }else {
            let url = URL(string: contributions[section].groupIconPath)
            print("image: \(url)")
            if (url == nil) {
                sectionHeader.img.image = UIImage(named: "defaulticon")
            }else {
            Nuke.loadImage(with: url!, into: sectionHeader.img)
            }
        }

        
        sectionHeader.amount.isHidden = true
        
        
        return sectionHeader
    }
    
    func tableView(_ tableView: FZAccordionTableView, didOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        print("did open")
        let sectionHeader = fzTableView.dequeueReusableHeaderFooterView(withIdentifier: MenuSectionHeaderView.kAccordionHeaderViewReuseIdentifier) as! MenuSectionHeaderView
        
        sectionHeader.arrowImageView.isHighlighted = true
        sectionHeader.arrowImageView.image = UIImage(named: "closeup")
    }
    
    
    func campaignComputation(campaignContribution: [GetCampaignContributionResponse]){
        for i in 0 ..< campaignContribution.count {
            let contributorsFirstName = contributions.map { return $0.groupName }
            let memId = contributions.map { return $0.groupId }
            
            print(contributorsFirstName)
            
            if (contributorsFirstName.contains(campaignContribution[i].groupId.groupName) && memId.contains(campaignContribution[i].groupId.groupId)) {
                let filteredArray = contributions.filter { $0.groupName  == campaignContribution[i].groupId.groupName && $0.groupId == campaignContribution[i].groupId.groupId}
                
                if (filteredArray.count != 0) {
                    let item = filteredArray.first!
                    item.contribution.append(campaignContribution[i])
                    if (campaignContribution[i].groupId.groupIconPath) == nil {
                        item.groupIconPath.append("")
                    }else {
                        item.groupIconPath = (campaignContribution[i].groupId.groupIconPath!)
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
                let section = RecentContributionSections()
                section.groupName = campaignContribution[i].groupId.groupName
                section.groupId = campaignContribution[i].groupId.groupId
                section.contribution.append(campaignContribution[i])
                section.totalAmount = campaignContribution[i].amount
                if (campaignContribution[i].groupId.groupIconPath) == nil {
                    section.groupIconPath = ""
                }else {
                    section.groupIconPath = (campaignContribution[i].groupId.groupIconPath!)
                }
                contributions.append(section)
                print("campaignContributions: \(contributions)")
            }
            fzTableView.reloadData()
            if (contributions.count > 0) {
                emptyView.isHidden = true
            }else{
                emptyView.isHidden = false
            }
        }
    }

}
