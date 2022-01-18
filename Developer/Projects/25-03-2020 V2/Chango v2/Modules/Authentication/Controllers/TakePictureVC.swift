//
//  TakePictureVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 12/03/2021.
//  Copyright © 2021 IT Consortium. All rights reserved.
//

import UIKit
import Alamofire
import FTIndicator
import FirebaseStorage
import FirebaseAuth

class TakePictureVC: BaseViewController, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    var email: String = ""
    var password: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var idType: String = ""
    var idNumber: String = ""
    var settingsPage: Bool = false
    var doB: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableDarkMode()
        showChatController()
        picker.delegate = self
    }
    @IBAction func backButtonActioin(_ sender: UIButton) {
        if settingsPage {
            self.navigationController?.popViewController(animated: true)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePictureButtonAction(_ sender: UIButton) {
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
        
        //        profileImage.image = image
        picker.dismiss(animated: true, completion: nil)
        
        //Loading indicator here
        FTIndicator.showProgress(withMessage: "loading")
        //Api call here
        uploadImagePic(img1: image, dob: doB)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Shit got picked")
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //        profileImage.image = chosenImage
        picker.dismiss(animated: true, completion: nil)
        
        //Loading indicator here
        FTIndicator.showProgress(withMessage: "loading")
        //make call to send picture here
        uploadImagePic(img1: chosenImage, dob: doB)
    }
    
    fileprivate func makingRoundedImageProfileWithRoundedBorder() {
        
        //        self.profileImage.layer.cornerRadius = 53.5
        //        self.profileImage.clipsToBounds = true
        //        self.profileImage.layer.borderWidth = 0.8
        //        self.profileImage.layer.borderColor = UIColor.white.cgColor
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
    
    func uploadImagePic(img1: UIImage, dob: String) {
        var data = NSData()
        data = img1.jpegData(compressionQuality: 0.8)! as NSData
        
        // set upload path
        let currentUser = Auth.auth().currentUser
        let filePath = "kyc/\(currentUser!.uid)" // path where you wanted to store img in storage
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
                            print("UPDATE PROFILE SUCCESSFUL")
                            //Api Call for change group image
                            let parameter: AddKYCParameter = AddKYCParameter(dob: dob, idCardUrl: (String(describing: myURL!)), idNumber: self.idNumber, idType: self.idType, photoUrl: (String(describing: myURL!)))
//                            print("imageUrl: \(self.imageUrl)")
                            print("imageUrl: \(myURL)")
                            self.addKYC(addKYCParamter: parameter)
                        }
                    }else{
                        print("Error: \(error!)")
                    }
                })
            }
        }

    }
    
    
    //UPLOAD KYC
    func addKYC(addKYCParamter: AddKYCParameter) {
        AuthNetworkManager.addKYC(parameter: addKYCParamter) { (result) in
            self.parseAddKYCResponse(result: result)
        }
    }

    private func parseAddKYCResponse(result: DataResponse<AddKYCResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            if !(response.responseMessage == nil) {
                if response.responseCode == "01" {
//                    FTIndicator.showToastMessage("\(response.responseMessage!)")

                    let alert = UIAlertController(title: "Chango", message: "\(response.responseMessage!)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        if self.settingsPage {
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: SettingsVC.self){
                                    self.navigationController?.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        } else {
                                self.dismiss(animated: true, completion: nil)
                            }
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)

//                    if (settingsPage) {
//                        for controller in self.navigationController!.viewControllers as Array {
//                            if controller.isKind(of: SettingsVC.self){
//                                self.navigationController?.popToViewController(controller, animated: true)
//                                break
//                            }
//                        }
//                    }else {
//                        let vc: AddMobileNumberVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mobile") as! AddMobileNumberVC
//                        vc.email = email
//                        vc.password = password
//                        vc.firstName = firstName
//                        vc.lastName = lastName
//                        vc.modalPresentationStyle = .fullScreen
//                        self.present(vc, animated: true, completion: nil)
//                    }
                }else {
                    let alert = UIAlertController(title: "Chango", message: "\(response.responseMessage!)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                        if self.settingsPage {
                            self.navigationController?.popViewController(animated: true)
                        }else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(withTitle: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
}
