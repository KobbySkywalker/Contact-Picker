//
//  AddMemberViewController.swift
//  Chango v2
//
//  Created by Hosny Savage on 26/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import EPContactsPicker
import FTIndicator
import PhoneNumberKit

class AddMemberViewController: BaseViewController, EPPickerDelegate, UITextFieldDelegate {
    
    var privateGroup: GroupResponse!

    @IBOutlet weak var phoneCode: UILabel!
    @IBOutlet weak var phoneNumber: ACFloatingTextfield!
    @IBOutlet weak var changeFlag: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var textfieldLine: UIView!
    private var alertStyle: UIAlertController.Style = .alert

    var country_name: String = ""
    var areaCode: String = ""
    var msisdnList: [String] = []
    var groupId: String = ""
    var enteredPhoneNumbers: [String] = []
    var members: [MemberResponse] = []

    let phoneNumberKit = PhoneNumberKit()
    
    var mapped: [String] = []


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        
        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(countryPicker(tapGestureRecognizer:)))
        self.changeFlag.isUserInteractionEnabled = true
        self.changeFlag.addGestureRecognizer(tapGestureRecognizer)
        
        addButton.cornerRadius = 10.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationItem.title = "Add Member"
        self.navigationItem.titleView?.tintColor = UIColor.white
        
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
//            self.getCountryPhoneCode(countryCode)
            self.changeFlag.image = UIImage(named: countryCode)
            self.phoneCode.text = countryCode.getCountryPhoneCode()
        }
        
    }
    
    

    
    func epContactPicker(_: EPContactsPicker, didCancel error: NSError){
        
    }
    
    func epContactPicker(_: EPContactsPicker, didSelectContact contact: EPContact){
        
        for item in contact.phoneNumbers {
            let phones = contact.phoneNumbers
            if phones.count > 1 {
                //                        let alert = UIAlertController(title: "Choose number", message: "", preferredStyle: .actionSheet)
                
                switch UIDevice.current.screenType {
                    
                    
                case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
                        
                        let alert = UIAlertController(title: "Choose number", message: "", preferredStyle: .actionSheet)
                        
                        for item in phones {

                        alert.addAction(title: item.phoneNumber, style: .default, handler: {(action) in
                            
                            var numbers = item.phoneNumber
                            
                            let alpha = numbers.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
                            let gama: String = alpha.replacingOccurrences(of: "-", with: "")
                            let phi: String = gama.replacingOccurrences(of: ")", with: "")
                            let zeta: String = phi.replacingOccurrences(of: "(", with: "")
                            let beta: String = zeta.replacingOccurrences(of: " ", with: "")
                            print(numbers)
                            print(alpha)
                            print(beta)
                            
                            do {
                                
                                self.mapped = self.members.map {
                                    do {
                                        let mappedMember = try self.phoneNumberKit.parse($0.memberId.msisdn!)
                                        let national = self.phoneNumberKit.format(mappedMember, toType: .national)
                                        
                                        return national
                                    }
                                    catch {
                                        
                                        return ""
                                    }
                                }
                                
                                let phoneNumberBeta = try self.phoneNumberKit.parse(beta)
                                let betaValue = self.phoneNumberKit.format(phoneNumberBeta, toType: .national)
                                print("beta number: \(betaValue)")
                                
                                if self.mapped.contains(betaValue)  {
                                    
                                    let alert = UIAlertController(title: "Chango", message: "Member already exists", preferredStyle: .alert)
                                    
                                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                                        
                                    }
                                    alert.addAction(okAction)
                                    
                                    self.present(alert, animated: true, completion: nil)
                                }else {
                                    FTIndicator.showProgress(withMessage: "Adding Member(s)")
                                    
                                    let parameter: AddMemberParameter = AddMemberParameter(groupId: self.groupId, msisdnList: [beta])
                                    print("selected number: \(beta)")
                                    self.addMember(addMemberParameter: parameter)
                                }
                            }
                            catch {
                                print("Generic parser error")
                            }
                            
                        })
                        
                    }
                        
                        alert.addAction(title: "Cancel", style: .cancel)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    
                default:
                    
                    var phoneNumb: [String] = []
                    for item in phones {
                        
                        phoneNumb.append(item.phoneNumber)
                    }
                        
                        let alert = UIAlertController(title: "Choose number", message: "", preferredStyle: .alert)
                        
                    for item in phoneNumb {
                            
                            var numbers = item
                            
                            let alpha = numbers.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
                            let gama: String = alpha.replacingOccurrences(of: "-", with: "")
                            let phi: String = gama.replacingOccurrences(of: ")", with: "")
                            let zeta: String = phi.replacingOccurrences(of: "(", with: "")
                            let beta: String = zeta.replacingOccurrences(of: " ", with: "")
                            print(numbers)
                            print(alpha)
                            print(beta)
                            
                        alert.addAction(title: beta, style: .default, handler: {(action) in

                            do {
                                
                                self.mapped = self.members.map {
                                    do {
                                        let mappedMember = try self.phoneNumberKit.parse($0.memberId.msisdn!)
                                        let national = self.phoneNumberKit.format(mappedMember, toType: .national)
                                        
                                        return national
                                    }
                                    catch {
                                        
                                        return ""
                                    }
                                }
                                
                                let phoneNumberBeta = try self.phoneNumberKit.parse(beta)
                                let betaValue = self.phoneNumberKit.format(phoneNumberBeta, toType: .national)
                                print("beta number: \(betaValue)")
                                
                                if self.mapped.contains(betaValue)  {
                                    
                                    let alert = UIAlertController(title: "Chango", message: "Member already exists", preferredStyle: .alert)
                                    
                                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                                        
                                    }
                                    alert.addAction(okAction)
                                    
                                    self.present(alert, animated: true, completion: nil)
                                }else {
                                    FTIndicator.showProgress(withMessage: "Adding Member(s)")
                                    
                                    let parameter: AddMemberParameter = AddMemberParameter(groupId: self.groupId, msisdnList: [beta])
                                    print("selected number: \(beta)")
                                    self.addMember(addMemberParameter: parameter)
                                }
                            }
                            catch {
                                print("Generic parser error")
                            }
                            
                        })
                        
                    }
                        
                        alert.addAction(title: "Cancel", style: .cancel)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                }
                
            }else {
                
                let numbers = item.phoneNumber
                
                let alpha = numbers.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
                let gama: String = alpha.replacingOccurrences(of: "-", with: "")
                let phi: String = gama.replacingOccurrences(of: ")", with: "")
                let zeta: String = phi.replacingOccurrences(of: "(", with: "")
                let beta: String = zeta.replacingOccurrences(of: " ", with: "")
                print(numbers)
                print(alpha)
                print(beta)
                
                //                phoneNumber.text = beta
                do {
                    self.mapped = self.members.map {
                        do {
                            let mappedMember = try self.phoneNumberKit.parse($0.memberId.msisdn!)
                            let national = self.phoneNumberKit.format(mappedMember, toType: .national)
                            
                            return national
                        }
                        catch {
                            return ""
                        }
                    }
                    
                    let phoneNumberBeta = try self.phoneNumberKit.parse(beta)
                    let betaValue = self.phoneNumberKit.format(phoneNumberBeta, toType: .national)
                    print("beta number: \(betaValue)")
                    
                    if self.mapped.contains(betaValue) {
                        let alert = UIAlertController(title: "Chango", message: "Member already exists", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                            
                        }
                        alert.addAction(okAction)
                        
                        self.present(alert, animated: true, completion: nil)
                    }else {
                        FTIndicator.showProgress(withMessage: "Adding Member(s)")
                        
                        let parameter: AddMemberParameter = AddMemberParameter(groupId: self.groupId, msisdnList: [betaValue])
                        print("selected number: \(betaValue)")
                        self.addMember(addMemberParameter: parameter)
                    }
                    
                }
                catch {
                    print("Generic parser error")
                    
                }
                
                
                
                //                for item in self.members {
                //
                //                    do {
                //                                            let phoneNumber = try self.phoneNumberKit.parse(item.memberId.msisdn)
                //                       let memberList = self.phoneNumberKit.format(phoneNumber, toType: .national)
                //                        print("list number: \(memberList)")
                //
                //                        let phoneNumberBeta = try self.phoneNumberKit.parse(beta)
                //                        let betaValue = self.phoneNumberKit.format(phoneNumberBeta, toType: .national)
                //                        print("beta number: \(betaValue)")
                //
                //
                //
                //                        if betaValue == memberList  {
                //
                //                            let alert = UIAlertController(title: "Chango", message: "Member already exists", preferredStyle: .alert)
                //
                //                            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                //
                //                            }
                //
                //                            alert.addAction(okAction)
                //
                //                            self.present(alert, animated: true, completion: nil)
                //                        }else {
                //
                //                        FTIndicator.showProgress(withMessage: "Adding Member(s)")
                //
                //                let parameter: AddMemberParameter = AddMemberParameter(groupId: self.groupId, msisdnList: [beta])
                //                        print("selected number: \(beta)")
                //                        self.addMember(addMemberParameter: parameter)
                //                        }
                //                    }
                //                        catch {
                //                            print("Generic parser error")
                //                    }
                //                }
            }
        }
    }
