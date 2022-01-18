//
//  ContactUsVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 10/08/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseDatabase
import IQKeyboardManagerSwift
import FTIndicator
import MessageUI
import PopupDialog
import Alamofire
import SafariServices

class ContactUsVC: BaseViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var phoneNumberTextField: ACFloatingTextfield!
    @IBOutlet weak var emailTextField: ACFloatingTextfield!
    @IBOutlet weak var messageTextView: IQTextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var phoneNumberLabel: UIButton!
    @IBOutlet weak var emailLabel: UIButton!
    @IBOutlet weak var requestCallBackButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    private var alertStyle: UIAlertController.Style = .alert
    
    typealias FetchUserCountryIdCompletionHandler = (_ countryId: String ) -> Void
    
    var loginCheck: Int = 0
    var countryPickerCheck: Int = 0
    var supportPhoneNumber: String = ""
    var supportEmail: String = ""
    var countryCode: String = ""
    var authProviderIdd: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableDarkMode()
        
        authProviderIdd = Auth.auth().currentUser?.uid as! String
        
        if loginCheck == 1 {
            print("logged")
//            closeButton.isHidden = true
            fetchLoggedInUsersCountryId(completionHandler: { (result) in
                self.countryCode = result
                if result != "GH"{
                    self.requestCallBackButton.isHidden = true
                }else{
                    let parameter : GetSupportDetailsParameter = GetSupportDetailsParameter(countryId: self.countryCode)
                    self.getSupportDetails(getSupportDetailsParameter: parameter)
                    self.requestCallBackButton.isHidden = false
                }
            }, authProviderId: Auth.auth().currentUser!.uid)
        }else {
            closeButton.setImage(UIImage(named: "icons-dark-back"), for: .normal)
            requestCallBackButton.isHidden = true
//            selectCountry()
        }
        
