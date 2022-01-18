//
//  PublicReportCampaignVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 06/12/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator
import Alamofire

class PublicReportCampaignVC: BaseViewController {

    var campaignId: String = ""
    
    @IBOutlet weak var reportStatementTextField: ACFloatingTextfield!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableDarkMode()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendReportButtonAction(_ sender: Any) {
        if reportStatementTextField.text!.isEmpty {
            showAlert(title: "Report Campaign", message: "Please enter a reason for report.")
        }else {
        let parameter: ReportPublicCampaignParameter = ReportPublicCampaignParameter(anonymous: "false", campaignId: self.campaignId, message: reportStatementTextField.text!)
        self.reportPublicCampaign(reportPublicCampaignParamter: parameter)
        }
    }
    
    //REPORT PRIVATE GROUP
    func reportPublicCampaign(reportPublicCampaignParamter: ReportPublicCampaignParameter) {
        AuthNetworkManager.reportPublicCampaign(parameter: reportPublicCampaignParamter) { (result) in
            self.parseReportPublicCampaign(result: result)
        }
    }
    
    
    private func parseReportPublicCampaign(result: DataResponse<ReportCampaign, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            
            let alert = UIAlertController(title: "Chango", message: "Your report has been submitted successfully.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            break
        case .failure(let error):
            
            if (result.response?.statusCode == 400) {
                
                sessionTimeout()
                
            }else if result.response?.statusCode == 404{
                
                let alert = UIAlertController(title: "Chango", message: "Your report has been submitted successfully.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                    self.navigationController?.popViewController(animated: true)
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                
            }else{
            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            }
        }
    }

}
