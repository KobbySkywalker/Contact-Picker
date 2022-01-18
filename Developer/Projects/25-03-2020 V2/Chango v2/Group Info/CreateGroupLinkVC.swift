//
//  CreateGroupLinkVC.swift
//  Chango v2
//
//  Created by Hosny Savage on 07/05/2020.
//  Copyright © 2020 IT Consortium. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDynamicLinks
import FirebaseStorage
import Nuke
import Alamofire
import FTIndicator

class CreateGroupLinkVC: BaseViewController {
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupLink: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var countDownTimer: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var resetLink: UIStackView!
    @IBOutlet weak var resetLinkButton: UIButton!
    
    var groupId: String = ""
    var duration: String = ""
    var generatedId: String = ""
    var groupName: String = ""
    var groupImage: String = ""
    var groupDescription: String = ""
    var linkDuration: Int = 0
    var timeUnits: String = ""
    var groupLinkUrl: String = ""
    var expiryDate: String = ""
    var isExpired: Bool = true
    var durationArray: [String] = ["One Hour", "One Day","One Week","One Month"]
    var counter: Double = 0.0
    var creatorInfo: String = ""
    var isAdmin: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        disableDarkMode()
        showChatController()
        
        groupNameLabel.text = groupName
        createdLabel.text = creatorInfo
        if (groupImage == "<null>") || (groupImage == nil) || (groupImage == ""){
            groupImageView.image = UIImage(named: "defaultgroupicon")
                    print(groupImage)
            groupImageView.contentMode = .scaleAspectFit
        }else {
            groupImageView.contentMode = .scaleAspectFill
            Nuke.loadImage(with: URL(string: groupImage)!, into: groupImageView)
        }
        print("duration: \(linkDuration)\(timeUnits)")
        groupLink.text = groupLinkUrl
        if isExpired == true && isAdmin == "true" {
        let parameter: RegisterGroupLinkParameter = RegisterGroupLinkParameter(duration: linkDuration, groupId: groupId, timeUnits: timeUnits)
        registerGroupLink(registerGroupLinkParameters: parameter)
        }else {
            print("link has not expired: \(isAdmin)")
            
        }
        
        if isAdmin == "false" {
            resetLink.isHidden = true
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
        
        if let newDate = dateFormatter.date(from: expiryDate) {
            print("expire: \(newDate)")
            print("current: \(Date())")
            let date = Date()
            let expiredDate: TimeInterval = newDate - date
            print("new: \(expiredDate.stringTime)")
            counter = expiredDate
        }
//        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareLinkActionBtn(_ sender: UIButton) {
        shareGroupLink(sender: sender, groupLinkUrl: groupLinkUrl)
    }
    