//        let parameter : GetSupportDetailsParameter = GetSupportDetailsParameter(countryId: "gh")
//        getSupportDetails(getSupportDetailsParameter: parameter)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        if loginCheck == 0 {

            self.dismiss(animated: true, completion: nil)
        }else {
            self.getEasySlide().openMenu(.leftMenu, animated: true, completion: {})
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if loginCheck == 0{
            requestCallBackButton.isHidden = true
            if countryPickerCheck == 1 {
//            selectCountry()
                countryPickerCheck = 0
            }
        }
    }
    
    
    @IBAction func emailButtonAction(_ sender: UIButton) {
        let email = supportEmail
        if MFMailComposeViewController.canSendMail() {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([email])
        mail.setSubject("Feedback on Chango")
            mail.setMessageBody("Name: <br> Email: \((Auth.auth().currentUser?.email)!) <br> Issue: ", isHTML: true)
        present(mail, animated: true)
        }else if let emailUrl = createEmailUrl(to: email, subject: "Feedback on Chango", body: "<br> Name: \((Auth.auth().currentUser?.displayName)!) <br> Email: \((Auth.auth().currentUser?.email)!) <br> Issue: ") {
            UIApplication.shared.open(emailUrl)
        }
    }
    
        private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
            let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

            let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
            let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
            let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
            let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
            let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

            if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
                return gmailUrl
            } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
                return outlookUrl
            } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
                return yahooMail
            } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
                return sparkUrl
            }

            return defaultUrl
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    
    
    
    func selectCountry() {
        
        let alert = UIAlertController(style: .alert, message: "Select Country")
        alert.addSupportLocalePicker(type: .country) { info in
            Log(info)
            let flag = (info?.flag)
            self.countryCode = ((info?.code)!)
//            self.countryFlag.image = flag
            print((info?.flag)!)
            print((info?.code)!)
            let parameter : GetSupportDetailsParameter = GetSupportDetailsParameter(countryId: self.countryCode)
            self.getSupportDetails(getSupportDetailsParameter: parameter)
        }
        alert.addAction(title: "OK", style: .cancel)
        alert.show()

    }
    
    
    @IBAction func sendButton(_ sender: UIButton) {
        
    }
    
    
    @IBAction func closePage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func callButton(_ sender: UIButton) {
        guard let number = URL(string: "tel://" + supportPhoneNumber) else { return }
        UIApplication.shared.open(number)
    }
    
    @IBAction func facebookPageLink(_ sender: UIButton) {
        let facebookUrl = URL(string: "fb://profile/378687889237936")!
        if UIApplication.shared.canOpenURL(facebookUrl){
            UIApplication.shared.open(facebookUrl)
        }else{
            let url = "https://m.facebook.com/ITConsortiumGhana"
            let vc = SFSafariViewController(url: URL(string: url)!)
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func twitterPageLink(_ sender: UIButton) {
        let twitterUrl = URL(string: "https://twitter.com/itconsortium_gh")!
        if UIApplication.shared.canOpenURL(twitterUrl){
            UIApplication.shared.open(twitterUrl)
        }else{
            let url = "https://twitter.com/itconsortium_gh"
            let vc = SFSafariViewController(url: URL(string: url)!)
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func instagramPageLInk(_ sender: UIButton) {
        let instagramUrl = URL(string: "https://www.instagram.com/itconsortium")!
        if UIApplication.shared.canOpenURL(instagramUrl){
            UIApplication.shared.open(instagramUrl)
        }else{
            let url = "https://www.instagram.com/itconsortium"
            let vc = SFSafariViewController(url: URL(string: url)!)
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func requestCallBackButton(_ sender: UIButton) {
        let vc: RequestCallBackVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "requestcallback") as! RequestCallBackVC
        vc.loginCheck = loginCheck
        if loginCheck == 0 {
            self.present(vc, animated: true, completion: nil)
        }else {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func DrawerButtonAction(_ sender: UIBarButtonItem) {
        self.getEasySlide().openMenu(.leftMenu, animated: true, completion: {})
    }
    
    // EASY SLIDE
    fileprivate func getEasySlide() -> ESNavigationController {
        return self.navigationController as! ESNavigationController
    }
    
    
    //PASSWORD RESET DIALOG
    func showCallBackRequestDialog(animated: Bool = true) {
        
        //create a custom view controller
        let callBackRequestVC = CallBackRequestCell(nibName: "CallBackRequestCell", bundle: nil)
        
        //create the dialog
        let popup = PopupDialog(viewController: callBackRequestVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
        
        if let phoneNumber : String = Auth.auth().currentUser?.phoneNumber {
            callBackRequestVC.phoneNumber.text = phoneNumber
        }else {
            callBackRequestVC.phoneNumber.text = ""
        }
        
        //create second button
        let callBackButton = DefaultButton(title: "CALL BACK", height: 60) {
            //            self.label.text = "Password sent to you mail"
            if(callBackRequestVC.phoneNumber.text?.isEmpty)!{
                self.showAlert(title: "Request Call Back", message: "Please enter phone number")
            }else {
                FTIndicator.showProgress(withMessage: "loading")
                let parameter: RequestACallbackParameter = RequestACallbackParameter(contactNumber: callBackRequestVC.phoneNumber.text!)
                self.requestACallback(requestACallbackParameter: parameter)
                }
            }
        
        //Add buttons to dialogz
        popup.addButtons([callBackButton])
        
        //Present dialog
        present(popup, animated: animated, completion: nil)
        
    }
    
    
    func fetchLoggedInUsersCountryId(completionHandler: @escaping FetchUserCountryIdCompletionHandler, authProviderId: String){
        var countryId: String = ""
        let memberRef = Database.database().reference().child("users").child("\(authProviderIdd)")
        _ = memberRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
                        print("dict: \(snapshot)")

            let snapshotValue = snapshot.value as? [String:AnyObject]
            
            if let cntryId = snapshotValue?["countryId"] as? String {
                print("cid:\(cntryId)")
                countryId = cntryId
            }

            completionHandler(countryId)
            
        })
        
    }
    
    //GET SUPPORT DETIALS
    func getSupportDetails(getSupportDetailsParameter: GetSupportDetailsParameter) {
        AuthNetworkManager.getSupportDetails(parameter: getSupportDetailsParameter) { (result) in
            self.parseGetSupportDetailsResponse(result: result)
        }
    }
    
    private func parseGetSupportDetailsResponse(result: DataResponse<GetSupportDetailsResponse, AFError>){
        switch result.result {
        case .success(let response):
            FTIndicator.dismissProgress()
            print("response: \(response)")
            
            phoneNumberLabel.setTitle("\(response.phone ?? "+233 552 571 940")", for: .normal)
            supportEmail = response.email ?? "chango@itconsortiumgh.com"
            supportPhoneNumber = response.phone ?? "+233 552 571 940"
            if response.countryId! == "GH" && loginCheck != 0 {
                requestCallBackButton.isHidden = false
            }
            break
        case .failure(_ ):
            FTIndicator.dismissProgress()

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
    
    
    //REQUEST A CALL BACK
    func requestACallback(requestACallbackParameter: RequestACallbackParameter) {
        AuthNetworkManager.requestACallback(parameter: requestACallbackParameter) { (result) in
            self.parseRequestACallbackResponse(result: result)
        }
    }
    
    private func parseRequestACallbackResponse(result: DataResponse<RevokeLoanApproverResponse, AFError>){
        switch result.result {
        case .success(let response):
            FTIndicator.dismissProgress()
            print("response: \(response)")
            
            showAlertWithPopView(title: "Contact Us", message: response.responseMessage!)
            break
        case .failure(let error):
            FTIndicator.dismissProgress()

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
