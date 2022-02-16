//
//  LoginTouchVC.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 30/05/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alamofire
import PopupDialog
import FTIndicator
import LocalAuthentication
import FirebaseDatabase

class LoginTouchVC: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var email: ACFloatingTextfield!
    @IBOutlet weak var password: ACFloatingTextfield!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordResetButton: UIButton!
    @IBOutlet weak var touchID: UIButton!
    
    typealias FetchUIDCompletionHandler = (_ user: UserObject) -> Void
    
    var fromPush: Bool = false
    var iconClick = true
    var loginButtonCheck = false
    
    var memberExists: String = ""
    var areaCode: String = ""
    var phoneNumber: String = ""
    var userObject: UserObject!
    
    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()

        loginButton.layer.cornerRadius = 25.0
        
        _ = SwiftEventBus.onMainThread(self, name: "push") { result in
            self.fromPush = true
        }
//        eyeImage.isHidden = true
        password.delegate = self
        // Do any additional setup after loading the view.
        
        
        if UserDefaults.standard.bool(forKey: "touchID"){
            print("touchID")
            //TOUCH ID
            let context = LAContext()
            var error: NSError?
            switch UIDevice.current.screenType {
            case UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax, UIDevice.ScreenType.iPhone_XR_11:
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    let reason = "Authenticate face to enable face ID"
                    UserDefaults.standard.set(true, forKey: "touchID")
                    touchID.imageView?.image = UIImage(named: "faceid2")
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                        [unowned self] (success, authenticationError) in
                        DispatchQueue.main.async {
                            if success {
//                                self.unlockID()
                                getCurrentAppVersion()
                            } else {
                                // error
                            }
                        }
                    }
                } else {
                    // no biometry
                    UserDefaults.standard.set(false, forKey: "touchID")
                    let alert = UIAlertController(title: "Face ID", message: "There are no enrolled faces or fingers.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
                break
            default:
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    let reason = "Login with your Touch ID"
                    
                    UserDefaults.standard.set(true, forKey: "touchID")
                    
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                        [unowned self] (success, authenticationError) in
                        
                        DispatchQueue.main.async {
                            if success {
//                                self.unlockID()
                                getCurrentAppVersion()
                            } else {
                                // error
                            }
                        }
                    }
                    
                } else {
                    // no biometry
                    
                    UserDefaults.standard.set(false, forKey: "touchID")
                    
                    let alert = UIAlertController(title: "Touch ID", message: "There are no enrolled faces or fingers.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        
                        
                    }
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
        }
        
    }
    
    func versioningCheck(apiVersion: String, forceUpdate: Bool, updateMessage: String, loginButtonStatus: Bool) {
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
            if loginButtonCheck {
                print("validate")
                validateAuthentication()
            }else {
            unlockID()
            }
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
            self.unlockID()
        }
        alert.addAction(downloadUpdate)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }    
    
    func unlockID() {
        guard let pass = UserDefaults.standard.string(forKey: "password") else { return }
        guard let email = UserDefaults.standard.string(forKey: "email") else { return }
        print("\(pass), \(email)")

        if pass.isEmpty || email.isEmpty {
        // Take user to normal sign in view
            noUserDefaultDetails()
        }else {
            FTIndicator.showProgress(withMessage: "logging in")
            Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                if error != nil {
                    //alert
                    FTIndicator.dismissProgress()
                    let alert = UIAlertController(title: "Sign in", message: "Invalid credentials", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    self.getVerifyIDToken()

                    print("\(Auth.auth().currentUser?.displayName)")
                    let users = Auth.auth().currentUser?.displayName
                    let prefs: UserDefaults = UserDefaults.standard
                    prefs.set(users, forKey: "users")
                }
                // ...
            }
        }
    }

    func noUserDefaultDetails() {
        let alert = UIAlertController(title: "Chango", message: "User credentials unsuccessfully retrieved. Please enter your credentials and reactivate biometric auth in settings.", preferredStyle: .alert)
        let downloadUpdate = UIAlertAction(title: "Go to Login", style: .default) { (action: UIAlertAction!) in
            let vc: LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "in") as! LoginVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
//        let cancelAction = UIAlertAction(title: "Update later", style: .default) { (action: UIAlertAction!) in
//
//        }
        alert.addAction(downloadUpdate)
//        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = .white
        
//        email.text = ""
        if let uNumber : String = UserDefaults.standard.string(forKey: "email") {
            self.email.text = uNumber
        }else {
            self.email.text = ""
        }
        password.text = ""
        
        switch UIDevice.current.screenType {
            
        case UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax, UIDevice.ScreenType.iPhone_XR_11:
            
            touchID.imageView!.image = UIImage(named: "faceid2")
            break
        default:
            
            touchID.imageView!.image = UIImage(named: "touchid2")
            
        }
        
            UIApplication.shared.statusBarStyle = .default
    }
    
    
    @IBAction func touchIDAlert(_ sender: UIButton) {

        loginButtonCheck = false
        if UserDefaults.standard.bool(forKey: "touchID"){
            print("touchID")
            
            //TOUCH ID
            let context = LAContext()
            var error: NSError?
            
            switch UIDevice.current.screenType {
                
            case UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax, UIDevice.ScreenType.iPhone_XR_11:
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    let reason = "Authenticate face to enable face ID"
                    
                    UserDefaults.standard.set(true, forKey: "touchID")
                    
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                        [unowned self] (success, authenticationError) in
                        
                        DispatchQueue.main.async {
                            if success {
//                                self.unlockID()
                                getCurrentAppVersion()
                            } else {
                                // error
                            }
                        }
                    }
                    
                } else {
                    // no biometry
                    
                    UserDefaults.standard.set(false, forKey: "touchID")
                    
                    let alert = UIAlertController(title: "Face ID", message: "There are no enrolled faces or fingers.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        
                        
                    }
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                break
            default:
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    let reason = "Login with your Touch ID"
                    
                    UserDefaults.standard.set(true, forKey: "touchID")
                    
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                        [unowned self] (success, authenticationError) in
                        
                        DispatchQueue.main.async {
                            if success {
//                                self.unlockID()
                                getCurrentAppVersion()
                            } else {
                                // error
                            }
                        }
                    }
                    
                } else {
                    // no biometry
                    
                    UserDefaults.standard.set(false, forKey: "touchID")
                    
                    let alert = UIAlertController(title: "Touch ID", message: "There are no enrolled faces or fingers.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        
                        
                    }
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
        }
    }
    
    
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        print("email valid?: \(emailTest.evaluate(with: testStr))")
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        
        if ((email.text?.isEmpty)! && (password.text?.isEmpty)!) {

            let alert = UIAlertController(title: "LOGIN", message: "Please fill empty fields.", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in


            }

            alert.addAction(okAction)

            self.present(alert, animated: true, completion: nil)

        }else if isValidEmail(testStr: email.text!) == false {
            
            let alert = UIAlertController(title: "LOGIN", message: "Invalid email.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }else {
            loginButtonCheck = true
            getCurrentAppVersion()
        }
        
    }

    func validateAuthentication() {
        if ((email.text?.isEmpty)! || (password.text?.isEmpty)!) {

            let alert = UIAlertController(title: "LOGIN", message: "Please fill empty fields.", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in


            }

            alert.addAction(okAction)

            self.present(alert, animated: true, completion: nil)

        }else {
            FTIndicator.showProgress(withMessage: "logging in")
            Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
                if error != nil {
                    //alert
                    //                        activityIndicatorView.stopAnimating()
                    FTIndicator.dismissProgress()

                    if error?.localizedDescription == "Too many unsuccessful login attempts. Please try again later." {
                        let alert = UIAlertController(title: "Sign in", message: "Too many unsuccessful login attempts. Please try again later.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                            print("send reset email")
                            alert.dismiss(animated: true, completion: nil)
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }else {
                        let alert = UIAlertController(title: "Sign in", message: "Invalid credentials", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                            alert.dismiss(animated: true, completion: nil)
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                //                else if (!(Auth.auth().currentUser?.phoneNumber != nil)) {
                //
                //                    let vc: AddMobileNumberVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mobile") as! AddMobileNumberVC
                //
                //                    self.present(vc, animated: true, completion: nil)
                //                } else if (!(Auth.auth().currentUser?.displayName != nil)) {
                //
                //                }
                else{

                    self.getVerifyIDToken()

                    let memberId = Auth.auth().currentUser?.uid
                    let idToken = UserDefaults.standard.string(forKey: "idToken")

                    let parameter: CreateDeviceParameter = CreateDeviceParameter(memberId: memberId!, regToken: idToken!)
                    self.createDevice(createDeviceParameter: parameter)

                    print("\(Auth.auth().currentUser?.displayName)")
                    let users = Auth.auth().currentUser?.displayName
                    let prefs: UserDefaults = UserDefaults.standard
                    prefs.set(users, forKey: "users")
                    prefs.set(self.password.text!, forKey: "password")
                    prefs.set(self.email.text!, forKey: "email")

                }
                // ...
            }
        }
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
            versioningCheck(apiVersion: response.iosCurrentVersion, forceUpdate: response.forcedUpdate, updateMessage: response.forcedUpdateMessage, loginButtonStatus: loginButtonCheck)
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
    
    
    @IBAction func contactUs(_ sender: UIButton) {
        let vc: ContactUsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contactus") as! ContactUsVC
        vc.loginCheck = 0
        vc.countryPickerCheck = 1
        self.present(vc, animated: true, completion: nil)
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
                //                FTIndicator.showInfo(withMessage: "Please enter email address")
                let alert = UIAlertController(title: "Password Reset", message: "Please enter email", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    
                }
                
                alert.addAction(OKAction)
                
                self.present(alert, animated: true, completion: nil)
                
            }else {
                FTIndicator.init()
                FTIndicator.setIndicatorStyle(UIBlurEffect.Style.dark)
                FTIndicator.showProgress(withMessage: "Checking", userInteractionEnable: false)
                Auth.auth().sendPasswordReset(withEmail: passwordVC.emailAddress.text!) { (error) in
                    FTIndicator.dismissProgress()
                    if error != nil {
                        
                        let alert = UIAlertController(title: "Sign in", message: error?.localizedDescription, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                            alert.dismiss(animated: true, completion: nil)
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        FTIndicator.dismissProgress()
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
        case .failure(let response):
            
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
    
    
    func fetchUserObject(completionHandler: @escaping FetchUIDCompletionHandler) {
        
        let groupsRef = Database.database().reference().child("users")
        let user = Auth.auth().currentUser
        let uid = groupsRef.child("\((user?.uid)!)")
        print("uid: \(uid)")
        _ = uid.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! [String: AnyObject]
            
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
            
        })
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
            }else if (self.memberExists == "false"){
                print("member does not ex")
                
            }
            
        }
        
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
            
//            self.phoneNumber = (self.currentUser?.phoneNumber)!
//
//            self.phoneNumber.removeFirst()
//            print(self.phoneNumber)
//
            
            self.fetchUserObject { (result) in
                print(result)
                print("authProvider: \(result.authProviderId)")
                
                if result.authProviderId == "" {
                    print("empty")
                    
                    self.areaCodeSearch(phoneNumber: self.phoneNumber)
                    
                    let vc: CompleteRegistrationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "complete") as! CompleteRegistrationVC
                    
                    vc.email = (self.currentUser?.email)!
                    vc.phone = self.phoneNumber
                    vc.failedSignUp = true
                    vc.areaCode = self.areaCode
                    
                    self.present(vc, animated: true, completion: nil)
                    
                }else {
                    print("not empty")
                    let vc: SlideController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! SlideController
                    vc.fromPush = self.fromPush
                    vc.modalPresentationStyle = .fullScreen
                    let idToken = UserDefaults.standard.string(forKey: "idToken")
                    let parameterr: UpdateRegistrationTokenParameter = UpdateRegistrationTokenParameter(registrationToken: idToken!)
                    print("reg token: \(idToken)")
                    FTIndicator.dismissProgress()
                    //user has signed in successfully
                    UserDefaults.standard.set(true, forKey: "authenticated")
                    
                    self.present(vc, animated: true, completion: nil)
                }
            }
            
//            let parameter: MemberExistsParameter = MemberExistsParameter(phone: self.phoneNumber)
//            self.memberExists(memberExistsParameter: parameter)
            
            
        }
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
            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
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
