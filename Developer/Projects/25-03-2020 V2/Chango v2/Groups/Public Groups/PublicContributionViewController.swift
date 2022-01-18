//
//  PublicContributionViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 26/02/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import PopupDialog
import FirebaseDatabase
import FirebaseAuth

class PublicContributionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var totalContributionsLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var publicGroup: GroupResponse!
    var myPublicGroupContributions: [Content] = []
    var campaignId: String = ""
    let cellReuseIdentifier = "MyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        tableView.register(UINib(nibName: "PublicContributionsCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.tableFooterView = UIView()
        
        FTIndicator.showProgress(withMessage: "loading")
        let parameters: memberContributionsParameter = memberContributionsParameter(campaignId: campaignId)
        memberContributions(memberContributionsParameters: parameters)

    }

    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPublicGroupContributions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let yourContributions = myPublicGroupContributions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PublicContributionsCell
        cell.amountLabel.text = yourContributions.displayAmount
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = formatter.date(from: yourContributions.created)!
        let dates = dayDifference(from: date)
        cell.dateLabel.text = dates

        
        return cell
    }
    
    // MEMBER CONTRIBUTIONS
    func memberContributions(memberContributionsParameters: memberContributionsParameter) {
        AuthNetworkManager.memberContributions(parameter: memberContributionsParameters) { (result) in
            self.parseMemberContributionsResponse(result: result)
        }
    }
    
    private func parseMemberContributionsResponse(result: DataResponse<[Content], AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("mem response: \(response)")

            self.myPublicGroupContributions = response
            for item in response {
                totalContributionsLabel.text = "Total Contributios(\(item.currency))"
            }
            
            var summy: Double = 0.0
            for i in 0 ..< self.myPublicGroupContributions.count {
                summy = summy + self.myPublicGroupContributions[i].amount
                print("sum: \(summy)")
            }
            let twoDeciSum = String(format: "%.2f", summy)
                self.totalAmountLabel.text = "\(twoDeciSum)"
        
            tableView.reloadData()
            
            break
        case .failure(_):
            
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
