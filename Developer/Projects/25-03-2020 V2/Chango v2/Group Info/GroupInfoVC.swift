//
//  GroupInfoVC.swift
//  
//
//  Created by Hosny Savage on 19/10/2020.
//

import UIKit
import Nuke
import Alamofire
import FTIndicator
import PopupDialog
import FirebaseStorage
import FirebaseMessaging

class GroupInfoVC: BaseViewController, UIImagePickerControllerDelegate, UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {

    let picker = UIImagePickerController()
    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var creatorDateLabel: UILabel!
    @IBOutlet weak var totalContributionsLabel: UILabel!
    @IBOutlet weak var totalCashoutLabel: UILabel!
    @IBOutlet weak var totalBorrowedCaption: UILabel!
    @IBOutlet weak var totalBorrowedLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var changeGroupIcon: UIButton!
    @IBOutlet weak var totalContributionCaption: UILabel!
    @IBOutlet weak var totalCashoutCaption: UILabel!
    @IBOutlet weak var approvalLogo: UIImageView!
    @IBOutlet weak var guaranteeLabel: UILabel!
    
    var groupName: String = ""
    var groupDescription: String = ""
    var groupIconPath: String = ""
    var created: String = ""
    var groupId: String = ""
    var loanFlag: Int = 0
    var totalContributions: String = ""
    var totalCashout: String = ""
    var totalBorrowed: String = ""
    var creatorName: String = ""
    var isAdmin: String = ""
    var campaignId: String = ""
    var campaignDetails: [GetGroupCampaignsResponse] = []
    var privateGroup: GroupResponse!
    var creatorInfo: String = ""
    var imageUrl: String = ""
    
    var didTheNameChange: Bool = false
    var durationArray: [String] = ["One Hour", "One Day","One Week","One Month"]
    var linkDuration: Int = 0
    var timeUnits: String = ""
    
    var groupElements: [String] = ["Send Statement","Group Name", "Group Activities","Group Policies","Approved Cashout","Invite to Group via Link","","Exit Group","Report Group"]
    var groupElementsNonAdmin: [String] = ["Send Statement","Group Activities","Group Policies","Approved Cashout","Invite to Group via Link","","Exit Group","Report Group"]
    
    let cell = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showChatController()
        disableDarkMode()
        
        tableView.tableFooterView = UIView()
        
        picker.delegate = self
        
        let parameter: GetApprovalBodyParameter = GetApprovalBodyParameter(countryId: privateGroup.countryId.countryId!)
        getApprovalBody(getApprovalBodyParameter: parameter)

        if isAdmin == "true" {
            changeGroupIcon.isHidden = false
        }else {
            changeGroupIcon.isHidden = true
        }
        
        if privateGroup.countryId.countryId == "GH"{
            guaranteeLabel.isHidden = false
            approvalLogo.isHidden = false
            guaranteeLabel.text = "This App has been approved by The Central Bank of Ghana"
        }else {
            guaranteeLabel.isHidden = true
            approvalLogo.isHidden = true
        }
        
        print("creator: \(creatorName)")
        if (creatorName == "") {
            creatorDateLabel.text = ""
        }else {
            creatorDateLabel.text = "Created on \(dateConversion(dateValue: created)) by \(creatorName)"
            creatorInfo = "Created on \(dateConversion(dateValue: created)) by \(creatorName)"
        }
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        self.tableView.tableFooterView = UIView()

        print("print: \(groupName)")
        groupNameLabel.text = groupName
        
        if (groupIconPath == "<null>") || (groupIconPath == ""){
            groupImage.image = UIImage(named: "defaultgroupicon")
                    print(groupIconPath)
            groupImage.contentMode = .scaleAspectFit
            
        }else {
            groupImage.contentMode = .scaleAspectFill
            Nuke.loadImage(with: URL(string: groupIconPath)!, into: groupImage)
            
        }
        
        if loanFlag == 1 {
            totalBorrowedLabel.isHidden = false
            totalBorrowedCaption.isHidden = false
            totalBorrowedLabel.text = "(totalBorrowed)"
            totalBorrowedCaption.text = "Total Amount Borrowed (\(privateGroup.countryId.currency))"
        }else {
            totalBorrowedLabel.isHidden = true
            totalBorrowedCaption.isHidden = true
        }
        totalContributionsLabel.text = "\(totalContributions)"
        totalContributionCaption.text = "Total Contributions (\(privateGroup.countryId.currency))"
        totalCashoutCaption.text = "Total Cashout (\(privateGroup.countryId.currency))"
        totalCashoutLabel.text = "\(totalCashout)"
        
        let param: GroupTotalsParameter = GroupTotalsParameter(groupId: privateGroup.groupId)
        self.getGroupTotals(groupTotalsParameter: param)
        