    @IBAction func copyLinkActionBtn(_ sender: UIButton) {
        UIPasteboard.general.string = groupLinkUrl
        FTIndicator.showToastMessage("Copied")
    }
    
    
    @IBAction func regenerateActionBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "Invite via Group Link", message: "Are you sure you want to reset the existing link? Users wanting to join \(groupName) will not be able to use the old link.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Reset Link", style: .default) { (action: UIAlertAction!) in
            
            self.DurationForGroupInviteLink()

        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction!) in
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)    }
    
    @IBAction func qrCodeActionBtn(_ sender: UIButton) {
//        generateQRImage(stringQR: groupLinkUrl, withSizeRate: 1.0)
    }
    
    
    @objc func shareGroupLink(sender: AnyObject, groupLinkUrl: String) {
        print("Share Group link")

            let myWebsite = self.groupLinkUrl
        let shareAll = [myWebsite]
            print("url: \(String(describing: myWebsite))")
        //let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        //activityViewController.popoverPresentationController?.sourceView = sender as! UIView
       //self.present(activityViewController, animated: true, completion: nil)
        
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.airDrop]
        if let popoverController = activityViewController.popoverPresentationController {
        popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
        popoverController.sourceView = self.view
        popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            }
        self.present(activityViewController, animated: true, completion: nil)
        }
    
    
    func generateGroupLink(groupImage: String, groupName: String, groupDescription: String, groupId: String, generatedId: String) {
        
        guard let link = URL(string: "https://www.changoapp.com/private?id=\(groupId)&genid=\(generatedId)") else { return }
//        let dynamicLinksDomainURIPRefix = "https://changov2.page.link" //uat
        let dynamicLinksDomainURIPRefix = "https://changov2preprod.page.link" //live
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPRefix)
        let params = DynamicLinkIOSParameters(bundleID: "ITC.Chango-v2")
        params.appStoreID = "1460147528"
        linkBuilder!.iOSParameters = params
        linkBuilder!.androidParameters = DynamicLinkAndroidParameters(packageName: "com.itconsortiumgh.changov2")
        
        let socialMeta = DynamicLinkSocialMetaTagParameters()
        if (groupImage == "<null>") || (groupImage == nil) || (groupImage == "") {
            //use change image
            print("no group image")
            let storageRef = Storage.storage().reference()
            // Create a reference to the file you want to download
            let starsRef = storageRef.child("1024.png")
            print(starsRef)

            // Fetch the download URL
            starsRef.downloadURL { url, error in
              if let error = error {
                // Handle any errors
                print("image error")
              } else {
                // Get the download URL for 'images/stars.jpg'
                print("url \(url?.absoluteString)")
                socialMeta.imageURL = URL(string: url!.absoluteString)!
              }
            }
//            socialMeta.imageURL = URL(string: "\(UIImage(named: "changoicon"))")
        }else {
            socialMeta.imageURL = URL(string: groupImage)!
        }
        socialMeta.title = groupName
        socialMeta.descriptionText = groupDescription
        linkBuilder!.socialMetaTagParameters = socialMeta
        print("Next")
        
        guard let longDynamicLink = linkBuilder?.url else { return }
        print("The long URL is: \(longDynamicLink)")
        
        linkBuilder!.options = DynamicLinkComponentsOptions()
        linkBuilder?.options!.pathLength = .short
        linkBuilder!.shorten() { url, warnings, error in
            self.groupLink.text = "\(url!)"
            self.groupLinkUrl = "\(url!)"
            if generatedId.isEmpty {
                print("id was not generated")
            }else {
            let parameter: SaveGroupLinkParameter = SaveGroupLinkParameter(generatedLink: self.groupLinkUrl, id: self.generatedId)
                self.saveGroupLink(saveGroupLinkParameter: parameter, groupLink: self.groupLinkUrl)
            }
        print("Warnings: \(String(describing: warnings))")
            print("url: \(String(describing: url))")
            print("error: \(String(describing: error))")
        }
    }
    
    //GENERATE ID
     func registerGroupLink(registerGroupLinkParameters: RegisterGroupLinkParameter) {
         AuthNetworkManager.registerGroupLink(parameter: registerGroupLinkParameters) { (result) in
             self.parseRegisterGroupLinkResponse(result: result)
         }
     }
     
     private func parseRegisterGroupLinkResponse(result: DataResponse<RegisterGroupLinkResponse, AFError>){
         switch result.result {
         case .success(let response):
             print(response)
             if response.data == nil {
             }else {
             generatedId = (response.data?.id)!
                print("gen id: \(generatedId)")
             }
            generateGroupLink(groupImage: groupImage, groupName: groupName, groupDescription: groupDescription, groupId: groupId, generatedId: generatedId)
             
             break
         case .failure( _):
             if result.response?.statusCode == 400 {
                 sessionTimeout()
             }else {
                 showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
             }
         }
     }
    
    
    //SAVE GROUP LINK
    func saveGroupLink(saveGroupLinkParameter: SaveGroupLinkParameter, groupLink: String) {
         AuthNetworkManager.saveGroupLink(parameter: saveGroupLinkParameter) { (result) in
            self.parseSaveGroupLinkResponse(result: result, groupLink: groupLink)
         }
     }
     
    private func parseSaveGroupLinkResponse(result: DataResponse<RevokeLoanApproverResponse, AFError>, groupLink: String){
         switch result.result {
         case .success(let response):
             print(response)
             shareGroupLink(sender: groupImageView, groupLinkUrl: groupLink)
             
             break
         case .failure( _):
             if result.response?.statusCode == 400 {
                 sessionTimeout()
             }else {
                 showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
             }
         }
     }
    
    //COUNTER
    @objc func updateCounter() {
        //example functionality
        if counter > 0 {
            print("\(counter.stringTime) seconds to the end of the world")

            countDownTimer.text = "\(counter.stringTime) remaining"
            counter -= 1
        }
    }
    
    //DURATION OPTIONS
    func DurationForGroupInviteLink(){
        var alert = UIAlertController(title: "Choose Duration for Group Link", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        switch UIDevice.current.screenType {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
            let actionSheetController: UIAlertController = UIAlertController(title: "Choose Duration for Group Link", message: "", preferredStyle: .actionSheet)
            for item in durationArray {
                actionSheetController.addAction(title: item, style: .default, handler: {(action) in
                        if item == "One Hour"{
                            self.linkDuration = 1
                            self.timeUnits = "hours"
                        }else if item == "One Day" {
                            self.linkDuration = 1
                            self.timeUnits = "days"
                        }else if item == "One Week" {
                            self.linkDuration = 1
                            self.timeUnits = "weeks"
                        }else if item == "One Month" {
                            self.linkDuration = 1
                            self.timeUnits = "months"
                        }
                    //create link
                    let parameter: RegisterGroupLinkParameter = RegisterGroupLinkParameter(duration: self.linkDuration, groupId: self.groupId, timeUnits: self.timeUnits)
                    self.registerGroupLink(registerGroupLinkParameters: parameter)
                    
                })
            }
            actionSheetController.addAction(title: "Cancel", style: .cancel)
            self.present(actionSheetController, animated: true, completion: nil)
            break
        default:
            alert = UIAlertController(title: "Choose Duration for Group Link", message: "", preferredStyle: UIAlertController.Style.alert)
            for item in durationArray {
                alert.addAction(title: item, style: .default, handler: {(action) in

                    if item == "One Hour"{
                        self.linkDuration = 1
                        self.timeUnits = "hours"
                    }else if item == "One Day" {
                        self.linkDuration = 1
                        self.timeUnits = "days"
                    }else if item == "One Week" {
                        self.linkDuration = 1
                        self.timeUnits = "weeks"
                    }else if item == "One Month" {
                        self.linkDuration = 1
                        self.timeUnits = "months"
                    }
                    //Create link
                    let parameter: RegisterGroupLinkParameter = RegisterGroupLinkParameter(duration: self.linkDuration, groupId: self.groupId, timeUnits: self.timeUnits)
                    self.registerGroupLink(registerGroupLinkParameters: parameter)

                })
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //QR CODE
    func generateQRImage(stringQR: String, withSizeRate rate: CGFloat) -> UIImage {
        let filter:CIFilter = CIFilter(name:"CIQRCodeGenerator")!
        filter.setDefaults()
        
        let data:NSData = stringQR.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSData
        filter.setValue(data, forKey: "inputMessage")
        
        let outputImg:CIImage = filter.outputImage!
        
        let context:CIContext = CIContext(options: nil)
        let cgimg:CGImage = context.createCGImage(outputImg, from: outputImg.extent)!
        
        var img:UIImage = UIImage(cgImage: cgimg, scale: 1.0, orientation: UIImage.Orientation.up)
        let width = img.size.width * rate
        let height = img.size.height * rate
        
        UIGraphicsBeginImageContext(CGSize.init(width: width, height: height))
        let cgContxt:CGContext = UIGraphicsGetCurrentContext()!
        cgContxt.interpolationQuality = CGInterpolationQuality.none
        img.draw(in: CGRect.init(x: 0, y: 0, width: width, height: height))
        img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }

}


extension TimeInterval {
    private var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }

    private var seconds: Int {
        return Int(self) % 60
    }

    private var minutes: Int {
        return (Int(self) / 60 ) % 60
    }

    private var hours: Int {
        return Int(self) / 3600
    }

    var stringTime: String {
        if hours != 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else if minutes != 0 {
            return "\(minutes)m \(seconds)s"
        } else if milliseconds != 0 {
            return "\(seconds)s \(milliseconds)ms"
        } else {
            return "\(seconds)s"
        }
    }

}


extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
