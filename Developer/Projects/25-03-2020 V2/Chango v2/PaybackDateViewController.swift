//
//  PaybackDateViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 19/03/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit

class PaybackDateViewController: BaseViewController {

    @IBOutlet weak var selectDate: UIButton!
    var amount: String = ""
    var groupId: String = ""
    var campaignId: String = ""
    var voteId: String = ""
    var paybackDate: String = ""
    var loanType: String = ""
    fileprivate var alertStyle: UIAlertController.Style = .actionSheet

    override func viewDidLoad() {
        super.viewDidLoad()

        showChatController()
        disableDarkMode()

    }
    

    @IBAction func selectDate(_ sender: UIButton) {
        let alert = UIAlertController(style: self.alertStyle, title: "Request Loan", message: "Select Date")
        let minDate = Date()
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: minDate, maximumDate: nil)
        { new in
            self.selectDate.setTitle(new.dateString(ofStyle: .medium), for: .normal)
            
            
            
            var day = ""
            var month = ""
            
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
            
            let year = new.year
            let dateString = "\(year)-\(month)-\(day)"
            
            
            
            self.paybackDate = dateString
            print(self.paybackDate)
            
        }
        alert.addAction(title: "Done", style: .cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if paybackDate == "" {
            
            let alert = UIAlertController(title: "Request Loan", message: "Please select a date to payback loan.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else {
        let vc: RequestLoanViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "description") as! RequestLoanViewController
            vc.amount = amount
            vc.paybackDate = paybackDate
            vc.loanType = loanType
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

