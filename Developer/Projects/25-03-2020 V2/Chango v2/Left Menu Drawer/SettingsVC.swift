//
//  SettingsVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 03/11/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import Nuke
import Alamofire
import FTIndicator
import FirebaseMessaging
import FirebaseDatabase
import FirebaseStorage
import BWWalkthrough
import LocalAuthentication

class SettingsVC: BaseViewController, MenuDelegate, BWWalkthroughViewControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var easySlideNavigationController: ESNavigationController?
    
    let cell = "cellId"
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    
    var personalContributions: CampaignContributionResponse!
    var myContributions: [MyContributionsSection] = []
    var allGroups: [GroupResponse] = []
    var movedFromWallet: Bool = false
    
    let user = Auth.auth().currentUser
    
    var drawerItems: [DrawerModel] = [DrawerModel(id_: 1, itemName_: "Change Password", itemImage_: "changepasswordicon"), DrawerModel(id_: 2, itemName_: "Change E-mail Address", itemImage_: "emailicon"), DrawerModel(id_: 3, itemName_: "Update KYC", itemImage_: "updatekyc"), DrawerModel(id_: 4, itemName_: "My Wallets", itemImage_: "walleticon"), DrawerModel(id_: 5, itemName_: "Touch ID/Face ID", itemImage_: "touchicon"), /*DrawerModel(id_: 6, itemName_: "Delete Account", itemImage_: "deleteaccount"),*/ DrawerModel(id_: 6, itemName_: "Logout", itemImage_: "drawerlogout")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        picker.delegate = self
        
        self.tableView.tableFooterView = UIView()
        
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 40.0
        profileImage.clipsToBounds = true
        
        userNameLabel.text = user?.displayName
        userPhoneNumberLabel.text = user?.phoneNumber
        profileImage.contentMode = .scaleToFill
        
        if (user!.photoURL != nil){
            print("not null")
            print(user!.photoURL!)
            Nuke.loadImage(with: URL(string: "\(user!.photoURL!)")!, into: profileImage)
        }else {
            print("default")
            profileImage.image = UIImage(named: "defaulticon")
        }
        
        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableView.register(UINib(nibName: "LeftDrawerCell", bundle: nil), forCellReuseIdentifier: "LeftDrawerCell")
        self.tableView.tableFooterView = UIView()
    }
    
    @IBAction func leftMenuButtonAction(_ sender: Any) {
        if (movedFromWallet) {
            self.navigationController?.popViewController(animated: true)
        }else {
        self.getEasySlide().openMenu(.leftMenu, animated: true, completion: {})
        }
    }
    
    
    @IBAction func editUserInfoButton(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.shootPhoto()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.photoFromLibrary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as! UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func switchChanged(_ sender : UISwitch!){
        
        print("table row switch Changed \(sender.tag)")
        print("The switch is \(sender.isOn ? "ON" : "OFF")")
        
        if sender.isOn {
            touchFaceIDOn(sender)
        }else {
            touchFaceIDOn(sender)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drawerItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: LeftDrawerCell = self.tableView.dequeueReusableCell(withIdentifier: "LeftDrawerCell", for: indexPath) as! LeftDrawerCell
        cell.selectionStyle = .none
        
        cell.drawerCellName.text = drawerItems[indexPath.row].itemName
        cell.drawerIcon.image = UIImage(named: "\(drawerItems[indexPath.row].itemImage)")
        
        switch indexPath.row {
        case 4:
            let switchView = UISwitch(frame: .zero)
            switchView.tag = indexPath.row // for detect which row switch Changed
            switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            cell.accessoryView = switchView
            
            let state: Bool = UserDefaults.standard.bool(forKey: "touchID")
            
            if (state) {
                switchView.setOn(true, animated: true)
            }else {
                switchView.setOn(false, animated: true)
                switchView.isOn = false
                UserDefaults.standard.set(false, forKey: "touchID")
            }
            
            if biometricType() == .face {
                cell.drawerCellName.text = "Face ID"
            }else if biometricType() == .touch {
                cell.drawerCellName.text = "Touch ID"
            }else {
                cell.drawerCellName.text = "Face ID/Touch ID"
            }
            
            
        //            switch UIDevice.current.screenType {
        //                
        //            case UIDevice.ScreenType.iPhones_X_XS_11Pro:
        //                cell.drawerCellName.text = "Face ID"
        //                
        //                break
        //                
        //            case UIDevice.ScreenType.iPhone_XSMax_ProMax:
        //                cell.drawerCellName.text = "Face ID"
        //                
        //                break
        //            case UIDevice.ScreenType.iPhone_XR_11:
        //                cell.drawerCellName.text = "Face ID"
        //                
        //                break
        //            default:
        //               cell.drawerCellName .text = "Touch ID/Face ID"
        //            }
        default:
            print("nothing")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            //Change Password
            let vc: ChangePasswordViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "change") as! ChangePasswordViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            //Change E-mail
            //            let vc1: UpdatEmailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "upd") as! UpdatEmailViewController
            let vc1: VerifyChangePasswordVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verifypass") as! VerifyChangePasswordVC
            
            self.navigationController?.pushViewController(vc1, animated: true)
            break
        case 2:
            //Update KYC
            retrieveMember()
            break
        case 3:
            //My Wallets
            let vc: WalletsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wallets") as! WalletsVC


            self.navigationController?.pushViewController(vc, animated: true)
//            showAlert(title: "Wallets", message: "This feature is temporarily unavailable")
            break
            
            
        case 4:
            //Touch Face ID
            
            break
            
        /*case 5:
            //Deactivate
            let vc: DeactivateAccountVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "deleteuser") as! DeactivateAccountVC
            
            self.navigationController?.pushViewController(vc, animated: true)*/
        case 5:
            //Logout
            print("Logout")
            
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout? Your biometric data will be cleared.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                let idToken = UserDefaults.standard.string(forKey: "idToken")
                let parameter: DeleteDeviceParameter = DeleteDeviceParameter(id: idToken!)
                self.deleteDevice(deleteDeviceParameter: parameter)
                
                for item in self.allGroups {
                    
                    Messaging.messaging().unsubscribe(fromTopic: item.groupId)
                    
                    print("unsubscribed from \(item.groupId)")
                }
                let vc: ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "walkthrough") as! ViewController
                
                //                    let prefs = UserDefaults.standard
                //                    prefs.removeObject(forKey: "email")
                //                    prefs.removeObject(forKey: "password")
                //                    //group link stored preferences
                //                    prefs.removeObject(forKey: "authenticated")
                //                    prefs.removeObject(forKey: "grouplinkexists")
                //store idToken in variable
                let idTokenRestore = idToken!
                //removing all userdefaults data
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                print("user logged out: \(Array(UserDefaults.standard.dictionaryRepresentation().keys))")
                //Restore token
                UserDefaults.standard.set(idTokenRestore, forKey: "idToken")
                //                    if let slideController = self.easySlideNavigationController{
                //                        slideController.setBodyViewController(vc, closeOpenMenu: true, ignoreClassMatch: true)
                //                    }
                //user has logged out successfully
                self.showWalkThrough()
                //                    self.present(vc, animated: true, completion: nil)
                //                    self.navigationController?.dismiss(animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action: UIAlertAction!) in
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
            break
            
        default:
            break
        }
        
    }
    
    func deleteDevice(deleteDeviceParameter: DeleteDeviceParameter) {
        AuthNetworkManager.deleteDevice(parameter: deleteDeviceParameter) { (result) in
            print("result: \(result)")
            
        }
    }
    
    func showWalkThrough(){
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
        let page_one = stb.instantiateViewController(withIdentifier: "walk1")
        let page_two = stb.instantiateViewController(withIdentifier: "walk2")
        let page_three = stb.instantiateViewController(withIdentifier: "walk3")
        let page_four = stb.instantiateViewController(withIdentifier: "walk4")
        let page_five = stb.instantiateViewController(withIdentifier: "walk5")
        let page_six = stb.instantiateViewController(withIdentifier: "walk6")
        //Attach the pages to the master
        walkthrough.delegate = self as? BWWalkthroughViewControllerDelegate
        //        walkthrough.add(viewController: page_one)
        //        walkthrough.add(viewController: page_three)
        walkthrough.add(viewController: page_two)
        walkthrough.add(viewController: page_four)
        walkthrough.add(viewController: page_five)
        walkthrough.add(viewController: page_six)
        walkthrough.modalPresentationStyle = .fullScreen
        self.present(walkthrough, animated: true, completion: nil)
    }
    
    
    //PERSONAL CONTRIBUTIONS
    func getPersonalContributionsParameter(personalContributionsParameter: PersonalContributionsParameter) {
        AuthNetworkManager.personalContributions(parameter: personalContributionsParameter) { (result) in
            self.parsePersonalContributionsResponse(result: result)
        }
    }
    
    private func parsePersonalContributionsResponse(result: DataResponse<CampaignContributionResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            
            personalContributions = response
            let vc: PersonalContributionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "personal") as! PersonalContributionViewController
            
            vc.personalContributions = response
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
            
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
    
    
    func retrieveMember() {
        AuthNetworkManager.retrieveMember() { (result) in
            self.parseRetrieveMemberResponse(result: result)
        }
    }
    
    private func parseRetrieveMemberResponse(result: DataResponse<RetrieveMemberResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            let vc: SelectIDVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectid") as! SelectIDVC
            vc.settingsPage = true
            vc.countryId = response.countryId
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    
    func encodeImage(_ dataImage:UIImage) -> String{
        let imageData = dataImage.pngData()
        return imageData!.base64EncodedString(options: [])
    }
    
    func details(_ sender:AnyObject) {
        
        let actionSheet: UIActionSheet = UIActionSheet(title: "", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take Picture", "Choose Existing Photo")
        actionSheet.delegate = self
        actionSheet.tag = 2
        actionSheet.show(in: self.view)
    }
    
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        if(buttonIndex == 1){//Report Post
            self.shootPhoto()
        } else if(buttonIndex == 2){
            self.photoFromLibrary()
        }else {
            actionSheet.dismiss(withClickedButtonIndex: 3, animated: true)
        }
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        profileImage.image = image
        picker.dismiss(animated: true, completion: nil)
        
        //Loading indicator here
        
        uploadImagePic(img1: image)
        //Api call here
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Shit got picked")
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImage.image = chosenImage
        picker.dismiss(animated: true, completion: nil)
        
        //Loading indicator here
        
        uploadImagePic(img1: chosenImage)
    }
    
    fileprivate func makingRoundedImageProfileWithRoundedBorder() {
        
        self.profileImage.layer.cornerRadius = 53.5
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.borderWidth = 0.8
        self.profileImage.layer.borderColor = UIColor.white.cgColor
    }
    
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message:"Sorry, this device has no camera", preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK",comment:"OK"), style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    //get a photo from the library. We present as! a popover on iPad, and fullscreen on smaller devices.
    func photoFromLibrary() {
        picker.allowsEditing = true //2
        picker.sourceType = .photoLibrary //3
        //picker.modalPresentationStyle = .Popover
        present(picker, animated: true, completion: nil)//4
        //picker.popoverPresentationController?.barButtonItem = sender
    }
    
    
    //take a picture, check if we have a camera first.
    func shootPhoto() {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            present(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    fileprivate func getEasySlide() -> ESNavigationController {
        return self.navigationController as! ESNavigationController
    }
    
    func updateMember(updateMemberParameter: UpdateMemberParameter) {
        AuthNetworkManager.updateMember(parameter: updateMemberParameter) { (result) in
            
            self.parseUpdateMemberResponse(result: result)
        }
    }
    
    private func parseUpdateMemberResponse(result: DataResponse<UpdateMemberResponse, AFError>){
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            FTIndicator.dismissProgress()
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
    
    
    
    
    
    func uploadImagePic(img1 :UIImage){
        FTIndicator.showProgress(withMessage: "saving")
        
        var data = NSData()
        data = img1.jpegData(compressionQuality: 0.8)! as NSData
        // set upload path
        let filePath = "profile_images/\(Auth.auth().currentUser!.uid)" // path where you wanted to store img in storage
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let storageRef = Storage.storage().reference()
        storageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print("Error while uploading image to firebase")
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                var myURL: URL!
                _ = storageRef.child((metaData?.path)!).downloadURL(completion: { (url, error) in
                    if(!(error != nil)){
                        myURL = url
                        print(myURL)
                        if(myURL != nil){
                            let user = Auth.auth().currentUser
                            
                            let changeRequest = user?.createProfileChangeRequest()
                            changeRequest?.photoURL = myURL
                            changeRequest?.commitChanges { error in
                                FTIndicator.dismissProgress()
                                if(!(error != nil)){
                                    print("UPDATE PROFILE SUCCESSFUL")
                                    //Api Call for change member image
                                    let parameter: UpdateMemberParameter = UpdateMemberParameter(image: (String(describing: myURL!)))
                                    self.updateMember(updateMemberParameter: parameter)
                                    
                                }else{
                                    print("Error again")
                                    print(error!)
                                }
                            }
                        }
                    }else{
                        print("Error: \(error!)")
                    }
                })
            }
        }
        
    }
    
    
    func biometricType() -> BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                return .none
            case .touchID:
                return .touch
            case .faceID:
                return .face
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
        }
    }
    
    enum BiometricType {
        case none
        case touch
        case face
    }
    
    func touchFaceIDOn(_ sender: UISwitch ){
        
        let context = LAContext()
        var error: NSError?
        
        if(sender.isOn){
            if biometricType() == .face {
                
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    let reason = "Authenticate fingerprint to enable Face ID"
                    
                    UserDefaults.standard.set(true, forKey: "touchID")
                    
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                        [unowned self] (success, authenticationError) in
                        
                        DispatchQueue.main.async {
                            if success {
                                let alert = UIAlertController(title: "SUCCESS", message: "You have successfully enabled Face ID", preferredStyle: .alert)
                                
                                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                                    
                                    
                                }
                                alert.addAction(okAction)
                                
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                // error
                            }
                        }
                    }
                    
                } else {
                    // no biometry
                    
                    UserDefaults.standard.set(false, forKey: "touchID")
                    
                    let alert = UIAlertController(title: "Face ID", message: "There are no enrolled faces.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        
                        
                    }
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }else if biometricType() == .touch {
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    let reason = "Authenticate fingerprint to enable Touch ID"
                    
                    UserDefaults.standard.set(true, forKey: "touchID")
                    
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                        [unowned self] (success, authenticationError) in
                        
                        DispatchQueue.main.async {
                            if success {
                                let alert = UIAlertController(title: "SUCCESS", message: "You have successfully enabled Touch ID", preferredStyle: .alert)
                                
                                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                                    
                                    
                                }
                                alert.addAction(okAction)
                                
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                // error
                            }
                        }
                    }
                    
                } else {
                    // no biometry
                    
                    UserDefaults.standard.set(false, forKey: "touchID")
                    
                    let alert = UIAlertController(title: "Face ID", message: "There are no enrolled faces.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        
                        
                    }
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }else {
            UserDefaults.standard.set(false, forKey: "touchID")
            
            print("switch is off")
        }
        
        //        switch UIDevice.current.screenType {
        //
        //        case UIDevice.ScreenType.iPhones_X_XS_11Pro:
        //
        //            if(sender.isOn){
        //                let context = LAContext()
        //                var error: NSError?
        //
        //
        //                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        //                    let reason = "Authenticate fingerprint to enable Face ID"
        //
        //                    UserDefaults.standard.set(true, forKey: "touchID")
        //
        //                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
        //                        [unowned self] (success, authenticationError) in
        //
        //                        DispatchQueue.main.async {
        //                            if success {
        //                                let alert = UIAlertController(title: "SUCCESS", message: "You have successfully enabled Face ID", preferredStyle: .alert)
        //
        //                                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
        //
        //
        //                                }
        //                                alert.addAction(okAction)
        //
        //                                self.present(alert, animated: true, completion: nil)
        //                            } else {
        //                                // error
        //                            }
        //                        }
        //                    }
        //
        //                } else {
        //                    // no biometry
        //
        //                    UserDefaults.standard.set(false, forKey: "touchID")
        //
        //                    let alert = UIAlertController(title: "Face ID", message: "There are no enrolled faces.", preferredStyle: .alert)
        //
        //                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
        //
        //
        //                    }
        //                    alert.addAction(okAction)
        //
        //                    self.present(alert, animated: true, completion: nil)
        //
        //                }
        //            }else {
        //
        //                UserDefaults.standard.set(false, forKey: "touchID")
        //
        //                print("switch is off")
        //            }
        //            break
        //
        //        case UIDevice.ScreenType.iPhone_XSMax_ProMax:
        //
        //            if(sender.isOn){
        //                let context = LAContext()
        //                var error: NSError?
        //
        //
        //                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        //                    let reason = "Authenticate fingerprint to enable Face ID"
        //
        //                    UserDefaults.standard.set(true, forKey: "touchID")
        //
        //                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
        //                        [unowned self] (success, authenticationError) in
        //
        //                        DispatchQueue.main.async {
        //                            if success {
        //                                let alert = UIAlertController(title: "SUCCESS", message: "You have successfully enabled Face ID", preferredStyle: .alert)
        //
        //                                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
        //
        //
        //                                }
        //                                alert.addAction(okAction)
        //
        //                                self.present(alert, animated: true, completion: nil)
        //                            } else {
        //                                // error
        //                            }
        //                        }
        //                    }
        //
        //                } else {
        //                    // no biometry
        //
        //                    UserDefaults.standard.set(false, forKey: "touchID")
        //
        //                    let alert = UIAlertController(title: "Face ID", message: "There are no enrolled faces", preferredStyle: .alert)
        //
        //                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
        //
        //
        //                    }
        //                    alert.addAction(okAction)
        //
        //                    self.present(alert, animated: true, completion: nil)
        //
        //                }
        //            }else {
        //
        //                UserDefaults.standard.set(false, forKey: "touchID")
        //
        //                print("switch is off")
        //            }
        //
        //            break
        //        case UIDevice.ScreenType.iPhone_XR_11:
        //
        //            if(sender.isOn){
        //                let context = LAContext()
        //                var error: NSError?
        //
        //
        //                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        //                    let reason = "Authenticate fingerprint to enable Face ID"
        //
        //                    UserDefaults.standard.set(true, forKey: "touchID")
        //
        //                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
        //                        [unowned self] (success, authenticationError) in
        //
        //                        DispatchQueue.main.async {
        //                            if success {
        //                                let alert = UIAlertController(title: "SUCCESS", message: "You have successfully enabled Face ID", preferredStyle: .alert)
        //
        //                                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
        //
        //
        //                                }
        //                                alert.addAction(okAction)
        //
        //                                self.present(alert, animated: true, completion: nil)
        //                            } else {
        //                                // error
        //                            }
        //                        }
        //                    }
        //
        //                } else {
        //                    // no biometry
        //
        //                    UserDefaults.standard.set(false, forKey: "touchID")
        //
        //                    let alert = UIAlertController(title: "Face ID", message: "There are no enrolled faces.", preferredStyle: .alert)
        //
        //                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
        //
        //
        //                    }
        //                    alert.addAction(okAction)
        //
        //                    self.present(alert, animated: true, completion: nil)
        //
        //                }
        //            }else {
        //
        //                UserDefaults.standard.set(false, forKey: "touchID")
        //
        //                print("switch is off")
        //            }
        //            break
        //        default:
        //
        //            if(sender.isOn){
        //                let context = LAContext()
        //                var error: NSError?
        //
        //
        //                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        //                    let reason = "Authenticate fingerprint to enable Touch ID"
        //
        //                    UserDefaults.standard.set(true, forKey: "touchID")
        //
        //                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
        //                        [unowned self] (success, authenticationError) in
        //
        //                        DispatchQueue.main.async {
        //                            if success {
        //                                let alert = UIAlertController(title: "SUCCESS", message: "You have successfully enabled Touch ID", preferredStyle: .alert)
        //
        //                                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
        //
        //
        //                                }
        //                                alert.addAction(okAction)
        //
        //                                self.present(alert, animated: true, completion: nil)
        //                            } else {
        //                                // error
        //                            }
        //                        }
        //                    }
        //
        //                } else {
        //                    // no biometry
        //
        //                    UserDefaults.standard.set(false, forKey: "touchID")
        //
        //                    let alert = UIAlertController(title: "Touch ID", message: "There are no enrolled fingerprints.", preferredStyle: .alert)
        //
        //                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
        //
        //
        //                    }
        //                    alert.addAction(okAction)
        //
        //                    self.present(alert, animated: true, completion: nil)
        //
        //                }
        //            }else {
        //
        //                UserDefaults.standard.set(false, forKey: "touchID")
        //
        //                print("switch is off")
        //            }
        //        }
    }
    
}