//    func epContactPicker(_: EPContactsPicker, didSelectMultipleContacts contacts: [EPContact]) {
////            let phones = contacts[0].phoneNumbers
////        if(phones.count>1){
////
////            let alert = UIAlertController(title: "Choose number", message: "", preferredStyle: .actionSheet)
////
////            for item in phones {
////
////                alert.addAction(title: item.phoneNumber, style: .default, handler: {(action) in
////
////                    let numbers = item.phoneNumber
////
////                    let alpha = numbers.removeCharacters(from: CharacterSet.decimalDigits.inverted)
////                    print(alpha)
////
////                    self.msisdnList.append(alpha)
////
////                })
////
////
////            }
////
////            alert.addAction(title: "Cancel", style: .cancel)
////
////
////            self.present(alert, animated: true, completion: nil)
////
////            FTIndicator.showProgress(withMessage: "Adding Member(s)")
////
////            let parameter: AddMemberParameter = AddMemberParameter(groupId: groupId, msisdnList: self.msisdnList)
////            print("selected number: \(self.msisdnList)")
////            self.addMember(addMemberParameter: parameter)
////
////        }else {
//
//        //Multiple contacts
////        for item in contacts {
////            print(item.phoneNumbers[0].phoneNumber)
////            let numbers = item.phoneNumbers[0].phoneNumber
////
////            let alpha = numbers.removeCharacters(from: CharacterSet.decimalDigits.inverted)
////            print(alpha)
////
////            self.msisdnList.append(alpha)
////
////
////
////        }
////
////        if msisdnList == [] {
////
////        }else {
////
////        FTIndicator.showProgress(withMessage: "Adding Member(s)")
////
////        let parameter: AddMemberParameter = AddMemberParameter(groupId: groupId, msisdnList: self.msisdnList)
////        print("selected number: \(self.msisdnList)")
////        self.addMember(addMemberParameter: parameter)
////        }
//    }
    
    
    @objc func countryPicker(tapGestureRecognizer: UITapGestureRecognizer){
        
        let alert = UIAlertController(title: "Area Code", message: "Select Country", preferredStyle: self.alertStyle)
        
        alert.addLocalePicker(type: .phoneCode) { info in
            Log(info)
            let flag = (info?.flag)
            self.areaCode = ((info?.code)!)
            self.changeFlag.image = flag
            print((info?.flag)!)
            self.phoneCode.text = info?.phoneCode
        }
        alert.addAction(title: "Cancel", style: .cancel)
        self.present(alert, animated: true, completion: nil)
//        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//
//
//
//        }
        
//        alert.addAction(okAction)
        
//        switch UIDevice.current.userInterfaceIdiom {
//        case .pad:
//            alert.popoverPresentationController?.sourceView = sender as UIView
//            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
//            alert.popoverPresentationController?.permittedArrowDirections = .up
//        default:
//            break
//        }
        
//        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func contactsPickerButtonAction(_ sender: Any) {
        let contactPickerScene = EPContactsPicker(delegate: self , multiSelection: false, subtitleCellType: SubtitleCellValue.phoneNumber)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    @IBAction func countryPickerButtonAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Area Code", message: "Select Country", preferredStyle: .alert)
        
        alert.addLocalePicker(type: .phoneCode) { info in
            Log(info)
            let flag = (info?.flag)
            self.areaCode = ((info?.code)!)
            self.changeFlag.image = flag
            print((info?.flag)!)
            self.phoneCode.text = info?.phoneCode
        }
        alert.addAction(title: "Cancel", style: .cancel)
        self.present(alert, animated: true, completion: nil)

//        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//
//
//        }
//
//        alert.addAction(okAction)
        
//        switch UIDevice.current.userInterfaceIdiom {
//        case .pad:
//            alert.popoverPresentationController?.sourceView = sender as UIView
//            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
//            alert.popoverPresentationController?.permittedArrowDirections = .up
//        default:
//            break
//        }
//        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func addMemberButtonAction(_ sender: UIButton) {
        let finalNumber = checkNumber(number: phoneNumber.text!, countryCode: phoneCode.text!)
                
        self.msisdnList = [finalNumber]
        
        do {
            self.mapped = self.members.map {
                do {
                    let mappedMember = try self.phoneNumberKit.parse($0.memberId.msisdn!)
                let national = self.phoneNumberKit.format(mappedMember, toType: .national)
                
                return national
            }
                catch {
                    return ""
                }
        }
            
            let phoneNumberBeta = try self.phoneNumberKit.parse(finalNumber)
            let betaValue = self.phoneNumberKit.format(phoneNumberBeta, toType: .national)
            print("beta number: \(betaValue)")
            
            if self.mapped.contains(betaValue) {
                let alert = UIAlertController(title: "Chango", message: "Member already exists", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                }
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }else {
                        print("entered number: \(self.msisdnList)")
                        
                        FTIndicator.showProgress(withMessage: "Adding member")
                        
                        let parameters: AddMembersToGroupParameter = AddMembersToGroupParameter(groupId: groupId, msisdnList: self.msisdnList)
                        addMemberToGroups(addmembersToGroupParameter: parameters)
            }
            
        }
        catch {
            print("Generic parser error")

        }
        
//        print("entered number: \(self.msisdnList)")
//
//        FTIndicator.showProgress(withMessage: "Adding member")
//
//        let parameters: AddMembersToGroupParameter = AddMembersToGroupParameter(groupId: groupId, msisdnList: self.msisdnList)
//        addMemberToGroups(addmembersToGroupParameter: parameters)
    }
    
    
    
    
    
    func addMember(addMemberParameter: AddMemberParameter) {
        AuthNetworkManager.addMember(parameter: addMemberParameter) { (result) in
//            self.parseAddMemberResponse(result: result)
            
            FTIndicator.dismissProgress()
            print("result: \(result)")
            
            
                let alert = UIAlertController(title: "Chango", message: "\(result)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//                    let vc: MembersViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "members") as! MembersViewController
//
//                    self.present(vc, animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)

                }

                alert.addAction(okAction)

                self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func addMemberToGroups(addmembersToGroupParameter: AddMembersToGroupParameter) {
        AuthNetworkManager.addMembersToGroup(parameter: addmembersToGroupParameter) { (result) in
            FTIndicator.dismissProgress()
            print("result: \(result)")
            if  result.contains("405") {
                print("it contains 405")
            }else if result.contains("400"){
                
                self.sessionTimeout()

            }else {
        
            
            let alert = UIAlertController(title: "Chango", message: "\(result)", preferredStyle: .alert)
            let  okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.navigationController?.popViewController(animated: true)
//                self.dismiss(animated: true, completion: nil)
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            }
        }
            
    }
    
    
    private func parseAddMemberResponse(result: DataResponse<String, AFError>){
        switch result.result {
        case .success(let response):
            print(response)
            let alert = UIAlertController(title: "Chango", message: "\(result)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in

                self.navigationController?.popViewController(animated: true)
                
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
}