        _ = SwiftEventBus.onMainThread(self, name: "namechange", handler: { result in
            let event: GroupNameChangeEvent = result?.object as! GroupNameChangeEvent

            self.groupNameChange(event)
        })
        
    }
    
    
    @IBAction func changeGroupIconButtonAction(_ sender: Any) {
        
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
        
        groupImage.image = image
        picker.dismiss(animated: true, completion: nil)
        
        //Loading indicator here
        imageUrl = "\(image)"
        uploadImagePic(img1: image)
        //Api call here
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Shit got picked")
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        groupImage.image = chosenImage
        picker.dismiss(animated: true, completion: nil)
        
        //Loading indicator here
        
        uploadImagePic(img1: chosenImage)
    }
    
    fileprivate func makingRoundedImageProfileWithRoundedBorder() {
        
        self.groupImage.layer.cornerRadius = 53.5
        self.groupImage.clipsToBounds = true
        self.groupImage.layer.borderWidth = 0.8
        self.groupImage.layer.borderColor = UIColor.white.cgColor
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
                            let parameter: UpdatePrivateGroupPictureParameter = UpdatePrivateGroupPictureParameter(groupIconPath: (String(describing: myURL!)), groupId: self.groupId)
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
            showAlert(withTitle: "Group Profile", message: "Update successful")
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
    
    
    //GROUP TOTALS
    func getGroupTotals(groupTotalsParameter: GroupTotalsParameter) {
        AuthNetworkManager.groupTotals(parameter: groupTotalsParameter) { (result) in
            self.parseGetGroupTotalsResponse(result: result)
        }
    }
    
    
    private func parseGetGroupTotalsResponse(result: DataResponse<GroupTotalsResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            
            totalContributionsLabel.text = "\(response.totalContributions)"
            totalCashoutLabel.text = "\(response.totalCashouts)"
            totalBorrowedLabel.text = "\(response.totalGroupLoans)"
            print("cashout: \(response.totalCashouts)")
            print("contributions: \(response.totalContributions)")
            
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

    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func groupNameChange(_ event: GroupNameChangeEvent){
        groupName = event.groupName
        groupNameLabel.text = event.groupName
        
        newGroupName = event.groupName
        reloadGroupTable = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isAdmin == "true" {
            return groupElements.count
        }else {
            return groupElementsNonAdmin.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath) as! UITableViewCell
        tableCell.selectionStyle = .none
        
        if isAdmin == "true" {
        tableCell.textLabel?.text = groupElements[indexPath.row]
            switch indexPath.row {
            case 0,1,2,3,4,5:
                tableCell.textLabel?.textColor = UIColor(hexString: "#05406F")
                break
            case 7,8:
                tableCell.textLabel?.textColor = UIColor(hexString: "#F14439")
                break
            default:
                break
            }
        }else {
            tableCell.textLabel?.text = groupElementsNonAdmin[indexPath.row]
            switch indexPath.row {
            case 0,1,2,3,4:
                tableCell.textLabel?.textColor = UIColor(hexString: "#05406F")
                break
            case 6,7:
                tableCell.textLabel?.textColor = UIColor(hexString: "#F14439")
                break
            default:
                break
            }
        }
        

        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isAdmin == "true" {
            switch indexPath.row {
            case 0:
                //send statement
                groupOrPersonalStatementOptions()
                break
            case 1:
                let vc: EditGroupNameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editname") as! EditGroupNameVC
                
                vc.creatorInfo = creatorInfo
                vc.groupIconPath = privateGroup.groupIconPath!
                vc.groupName = privateGroup.groupName
                vc.groupId = privateGroup.groupId
                    self.navigationController?.pushViewController(vc, animated: true)
                break
            case 2:
                //group activities
                FTIndicator.showProgress(withMessage: "loading group activities", userInteractionEnable: false)
                let parameter: GroupActivityParameter = GroupActivityParameter(groupId: groupId)
                self.getGroupActivity(groupActivity: parameter)
                    
                break
            case 3:
                //group policies
                FTIndicator.showProgress(withMessage: "loading group policies", userInteractionEnable: false)
//                let parameter: GroupPoliciesParameter = GroupPoliciesParameter(groupId: groupId)
//                self.groupPolicies(groupPolicies: parameter)
                let parameter: GroupPoliciesParameter = GroupPoliciesParameter(groupId: groupId)
                self.groupPolicy(groupPolicies: parameter)
                break
            case 4:
                //approved cashouts
                let vc: ApprovedCashoutsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "approvedcashouts") as! ApprovedCashoutsVC
                vc.campaignId = campaignId
                vc.groupId = groupId
                vc.privateGroup = privateGroup
                vc.created = creatorInfo
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 5:
                //invite via link
//                if isAdmin == "true" {
                let parameter: RetrieveGroupLinkParameter = RetrieveGroupLinkParameter(groupId: groupId)
                retrieveGroupLink(retrieveGroupLinkParameter: parameter)
//                }else {
//                    showAlert(title: "\(groupName)", message: "Only admins of this group can invite via link.")
//                }
                break
            case 7:
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
                break
            case 8:
                //report group
                showReportGroupDialog()
                break
            default:
                break
                }
        }else {
        switch indexPath.row {
        case 0:
            //send statement
            let vc: SendStatementViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "send") as! SendStatementViewController
                vc.groupId = groupId
                vc.groupName = groupName
                vc.created = creatorInfo
                vc.groupIconPath = groupIconPath
                vc.statementType = "MEMBER"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            //group activities
            FTIndicator.showProgress(withMessage: "loading group activities", userInteractionEnable: false)
            let parameter: GroupActivityParameter = GroupActivityParameter(groupId: groupId)
            self.getGroupActivity(groupActivity: parameter)
                
            break
        case 2:
            //group policies
            FTIndicator.showProgress(withMessage: "loading group policies", userInteractionEnable: false)
//            let parameter: GroupPoliciesParameter = GroupPoliciesParameter(groupId: groupId)
//            self.groupPolicies(groupPolicies: parameter)
            let parameter: GroupPoliciesParameter = GroupPoliciesParameter(groupId: groupId)
            self.groupPolicy(groupPolicies: parameter)
            break
        case 3:
            //approved cashouts
            let vc: ApprovedCashoutsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "approvedcashouts") as! ApprovedCashoutsVC
            vc.campaignId = campaignId
            vc.groupId = groupId
            vc.privateGroup = privateGroup
            vc.created = creatorInfo
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 4:
            //invite via link
//            if isAdmin == "true" {
            let parameter: RetrieveGroupLinkParameter = RetrieveGroupLinkParameter(groupId: groupId)
            retrieveGroupLink(retrieveGroupLinkParameter: parameter)
//            }else {
//                showAlert(title: "\(groupName)", message: "Only admins of this group can invite via link.")
//            }
            break
        case 6:
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
            break
        case 7:
            //report group
            showReportGroupDialog()
            break
        default:
            break
            }
        }
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
    
    //LEAVE GROUP
    func leaveGroup(leaveGroupParameter: LeaveGroupParameter) {
        AuthNetworkManager.leaveGroup(parameter: leaveGroupParameter) { (result) in
            FTIndicator.dismissProgress()
            print("result: \(result)")
            
            if result == "Successfully left group" {
                //                self.allGroupsController.leftGroup = true
                Messaging.messaging().unsubscribe(fromTopic: self.groupId)
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
    func groupPolicies(groupPolicies: GroupPoliciesParameter) {
        AuthNetworkManager.getGroupPolicies(parameter: groupPolicies) { (result) in
            self.parseGetGroupResponse(result: result)
        }
    }
    
    
    private func parseGetGroupResponse(result: DataResponse<GroupPoliciesResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response.makeadmin)
            
            let vc: GroupPolicyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "policy") as! GroupPolicyVC
            
            vc.groupPolicies = [response]
            vc.groupIconPath = groupIconPath
            vc.creatorInfo = creatorInfo
            vc.groupName = groupName
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        case .failure(_ ):
            
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
    
    
    //GROUP POLICIES
    func groupPolicy(groupPolicies: GroupPoliciesParameter) {
        AuthNetworkManager.getGroupPolicy(parameter: groupPolicies) { (result) in
            self.parseGroupPoilicyResponse(result: result)
        }
    }
    
    
    private func parseGroupPoilicyResponse(result: DataResponse<GroupPolicyResponse, AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print(response.makeAdmin)
            
            let vc: GroupPolicyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "policy") as! GroupPolicyVC
            
            vc.groupPolicy = [response]
            vc.groupIconPath = groupIconPath
            vc.creatorInfo = creatorInfo
            vc.groupName = groupName
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        case .failure(_ ):
            
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
            vc.groupName = groupName
            vc.groupIconPath = groupIconPath
            vc.creatorInfo = creatorInfo
            
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
            if isAdmin == "true" {
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
                vc.creatorInfo = creatorInfo
                vc.isAdmin = isAdmin
                self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                if response.data == nil {
                    showAlert(title: "\(groupName)", message: "There is currently no invite link available for your group. You can contact your admin to generate one")
                } else if  ((response.data?.isExpired)! == true) {
                    showAlert(title: "\(groupName)", message: "The group link has expired. Contact your group admin(s) to generate a new invite link")
                } else if  ((response.data?.isExpired)! == false) && (response.data?.generatedLink != nil) {
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
                    vc.creatorInfo = creatorInfo
                    vc.isAdmin = isAdmin
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
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
                
                sessionTimeout()
                
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
                    vc.isAdmin = self.isAdmin
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
                    vc.isAdmin = self.isAdmin
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
    
    
    func groupOrPersonalStatementOptions(){
        var alert = UIAlertController(title: "Choose Statement Option", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        switch UIDevice.current.screenType {
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE, UIDevice.ScreenType.iPhone_XR_11, UIDevice.ScreenType.iPhone4_4S, UIDevice.ScreenType.iPhones_6_6s_7_8, UIDevice.ScreenType.iPhones_X_XS_11Pro, UIDevice.ScreenType.iPhone_XSMax_ProMax:
            let actionSheetController: UIAlertController = UIAlertController(title: "Choose Statement Option", message: "", preferredStyle: .actionSheet)
            actionSheetController.addAction(title: "Group Statement", style: .default, handler: { (action) in
                //move to statemennt view
                let vc: SendStatementViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "send") as! SendStatementViewController
                vc.groupId = self.groupId
                vc.groupName = self.groupName
                vc.created = self.creatorInfo
                vc.groupIconPath = self.groupIconPath
                vc.statementType = "GROUP"
                self.navigationController?.pushViewController(vc, animated: true)
            })
            actionSheetController.addAction(title: "Personal Statement", style: .default, handler:  { (action) in
                //move to statemennt view
                let vc: SendStatementViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "send") as! SendStatementViewController
                vc.groupId = self.groupId
                vc.groupName = self.groupName
                vc.created = self.creatorInfo
                vc.groupIconPath = self.groupIconPath
                vc.statementType = "MEMBER"
                self.navigationController?.pushViewController(vc, animated: true)
            })
            actionSheetController.addAction(title: "Cancel", style: .cancel)
            self.present(actionSheetController, animated: true, completion: nil)
            break
        default:
            alert = UIAlertController(title: "Choose Statement Option", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(title: "Group Statement", style: .default, handler: {(action) in
                let vc: SendStatementViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "send") as! SendStatementViewController
                vc.groupId = self.groupId
                vc.groupName = self.groupName
                vc.created = self.creatorInfo
                vc.groupIconPath = self.groupIconPath
                vc.statementType = "GROUP"
                self.navigationController?.pushViewController(vc, animated: true)
            })
            alert.addAction(title: "Personal Statement", style: .default, handler: {(action) in
                let vc: SendStatementViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "send") as! SendStatementViewController
                vc.groupId = self.groupId
                vc.groupName = self.groupName
                vc.created = self.creatorInfo
                vc.groupIconPath = self.groupIconPath
                vc.statementType = "MEMBER"
                self.navigationController?.pushViewController(vc, animated: true)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getApprovalBody(getApprovalBodyParameter: GetApprovalBodyParameter) {
        AuthNetworkManager.getApprovalBody(parameter: getApprovalBodyParameter) { (result) in
            self.parseGetApprovalBodyResponse(result: result)
        }
    }
    
    private func parseGetApprovalBodyResponse(result: DataResponse<[GetApprovalBodyResponse], AFError>){
        FTIndicator.dismissProgress()
        switch result.result {
        case .success(let response):
            print("response: \(response)")
            for item in response {
                Nuke.loadImage(with: URL(string: item.logo!)!, into: approvalLogo)
                guaranteeLabel.text = "\(item.message!)\(item.name!)"
            }
            break
        case .failure( _):
            if result.response?.statusCode == 400 {
                sessionTimeout()
            }else {
                showAlert(title: "Chango", message: NetworkManager().getErrorMessage(response: result))
            }
        }
    }
}


func dateConversion(dateValue: String) -> String{
    let formatter = DateFormatter()
    formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    _ = formatter.string(from: Date())
    let date = formatter.date(from: dateValue)
    
    formatter.dateStyle = DateFormatter.Style.medium
    
    let newDate = formatter.string(from: date!)
    print(newDate)
    
    return newDate
}

func dateConversionWithMilliSeconds(dateValue: String) -> String{
    let formatter = DateFormatter()
    formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
    let miliSecString = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    if (dateValue.count < miliSecString.count) && (dateValue.components(separatedBy: ".").count < miliSecString.components(separatedBy: ".").count) {
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }else {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    }
    
    _ = formatter.string(from: Date())
    let date = formatter.date(from: dateValue)
    
//    formatter.dateStyle = DateFormatter.Style.medium
    formatter.dateFormat = "MMM d, h:mm a"
    
    let newDate = formatter.string(from: date!)
    print(newDate)
    
    return newDate
}
