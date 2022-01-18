//
//  RecurringVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 30/08/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import PopupDialog
import FirebaseDatabase
import FirebaseAuth
import Nuke

class RecurringVC: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate,  UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var repeatCycleLabel: UIButton!
    @IBOutlet weak var paymentDurationLabel: UIButton!
    @IBOutlet weak var contributeBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cycleCollectionView: UICollectionView!
    @IBOutlet weak var durationCollectionView: UICollectionView!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    var groupImage: String = ""
    var repeatCycle: String = ""
    var paymentDuration: String = ""
    var groupId: String = ""
    var campaignId: String = ""
    var network: String = ""
    var campaignName: String = ""
    var amount: Double = 0.0
    var currency: String = ""
    var msisdn: String = ""
    var othersMsisdn: String = ""
    var othersMemberId: String = ""
    var voucherCode: String = ""
    var thirdPartyReferenceNo: String = ""
    var recurring: String = ""
    var publicGroupCheck: Int = 0
    var frequencyArray: [String] = []
    var durationArray: [String] = []
    var lastItem: String = ""
    var anonymous: String = "false"
    var freqCycle : [String] = ["Daily","Monthly","Weekly"]
    var periodCycle : [String] = ["1 month", "6 months", "3 months", "1 year"]
    var groupIconPath: String = ""
    var selectedCycle: [String] = []
    var selectedDuration:  [String] = []
    var paymentDurationItem: String = ""
    var paymentCycleItem: String = ""
    let reuseIdentifier = "cell"
    
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableDarkMode()
        
        groupNameLabel.text = campaignName
        if (groupImage == "<null>") || (groupImage == nil) || (groupImage == ""){
            groupImageView.image = UIImage(named: "defaultgroupicon")
            groupImageView.contentMode = .center
        }else {
            Nuke.loadImage(with: URL(string: groupImage)!, into: groupImageView)
        }
        let nib = UINib(nibName: "RecurringCollectionCell", bundle:nil)
        let durationNib = UINib(nibName: "RecurringCollectionCell", bundle:nil)
        self.cycleCollectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        self.durationCollectionView.register(durationNib, forCellWithReuseIdentifier: reuseIdentifier)
        
        print("duration: \(durationArray), frequency: \(frequencyArray)")
        if (durationArray == ["none"]) || (durationArray == []) {
        }else {
            lastItem = durationArray.last!
            print(lastItem)
        }
        fetchMandateObject()
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView != durationCollectionView {
        if (frequencyArray == ["none"]) || (frequencyArray == []) {
           return freqCycle.count
        }else {
           return frequencyArray.count
            }
        }else {
            if (durationArray == ["none"]) || (durationArray == []) {
                return periodCycle.count
            }else {
                return durationArray.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView != durationCollectionView {
            let cell = cycleCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecurringCollectionCell

            if (frequencyArray == ["none"]) || (frequencyArray == []) {
                cell.recurringItem.text = freqCycle[indexPath.row]
                print("using this")
                if selectedCycle.contains(freqCycle[indexPath.row]){
                    cell.checkBox.setOn(true, animated: true)
                }else {
                    cell.checkBox.setOn(false, animated: true)
                }
            }else {
                print("using array from end point")
                cell.recurringItem.text = frequencyArray[indexPath.row]
                if selectedCycle.contains(frequencyArray[indexPath.row]){
                    cell.checkBox.setOn(true, animated: true)
                }else {
                    cell.checkBox.setOn(false, animated: true)
                }
            }

            return cell
        }else {
            let durationCell = durationCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecurringCollectionCell
            if (durationArray == ["none"]) || (durationArray == []) {
                durationCell.recurringItem.text = periodCycle[indexPath.row]
                if selectedDuration.contains(periodCycle[indexPath.row]) {
                    durationCell.checkBox.setOn(true, animated: true)
                }else {
                    durationCell.checkBox.setOn(false, animated: true)
                }
            }else {
                durationCell.recurringItem.text = durationArray[indexPath.row]
                if selectedDuration.contains(durationArray[indexPath.row]){
                    durationCell.checkBox.setOn(true, animated: true)
                }else {
                    durationCell.checkBox.setOn(false, animated: true)
                }
            }
            return durationCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("wa did selecti me oh")
        if collectionView == durationCollectionView {
            if (durationArray == ["none"]) || (durationArray == []) {
            if !selectedDuration.isEmpty {
                if selectedDuration.first! == periodCycle[indexPath.row] {
                    selectedDuration = []
                    durationCollectionView.reloadData()
                    return
                }
            }
            selectedDuration = []
            selectedDuration.append(periodCycle[indexPath.row])
            paymentDurationItem = periodCycle[indexPath.row]
            print("duration: \(selectedDuration)")
                if paymentDurationItem == "1 Week" {
                    self.paymentDuration = "7"
                }else if paymentDurationItem == "1 month" {
                    self.paymentDuration = "30"
                }else if paymentDurationItem == "3 months" {
                    self.paymentDuration = "92"
                }else if paymentDurationItem == "6 months" {
                    self.paymentDuration = "180"
                }else if paymentDurationItem == "1 year" || paymentDurationItem == "1 year " {
                    self.paymentDuration = "365"
                }
            durationCollectionView.reloadData()
            }else {
                //When from API
                if !selectedDuration.isEmpty {
                    if selectedDuration.first! == durationArray[indexPath.row] {
                        selectedDuration = []
                        durationCollectionView.reloadData()
                        return
                    }
                }
                selectedDuration = []
                selectedDuration.append(durationArray[indexPath.row])
                paymentDurationItem = durationArray[indexPath.row]
                if paymentDurationItem == "1 Week" {
                    self.paymentDuration = "7"
                }else if paymentDurationItem == "1 month" {
                    self.paymentDuration = "30"
                }else if paymentDurationItem == "3 months" {
                    self.paymentDuration = "92"
                }else if paymentDurationItem == "6 months" {
                    self.paymentDuration = "180"
                }else if paymentDurationItem == "1 year " {
                    self.paymentDuration = "365"
                }else if paymentDurationItem == "One Week" {
                    self.paymentDuration = "7"
                }else if paymentDurationItem == "One Month" {
                    self.paymentDuration = "30"
                }else if paymentDurationItem == "Three Months" {
                    self.paymentDuration = "92"
                }else {
                    self.paymentDuration = durationArray[indexPath.row]
                }
                print("duration item: \(paymentDurationItem)")
                durationCollectionView.reloadData()
            }
        }else {
            if (frequencyArray == ["none"]) || (frequencyArray == []) {
            if !selectedCycle.isEmpty {
                if selectedCycle.first! == freqCycle[indexPath.row] {
                    selectedCycle = []
                    cycleCollectionView.reloadData()
                    return
                }
            }
            selectedCycle = []
            selectedCycle.append(freqCycle[indexPath.row])
            paymentCycleItem = freqCycle[indexPath.row]
            print("paycycle: \(selectedCycle)")
                

            cycleCollectionView.reloadData()
            }else {
                //API
                if !selectedCycle.isEmpty {
                    if selectedCycle.first! == frequencyArray[indexPath.row] {
                        selectedCycle = []
                        cycleCollectionView.reloadData()
                        return
                    }
                }
                selectedCycle = []
                selectedCycle.append(frequencyArray[indexPath.row])
                paymentCycleItem = frequencyArray[indexPath.row]
                cycleCollectionView.reloadData()
            }
        }
    }
    

    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if collectionView == durationCollectionView {
//
//        }else {
//            let cell = cycleCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecurringCollectionCell
////            cell.checkBox.setOn(true)
//            print("deselect cycle cell")
//            if let index = selectedCycle.firstIndex(of: freqCycle[indexPath.row]) {
//                selectedCycle.remove(at: index)
//            }
//            cycleCollectionView.reloadData()
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //device screen size
        let width = UIScreen.main.bounds.size.width
        //calculation of cell size
        return CGSize(width: ((width/3)), height: 25)
    }
    
    
    func repeatCycleAlert() {
        var alert = UIAlertController(title: "Choose Repeat Cycle", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        switch UIDevice.current.screenType {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
            let actionSheetController: UIAlertController = UIAlertController(title: "Choose Repeat Cycle", message: "", preferredStyle: .actionSheet)
            //Create and add the "Cancel" action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
                print("you cancelled")
            }
            let daily: UIAlertAction = UIAlertAction(title: "Daily", style: .default) { action -> Void in
                self.repeatCycle = "Daily"
                self.repeatCycleLabel.setTitle("Daily", for: .normal)
            }
            let weekly: UIAlertAction = UIAlertAction(title: "Weekly", style: .default) { action -> Void in
                self.repeatCycle = "Weekly"
                self.repeatCycleLabel.setTitle("Weekly", for: .normal)
            }
            let monthly: UIAlertAction = UIAlertAction(title: "Monthly", style: .default) { action -> Void in
                self.repeatCycle = "Monthly"
                self.repeatCycleLabel.setTitle("Monthly", for: .normal
                )
            }
            actionSheetController.addAction(daily)
            actionSheetController.addAction(weekly)
            actionSheetController.addAction(monthly)
            actionSheetController.addAction(cancelAction)
            self.present(actionSheetController, animated: true, completion: nil)
            break
        default:
            alert = UIAlertController(title: "Choose Repeat Cycle", message: "", preferredStyle: UIAlertController.Style.alert)
            //Create and add the "Cancel" action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
                print("you cancelled")
            }
            let daily: UIAlertAction = UIAlertAction(title: "Daily", style: .default) { action -> Void in
                self.repeatCycle = "Daily"
                self.repeatCycleLabel.setTitle("Daily", for: .normal)
            }
            let weekly: UIAlertAction = UIAlertAction(title: "Weekly", style: .default) { action -> Void in
                self.repeatCycle = "Weekly"
                self.repeatCycleLabel.setTitle("Weekly", for: .normal)
            }
            let monthly: UIAlertAction = UIAlertAction(title: "Monthly", style: .default) { action -> Void in
                self.repeatCycle = "Monthly"
                self.repeatCycleLabel.setTitle("Monthly", for: .normal
                )
            }
            alert.addAction(daily)
            alert.addAction(weekly)
            alert.addAction(monthly)
            alert.addAction(cancelAction)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func otherRepeatCycle(frequencyArray: [String]){
        var alert = UIAlertController(title: "Choose Repeat Cycle", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        switch UIDevice.current.screenType {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
            let actionSheetController: UIAlertController = UIAlertController(title: "Choose Repeat Cycle", message: "", preferredStyle: .actionSheet)
            for item in frequencyArray {
                actionSheetController.addAction(title: item, style: .default, handler: {(action) in
                    self.repeatCycle = item
                    self.repeatCycleLabel.setTitle(item, for: .normal)
                })
            }
            actionSheetController.addAction(title: "Cancel", style: .cancel)
            self.present(actionSheetController, animated: true, completion: nil)
            break
        default:
            alert = UIAlertController(title: "Choose Repeat Cycle", message: "", preferredStyle: UIAlertController.Style.alert)
            for item in frequencyArray {
                alert.addAction(title: item, style: .default, handler: {(action) in
                    self.repeatCycle = item
                    self.repeatCycleLabel.setTitle(item, for: .normal)
                })
            }
            self.present(alert, animated: true, completion: nil)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
    }
    
    @IBAction func selectCycleSheet(_ sender: UIButton) {
        print(frequencyArray)
        if (frequencyArray == ["none"]) || (frequencyArray == []) {
            print("print for static options")
            repeatCycleAlert()
        }else {
            print("other cycle")
            otherRepeatCycle(frequencyArray: frequencyArray)
        }
    }
    
    
    func selectDuration() {
        var alert = UIAlertController(title: "Choose Repeat Cycle", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        switch UIDevice.current.screenType {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
            let actionSheetController: UIAlertController = UIAlertController(title: "Choose Repeat Cycle", message: "", preferredStyle: .actionSheet)
            //Create and add the "Cancel" action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
                print("you cancelled")
            }
            let month1: UIAlertAction = UIAlertAction(title: "1 Month", style: .default) { action -> Void in
                self.paymentDuration = "30"
                self.paymentDurationLabel.setTitle("1 Month", for: .normal)
            }
            let months3: UIAlertAction = UIAlertAction(title: "3 Months", style: .default) { action -> Void in
                self.paymentDuration = "92"
                self.paymentDurationLabel.setTitle("3 Months", for: .normal)
            }
            let months6: UIAlertAction = UIAlertAction(title: "6 Months", style: .default) { action -> Void in
                self.paymentDuration = "180"
                self.paymentDurationLabel.setTitle("6 Months", for: .normal)
            }
            let year1: UIAlertAction = UIAlertAction(title: "1 Year", style: .default) { action -> Void in
                self.paymentDuration = "365"
                self.paymentDurationLabel.setTitle("1 Year", for: .normal)
            }
            actionSheetController.addAction(month1)
            actionSheetController.addAction(months3)
            actionSheetController.addAction(months6)
            actionSheetController.addAction(year1)
            actionSheetController.addAction(cancelAction)
            self.present(actionSheetController, animated: true, completion: nil)
            break
        default:
            alert = UIAlertController(title: "Choose Repeat Cycle", message: "", preferredStyle: UIAlertController.Style.alert)
            //Create and add the "Cancel" action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Just dismiss the action sheet
                print("you cancelled")
            }
            let month1: UIAlertAction = UIAlertAction(title: "1 Month", style: .default) { action -> Void in
                self.paymentDuration = "30"
                self.paymentDurationLabel.setTitle("1 Month", for: .normal)
            }
            let months3: UIAlertAction = UIAlertAction(title: "3 Months", style: .default) { action -> Void in
                self.paymentDuration = "92"
                self.paymentDurationLabel.setTitle("3 Months", for: .normal)
            }
            let months6: UIAlertAction = UIAlertAction(title: "6 Months", style: .default) { action -> Void in
                self.paymentDuration = "180"
                self.paymentDurationLabel.setTitle("6 Months", for: .normal)
            }
            let year1: UIAlertAction = UIAlertAction(title: "1 Year", style: .default) { action -> Void in
                self.paymentDuration = "365"
                self.paymentDurationLabel.setTitle("1 Year", for: .normal)
            }
            alert.addAction(month1)
            alert.addAction(months3)
            alert.addAction(months6)
            alert.addAction(year1)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func otherSelectDuration(){
        var alert = UIAlertController(title: "Choose Repeat Cycle", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        switch UIDevice.current.screenType {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
            let actionSheetController: UIAlertController = UIAlertController(title: "Choose Repeat Cycle", message: "", preferredStyle: .actionSheet)
            let tilCampaign = "Till Campaign Ends"
            durationArray.popLast()
            durationArray.append(tilCampaign)
            for item in durationArray {
                actionSheetController.addAction(title: item, style: .default, handler: {(action) in
                    self.paymentDurationLabel.setTitle(item, for: .normal)
                    if item == self.durationArray.last {
                        self.paymentDuration = self.lastItem
                    }else {
                        if item == "One Week" {
                            self.paymentDuration = "7"
                        }else if item == "One Month" {
                            self.paymentDuration = "30"
                        }else if item == "Three Months" {
                            self.paymentDuration = "92"
                        }else if item == "Six Months" {
                            self.paymentDuration = "180"
                        }else if item == "One Year " {
                            self.paymentDuration = "365"
                        }
                    }
                })
            }
            actionSheetController.addAction(title: "Cancel", style: .cancel)
            self.present(actionSheetController, animated: true, completion: nil)
            break
        default:
            alert = UIAlertController(title: "Choose Repeat Cycle", message: "", preferredStyle: UIAlertController.Style.alert)
            let tilCampaign = "Till Campaign Ends"
            durationArray.popLast()
            durationArray.append(tilCampaign)
            for item in durationArray {
                alert.addAction(title: item, style: .default, handler: {(action) in
                    self.paymentDurationLabel.setTitle(item, for: .normal)
                    if item == self.durationArray.last {
                        self.paymentDuration = self.lastItem
                    }else {
                        if item == "One Week" {
                            self.paymentDuration = "7"
                        }else if item == "One Month" {
                            self.paymentDuration = "30"
                        }else if item == "Three Months" {
                            self.paymentDuration = "92"
                        }else if item == "Six Months" {
                            self.paymentDuration = "180"
                        }else if item == "One Year " {
                            self.paymentDuration = "365"
                        }
                    }
                })
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectDuration(_ sender: UIButton) {
        print(durationArray)
        if (durationArray == ["none"]) || (durationArray == []) {
            selectDuration()
        }else {
            otherSelectDuration()
        }
    }
    
    
    @IBAction func contributeButtonAction(_ sender: UIButton) {
        
        if (paymentDuration == "" || paymentCycleItem == "") {
            print("dur: \(paymentDuration),\(paymentCycleItem)")
            showAlert(title: "Recurring Payment", message: "Please select both duration and frequency options.")
        }else if thirdPartyReferenceNo != "" {
            print("show otp")
//            showRecurringOTPDialog(animated: true)
            let vc: VerifyRecurringVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verifyrecurring") as! VerifyRecurringVC
            vc.amount = amount
            vc.campaignId = campaignId
            vc.currency = currency
            vc.groupId = groupId
            vc.duration = paymentDuration
            vc.freqType = paymentCycleItem
            vc.msisdn = msisdn
            vc.narration = campaignId
            vc.network = network
            vc.recurring = "true"
            vc.voucherCode = voucherCode
            vc.othersMsisdn = othersMsisdn
            vc.othersMemberId = othersMemberId
            vc.anonymous = anonymous
            vc.groupIconPath = groupIconPath
            vc.campaignName = campaignName
            vc.publicGroupCheck = publicGroupCheck
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            FTIndicator.showProgress(withMessage: "loading")
            let parameter: MakeContributionParameter = MakeContributionParameter(amount: amount, campaignId: campaignId, currency: currency, destination: "", groupId: groupId, invoiceId: "", duration: paymentDuration, freqType: paymentCycleItem, msisdn: msisdn, narration: campaignName, network: network, recurring: "true", voucher: voucherCode, othersMsisdn: othersMsisdn, othersMemberId: othersMemberId, anonymous: anonymous)
            makeContribution(makeContributionParameter: parameter)
            recurring = "true"
        }
    }
    
    
    //CONTRIBUTE
    func makeContribution(makeContributionParameter: MakeContributionParameter) {
        AuthNetworkManager.makeContribution(parameter: makeContributionParameter) { (result) in
            self.parseMakeContributionResponse(result: result)
        }
    }
    
    private func parseMakeContributionResponse(result: DataResponse<ContributeResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            if network == "VODAFONE"{
                let alert = UIAlertController(title: "Chango", message:  "\(response.responseMessage!)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: PrivateGroupDashboardVC.self){
                            (controller as! PrivateGroupDashboardVC).refreshPage = true
                            self.navigationController?.popToViewController(controller, animated: true)
                        }
                    }
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }else {
                let alert = UIAlertController(title: "Chango", message: "\(response.responseMessage!)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    if self.publicGroupCheck == 1 {
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: PublicGroupDashboardVC.self){
                                    (controller as! PrivateGroupDashboardVC).refreshPage = true
                                self.navigationController?.popToViewController(controller, animated: true)
                            }
                        }
                    }else {
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: PrivateGroupDashboardVC.self){
                                (controller as! PrivateGroupDashboardVC).refreshPage = true
                                self.navigationController?.popToViewController(controller, animated: true)
                            }
                        }
                    }
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    //CONTRIBUTION FOR WALLET
    func contribute(contributeParameter: ContributeParameter) {
        AuthNetworkManager.contribute(parameter: contributeParameter) { (result) in
            self.parseContributeResponse(result: result)
        }
    }
    
    private func parseContributeResponse(result: DataResponse<RegularResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")

                let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: MainMenuTableViewController.self){
                            (controller as! MainMenuTableViewController).refreshPage = true
                            self.navigationController?.popToViewController(controller, animated: true)
                        }
                    }
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

    
    
    func fetchMandateObject() {
        let groupsRef = Database.database().reference().child("mandate")
        let uid = groupsRef.child("\(msisdn)")
        print("uid: \(uid)")
        _ = uid.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if let snapshotValue = snapshot.value as? [String: AnyObject] {
                if snapshotValue.count > 0 {
                    self.thirdPartyReferenceNo = "show"
                }else {
                    print("no mandate exists")
                    self.thirdPartyReferenceNo = ""
                }
            }
        })
    }
    
    
    //RECURRING OTP DIALOG
    func showRecurringOTPDialog(animated: Bool = true) {
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
                self.showAlert(title: "Recurring Payment Verification", message: "Please enter password")
            }else {
                FTIndicator.init()
                FTIndicator.setIndicatorStyle(UIBlurEffect.Style.dark)
                FTIndicator.showProgress(withMessage: "Checking", userInteractionEnable: false)
                //Firebase Auth
                var currentUser = Auth.auth().currentUser
                Auth.auth().signIn(withEmail: (currentUser?.email)!, password: recurringVC.oTP.text!) { (user, error) in
                    if error != nil {
                        FTIndicator.dismissProgress()
                        self.showAlert(withTitle: "Recurring Payment", message: "Invalid credentials")
                        print(error?.localizedDescription)
                    } else {
                        //call endpoint
                        let parameter: MakeContributionParameter = MakeContributionParameter(amount: self.amount, campaignId: self.campaignId, currency: self.currency, destination: "", groupId: self.groupId, invoiceId: "", duration: self.paymentDuration, freqType: self.repeatCycle, msisdn: self.msisdn, narration: self.campaignName, network: self.network, recurring: "true", voucher: self.voucherCode, othersMsisdn: self.othersMsisdn, othersMemberId: self.othersMemberId, anonymous: self.anonymous)
                        self.makeContribution(makeContributionParameter: parameter)
                        FTIndicator.showProgress(withMessage: "loading")
                    }
                }
            }
        }
        //Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        //Present dialog
        present(popup, animated: animated, completion: nil)
    }
    
    
    //RECURRING PAYMENT OTP
    func recurringPayment(recurringPayment: RecurringOTPParameter) {
        AuthNetworkManager.recurringPayment(parameter: recurringPayment) { (result) in
            self.parseRecurringPaymentResponse(result: result)
        }
    }
    
    private func parseRecurringPaymentResponse(result: DataResponse<RecurringResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            let alert = UIAlertController(title: "Chango", message: response.responseMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: MainMenuTableViewController.self){
                        (controller as! MainMenuTableViewController).refreshPage = true
                        self.navigationController?.popToViewController(controller, animated: true)
                    }
                }
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
