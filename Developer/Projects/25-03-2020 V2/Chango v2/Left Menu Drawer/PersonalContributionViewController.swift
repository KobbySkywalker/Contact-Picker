//
//  PersonalContributionViewController.swift
//  
//
//  Created by Hosny Ben Savage on 24/01/2019.
//

import UIKit
import Alamofire
import FTIndicator
import Nuke
import ESPullToRefresh

class PersonalContributionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let groups = ["Elikem's Wedding", "Alice Birthday", "Korle Bu Children's Ward"]
    let amount = ["GHS 50.00", "GHS 35.00", "GHS 100.00"]
    let date = ["Aug 28", "Mar 23", "Nov 16"]
    let cell = "cellId"
    var page: Int = 1
    
    var personalContributions: CampaignContributionResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableView.register(UINib(nibName: "PersonalContributionCell", bundle: nil), forCellReuseIdentifier: "PersonalContributionCell")
        
        self.tableView.tableFooterView = UIView()
        
        let parameter: PersonalContributionsParameter = PersonalContributionsParameter(offset: "\(self.page)", pageSize: "10")
        getMoreData(personalContributionsParameter: parameter)
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        let vc: SettingsTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settings") as! SettingsTableViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personalContributions.content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        
        var date = formatter.date(from: self.personalContributions.content[indexPath.row].created)
        
        
        
        formatter.dateStyle = DateFormatter.Style.medium
        
        _ = formatter.string(from: date as! Date)
        
        
            let cell: PersonalContributionCell = self.tableView.dequeueReusableCell(withIdentifier: "PersonalContributionCell", for: indexPath) as! PersonalContributionCell
            cell.selectionStyle = .none
        
            let myPersonalContributions = self.personalContributions.content[indexPath.row]

            cell.groupImage.image = nil
        
        let dates = timeAgoSinceDate(date!)

        if(myPersonalContributions.groupId.groupIconPath == "<null>") || (myPersonalContributions.groupId.groupIconPath == nil) || (myPersonalContributions.groupId.groupIconPath == "") {
            cell.groupImage.image = UIImage(named: "people")
            
        }else {
                    let url = URL(string: myPersonalContributions.groupId.groupIconPath!)
                    Nuke.loadImage(with: url!, into: cell.groupImage)
        }
        
        if myPersonalContributions.campaignId.campaignName == "Contributions" {
            cell.groupName.text = myPersonalContributions.groupId.groupName
        }else{
        cell.groupName.text = myPersonalContributions.campaignId.campaignName
        }
        
        cell.amountContributed.text = "\(myPersonalContributions.campaignId.amountReceived!)"
        
//        if self.personalContributions.content[indexPath.row].modified == nil {
//            cell.groupDate.text = "nil"
//        }else {
            cell.groupDate.text = dates

//        }
        return cell

            }
    
    func getMoreData(personalContributionsParameter: PersonalContributionsParameter) {
        AuthNetworkManager.personalContributions(parameter: personalContributionsParameter) { (result) in
            self.parsePersonalContributionsResponse(result: result)
        }
    }
    
    
    func parsePersonalContributionsResponse(result: DataResponse<CampaignContributionResponse, AFError>) {
        self.tableView.es.addInfiniteScrolling {
            [unowned self] in
            let parameter: PersonalContributionsParameter = PersonalContributionsParameter(offset: "\(self.page)", pageSize: "50")
            self.getMoreData(personalContributionsParameter: parameter)
            switch result.result {
            case .success(let response):
                self.personalContributions.content.append(response.content)
                self.tableView.reloadData()
                self.page = self.page + 1
                
                if response.last == true {
                    self.tableView.es.stopLoadingMore()
                }
                break
            case .failure(let error):
                
                if result.response?.statusCode == 400 {
                    
                    self.sessionTimeout()
                    
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
    
    
    //PERSONAL CONTRIBUTIONS
//    func getPersonalContributionsParameter(personalContributionsParameter: PersonalContributionsParameter) {
//        AuthNetworkManager.personalContributions(parameter: personalContributionsParameter) { (result) in
//            self.parsePersonalContributionsResponse(result: result)
//        }
//    }
    
//    private func parsePersonalContributionsResponse(result: DataResponse<CampaignContributionResponse>){
//        FTIndicator.dismissProgress()
//        switch result.result {
//        case .success(let response):
//            print("response: \(response)")
//            //            for item in response {
//            //                self.groupContributions.append(item)
//            //             }
//            let vc: PersonalContributionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "personal") as! PersonalContributionViewController
//
//            vc.personalContributions = response
//
//            self.navigationController?.pushViewController(vc, animated: true)
//
//
//
//            break
//        case .failure(let error):
//
//            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(error: error), preferredStyle: .alert)
//
//            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//            }
//
//            alert.addAction(okAction)
//
//            self.present(alert, animated: true, completion: nil)
//        }
//    }

    

            

}
