//
//  PublicCampaignContributionsViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 15/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class PublicCampaignContributionsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableVeiw: UITableView!
    @IBOutlet weak var contributionView: UIView!
    @IBOutlet weak var totalContributions: UILabel!
    @IBOutlet weak var contributionLabel: UILabel!
    
    var publicGroup: GroupResponse!
    var campaign: GetGroupCampaignsResponse!
    var groupContributions: CampaignContributionResponse!
    var campaignId: String = ""
    var campaignName: String = ""
    let cell = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()

        contributionView.layer.cornerRadius = 10
        contributionView.layer.shadowColor = UIColor.black.cgColor
        contributionView.layer.shadowOffset = CGSize(width: 2, height: 4)
        contributionView.layer.shadowRadius = 8
        contributionView.layer.shadowOpacity = 0.2
        
        tableVeiw.tableFooterView = UIView(frame: .zero)

        self.tableVeiw.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableVeiw.register(UINib(nibName: "CampaignsCell", bundle: nil), forCellReuseIdentifier: "CampaignsCell")
        
//        tableView.tableFooterView = UIView(frame: .zero)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = publicGroup.groupName
        self.navigationItem.titleView?.tintColor = UIColor.white
        print(publicGroup.groupName)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if groupContributions == nil {
            return 0
        }else {
            return groupContributions.content.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: CampaignsCell = self.tableVeiw.dequeueReusableCell(withIdentifier: "CampaignsCell", for: indexPath) as! CampaignsCell
        cell.selectionStyle = .none
        
        let campaignContributions = self.groupContributions.content[indexPath.row]
        
//        let dates = convertDateFormatter(date: "\(campaignContributions.created)")
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if campaignContributions.modified == nil {
            
            cell.memberDate.isHidden = true
        }else {
        
        let date = formatter.date(from: campaignContributions.modified!)
        
        
        
        formatter.dateStyle = DateFormatter.Style.medium
        
        _ = formatter.string(from: date as! Date)
            
            cell.memberDate.text = "\(date)"
            
        }
        
        
        if campaignContributions.amount == nil {
            totalContributions.text = "0.00"
            contributionLabel.text = "My Total Contributions (\(campaignContributions.currency))"
//            emptyView.isHidden = false
        }else {
            totalContributions.text = String(format:"%.2f", campaignContributions.campaignId.amountReceived!)
            contributionLabel.text = "My Total Contributions (\(campaignContributions.currency))"
        }
        
        let amount = String(format:"%.2f", campaignContributions.amount)
        

        
        
        cell.memberName.text = "\(campaignContributions.memberId.firstName) \(campaignContributions.memberId.lastName)"
        cell.memberAmount.text = amount
        
        return cell
    }

    
    @IBAction func makeContributionButtonAction(_ sender: UIBarButtonItem) {
        let vc: PublicCampaginContributeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "campaigncontributes") as! PublicCampaginContributeViewController
        
        vc.campaignId = campaignId
        vc.publicGroup = publicGroup
        vc.campaignName = campaignName
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

}
