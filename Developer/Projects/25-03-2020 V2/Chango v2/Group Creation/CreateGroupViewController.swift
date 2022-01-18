//
//  CreateGroupViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 29/11/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import UIKit
import EPContactsPicker
import FirebaseMessaging
import Alamofire
import FTIndicator
import PhoneNumberKit

class CreateGroupViewController: BaseViewController, EPPickerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contactPicker: UIButton!
    @IBOutlet weak var createGroup: UIButton!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var createGroupButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var phoneNumberTextField: ACFloatingTextfield!
    @IBOutlet weak var phoneCode: UILabel!
    @IBOutlet weak var countryFlag: UIImageView!
    
    private var alertStyle: UIAlertController.Style = .alert
    var addMemberVC: AddMemberViewController = AddMemberViewController()
    
    var countryId: String = ""
    var groupName: String = ""
    var cashoutMinVote: String = ""
    var loanMinVote: String = ""
    var msisdnList: [String] = []
    var groupCheck: Bool = false
    var groupDesc: String = ""
    var tnc: String = ""
    var loanFlag: String = ""
    var contactPicked: Int = 0
    var cell = "cellId"
    var addedMembers: [AddedContactsModel] = []
    var country_name: String = ""
    var areaCode: String = ""
    let phoneNumberKit = PhoneNumberKit()
    var members: [MemberResponse] = []
    var memberTag: AddedContactsModel!

    
    var mapped: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showChatController()
        disableDarkMode()
        print("terms :\(tnc)")
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableView.register(UINib(nibName: "RegularCell", bundle: nil), forCellReuseIdentifier: "RegularCell")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(countryPicker(tapGestureRecognizer:)))
        self.countryFlag.isUserInteractionEnabled = true
        self.countryFlag.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
            let currentLocale = Locale.current
            let englishLocale: NSLocale = NSLocale.init(localeIdentifier: "en_US")
            print(englishLocale)
            
            var theEnglishName: String? = englishLocale.displayName(forKey: NSLocale.Key.identifier, value: currentLocale.identifier)
            if let theEnglishName = theEnglishName {
                
                country_name = theEnglishName.sliceFrom(start: "(", to: ")")!
                print(country_name)
                
            }
            if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                print(countryCode)
