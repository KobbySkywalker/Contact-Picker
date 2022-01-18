//
//  RecurringPaymentsVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 06/09/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Alamofire
import FTIndicator
import PopupDialog

class RecurringPaymentsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mandateHistoryTableView: UITableView!
    @IBOutlet weak var cancelMandateButton: UIButton!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var emptyViewLabel: UILabel!
    @IBOutlet weak var activeMandatesButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    
    typealias FetchMandateCompletionHandler = (_ user: [Mandate]) -> Void
    
    var userMandates : [Mandate] = []
    var mandateHistory: [Mandate] = []
    var activeMandates: [Mandate] = []
    var mandateIds: [String] = []
    var mandateDate: String = ""
    var mandateCreated: String = ""
    
    var activeMandate: [Mandate] = [Mandate(amount_: "100", campaignName_: "test", created_: "22 Nov", currency_: "GHS", duration_: "10", expired_: "", frequencyType_: "", groupName_: "Group Test", lastDebitDate_: "18 Jul", mandateId_: "24345", modified_: "10 Sep", msisdn_: "0544524329", status_: "active", thirdPartyReferenceNo_: "dsfewofwew")]
    
    let cell = "cellId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()

        self.title = "My Recurring Payments"
        
        fetchMandate { (result) in
            self.userMandates = []
            self.userMandates = result
            print("user mandates: \(self.userMandates)")
            self.activeMandates = []
            self.mandateHistory = []
            for item in self.userMandates {

                self.mandateIds.append(item.mandateId ?? "nil")

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
                
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS"
                
                if let newDate = dateFormatter.date(from: item.expired) {
                    if (Date() < newDate) && (item.status != "cancelled") {
                        self.activeMandates.append(item)
                        print("not expired: \(item.expired)")

                    }else if (item.status == "cancelled") || (Date() > newDate){
                        self.mandateHistory.append(item)
                        print("expired: \(item.expired)")

                    }
                    
                }else if let newDate = dateFormatter1.date(from: item.expired){
                    if (Date() < newDate) && (item.status == "created"){
                        self.activeMandates.append(item)
                        print("diff not expired: \(item.expired)")

                    }else if (item.status == "cancelled") || (Date() > newDate) {
                        self.mandateHistory.append(item)
                        print("diff expired: \(item.expired)")

                    }
                }
                
                
            }
            print("mandate ids: \(self.mandateIds)")
            print("mandate histroy: \(self.mandateHistory)")
            self.userMandates = self.userMandates.sorted(by: { $0.lastDebitDate > $1.lastDebitDate})
            self.mandateHistory = self.mandateHistory.sorted(by: { $0.lastDebitDate > $1.lastDebitDate})
            self.activeMandates = self.activeMandates.sorted(by: { $0.lastDebitDate > $1.lastDebitDate})
            
            if self.userMandates.count == 0 {
                print("hide view")
                self.emptyView.isHidden = false
                self.emptyViewLabel.text = "You have no recurring payments set up"
            }
            
            self.tableView.reloadData()
            self.mandateHistoryTableView.reloadData()
                        
        }
                
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableView.register(UINib(nibName: "MandateCell", bundle: nil), forCellReuseIdentifier: "MandateCell")
        self.tableView.register(UINib(nibName: "RecurringPaymentsVC", bundle: nil), forCellReuseIdentifier: "RecurringPaymentsVC")
        
        self.mandateHistoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.mandateHistoryTableView.register(UINib(nibName: "MandateCell", bundle: nil), forCellReuseIdentifier: "MandateCell")
        self.mandateHistoryTableView.register(UINib(nibName: "RecurringPaymentsVC", bundle: nil), forCellReuseIdentifier: "RecurringPaymentsVC")
        
        tableView.tableFooterView = UIView()
        mandateHistoryTableView.tableFooterView = UIView()
                
        
        self.tableView.es.addPullToRefresh {
            [unowned self] in
            self.callFetchMandate()
            self.tableView.es.stopPullToRefresh()
            self.tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
        }
        
    }
    
    
    @IBAction func segmentedControlActn(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            tableView.isHidden = false
            mandateHistoryTableView.isHidden = true
            if activeMandates.count > 0 {
                self.emptyView.isHidden = true
                cancelMandateButton.isHidden = false
            }else {
                self.emptyView.isHidden = false
                cancelMandateButton.isHidden = true
                emptyViewLabel.text = "No active mandate(s) available"
            }
            break
        case 1:
            tableView.isHidden = true
            mandateHistoryTableView.isHidden = false
            cancelMandateButton.isHidden = true
            if mandateHistory.count > 0 {
                self.emptyView.isHidden = true
            }else {
                self.emptyView.isHidden = false
                emptyViewLabel.text = "No mandate history available"
            }
            break
        default:
            break
        }
    }
    
    @IBAction func activeMandatesButtonAction(_ sender: Any) {
        activeMandatesButton.setTitleColor(UIColor(hexString: "#F14439"), for: .normal)
        historyButton.setTitleColor(UIColor(hexString: "#05406F"), for: .normal)
        tableView.isHidden = false
        mandateHistoryTableView.isHidden = true
        if activeMandates.count > 0 {
            self.emptyView.isHidden = true
            cancelMandateButton.isHidden = false
        }else {
            self.emptyView.isHidden = false
            cancelMandateButton.isHidden = true
            emptyViewLabel.text = "No active mandate(s) available"
        }
    }
    
    @IBAction func historyButtonAction(_ sender: Any) {
        historyButton.setTitleColor(UIColor(hexString: "#F14439"), for: .normal)
        activeMandatesButton.setTitleColor(UIColor(hexString: "#05406F"), for: .normal)
        tableView.isHidden = true
        mandateHistoryTableView.isHidden = false
        cancelMandateButton.isHidden = true
        if mandateHistory.count > 0 {
            self.emptyView.isHidden = true
        }else {
            self.emptyView.isHidden = false
            emptyViewLabel.text = "No mandate history available"
        }
    }
    
    
    @IBAction func cancelAllMandates(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Recurring Payments", message: "Are you sure you want to cancel all mandates?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes, Cancel", style: .default) { (action: UIAlertAction!) in
            
            let parameter: [String] = self.mandateIds
            self.cancelAllMandates(cancelAllMandatesParameter: parameter)
            
        }
        
        let cancelAction = UIAlertAction(title: "DISMISS", style: .default) { (action: UIAlertAction!) in
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func slideMenu(_ sender: UIBarButtonItem) {
        self.getEasySlide().openMenu(.leftMenu, animated: true, completion: {})
        
    }
    
    
    @IBAction func slideMenuAction(_ sender: Any) {
        self.getEasySlide().openMenu(.leftMenu, animated: true, completion: {})
    }
    
    func callFetchMandate(){
            self.userMandates = []
        fetchMandate { (result) in
            self.userMandates = result
            print("user mandates: \(self.userMandates)")
            self.activeMandates = []
            self.mandateHistory = []
            for item in self.userMandates {
                self.mandateIds.append(item.mandateId ?? "nil")

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
                
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS"
                
                if let newDate = dateFormatter.date(from: item.expired) {
                    if (Date() < newDate) && (item.status != "cancelled"){
                        self.activeMandates.append(item)
                        print("not expired: \(item.expired)")

                    }else if (item.status == "cancelled") || (Date() > newDate){
                        self.mandateHistory.append(item)
                        print("expired: \(item.expired)")

                    }
                                        
                    
                }else if let newDate = dateFormatter1.date(from: item.expired){
                    if (Date() < newDate) && (item.status != "cancelled") {
                        self.activeMandates.append(item)
                        print("diff not expired: \(item.expired)")

                    }else if (item.status == "cancelled") || (Date() > newDate) {
                        self.mandateHistory.append(item)
                        print("diff expired: \(item.expired)")

                    }
                }
                
                
            }
            print("mandate ids: \(self.mandateIds)")
            print("mandate histroy: \(self.mandateHistory)")
            self.userMandates = self.userMandates.sorted(by: { $0.lastDebitDate > $1.lastDebitDate})
            self.mandateHistory = self.mandateHistory.sorted(by: { $0.lastDebitDate > $1.lastDebitDate})
            self.activeMandates = self.activeMandates.sorted(by: { $0.lastDebitDate > $1.lastDebitDate})
            
            if self.userMandates.count == 0 {
                print("hide view")
                self.emptyView.isHidden = false
                self.emptyViewLabel.text = "You have no recurring payments set up"
            }
            
            self.tableView.reloadData()
            self.mandateHistoryTableView.reloadData()
                        
        }
    }
    
    
    func fetchMandate(completionHandler: @escaping FetchMandateCompletionHandler) {
        
        let currentUser = Auth.auth().currentUser
        var phoneNumber = (currentUser?.phoneNumber)!
        let authProviderId = (currentUser?.uid)!
        phoneNumber.removeFirst()
        
        var mandates: [Mandate] = []
        
        let mandateRef = Database.database().reference().child("mandate").child("\(phoneNumber)")
        let mandateUidRef = Database.database().reference().child("mandate").child("\(authProviderId)")
        print(mandateRef)
        print(mandateUidRef)
        _ = mandateRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshotValue = snapshot.children.allObjects as? [DataSnapshot]{
                for snapDict in snapshotValue{
                    let dict = snapDict.value as? [String:AnyObject]
                    print(dict)
                    if let mandateArray = dict as? NSDictionary {
                        
                        
                        var amt = ""
                        if let amount = mandateArray.value(forKey: "amount") as? String {
                            amt = amount
                        }
                        
                        var cmpNm = ""
                        if let campaignName = mandateArray.value(forKey: "campaignName") as? String {
                            cmpNm = campaignName
                        }
                        
                        var crtd = ""
                        if let created = mandateArray.value(forKey: "created") as? String {
                            crtd = created
                        }
                        
                        var crrncy = ""
                        if let currency = mandateArray.value(forKey: "currency") as? String {
                            crrncy = currency
                        }
                        
                        var drtn = ""
                        if let duration = mandateArray.value(forKey: "duration") as? String {
                            drtn = duration
                        }
                        
                        var exprd = ""
                         if let expired = mandateArray.value(forKey: "expired") as? String {
                             exprd = expired
                         }
                        
                        var frqncyTyp = ""
                        if let frequencyType = mandateArray.value(forKey: "frequencyType") as? String {
                            frqncyTyp = frequencyType
                        }
                        
                        var grpNme = ""
                        if let groupName = mandateArray.value(forKey: "groupName") as? String {
                            grpNme = groupName
                        }
                        
                        var lstDbtDt = ""
                        if let lastDebitDate = mandateArray.value(forKey: "lastDebitDate") as? String {
                            lstDbtDt = lastDebitDate
                        }
                        
                        var mndtd = ""
                        if let mandateId = mandateArray.value(forKey: "mandateId") as? String {
                            mndtd = mandateId
                        }
                        
                        var mdfd = ""
                        if let modified = mandateArray.value(forKey: "modified") as? String {
                            mdfd = modified
                        }
                        
                        var msdn = ""
                        if let msisdn = mandateArray.value(forKey: "msisdn") as? String {
                            msdn = msisdn
                        }
                        
                        var stts = ""
                        if let status = mandateArray.value(forKey: "status") as? String {
                            stts = status
                        }
                        
                        var thrdPrtyRfrncN = ""
                        if let thirdPartyReferenceNo = mandateArray.value(forKey: "thirdPartyReferenceNo") as? String {
                            thrdPrtyRfrncN = thirdPartyReferenceNo
                        }
//                        let mandateDetails = Mandate(amount_: mandateArray.value(forKey: "amount") as! String, campaignName_: mandateArray.value(forKey: "campaignName") as! String, created_: mandateArray.value(forKey: "created") as! String, currency_: mandateArray.value(forKey: "currency") as! String, duration_: mandateArray.value(forKey: "duration") as! String, frequencyType_: mandateArray.value(forKey: "frequencyType") as! String, groupName_: mandateArray.value(forKey: "groupName") as! String, lastDebitDate_: mandateArray.value(forKey: "lastDebitDate") as! String, mandateId_: mandateArray.value(forKey: "mandateId") as! String, modified_: mandateArray.value(forKey: "modified") as! String, msisdn_: mandateArray.value(forKey: "msisdn") as! String, status_: mandateArray.value(forKey: "status") as! String, thirdPartyReferenceNo_: mandateArray.value(forKey: "thirdPartyReferenceNo") as! String)
                        
                        let mandateDetails = Mandate(amount_: amt, campaignName_: cmpNm, created_: crtd, currency_: crrncy, duration_: drtn, expired_: exprd, frequencyType_: frqncyTyp, groupName_: grpNme, lastDebitDate_: lstDbtDt, mandateId_: mndtd, modified_: mdfd, msisdn_: msdn, status_: stts, thirdPartyReferenceNo_: thrdPrtyRfrncN)
                        
                        mandates.append(mandateDetails)
                    }
                }
            }
            print("mandates: \(mandates)")

            _ = mandateUidRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshotValue = snapshot.children.allObjects as? [DataSnapshot]{
                    for snapDict in snapshotValue{
                        let dict = snapDict.value as? [String:AnyObject]
                        print(dict)
                        if let mandateArray = dict as? NSDictionary {


                            var amt = ""
                            if let amount = mandateArray.value(forKey: "amount") as? String {
                                amt = amount
                            }

                            var cmpNm = ""
                            if let campaignName = mandateArray.value(forKey: "campaignName") as? String {
                                cmpNm = campaignName
                            }

                            var crtd = ""
                            if let created = mandateArray.value(forKey: "created") as? String {
                                crtd = created
                            }

                            var crrncy = ""
                            if let currency = mandateArray.value(forKey: "currency") as? String {
                                crrncy = currency
                            }

                            var drtn = ""
                            if let duration = mandateArray.value(forKey: "duration") as? String {
                                drtn = duration
                            }

                            var exprd = ""
                             if let expired = mandateArray.value(forKey: "expired") as? String {
                                 exprd = expired
                             }

                            var frqncyTyp = ""
                            if let frequencyType = mandateArray.value(forKey: "frequencyType") as? String {
                                frqncyTyp = frequencyType
                            }

                            var grpNme = ""
                            if let groupName = mandateArray.value(forKey: "groupName") as? String {
                                grpNme = groupName
                            }

                            var lstDbtDt = ""
                            if let lastDebitDate = mandateArray.value(forKey: "lastDebitDate") as? String {
                                lstDbtDt = lastDebitDate
                            }

                            var mndtd = ""
                            if let mandateId = mandateArray.value(forKey: "mandateId") as? String {
                                mndtd = mandateId
                            }

                            var mdfd = ""
                            if let modified = mandateArray.value(forKey: "modified") as? String {
                                mdfd = modified
                            }

                            var msdn = ""
                            if let msisdn = mandateArray.value(forKey: "msisdn") as? String {
                                msdn = msisdn
                            }

                            var stts = ""
                            if let status = mandateArray.value(forKey: "status") as? String {
                                stts = status
                            }

                            var thrdPrtyRfrncN = ""
                            if let thirdPartyReferenceNo = mandateArray.value(forKey: "thirdPartyReferenceNo") as? String {
                                thrdPrtyRfrncN = thirdPartyReferenceNo
                            }

                            let mandateDetails = Mandate(amount_: amt, campaignName_: cmpNm, created_: crtd, currency_: crrncy, duration_: drtn, expired_: exprd, frequencyType_: frqncyTyp, groupName_: grpNme, lastDebitDate_: lstDbtDt, mandateId_: mndtd, modified_: mdfd, msisdn_: msdn, status_: stts, thirdPartyReferenceNo_: thrdPrtyRfrncN)

                            mandates.append(mandateDetails)
                        }
                    }
                }
                print("mandates: \(mandates)")
                completionHandler(mandates)
            })
            
        })

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == mandateHistoryTableView {
            print("mandate count: \(mandateHistory.count)")
            return mandateHistory.count
        }else {
        return activeMandates.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == mandateHistoryTableView {
            
            let cell: MandateCell = self.mandateHistoryTableView.dequeueReusableCell(withIdentifier: "MandateCell", for: indexPath) as! MandateCell

            cell.selectionStyle = .none
                        
            let mandate = self.mandateHistory[indexPath.row]
            
            print("3: \(mandate.thirdPartyReferenceNo)")

            var frequencyDuration: String = ""
            var duration: String = ""
            frequencyDuration = mandate.duration ?? "nil"
            
            if frequencyDuration == "7"{
                    duration = "for One Week"
            }else if frequencyDuration == "30" {
                duration = "for One month"
            }else if frequencyDuration == "90" {
                duration = "for Three months"
            }else if frequencyDuration == "180" {
                duration = "for Six months"
            }else if frequencyDuration == "365" {
                duration = "for One year"
            }else {
                duration = "Till Campaign Ends"
            }
            
            if (mandate.status == "cancelled"){
                cell.status.text = "Cancelled"
            }else {
                cell.status.text = "Expired"
            }
            
            mandateDate = mandate.lastDebitDate ?? "nil"
            mandateCreated = mandate.lastDebitDate ?? "nil"
            
            print("date: \(mandateDate)")
            
            if mandateDate == "N/A" {
                cell.debitDate.text = "\(mandate.lastDebitDate)"
                
            }else if mandateDate == "" {
                cell.debitDate.text = "N/A"
            }else {
                
            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            
                let formatter1 = DateFormatter()
                formatter1.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
                _ = formatter.string(from: Date())
                _ = formatter1.string(from: Date())
            
                let date = formatter.date(from: self.mandateCreated)
                let date1 = formatter1.date(from: self.mandateCreated)
                print(date)
            
                formatter.dateStyle = DateFormatter.Style.medium
                formatter1.dateStyle = DateFormatter.Style.medium
            
            let newDate = formatter.string(for: date)
            let newDate1 = formatter1.string(for: date1)
            
                
                if mandateCreated.count == 23 {
              cell.debitDate.text = "on \(newDate!)"
                }else {
                    cell.debitDate.text = "on \(newDate1!)"
                }

            }
            
            print("mandate id: \(mandate.mandateId)")
            
            cell.groupName.text = "\(mandate.groupName)"
            cell.amount.text = "\(mandate.currency) \(mandate.amount)"
            cell.frequency.text = "\(mandate.campaignName)"
//            cell.frequency.text = "\(mandate.frequencyType) \(duration)"
            
            return cell
        }else {
            let cell: MandateCell = self.tableView.dequeueReusableCell(withIdentifier: "MandateCell", for: indexPath) as! MandateCell
            
        cell.selectionStyle = .none
            cell.status.isHidden = true
        let mandate = self.activeMandates[indexPath.row]
                    
        var frequencyDuration: String = ""
        var duration: String = ""
        frequencyDuration = mandate.duration ?? "nil"
        
        if frequencyDuration == "7"{
                duration = "for One Week"
        }else if frequencyDuration == "30" {
            duration = "for One month"
        }else if frequencyDuration == "90" {
            duration = "for Three months"
        }else if frequencyDuration == "180" {
            duration = "for Six months"
        }else if frequencyDuration == "365" {
            duration = "for One year"
        }else {
            duration = "Till Campaign Ends"
        }
        
        mandateDate = mandate.lastDebitDate ?? "nil"
        mandateCreated = mandate.created ?? "nil"
        
        print("date: \(mandateDate)")
        print("active: \(mandate.thirdPartyReferenceNo)")
        
        if mandateDate == "N/A" {
            cell.debitDate.text = "\(mandate.lastDebitDate)"
        }else if mandateDate == "" {
            cell.debitDate.text = "N/A"
        }else {
            
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
            let formatter1 = DateFormatter()
            formatter1.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
            _ = formatter.string(from: Date())
            _ = formatter1.string(from: Date())
        
            let date = formatter.date(from: self.mandateCreated)
            let date1 = formatter1.date(from: self.mandateCreated)

            formatter.dateStyle = DateFormatter.Style.medium
            formatter1.dateStyle = DateFormatter.Style.medium
        
        let newDate = formatter.string(for: date)
        let newDate1 = formatter1.string(for: date1)
        
            
            if mandateCreated.count == 23 {
                cell.debitDate.text = "\(newDate!)"
            }else {
                cell.debitDate.text = "\(newDate1!)"
            }
        }
        
        print("mandate id: \(mandate.mandateId)")
        
        cell.groupName.text = "\(mandate.groupName)"
        cell.amount.text = "\(mandate.currency) \(mandate.amount)"
        cell.frequency.text = "\(mandate.campaignName)"
        
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == mandateHistoryTableView {
        return 80.00
        }else {
            return 80.00
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if tableView == mandateHistoryTableView {
            let mandate = self.mandateHistory[indexPath.row]
            
            if mandate.status == "cancelled" {
                
                let alert = UIAlertController(title: "Recurring Payments", message: "Mandate of \(mandate.groupName) - \(mandate.campaignName) of \(mandate.currency) \(mandate.amount) \(mandate.frequencyType) for \(mandate.duration) days", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "CLOSE", style: .default) { (action: UIAlertAction!) in
                    
                }
                
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
            }else {
                //expired
                let alert = UIAlertController(title: "Recurring Payments", message: "Restart mandate of \(mandate.groupName) - \(mandate.campaignName) of \(mandate.currency) \(mandate.amount) \(mandate.frequencyType) for \(mandate.duration) days?", preferredStyle: .alert)
                print("3rd: \(mandate.thirdPartyReferenceNo)")

                let okAction = UIAlertAction(title: "RESTART MANDATE", style: .default) { (action: UIAlertAction!) in
                    
                    self.showRecurringOTPDialog(thirdPartyReferenceNo: mandate.thirdPartyReferenceNo)
                    
                }
                
                let cancelAction = UIAlertAction(title: "CLOSE", style: .default) { (action: UIAlertAction!) in
                    
                }
                
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }else {
        let mandate = self.activeMandates[indexPath.row]
        
        let alert = UIAlertController(title: "Recurring Payments", message: "Are you sure you want to STOP mandate of \(mandate.groupName) - \(mandate.campaignName) of \(mandate.currency) \(mandate.amount) \(mandate.frequencyType) for \(mandate.duration) days?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "STOP", style: .default) { (action: UIAlertAction!) in
            
            let parameter: CancelSingleMandateParameter = CancelSingleMandateParameter(id: mandate.mandateId!)
            
            self.cancelMandate(cancelSingleMandateParameter: parameter)
            
        }
        
        let cancelAction = UIAlertAction(title: "CLOSE", style: .default) { (action: UIAlertAction!) in
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //CANCEL ALL
    func cancelAllMandates(cancelAllMandatesParameter: [String]) {
        AuthNetworkManager.cancelAllMandates(parameter: cancelAllMandatesParameter) { (result) in
            self.parseCancelAllMandatesResponse(result: result)
        }
    }
    
    
    private func parseCancelAllMandatesResponse(result: DataResponse<RevokeLoanApproverResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            let alert = UIAlertController(title: "Recurring Payments", message: response.responseMessage , preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
//                let vc: GroupsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "groups") as! GroupsViewController
//                
//                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
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
    
    
    //CANCEL SINGLE MANDATE
    func cancelMandate(cancelSingleMandateParameter: CancelSingleMandateParameter) {
        AuthNetworkManager.cancelSingleMandate(parameter: cancelSingleMandateParameter) { (result) in
            self.parseCancelSingleMandatesResponse(result: result)
        }
    }
    
    
    private func parseCancelSingleMandatesResponse(result: DataResponse<RevokeLoanApproverResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            let alert = UIAlertController(title: "Recurring Payments", message: response.responseMessage , preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
//                let vc: GroupsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "groups") as! GroupsViewController
//
//                self.navigationController?.popViewController(animated: true)
                
                self.callFetchMandate()
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
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
    
    
    //REACTIVATE MANDATE
    func reactivateMandate(reactivateMandateParameter: ReactivateMandateParameter) {
        AuthNetworkManager.reactivateMandate(parameter: reactivateMandateParameter) { (result) in
            self.parseReactivateMandateResponse(result: result)
        }
    }
    
    
    private func parseReactivateMandateResponse(result: DataResponse<RevokeLoanApproverResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            let alert = UIAlertController(title: "Recurring Payments", message: response.responseMessage , preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
//                let vc: GroupsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "groups") as! GroupsViewController
                
//                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
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
    
    
     //RECURRING OTP DIALOG
    func showRecurringOTPDialog(animated: Bool = true, thirdPartyReferenceNo: String) {
            
            //create a custom view controller
            let recurringVC = RecurringPaymentCell(nibName: "RecurringPaymentCell", bundle: nil)
            
            //create the dialog
            let popup = PopupDialog(viewController: recurringVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
            
            //create first button
            let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            }
            
            //create second button
            let buttonTwo = DefaultButton(title: "VERIFY", height: 60) {
                if(recurringVC.oTP.text?.isEmpty)!{
                    let alert = UIAlertController(title: "Recurring Payment Verification", message: "Please enter password", preferredStyle: .alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                        
                    }
                    
                    alert.addAction(OKAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }else {
                    FTIndicator.init()
                    FTIndicator.setIndicatorStyle(UIBlurEffect.Style.dark)
                    FTIndicator.showProgress(withMessage: "Checking", userInteractionEnable: false)
                    
                    //Firebase Auth
                    var currentUser = Auth.auth().currentUser
                    
                    Auth.auth().signIn(withEmail: (currentUser?.email)!, password: recurringVC.oTP.text!) { (user, error) in
                        if error != nil {
                            //alert
                            //                        activityIndicatorView.stopAnimating()
                            FTIndicator.dismissProgress()
                            let alert = UIAlertController(title: "Recurring Payment", message: "Invalid credentials", preferredStyle: .alert)
                            print("error: \(error?.localizedDescription)")
                            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                                alert.dismiss(animated: true, completion: nil)
                            }
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            
                            print(error?.localizedDescription)
                        } else {
                            //call endpoint
                            let parameter: ReactivateMandateParameter = ReactivateMandateParameter(thirdPartyReference: thirdPartyReferenceNo)
                            
                            self.reactivateMandate(reactivateMandateParameter: parameter)
                            
                            FTIndicator.showProgress(withMessage: "loading")
                            
    //                        var phone = self.msisdn
    //                        phone.removeFirst()
    //                        let parameter: RecurringOTPParameter = RecurringOTPParameter(phone: phone, thirdPartyReferenceNo: "")
    //                        self.recurringPayment(recurringPayment: parameter)
                        }
                    }

                }
            }
            
            //Add buttons to dialog
            popup.addButtons([buttonOne, buttonTwo])
            
            //Present dialog
            present(popup, animated: animated, completion: nil)
            
        }
    
    
    // EASY SLIDE
    fileprivate func getEasySlide() -> ESNavigationController {
        return self.navigationController as! ESNavigationController
        
    }
}
