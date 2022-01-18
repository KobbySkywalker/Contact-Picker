//
//  ExtendCampaignVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 17/12/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator

class ExtendCampaignVC: BaseViewController {

    @IBOutlet weak var campaignDateButton: UIButton!
    @IBOutlet weak var endCampaignDate: UIButton!
    
    fileprivate var alertStyle: UIAlertController.Style = .actionSheet
    
    var endDate = ""
    var endDateString = ""
    var campaignId: String = ""
    var groupId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func extendCampaignButton(_ sender: Any) {
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
    
    @IBAction func extendCampaignButtonAction(_ sender: Any) {
        if endDate == "" {
            showAlert(title: "Campaigns", message: "Please select extension date.")
        }else {
            let parameter : ExtendCampaignParameter = ExtendCampaignParameter(campaignId: campaignId, endDate: self.endDate, groupId: groupId)
        extendCampaign(extendCampaignParameter: parameter)
        FTIndicator.showProgress(withMessage: "extending date")
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
                self.dismiss(animated: true, completion: nil)
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
}
