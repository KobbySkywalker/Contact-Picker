//
//  InitiateCashoutVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 23/07/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import FirebaseAuth

class InitiateCashoutVC: BaseViewController {

    @IBOutlet weak var cashoutView: UIView!
    @IBOutlet weak var selectCampaignButton: UIButton!
    @IBOutlet weak var selectDesitnationButton: UIButton!
    @IBOutlet weak var selectPaymentMethodButton: UIButton!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var reason: ACFloatingTextfield!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var paymentMethodDropDown: UIStackView!
    @IBOutlet weak var campaignOptionsDropDown: UIStackView!
    @IBOutlet weak var destinationOptionDropDown: UIStackView!
    @IBOutlet weak var campaignBalanceLabel: UILabel!
    
    var bankCheck: Int = 0
    
    let dropDown = DropDown()
    
    var groupId: String = ""
    var voteId: String = ""
    var network: String = ""
    var campaignBalance: String = ""
    var cashoutVotesRequired: Int = 0
    var cashoutVotesCompleted: Int = 0
    let campaignDropDown = DropDown()
    let paymentDropDown = DropDown()
    let destinationDropDown = DropDown()
    var members: [MemberResponse] = []
    var memberName: String = ""
    var memberNumber: String = ""
    var cashout: Int = 0
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.campaignDropDown,
            self.paymentDropDown,
            self.destinationDropDown
        ]
    }()
    
    var campaignNames: [GetGroupCampaignsResponse] = []
    
    var campaignName: [String] = []
    var campaignIdd: String = ""
    var campaignId: [String] = []
    var campaignStatus: [String] = []
    var campaignBal : [Double] = [0.0]
    var campBal: Double = 0.0
    var status: String = ""
    var paymentMethod: [String] = ["      Mobile Wallet      ", "      Bank Account     "]
    var destinationOptions: [String] = ["    Self    ", "    Other    ", "    Members    "]
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showChatController()
        disableDarkMode()
        
        let parameters: GetMemberParameter = GetMemberParameter(groupId: groupId)
        getMembers(getMembersParameter: parameters)
        
        cashoutView.layer.cornerRadius = 10
        cashoutView.layer.shadowColor = UIColor.black.cgColor
        cashoutView.layer.shadowOffset = CGSize(width: 2, height: 4)
        cashoutView.layer.shadowRadius = 8
        cashoutView.layer.shadowOpacity = 0.2
        
        setupDropDowns()
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        
        destinationLabel.text = "\(memberName)"
        
    }
    
    func setupDropDowns() {
        setupCashoutDropDown()
        setupPaymentDropDown()
        setupDestinationDropDown()
    }
    

    
    func setupCashoutDropDown(){
        campaignDropDown.anchorView = campaignOptionsDropDown
        
        campaignDropDown.bottomOffset = CGPoint(x: 0, y: campaignDropDown.bounds.height + 10)
        
        for item in campaignNames {
            self.campaignName.append(item.campaignName)
            self.campaignId.append(item.campaignId ?? "")
            self.campaignStatus.append(item.status!)
            self.campaignBal.append(item.amountReceived!)
            print("id: \(campaignId)")
            print("campaign balance: \(campaignBal)")
        }
        campaignDropDown.dataSource = campaignName
        
        
        //        Action triggered on selection
        campaignDropDown.selectionAction = { [weak self] (index, item) in
            print("Selected item: \(item) at \(index)")
            self!.selectCampaignButton.titleLabel?.text = item
            self?.campaignIdd = self!.campaignId[index]
            self?.status = self!.campaignStatus[index]
            self?.campBal = (self?.campaignBal[index])!
            print(self!.status)
            print(self!.campaignIdd)
            print(self!.campBal)
            
            self!.campaignBalanceLabel.isHidden = false
//            self!.campaignBalances.isHidden = false
            
            if index == 0 {
                
                self!.campaignBalanceLabel.text = "\(self!.campaignBalance)"
            }else {
                self!.campaignBalanceLabel.text = "\(self!.campBal)"
                
            }

            
            self!.campaignDropDown.backgroundColor = UIColor.white
            self!.campaignDropDown.selectionBackgroundColor = UIColor.white
            
            if self!.status == "stop" {
                let alert = UIAlertController(title: "Cashout", message: "This campaign has been stopped.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                alert.addAction(okAction)
                
                self!.present(alert, animated: true, completion: nil)
            }else if self!.status == "pause"{
                let alert = UIAlertController(title: "Cashout", message: "This campaign has been paused.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                alert.addAction(okAction)
                
                self!.present(alert, animated: true, completion: nil)
            }
            
        }
        
        
        campaignDropDown.width = 200
        
    }
    
    
    func setupPaymentDropDown(){
        paymentDropDown.anchorView = paymentMethodDropDown

        
        paymentDropDown.bottomOffset = CGPoint(x: 0, y: paymentMethodDropDown.bounds.height + 10)
        
        
        paymentDropDown.dataSource = paymentMethod
        
        
        //        Action triggered on selection
        paymentDropDown.selectionAction = { [weak self] (index, item) in
            print("Selected item: \(item) at \(index)")
            
            print(self!.paymentMethod)
            self!.selectPaymentMethodButton.titleLabel?.text = item

            
            if item == "      Bank Account     " {
                
//                self!.selectPaymentMethodButton.titleLabel?.text = item
                
                self!.bankCheck = 1
//                self!.reasonIcon.image = UIImage(named: "bank")
//                self!.reason.placeholder = "Enter recipient account number"
                
//                self!.lastIcon.isHidden = false
//                self!.lastTextfield.isHidden = false
                
            }else {
//                self!.selectPaymentMethodButton.titleLabel?.text = item
                
                self!.bankCheck = 0
//                self!.reasonIcon.image = UIImage(named: "reason")
//                self!.reason.placeholder = "Reason"
//                self!.reason.keyboardType = .asciiCapable
//                self!.lastIcon.isHidden = true
//                self!.lastTextfield.isHidden = true
            }
            
            self!.paymentDropDown.backgroundColor = UIColor.white
            self!.paymentDropDown.selectionBackgroundColor = UIColor.white
            
        }
        
        
        paymentDropDown.width = 200
        
    }
    
    
    func setupDestinationDropDown(){
        destinationDropDown.anchorView = destinationOptionDropDown

        
        destinationDropDown.bottomOffset = CGPoint(x: 0, y: destinationOptionDropDown.bounds.height + 10)
        
        
        destinationDropDown.dataSource = destinationOptions
        
        
        //        Action triggered on selection
        destinationDropDown.selectionAction = { [weak self] (index, item) in
            print("Selected item: \(item) at \(index)")
            self!.selectDesitnationButton.titleLabel?.text = item

            print(self!.destinationOptions)
            
            if item == "    Self    " {
                
                self!.selectDesitnationButton.titleLabel?.text = item
                self!.destinationLabel.text = self!.user?.phoneNumber
                


                
            }else if item == "    Other    " {
             
//                self!.selectDesitnationButton.titleLabel?.text = item
                
            }else {
//                self!.selectDesitnationButton.titleLabel?.text = item
                
                let vc: MemberSearchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "membersearch") as! MemberSearchViewController
                
                self!.cashout = 1
                vc.members = self!.members
                vc.cashout = self!.cashout
                self?.navigationController?.pushViewController(vc, animated: true)
                
            }
            
            self!.destinationDropDown.backgroundColor = UIColor.white
            self!.destinationDropDown.selectionBackgroundColor = UIColor.white
            
        }
        
        
        destinationDropDown.width = 200
        
    }
    
    
    func getMembers(getMembersParameter: GetMemberParameter) {
        AuthNetworkManager.getMembers(parameter: getMembersParameter) { (result) in
            self.parseGetMembersResponse(result: result)
        }
    }
    
    private func parseGetMembersResponse(result: DataResponse<[MemberResponse], AFError>){
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            
            for item in response {
                members.append(item)
            }
            
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
    
    
    @IBAction func campaignDropDownAction(_ sender: UIButton) {
        campaignDropDown.show()
    }
    
    @IBAction func destinationDropDownAction(_ sender: UIButton) {
        destinationDropDown.show()
    }
    
    @IBAction func paymentMethodDropDownAction(_ sender: UIButton) {
        paymentDropDown.show()
    }
    
}