//                self.addMemberVC.getCountryPhoneCode(countryCode)
                self.countryFlag.image = UIImage(named: countryCode)
                self.phoneCode.text = countryCode.getCountryPhoneCode()

        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func createGroupButton(_ sender: UIButton) {
        print(groupName)
        print(countryId)
        print(cashoutMinVote)
        print(loanMinVote)
        print(tnc)
        print(loanFlag)
        if loanMinVote == "" {
            print("no loans for this group")
            let ballotDetailOne = BallotDetail(ballotId: "cashout", minVote: self.cashoutMinVote)
            let ballotArray = [ballotDetailOne]
            let parameterr: GroupCreationParameter = GroupCreationParameter(countryId: self.countryId, groupName: self.groupName, description: self.groupDesc, ballotDetail: ballotArray, tnc: self.tnc, msisdn: self.msisdnList, loanFlag: self.loanFlag)
            print(parameterr)
            FTIndicator.showProgress(withMessage: "creating group")
            self.createGroup(createGroupParameter: parameterr)
        }else {
            let ballotDetailOne = BallotDetail(ballotId: "cashout", minVote: self.cashoutMinVote)
            let ballotDetailTwo = BallotDetail(ballotId: "loan", minVote: self.loanMinVote)
            let ballotArray = [ballotDetailOne, ballotDetailTwo]
            let parameter: GroupCreationParameter = GroupCreationParameter(countryId: self.countryId, groupName: self.groupName, description: self.groupDesc, ballotDetail: ballotArray, tnc: self.tnc, msisdn: self.msisdnList, loanFlag: self.loanFlag)
            print(parameter)
            FTIndicator.showProgress(withMessage: "creating group")
            self.createGroup(createGroupParameter: parameter)
        }
        
        
    }
    
    
    @objc func countryPicker(tapGestureRecognizer: UITapGestureRecognizer){
        
        let alert = UIAlertController(title: "Area Code", message: "Select Country", preferredStyle: .actionSheet)
        
        alert.addLocalePicker(type: .phoneCode) { info in
            Log(info)
            let flag = (info?.flag)
            self.areaCode = ((info?.code)!)
            self.countryFlag.image = flag
            print((info?.flag)!)
            self.phoneCode.text = info?.phoneCode
        }
        
        let okAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func addMembersButtonAction(_ sender: Any) {
        if phoneNumberTextField.text == "" {
            showAlert(title: "Create Group", message: "No phone number added.")
        }else if msisdnList.contains("\(phoneCode.text!)\(phoneNumberTextField.text!)"){
            showAlert(title: "Create Group", message: "Phone number already added.")
        }else {
            let newNumber = "\(phoneCode.text!)\(phoneNumberTextField.text!)"
           let newNumberValue = AddedContactsModel(name_: "", phoneNumber_: newNumber, image_: "defaulticon")
            addedMembers.append(newNumberValue)
            msisdnList.append(newNumber)
            phoneNumberTextField.text = ""
            tableView.reloadData()
        }
    }
    
    @IBAction func contactPickerAction(_ sender: UIButton) {
        groupCheck = true
        let contactPickerScene = EPContactsPicker(delegate: self , multiSelection: false, subtitleCellType: SubtitleCellValue.phoneNumber)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
    @IBAction func skipButtonAction(_ sender: Any) {
        
    }
    
    
    func epContactPicker(_: EPContactsPicker, didCancel error: NSError){
        
    }
    
    func epContactPicker(_: EPContactsPicker, didSelectContact contact: EPContact){
        
        for item in contact.phoneNumbers {
            let phones = contact.phoneNumbers
            if phones.count > 1 {
//                for item in phones {
                    
                    switch UIDevice.current.screenType {
                        
                    case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
                        
                        let alert = UIAlertController(title: "Choose number", message: "", preferredStyle: .actionSheet)
                        
                        for item in phones {

                            let name = contact.displayName()
                            let numbers = item.phoneNumber
                            
                            let alpha = numbers.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
                            let gama: String = alpha.replacingOccurrences(of: "-", with: "")
                            let phi: String = gama.replacingOccurrences(of: ")", with: "")
                            let zeta: String = phi.replacingOccurrences(of: "(", with: "")
                            let beta: String = zeta.replacingOccurrences(of: " ", with: "")
                            print(numbers)
                            print(alpha)
                            print(beta)
                            
                            alert.addAction(title: beta, style: .default, handler: {(action) in

                                print("just selected \(beta)")
                            self.msisdnList.append(beta)
                            let newNumberValue = AddedContactsModel(name_: name, phoneNumber_: beta, image_: "defaulticon")
                                for item in self.addedMembers {
                                    if item.phoneNumber == beta {
                                        let alert = UIAlertController(title: "Chango", message: "Member already exists", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                                            
                                        }
                                        alert.addAction(okAction)
                                        self.present(alert, animated: true, completion: nil)
                                    }else {
                                        print("append \(newNumberValue.phoneNumber)")
                                        self.addedMembers.append(newNumberValue)
                                        self.tableView.reloadData()
                                    }
                                }

//                                }
//                            if self.loanMinVote == "" {
//                                print("no loans for this group")
//                                let ballotDetailOne = BallotDetail(ballotId: "cashout", minVote: self.cashoutMinVote)
//                                let ballotArray = [ballotDetailOne]
//                                let parameterr: GroupCreationParameter = GroupCreationParameter(countryId: self.countryId, groupName: self.groupName, description: self.groupDesc, ballotDetail: ballotArray, tnc: self.tnc, msisdn: self.msisdnList, loanFlag: self.loanFlag)
//                                print(parameterr)
//                                FTIndicator.showProgress(withMessage: "creating group")
//                                self.createGroup(createGroupParameter: parameterr)
//                            }else {
//                                let ballotDetailOne = BallotDetail(ballotId: "cashout", minVote: self.cashoutMinVote)
//                                let ballotDetailTwo = BallotDetail(ballotId: "loan", minVote: self.loanMinVote)
//                                let ballotArray = [ballotDetailOne, ballotDetailTwo]
//                                let parameter: GroupCreationParameter = GroupCreationParameter(countryId: self.countryId, groupName: self.groupName, description: self.groupDesc, ballotDetail: ballotArray, tnc: self.tnc, msisdn: self.msisdnList, loanFlag: self.loanFlag)
//                                print(parameter)
//                                FTIndicator.showProgress(withMessage: "creating group")
//                                self.createGroup(createGroupParameter: parameter)
//                            }catch {
//
//                                }
                            })
                        }
                        alert.addAction(title: "Cancel", style: .cancel)
                        self.present(alert, animated: true, completion: nil)
                        
                    default:
                        
                        print("default")
                        let alert = UIAlertController(title: "Choose number", message: "", preferredStyle: .alert)
                            let numbers = item.phoneNumber
                            let name = contact.displayName()

                            let alpha = numbers.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
                            let gama: String = alpha.replacingOccurrences(of: "-", with: "")
                            let phi: String = gama.replacingOccurrences(of: ")", with: "")
                            let zeta: String = phi.replacingOccurrences(of: "(", with: "")
                            let beta: String = zeta.replacingOccurrences(of: " ", with: "")
                            print(numbers)
                            print(alpha)
                            print(beta)
                        alert.addAction(title: beta, style: .default, handler: {(action) in

                            self.msisdnList.append(beta)
                            let newNumberValue = AddedContactsModel(name_: name, phoneNumber_: beta, image_: "defaulticon")
                            self.addedMembers.append(newNumberValue)
                            self.tableView.reloadData()
//                            if self.loanMinVote == "" {
//                                print("no loans for this group")
//                                let ballotDetailOne = BallotDetail(ballotId: "cashout", minVote: self.cashoutMinVote)
//                                let ballotArray = [ballotDetailOne]
//                                let parameterr: GroupCreationParameter = GroupCreationParameter(countryId: self.countryId, groupName: self.groupName, description: self.groupDesc, ballotDetail: ballotArray, tnc: self.tnc, msisdn: self.msisdnList, loanFlag: self.loanFlag)
//                                print(parameterr)
//                                FTIndicator.showProgress(withMessage: "creating group")
//                                self.createGroup(createGroupParameter: parameterr)
//                            }else {
//                                let ballotDetailOne = BallotDetail(ballotId: "cashout", minVote: self.cashoutMinVote)
//                                let ballotDetailTwo = BallotDetail(ballotId: "loan", minVote: self.loanMinVote)
//                                let ballotArray = [ballotDetailOne, ballotDetailTwo]
//                                let parameter: GroupCreationParameter = GroupCreationParameter(countryId: self.countryId, groupName: self.groupName, description: self.groupDesc, ballotDetail: ballotArray, tnc: self.tnc, msisdn: self.msisdnList, loanFlag: self.loanFlag)
//                                print(parameter)
//                                FTIndicator.showProgress(withMessage: "creating group")
//                                self.createGroup(createGroupParameter: parameter)
//                            }
                        })
                        alert.addAction(title: "Cancel", style: .cancel)
                        self.present(alert, animated: true, completion: nil)
                    }
            } else {
                
                print("single contact")
                        let numbers = item.phoneNumber
                        let name = contact.displayName()

                               let alpha = numbers.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
                               let gama: String = alpha.replacingOccurrences(of: "-", with: "")
                               let phi: String = gama.replacingOccurrences(of: ")", with: "")
                               let zeta: String = phi.replacingOccurrences(of: "(", with: "")
                               let beta: String = zeta.replacingOccurrences(of: " ", with: "")
                               print(numbers)
                               print(alpha)
                               print(beta)
                               
                               //                phoneNumber.text = beta
//                               do {
//                                   self.mapped = self.addedMembers.map {
//                                       do {
//                                           let mappedMember = try self.phoneNumberKit.parse($0.phoneNumber)
//                                           let national = self.phoneNumberKit.format(mappedMember, toType: .national)
//
//                                           return national
//                                       }
//                                       catch {
//                                           return ""
//                                       }
//                                   }
//
//                                   let phoneNumberBeta = try self.phoneNumberKit.parse(beta)
//                                   let betaValue = self.phoneNumberKit.format(phoneNumberBeta, toType: .national)
//                                   print("beta number: \(betaValue)")
//
//
//                        }catch {
                            
//                        }
//                        self.mapped = self.addedMembers.map
                
                
                        self.msisdnList.append(beta)
                        let newNumberValue = AddedContactsModel(name_: name, phoneNumber_: beta, image_: "defaulticon")
                        self.addedMembers.append(newNumberValue)
                        self.tableView.reloadData()
                    }
//                if self.loanMinVote == "" {
//                    print("no loans for this group")
//                    let ballotDetailOne = BallotDetail(ballotId: "cashout", minVote: self.cashoutMinVote)
//                    let ballotArray = [ballotDetailOne]
//                    let parameterr: GroupCreationParameter = GroupCreationParameter(countryId: self.countryId, groupName: self.groupName, description: self.groupDesc, ballotDetail: ballotArray, tnc: self.tnc, msisdn: self.msisdnList, loanFlag: self.loanFlag)
//                    print(parameterr)
//                    FTIndicator.showProgress(withMessage: "creating group")
//                    self.createGroup(createGroupParameter: parameterr)
//                }else {
//                    let ballotDetailOne = BallotDetail(ballotId: "cashout", minVote: self.cashoutMinVote)
//                    let ballotDetailTwo = BallotDetail(ballotId: "loan", minVote: self.loanMinVote)
//                    let ballotArray = [ballotDetailOne, ballotDetailTwo]
//                    let parameter: GroupCreationParameter = GroupCreationParameter(countryId: self.countryId, groupName: self.groupName, description: self.groupDesc, ballotDetail: ballotArray, tnc: self.tnc, msisdn: self.msisdnList, loanFlag: self.loanFlag)
//                    print(parameter)
//                    FTIndicator.showProgress(withMessage: "creating group")
//                    self.createGroup(createGroupParameter: parameter)
//                }
            
        }
        print(self.groupName)
        print(self.countryId)
        print(self.cashoutMinVote)
        print(self.loanMinVote)
        print(self.tnc)
    }
    
//    func epContactPicker(_: EPContactsPicker, didSelectMultipleContacts contacts: [EPContact]) {
//        msisdnList = []
//        for item in contacts {
//            print(item.phoneNumbers[0].phoneNumber)
//            let numbers = item.phoneNumbers[0].phoneNumber
//            let alpha = numbers.removeCharacters(from: CharacterSet.decimalDigits.inverted)
//            print("alpha: \(alpha)")
//            self.msisdnList.append(alpha)
//        }
//        print(self.groupName)
//        print(self.countryId)
//        print(self.cashoutMinVote)
//        print(self.loanMinVote)
//        print(self.tnc)
//    }
    
    func createGroupNow() {
        print("list: \(msisdnList.count)")
        if (contactPicked == 1) {
            print("contact has been picked and group will be created now")
        }else {
            print("contact was empty cos count was \(msisdnList.count)")
        }
    }
    
    func createGroup(createGroupParameter: GroupCreationParameter) {
        AuthNetworkManager.createGroup(parameter: createGroupParameter) { (result) in
            self.parseCreateGroupResponse(result: result)
        }
    }
    
    private func parseCreateGroupResponse(result: DataResponse<CreateGroupResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            print("empty msisdn")
            if response.responseCode == "01" {
            let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! UINavigationController
            let alert = UIAlertController(title: "Chango", message: "\(response.responseMessage!)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            }else {
                let alert = UIAlertController(title: "Chango", message: "\(response.responseMessage!)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Go to Settings", style: .default) { (action: UIAlertAction!) in
                    let vc2: SettingsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersettings") as! SettingsVC
                    vc2.allGroups = allGroups
                    vc2.movedFromWallet = false
                    self.navigationController?.pushViewController(vc2, animated: true)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            
            break
        case .failure(_ ):
            if (result.response?.statusCode == 400) {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: RegularCell = tableView.dequeueReusableCell(withIdentifier: "RegularCell", for: indexPath) as! RegularCell
        cell.selectionStyle = .none
        let addedMember = addedMembers[indexPath.row]
        
        cell.topValue.text = addedMember.name
        cell.bottomValue.text = addedMember.phoneNumber
        cell.imageIcon.image = UIImage(named: addedMember.image)
        cell.removeButton.isHidden = false
        cell.removeButton.addTarget(self, action: #selector(RemoveContact(button:)), for: .touchUpInside)
        cell.removeButton.tag = indexPath.row
        
        return cell
    }
    
    @objc func RemoveContact(button: UIButton) {

        memberTag = addedMembers[button.tag]
        
        let memberValue = AddedContactsModel(name_: memberTag.name, phoneNumber_: memberTag.phoneNumber, image_: memberTag.image)
        print("value: \(memberValue), \(button.tag)")
        addedMembers.remove(at: button.tag)
        msisdnList.remove(at: button.tag)
        tableView.reloadData()
    }
    
}


extension String {
    
    func removeCharacters(from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }
    
    func removeCharacters(from: String) -> String {
        return removeCharacters(from: CharacterSet(charactersIn: from))
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
