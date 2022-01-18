
//
//  SettingsTableViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 24/01/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
import Nuke
import FTIndicator
import Alamofire
import LocalAuthentication
import BWWalkthrough

class SettingsTableViewController: BaseTableViewController, UIImagePickerControllerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate, BWWalkthroughViewControllerDelegate {

    var easySlideNavigationController: ESNavigationController?

    @IBOutlet var table: UITableView!
    
    let picker = UIImagePickerController()

    @IBOutlet weak var changeImage: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var touchIDSwitch: UISwitch!
    @IBOutlet weak var authenticationLabel: UILabel!
    
    var personalContributions: CampaignContributionResponse!
    var myContributions: [MyContributionsSection] = []
    var allGroups: [GroupResponse] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        self.table.tableFooterView = UIView()
        
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 2.0
        profileImage.borderColor = UIColor.red
        profileImage.layer.cornerRadius = 50.0
        profileImage.clipsToBounds = true
        
        picker.delegate = self
        
        let user = Auth.auth().currentUser
        
        displayName.text = user?.displayName
        print(displayName)
        phoneNumber.text = user?.phoneNumber
        print(phoneNumber)
        email.text = user?.email
        print(email)
        
        if (user!.photoURL != nil){
            print("not null")
            print(user!.photoURL!)
            Nuke.loadImage(with: URL(string: "\(user!.photoURL!)")!, into: profileImage)
        }else {
            print("default")
            profileImage.image = UIImage(named: "individual")
        }
        
        
        let state: Bool = UserDefaults.standard.bool(forKey: "touchID")
        
        if (state) {
            touchIDSwitch.setOn(true, animated: true)
        }else {
            touchIDSwitch.setOn(false, animated: true)
        }
        
        
        //Chango Biometric Authentication
        
        //Scan your fingerprint to authenticate. This will help increase security within chango.


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func changeImageAction(_ sender: Any) {
//        let actionSheet: UIActionSheet = UIActionSheet(title: "", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take Picture", "Choose Existing Photo")
//        actionSheet.delegate = self
//        actionSheet.tag = 2
//        actionSheet.show(in: self.view)
        

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
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
//        let vc: SlideController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main") as! SlideController
//
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
        self.getEasySlide().openMenu(.leftMenu, animated: true, completion: {})

    }
    

    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .white
        }
    }
    
    @IBAction func touchIDButtonAction(_ sender: UISwitch) {

        switch UIDevice.current.screenType {
            
        case UIDevice.ScreenType.iPhones_X_XS_11Pro:
            
            if(sender.isOn){
                let context = LAContext()
                var error: NSError?
                
                
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
            }else {
                
                UserDefaults.standard.set(false, forKey: "touchID")
                
                print("switch is off")
            }
            break
            
        case UIDevice.ScreenType.iPhone_XSMax_ProMax:
            
            if(sender.isOn){
                let context = LAContext()
                var error: NSError?
                
                
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
                    
                    let alert = UIAlertController(title: "Face ID", message: "There are no enrolled faces", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        
                        
                    }
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }else {
                
                UserDefaults.standard.set(false, forKey: "touchID")
                
                print("switch is off")
            }
            
            break
        case UIDevice.ScreenType.iPhone_XR_11:
            
            if(sender.isOn){
                let context = LAContext()
                var error: NSError?
                
                
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
            }else {
                
                UserDefaults.standard.set(false, forKey: "touchID")
                
                print("switch is off")
            }
            break
        default:
            
            if(sender.isOn){
                let context = LAContext()
                var error: NSError?
                
                
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
                    
                    let alert = UIAlertController(title: "Touch ID", message: "There are no enrolled fingerprints.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        
                        
                    }
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }else {
                
                UserDefaults.standard.set(false, forKey: "touchID")
                
                print("switch is off")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {

        case 1:

            if (indexPath.row == 0){
                //Change Password
                print("Password")
                let vc: ChangePasswordViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "change") as! ChangePasswordViewController
                
                self.navigationController?.pushViewController(vc, animated: true)
            
            }else if (indexPath.row == 1){
               //Change Email Address
                print("email")
                let vc: UpdatEmailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "upd") as! UpdatEmailViewController
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if (indexPath.row == 2){
//                My Wallets
//                let vc: WalletsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wallets") as! WalletsVC
//
//
//                self.navigationController?.pushViewController(vc, animated: true)
                showAlert(title: "Wallets", message: "This feature is temporarily unavailable")
            
                
        }else if (indexPath.row == 3) {
                //touch id
                switch UIDevice.current.screenType {
                    
                case UIDevice.ScreenType.iPhones_X_XS_11Pro:
                    authenticationLabel.text = "Face ID"
                    
                    break
                    
                case UIDevice.ScreenType.iPhone_XSMax_ProMax:
                    authenticationLabel.text = "Face ID"
                    
                    break
                case UIDevice.ScreenType.iPhone_XR_11:
                    authenticationLabel.text = "Face ID"
                    
                    break
                default:
                    authenticationLabel.text = "Touch ID/Face ID"
                }
                
            }else {
                //Logout
                
                print("Logout")
                
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
                let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
                
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
                
            }
            break
        default:
            print("nil")



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
        walkthrough.add(viewController: page_three)
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
                
                baseTableSessionTimeout()
                
            }else {
            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
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
                
                baseTableSessionTimeout()
                
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

}
