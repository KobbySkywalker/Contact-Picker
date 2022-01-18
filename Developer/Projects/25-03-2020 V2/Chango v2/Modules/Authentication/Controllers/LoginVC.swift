//
//  LoginVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 14/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alamofire
import PopupDialog
import FTIndicator
import LocalAuthentication
import FirebaseDatabase
import AuthenticationServices

let globalAppVersion: String = "1.3.6"

class LoginVC: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: ACFloatingTextfield!
    @IBOutlet weak var password: ACFloatingTextfield!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordResetButton: UIButton!
    @IBOutlet weak var eyeImage: UIButton!
    @IBOutlet weak var verifyEmailButton: UIButton!
    @IBOutlet weak var passwordButtonIcon: UIImageView!
    
    typealias FetchUIDCompletionHandler = (_ user: UserObject) -> Void
    
    var fromPush: Bool = false
    var iconClick = true
    
    var privateGroups: [GroupResponse] = []
    var userObject: UserObject!
    
    var phoneNumber: String = ""
    var areaCode: String = ""
    var memberExists: String = ""
    var countryCode: String = ""
    
    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()

        UserDefaults.standard.set(true, forKey: "regular")
        
        loginButton.layer.cornerRadius = 10.0
        
        _ = SwiftEventBus.onMainThread(self, name: "push") { result in
            self.fromPush = true
        }
        eyeImage.isHidden = true
        password.delegate = self
        // Do any additional setup after loading the view.
                
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = .white
        
        email.text = ""
        password.text = ""
        password.setLeftPaddingPoints(50)
        
        if let uEmail : String = UserDefaults.standard.string(forKey: "email") {
            self.email.text = uEmail
        }else {
            self.email.text = ""
//            self.password.isHidden = true
//            self.passwordButtonIcon.isHidden = true
//            self.loginButton.isHidden = true
//            self.verifyEmailButton.isHidden = false
        }
        
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == password) {
            print("show icon")
            eyeImage.isHidden = false
        }else {
            eyeImage.isHidden = true
        }
    }
    
    @IBAction func eyeButtonAction(_ sender: UIButton) {
        
        if(iconClick == true) {
            if case eyeImage.imageView?.image = UIImage(named: "invisible") {
                //                sender.setImage(UIImage(named: "eye"), for: .normal)
            }
            sender.setTitle("HIDE", for: .normal)
            password.isSecureTextEntry = false
            print("made visible so image invisible")
            
        } else {
            if case eyeImage.imageView?.image = UIImage(named: "eye") {
                //                sender.setImage(UIImage(named: "invisible"), for: .normal)
                
            }
            sender.setTitle("SHOW", for: .normal)
            password.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
        
    }
    

    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        print("email valid?: \(emailTest.evaluate(with: testStr))")
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else {
            return false }
        
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[0-9])(?=.*[a-z]).{8,}")
        
        print(passwordTest.evaluate(with: testStr))
        return passwordTest.evaluate(with: testStr)
    }
    
    func areaCodeSearch(phoneNumber: String){
        let phoneUtil = NBPhoneNumberUtil()
        
        do {
            let phone: NBPhoneNumber = try phoneUtil.parse(phoneNumber, defaultRegion: nil)
            //        let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .E164)
            areaCode = phoneUtil.getRegionCode(for: phone)
            //
            //        NSLog("[%@]", formattedString)
            //        print("formatted string \(formattedString)")
            
            print("code: \(areaCode)")
        }catch {
            
        }
    }
    
    @IBAction func verifyEmailButton(_ sender: UIButton) {
        if (email.text!.isEmpty) {
            showAlert(title: "Sign in", message: "Please enter email address.")
        }
        else if isValidEmail(testStr: email.text!) == false {
            showAlert(title: "Sign in", message: "Invalid email")
        }
        else {
            FTIndicator.showProgress(withMessage: "verifying")
            let parameters: CheckMemberDetailsParameter = CheckMemberDetailsParameter(email: self.email.text!, msisdn: "")
            checkEmailAddress(checkEmailParameter: parameters)
        }
    }
    
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        if (email.text!.isEmpty) {
            showAlert(title: "Sign in", message: "Please enter email address.")
        }
        else if (password.text!.isEmpty) {
            showAlert(title: "Sign in", message: "Please enter password.")
        }
        else if isValidEmail(testStr: email.text!) == false {
            showAlert(title: "Sign in", message: "Invalid email")
        }
        else if isValidPassword(testStr: password.text) == false {
            showAlert(title: "Sign in", message: "Passwords should contain at least one digit, one alphabet and at least 8 characters.")
        }
        else {
            getCurrentAppVersion()
        }

    }

    func validateAuthentication() {

        FTIndicator.showProgress(withMessage: "Authenticating", userInteractionEnable: false)

        Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { (authResult, error) in
            if error != nil {
                FTIndicator.dismissProgress()
                if error?.localizedDescription == "Network error (such as timeout, interrupted connection or unreachable host) has occurred." {
                    self.showAlert(withTitle: "Sign in", message: "Network Error. Please check your connection and try again.")
                } else if error?.localizedDescription == "Too many unsuccessful login attempts. Please try again later." {
                    print(error?.localizedDescription)
                    let alert = UIAlertController(title: "Sign in", message: "Too many unsuccessful login attempts. Please try again later.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        //reset password
                        Auth.auth().sendPasswordReset(withEmail: self.email.text!) { (error) in
                            print(error)
                        }
                        alert.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }else {
                    print(error?.localizedDescription)
                    self.showAlert(withTitle: "Sign in", message: "Invalid credentials")
                }
            }else if (!(Auth.auth().currentUser?.phoneNumber != nil)) {
                FTIndicator.dismissProgress()
                print("nname: \(Auth.auth().currentUser?.displayName)")
                let vc: AddMobileNumberVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mobile") as! AddMobileNumberVC
                vc.email = self.email.text!
                vc.password = self.password.text!
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
            else if (!(Auth.auth().currentUser?.displayName != nil)) {
                FTIndicator.dismissProgress()
                print("print no display name")
                let vc: CompleteRegistrationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "complete") as! CompleteRegistrationVC
                vc.email = self.email.text!
                vc.password = self.password.text!
                //vc.areaCode = self.areaCode
                //get the area code before leaving this area.
                vc.phone = (Auth.auth().currentUser?.phoneNumber)!
                vc.changeName = 1
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
            else{
                print("get token")
                let prefs: UserDefaults = UserDefaults.standard
                let users = Auth.auth().currentUser?.displayName
                prefs.set(users, forKey: "users")
                prefs.set(self.password.text!, forKey: "password")
                prefs.set(self.email.text!, forKey: "email")
                let memberId = Auth.auth().currentUser?.uid
                let idToken = UserDefaults.standard.string(forKey: "idToken")
                self.getVerifyIDToken()
                print("id Token: \(idToken)")
                let parameter: CreateDeviceParameter = CreateDeviceParameter(memberId: memberId!, regToken: idToken!)
                self.createDevice(createDeviceParameter: parameter)
                print(authResult)

            }
        }
    }

    func versioningCheck(apiVersion: String, forceUpdate: Bool, updateMessage: String) {
        let appVersion = globalAppVersion
        let appVersionInt = appVersion.replacingOccurrences(of: ".", with: "")
        let apiVersionInt = apiVersion.replacingOccurrences(of: ".", with: "")
        if appVersionInt < apiVersionInt {
            if forceUpdate {
                // force update alert
                navigateUserToUpdateApp(appMessage: updateMessage)
            } else {
                updateAppAlertMessage(appMessage: "A new version of chango is available, would you like to update?")
            }
        } else {
            validateAuthentication()
        }
    }

    func navigateUserToUpdateApp(appMessage: String){
        let alert = UIAlertController(title: "Chango", message: appMessage, preferredStyle: .alert)
        let downloadUpdate = UIAlertAction(title: "Download update", style: .default) { (action: UIAlertAction!) in
            //redirect to chango on appstore
            guard let url = URL(string: "https://apps.apple.com/us/app/changov2/id1460147528") else { return }
            UIApplication.shared.open(url)
        }
        alert.addAction(downloadUpdate)
        self.present(alert, animated: true, completion: nil)
    }

    func updateAppAlertMessage(appMessage: String) {
        let alert = UIAlertController(title: "Chango", message: appMessage, preferredStyle: .alert)
        let downloadUpdate = UIAlertAction(title: "Yes, update", style: .default) { (action: UIAlertAction!) in
            //redirect to chango on appstore
            guard let url = URL(string: "https://apps.apple.com/us/app/changov2/id1460147528") else { return }
            UIApplication.shared.open(url)
        }
        let cancelAction = UIAlertAction(title: "Update later", style: .default) { (action: UIAlertAction!) in
            self.validateAuthentication()
        }
        alert.addAction(downloadUpdate)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }


    func getCurrentAppVersion() {
        AuthNetworkManager.getCurrentAppVersion() { (result) in
            self.parseGetCurrenntAppVersionResponse(result: result)
        }
    }

    private func parseGetCurrenntAppVersionResponse(result: DataResponse<GetCurrentAppVersionResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            versioningCheck(apiVersion: response.iosCurrentVersion, forceUpdate: response.forcedUpdate, updateMessage: response.forcedUpdateMessage)
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        showPasswordResetDialog()
        
    }
    
    
    @IBAction func contactUsBtn(_ sender: UIButton) {
        selectCountry()
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
        alert.addAction(title: "Cancel", style: .cancel)
        
        alert.show()
    }
    
    
    //PASSWORD RESET DIALOG
    func showPasswordResetDialog(animated: Bool = true) {
        
        //create a custom view controller
        let passwordVC = PasswordResetCell(nibName: "PasswordResetCell", bundle: nil)
        
        //create the dialog
        let popup = PopupDialog(viewController: passwordVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
        
        //create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            //            self.label.text = "You canceled password reset"
        }
        
        //create second button
        let buttonTwo = DefaultButton(title: "VERIFY", height: 60) {
            //            self.label.text = "Password sent to you mail"
            if(passwordVC.emailAddress.text?.isEmpty)!{
                self.showAlert(title: "Password Reset", message: "Please enter email")
            }else {
                FTIndicator.init()
                FTIndicator.setIndicatorStyle(UIBlurEffect.Style.dark)
                FTIndicator.showProgress(withMessage: "Checking", userInteractionEnable: false)
                Auth.auth().sendPasswordReset(withEmail: passwordVC.emailAddress.text!) { (error) in
                    FTIndicator.dismissProgress()
                    if error != nil {
                        self.showAlert(withTitle: "Sign in", message: error!.localizedDescription)
                    }else{
                        FTIndicator.dismissProgress()
                        self.showAlert(title: "Chango", message: "An email has been sent to \(passwordVC.emailAddress.text ?? "your mail")")
                        print("email sent")
                    }
                }
            }
        }
        
        //Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        //Present dialog
        present(popup, animated: animated, completion: nil)
        
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

//
            let vc: ContactUsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contactus") as! ContactUsVC
            vc.loginCheck = 0
            vc.countryPickerCheck = 1
            vc.supportPhoneNumber = response.phone ?? "+233 552 571 940"
            vc.supportEmail = response.email ?? "chango@itconsortiumgh.com"
            
    //        vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
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
    
    func checkEmailAddress(checkEmailParameter: CheckMemberDetailsParameter) {
        AuthNetworkManager.checkEmailAddress(parameter: checkEmailParameter) { (result) in
            self.parseCheckEmailAddress(result: result)
        }
    }
    
    private func parseCheckEmailAddress(result: DataResponse<Bool, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            if response {
                password.isHidden = false
                passwordButtonIcon.isHidden = false
                loginButton.isHidden = false
                verifyEmailButton.isHidden = true
            }else {
                let alert = UIAlertController(title: "SIGN UP", message: "This email address hasn't been signed up yet. Would you like to create an account?", preferredStyle: .alert)
                
                let vc: SignupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "up") as! SignupVC
                vc.emailAddress = email.text!

                let okAction = UIAlertAction(title: "Yes", style: .default) { (action: UIAlertAction!) in
                    
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
                let cancelAction = UIAlertAction(title: "No", style: .default) { (action: UIAlertAction!) in
                }
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)            }
            break
        case .failure(let error):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    
    
    func updateRegistrationToken(updateRegistrationTokenParameter: UpdateRegistrationTokenParameter) {
        AuthNetworkManager.updateRegistrationToken(parameter: updateRegistrationTokenParameter) { (result) in
            print("result: \(result)")
        }
    }
    
    private func parseUpdateRegistrationToken(result: DataResponse<String, AFError>){
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            break
        case .failure(let error):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    
    
    
    func memberExists(memberExistsParameter: MemberExistsParameter) {
        AuthNetworkManager.memberExists(parameter: memberExistsParameter) { (result) in
            
            FTIndicator.dismissProgress()
            print("member exists: \(result)")
            
            self.memberExists = result
            
            if (self.memberExists == "true") {
                print("member exists")
                let vc: SlideController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! SlideController
                vc.fromPush = self.fromPush
                let idToken = UserDefaults.standard.string(forKey: "idToken")
                let parameterr: UpdateRegistrationTokenParameter = UpdateRegistrationTokenParameter(registrationToken: idToken!)
                print("reg token: \(idToken!)")
                FTIndicator.dismissProgress()
                
                self.present(vc, animated: true, completion: nil)
            }else if (self.memberExists == "false") {
                print("member does not ex")
                
                self.areaCodeSearch(phoneNumber: self.phoneNumber)
                
                let vc: CompleteRegistrationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "complete") as! CompleteRegistrationVC
                
                vc.email = (self.currentUser?.email)!
                vc.phone = self.phoneNumber
                vc.failedSignUp = true
                vc.areaCode = self.areaCode
                print("area: \(self.areaCode)")
                print("phone: \(self.phoneNumber)")
                
                self.present(vc, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    
    func fetchUserObject(completionHandler: @escaping FetchUIDCompletionHandler) {
        
        let groupsRef = Database.database().reference().child("users")
        let user = Auth.auth().currentUser
        let uid = groupsRef.child("\((user?.uid)!)")
        print("uid: \(uid)")
        _ = uid.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if let snapshotValue = snapshot.value as? [String: AnyObject] {
                
                var authId = ""
                if let authProviderId = snapshotValue["authProviderId"] as? String {
                    authId = authProviderId
                }
                
                var mail = ""
                if let email = snapshotValue["email"] as? String {
                    mail = email
                }
                
                var mmbrId = ""
                if let memberId = snapshotValue["memberId"] as? String {
                    mmbrId = memberId
                }
                
                var mssdn = ""
                if let msisdn = snapshotValue["msisdn"] as? String {
                    mssdn = msisdn
                }
                
                var nm = ""
                if let name = snapshotValue["name"] as? String {
                    nm = name
                }
                
                let users = UserObject(authProviderId_: authId, email_: mail, memberId_: mmbrId, msisdn_: mssdn, name_: nm)
                
                self.userObject = users
                print("info \(users)")
                completionHandler(users)
            }else {
                let users = UserObject(authProviderId_: "", email_: "", memberId_: "", msisdn_: "", name_: "")
                
                completionHandler(users)
            }
            
        })
    }
    
    
    
    func createDevice(createDeviceParameter: CreateDeviceParameter){
        AuthNetworkManager.createDevice(parameter: createDeviceParameter) { (result) in
            self.parseCreateDevice(result: result)
        }
    }
    
    private func parseCreateDevice(result: DataResponse<createDevice, AFError>){
        switch result.result {
        case .success(let response):
            print(response)
            break
        case .failure(let error):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    
    
    
    //verify id
    func getVerifyIDToken(){
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                // Handle error
                print("error: \(error.localizedDescription)")
                return
            }
            print("id token: \(String(describing: idToken))")
            let def: UserDefaults = UserDefaults.standard
            def.set(idToken, forKey: "idToken")
            // Send token to your backend via HTTPS
            // ...
            self.userObjectFetch()
        }
    }
    
    func userObjectFetch(){
        self.fetchUserObject { (result) in
            print(result)
            print("authProvider: \(result.authProviderId)")
            if result.authProviderId == "" {
                print("empty")
                if self.currentUser?.phoneNumber != nil {
                self.areaCodeSearch(phoneNumber: (self.currentUser?.phoneNumber)!)
                }
                
                let vc: CompleteRegistrationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "complete") as! CompleteRegistrationVC
                
                print("not a user in the fb rtdb")
                vc.email = (self.currentUser?.email)!
                vc.phone = (self.currentUser?.phoneNumber)!
                vc.failedSignUp = true
                vc.areaCode = self.areaCode
                print("area: \(self.areaCode)")
                print("phone: \(self.phoneNumber)")
                FTIndicator.dismissProgress()
                self.present(vc, animated: true, completion: nil)
            }else {
                print("not empty")
                let vc: SlideController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! SlideController
                vc.fromPush = self.fromPush
                vc.modalPresentationStyle = .fullScreen
                let idToken = UserDefaults.standard.string(forKey: "idToken")
                //confirm user has signed in
                UserDefaults.standard.set(true, forKey: "authenticated")
                let parameterr: UpdateRegistrationTokenParameter = UpdateRegistrationTokenParameter(registrationToken: idToken!)
                print("reg token: \(idToken!)")
                FTIndicator.dismissProgress()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //delegate method
        print("first responder")
        textField.resignFirstResponder()
        return true
    }
}


