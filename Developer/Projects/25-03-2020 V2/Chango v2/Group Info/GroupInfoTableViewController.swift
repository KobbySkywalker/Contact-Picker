//
//  GroupInfoTableViewController.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 05/09/2019.
//  Copyright © 2019 IT Consortium. All rights reserved.
//

import UIKit
import FTIndicator
import Alamofire
import Nuke
import FirebaseStorage
import PopupDialog

class GroupInfoTableViewController: BaseTableViewController, UIImagePickerControllerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var groupIcon: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupDescriptionLabel: UILabel!
    @IBOutlet weak var totalContributionsLabel: UILabel!
    @IBOutlet weak var totalCashoutLabel: UILabel!
    @IBOutlet weak var totalBorrowedLabel: UILabel!
    @IBOutlet weak var borrowStack: UIStackView!
    @IBOutlet weak var totalContriLabel: UILabel!
    @IBOutlet weak var totalCashLabel: UILabel!
    @IBOutlet weak var noBorrowStack: UIStackView!
    @IBOutlet weak var contributionView: UIView!
    @IBOutlet weak var cashoutView: UIView!
    @IBOutlet weak var borrowView: UIView!
    @IBOutlet weak var contriView: UIView!
    @IBOutlet weak var cashView: UIView!
    @IBOutlet weak var cameraBackground: UIButton!
    @IBOutlet weak var changeImage: UIButton!
    
    
    var groupName: String = ""
    var groupDescription: String = ""
    var created: String = ""
    var groupIconPath: String = ""
    var groupId: String = ""
    var imageUrl: String = ""
    var loanFlag: Int = 0
    var totalContributions: String = ""
    var totalCashout: String = ""
    var totalBorrowed: String = ""
    var creatorName: String = ""
    var creatorLabel: String = ""
    var isAdmin: String = ""
    var campaignId: String = ""
    var privateGroup: GroupResponse!
        
    var didTheNameChange: Bool = false
    var durationArray: [String] = ["One Hour", "One Day","One Week","One Month"]
    var linkDuration: Int = 0
    var timeUnits: String = ""
    var campaignDetails: [GetGroupCampaignsResponse] = []

    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableDarkMode()
        self.title = "Group Info"
        print("creator: \(creatorName)")
        if creatorName == nil || creatorName == "" {
            creatorLabel = ""
        }else {
        creatorLabel = "by \(creatorName)"
        }
        
        groupNameLabel.text = groupName
        
        picker.delegate = self

        if (groupIconPath == "<null>") || (groupIconPath == nil) || (groupIconPath == ""){
            groupIcon.image = UIImage(named: "defaultgroupicon")
                    print(groupIconPath)
            groupIcon.contentMode = .scaleAspectFit
            
        }else {
            groupIcon.contentMode = .scaleAspectFill
            Nuke.loadImage(with: URL(string: groupIconPath)!, into: groupIcon)
            
        }

        groupDescriptionLabel.text = groupDescription
        
        if (loanFlag == 0){
            print("hide loan stack")
            borrowStack.isHidden = true
            noBorrowStack.isHidden = false

        }else if (loanFlag == 1){
            borrowStack.isHidden = false
            noBorrowStack.isHidden = true
        }
        
        print("admin: \(isAdmin)")
        if isAdmin == "true" {
            changeImage.isHidden = false
            cameraBackground.isHidden = false
        }
        
        totalContributionsLabel.text = totalContributions
        totalCashoutLabel.text = totalCashout
        totalBorrowedLabel.text = totalBorrowed
        totalContriLabel.text = totalContributions
        totalCashLabel.text = totalCashout
        
                contributionView.layer.cornerRadius = 10
                contributionView.layer.shadowColor = UIColor.black.cgColor
                contributionView.layer.shadowOffset = CGSize(width: 2, height: 4)
                contributionView.layer.shadowRadius = 8
                contributionView.layer.shadowOpacity = 0.2
        
                borrowView.layer.cornerRadius = 10
                borrowView.layer.shadowColor = UIColor.black.cgColor
                borrowView.layer.shadowOffset = CGSize(width: 2, height: 4)
                borrowView.layer.shadowRadius = 8
                borrowView.layer.shadowOpacity = 0.2
        
                cashoutView.layer.cornerRadius = 10
                cashoutView.layer.shadowColor = UIColor.black.cgColor
                cashoutView.layer.shadowOffset = CGSize(width: 2, height: 4)
                cashoutView.layer.shadowRadius = 8
                cashoutView.layer.shadowOpacity = 0.2
        
                contriView.layer.cornerRadius = 10
                contriView.layer.shadowColor = UIColor.black.cgColor
                contriView.layer.shadowOffset = CGSize(width: 2, height: 4)
                contriView.layer.shadowRadius = 8
                contriView.layer.shadowOpacity = 0.2
        
                cashView.layer.cornerRadius = 10
                cashView.layer.shadowColor = UIColor.black.cgColor
                cashView.layer.shadowOffset = CGSize(width: 2, height: 4)
                cashView.layer.shadowRadius = 8
                cashView.layer.shadowOpacity = 0.2
        
        _ = SwiftEventBus.onMainThread(self, name: "namechange", handler: { result in
            let event: GroupNameChangeEvent = result?.object as! GroupNameChangeEvent

            self.groupNameChange(event)
        })
         
    
    }

    
    @IBAction func changeProfileImage(_ sender: UIButton) {
        
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
    
    
    //REPORT GROUP DIALOG
    func showReportGroupDialog(animated: Bool = true) {
        
        //create a custom view controller
        let reportCampaignVC = ReportGroupVC(nibName: "ReportGroupVC", bundle: nil)
        
        //create the dialog
        let popup = PopupDialog(viewController: reportCampaignVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: true)
        
        //create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
        }
        CancelButton.appearance().titleColor = UIColor.lightGray
        
        //create second button
        let buttonTwo = DefaultButton(title: "SEND REPORT", height: 60) {
            if(reportCampaignVC.groupReport.textColor == UIColor.lightGray){
                let alert = UIAlertController(title: "Report This Group", message: "Please enter a report", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    

                }
                
                alert.addAction(OKAction)
                
                self.present(alert, animated: true, completion: nil)
                
            }else {
                let parameter: ReportPrivateGroupParameter = ReportPrivateGroupParameter(anonymous: "false", groupId: self.groupId, message: reportCampaignVC.groupReport.text!)
                self.reportPrivateGroup(reportPrivateGroupParameter: parameter)
            }
        }
        DefaultButton.appearance().titleColor = UIColor(red: 49/255, green: 102/255, blue: 216/255, alpha: 1)

        
        //Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        //Present dialog
        present(popup, animated: animated, completion: nil)
        
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
        
        groupIcon.image = image
        picker.dismiss(animated: true, completion: nil)
        
        //Loading indicator here
        imageUrl = "\(image)"
        uploadImagePic(img1: image)
        //Api call here
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Shit got picked")
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        groupIcon.image = chosenImage
        picker.dismiss(animated: true, completion: nil)
        
        //Loading indicator here
        
        uploadImagePic(img1: chosenImage)
    }
    
    fileprivate func makingRoundedImageProfileWithRoundedBorder() {
        
        self.groupIcon.layer.cornerRadius = 53.5
        self.groupIcon.clipsToBounds = true
        self.groupIcon.layer.borderWidth = 0.8
        self.groupIcon.layer.borderColor = UIColor.white.cgColor
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
    
    
    func uploadImagePic(img1 :UIImage){
        FTIndicator.showProgress(withMessage: "saving")
        
        var data = NSData()
        data = img1.jpegData(compressionQuality: 0.8)! as NSData
        // set upload path
        let filePath = "group_images/\(groupIconPath)" // path where you wanted to store img in storage
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
                            let parameter: UpdatePrivateGroupPictureParameter = UpdatePrivateGroupPictureParameter(groupIconPath: (String(describing: myURL!)), groupId: self.groupIconPath)
                            print("imageUrl: \(self.imageUrl)")
                            print("imageUrl: \(myURL)")
                            
                            self.updatePrivateGroupProfilePicture(updatePrivateGroupPictureParameter: parameter)
                            
                        }
                    }else{
                        print("Error: \(error!)")
                    }
                })
            }
        }
        
    }
    
    func updatePrivateGroupProfilePicture(updatePrivateGroupPictureParameter: UpdatePrivateGroupPictureParameter){
        AuthNetworkManager.updatePrivateGroupProfilePicture(parameter: updatePrivateGroupPictureParameter) { (result) in
            self.parseUpdatePrivateGroupProfilePicture(result: result)
        }
    }
    
    private func parseUpdatePrivateGroupProfilePicture(result: DataResponse<UpdatePrivateGroupImageResponse, AFError>){
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
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x:10, y:0, width:tableView.frame.size.width, height: 40))
        footerView.backgroundColor = UIColor.clear
        
        switch section {
            
        case 2:
            let label = UILabel(frame: footerView.frame)
            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            _ = formatter.string(from: Date())
            
            let date = formatter.date(from: self.created)
            
            formatter.dateStyle = DateFormatter.Style.medium
            
            let newDate = formatter.string(from: date!)
            print(newDate)
            label.text = "Created \(newDate) \(creatorLabel)"
        
            label.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            label.textColor = UIColor.gray
            footerView.addSubview(label)
            return footerView
        default: break
        }
        return nil
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let headerHeight: CGFloat
        
        switch section {
        case 0:
            // hide the header
            headerHeight = CGFloat.leastNonzeroMagnitude
        default:
            headerHeight = 21
        }
        
        return headerHeight
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case 0:
            if indexPath.row == 2 {
                
                if isAdmin == "false" {
                    let alert = UIAlertController(title: "Chango", message: "Only admins can edit group names.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction!) in

                    }

                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }else {
                let vc: EditGroupNameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editname") as! EditGroupNameVC
                
                vc.groupName = groupName
                vc.groupId = groupId
                self.present(vc, animated: true, completion: nil)
//                self.navigationController?.pushViewController(vc, animated: true)
                self.modalPresentationStyle = .overCurrentContext
                }
            }
            break
            
        case 1:
            if indexPath.row == 0 {
            let vc: SendStatementViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "send") as! SendStatementViewController
            
                vc.groupId = groupId
            self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1 {
                //Group Activities
                FTIndicator.showProgress(withMessage: "loading group activities", userInteractionEnable: false)
                let parameter: GroupActivityParameter = GroupActivityParameter(groupId: groupId)
                self.getGroupActivity(groupActivity: parameter)
            }else if indexPath.row == 2 {
                FTIndicator.showProgress(withMessage: "loading group policies", userInteractionEnable: false)

//                let parameter: GroupPoliciesParameter = GroupPoliciesParameter(groupId: groupId)
//                self.groupPolicies(groupPolicies: parameter)
            }else if indexPath.row == 3 {
                //approved cashouts
//                showAlert(title: "Approved Cashouts", message: "This feature is not available yet.")
                let vc: ApprovedCashoutsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "approvedcashouts") as! ApprovedCashoutsVC
                vc.campaignId = campaignId
                vc.groupId = groupId
                vc.privateGroup = privateGroup

                self.navigationController?.pushViewController(vc, animated: true)

            }else if indexPath.row == 4 {
                //group link
                if isAdmin == "true" {
                let parameter: RetrieveGroupLinkParameter = RetrieveGroupLinkParameter(groupId: groupId)
                retrieveGroupLink(retrieveGroupLinkParameter: parameter)
                }else {
                    showAlert(title: "\(groupName)", message: "Only admins of this group can invite via link.")
                }
            }
            break
            
        case 2:
            if indexPath.row == 0 {
                //exit group
                
                let alert = UIAlertController(title: "\(groupName)", message: "Are you sure you want to exit this group? You cannot return without being invited again!", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "EXIT GROUP", style: .default) { (action: UIAlertAction!) in
                    
                    FTIndicator.showProgress(withMessage: "Leaving group")
                    let parameter: LeaveGroupParameter = LeaveGroupParameter(groupId: self.groupId)
                    self.leaveGroup(leaveGroupParameter: parameter)
                }
                
                let cancelAction = UIAlertAction(title: "STAY", style: .default) { (action: UIAlertAction!) in
                    
                }
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
                
            }else if indexPath.row == 1 {
                //report group
                showReportGroupDialog()
            }

            
            break
        default:
            print("default")
            
            
        }
        
    }
    
    func groupNameChange(_ event: GroupNameChangeEvent){

        
        groupName = event.groupName
        groupNameLabel.text = event.groupName
        
        newGroupName = event.groupName
        reloadGroupTable = true
        
//        SwiftEventBus.post("namechanges", sender: GroupNameChangeEvent(groupName_: groupName))
    }
  
    
    //LEAVE GROUP
    func leaveGroup(leaveGroupParameter: LeaveGroupParameter) {
        AuthNetworkManager.leaveGroup(parameter: leaveGroupParameter) { (result) in
            //            self.parseAddMemberResponse(result: result)
            FTIndicator.dismissProgress()
            print("result: \(result)")
            //            print("value: \(result.value)")
            
            if result == "left successfully" {
//                self.allGroupsController.leftGroup = true
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: AllGroupsViewController.self){
                        (controller as! AllGroupsViewController).leftGroup = true
                        self.navigationController?.popToViewController(controller, animated: true)
                    }
                }
            }else {
                FTIndicator.showToastMessage(result)
            }
            
        }
    }
    
    
    
    //GROUP POLICIES
//    func groupPolicies(groupPolicies: GroupPoliciesParameter) {
//        AuthNetworkManager.getGroupPolicies(parameter: groupPolicies) { (result) in
//            self.parseGetGroupResponse(result: result)
//        }
//    }
    
    
//    private func parseGetGroupResponse(result: DataResponse<GroupPoliciesResponse, AFError>){
//        FTIndicator.dismissProgress()
//        switch result.result {
//        case .success(let response):
//            print(response.makeadmin)
//
//            let vc: GroupPolicyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "policy") as! GroupPolicyVC
//
//            vc.groupPolicies = [response]
//
//            self.navigationController?.pushViewController(vc, animated: true)
//
//            break
//        case .failure(let error):
//
//            if result.response?.statusCode == 400 {
//
//                baseTableSessionTimeout()
//
//            }else {
//                let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
//
//                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
//
//                }
//
//                alert.addAction(okAction)
//
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
//    }
    
    
    func getGroupActivity(groupActivity: GroupActivityParameter) {
        AuthNetworkManager.getGroupActivity(parameter: groupActivity) { (result) in
            self.parseGetGroupActivityResponse(result: result)
        }
    }
    
    
    private func parseGetGroupActivityResponse(result: DataResponse<[UserActivity], AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response)
            
            
            let vc: GroupActivityVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "groupactivity") as! GroupActivityVC
            
            vc.groupActivites = response
            
            self.navigationController?.pushViewController(vc, animated: true)

            break
        case .failure(let error):
            print(NetworkManager().getErrorMessage(response: result))
            if result.response?.statusCode == 400 {
                
                let alert = UIAlertController(title: "Chango", message: "Your session has timed out. Please login", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                    if UserDefaults.standard.bool(forKey: "touchID"){
                        
                        let vc: LoginTouchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "touch") as! LoginTouchVC
                        
                        self.present(vc, animated: true, completion: nil)
                        print("touchID")
                        
                    }else {
                        let vc: LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "in") as! LoginVC
                        
                        
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    
    //RETRIEVE GROUP LINK
     func retrieveGroupLink(retrieveGroupLinkParameter: RetrieveGroupLinkParameter) {
         AuthNetworkManager.retrieveGroupLink(parameter: retrieveGroupLinkParameter) { (result) in
             self.parseRetrieveGroupLinkResponse(result: result)
         }
     }
     
    private func parseRetrieveGroupLinkResponse(result: DataResponse<RetrieveGroupLinkResponse, AFError>){
        switch result.result {
        case .success(let response):
            print(response)
            if response.data == nil {
                print("data is nil")
                DurationForGroupInviteLink()
            }else if ((response.data?.isExpired)! == true) || (response.data?.generatedLink == nil) {
                print("showmessage")
                DurationForGroupInviteLink()
            }else if  ((response.data?.isExpired)! == false) && (response.data?.generatedLink != nil) {
                print(" false, not nil")
                let vc: CreateGroupLinkVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "grouplink") as! CreateGroupLinkVC
                vc.groupDescription = groupDescription
                vc.groupName = groupName
                vc.groupImage = groupIconPath
                vc.groupId = groupId
                vc.linkDuration = self.linkDuration
                vc.timeUnits = self.timeUnits
                vc.isExpired = (response.data?.isExpired)!
                vc.expiryDate = (response.data?.expired)!
                vc.groupLinkUrl = (response.data?.generatedLink ?? "")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                baseTableSessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
    
    
    //REPORT PRIVATE GROUP
    func reportPrivateGroup(reportPrivateGroupParameter: ReportPrivateGroupParameter) {
        AuthNetworkManager.reportPrivateGroup(parameter: reportPrivateGroupParameter) { (result) in
            self.parseReportPrivateGroup(result: result)
        }
    }
    
    
    private func parseReportPrivateGroup(result: DataResponse<ReportCampaign, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            
            let alert = UIAlertController(title: "Chango", message: "Your report has been submitted successfully.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            break
        case .failure(let error):
            
            if (result.response?.statusCode == 400) {
                
                baseTableSessionTimeout()
                
            }else if result.response?.statusCode == 404{
                
                let alert = UIAlertController(title: "Chango", message: "Your report has been submitted successfully.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                    
                    self.navigationController?.popViewController(animated: true)
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                
            }else {
            let alert = UIAlertController(title: "Chango", message: NetworkManager().getErrorMessage(response: result), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func DurationForGroupInviteLink(){
        var alert = UIAlertController(title: "Choose Duration for Group Link", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        switch UIDevice.current.screenType {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
            let actionSheetController: UIAlertController = UIAlertController(title: "Choose Duration for Group Link", message: "", preferredStyle: .actionSheet)
            for item in durationArray {
                actionSheetController.addAction(title: item, style: .default, handler: {(action) in
                    let vc: CreateGroupLinkVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "grouplink") as! CreateGroupLinkVC
                    vc.groupDescription = self.groupDescription
                    vc.groupName = self.groupName
                    vc.groupImage = self.groupIconPath
                    vc.groupId = self.groupId
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
                    vc.linkDuration = self.linkDuration
                    vc.timeUnits = self.timeUnits
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }
            actionSheetController.addAction(title: "Cancel", style: .cancel)
            self.present(actionSheetController, animated: true, completion: nil)
            break
        default:
            alert = UIAlertController(title: "Choose Duration for Group Link", message: "", preferredStyle: UIAlertController.Style.alert)
            for item in durationArray {
                alert.addAction(title: item, style: .default, handler: {(action) in
                    let vc: CreateGroupLinkVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "grouplink") as! CreateGroupLinkVC
                    vc.groupDescription = self.groupDescription
                    vc.groupName = self.groupName
                    vc.groupImage = self.groupIconPath
                    vc.groupId = self.groupId
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
                    vc.linkDuration = self.linkDuration
                    vc.timeUnits = self.timeUnits
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
