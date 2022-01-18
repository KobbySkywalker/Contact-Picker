//
//  AppDelegate.swift
//  Chango v2
//
//  Created by Hosny Ben Savage on 08/10/2018.
//  Copyright © 2018 IT Consortium. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseCore
import FirebaseMessaging
import GoogleSignIn
import IQKeyboardManagerSwift
//import RealmSwift
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import LocalAuthentication
import BWWalkthrough
import Alamofire
import FirebaseDynamicLinks
import CardScan
import FBSDKCoreKit
import TwitterKit

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?
    
    override init() {
        super.init()
        FirebaseApp.configure()
//        FirebaseOptions.init().deepLinkURLScheme = "ITC.Chango-v2"
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        TWTRTwitter.sharedInstance().start(withConsumerKey: "O0wzpsZelbUwrQrxVcWOFRw1q", consumerSecret: "E08iJKUNL0NI9bLZbQlbOEbxrGxBvuUYAQHZ7Hr0Ix1s5BlPin")
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().delegate = self
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        print("something there")
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if UserDefaults.standard.bool(forKey: "touchID"){
                let vc: LoginTouchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "touch") as! LoginTouchVC
                self.window?.rootViewController = vc
                print("touchID")
            }else if UserDefaults.standard.bool(forKey: "regular") {
                //old user with no touch or face id
                let vc: LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "in") as! LoginVC
                vc.modalPresentationStyle = .fullScreen
                self.window?.rootViewController = vc
                print("login1")
            }else {
                showWalkThrough()
            }
        } else {
            // no biometry
            if UserDefaults.standard.bool(forKey: "regular"){
            let vc: LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "in") as! LoginVC
                vc.modalPresentationStyle = .fullScreen
                self.window?.rootViewController = vc
            }else {
                //First time user or logged out.
                showWalkThrough()
            print("login2")
            }
        }
        
//        FirebaseApp.configure()
//        Database.database().isPersistenceEnabled = true
        let storage = Storage.storage()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.tokenRefreshNotification),
//                                               name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
//        registerForPushNotifications(application: application)

        
        IQKeyboardManager.shared.enable = true

        return true
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
        self.window?.rootViewController = walkthrough
    }
    
    
    //DYNAMIC LINKS
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let dynamicLinks = application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: "")
        Auth.auth().canHandle(url)
        let checkGoogle = GIDSignIn.sharedInstance().handle(url)
        //facebook
//        let facebook = ApplicationDelegate.shared.application(
//            app,
//            open: url,
//            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//        )
        let checkFacebook = ApplicationDelegate.shared.application(app, open: url, options: options)
        
        let twitterAuthentication = TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        
        return dynamicLinks || checkGoogle || twitterAuthentication || checkFacebook
        }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url)
        if let dynamicLink = dynamicLink {
            // Handle the deep link here.
            // Show promotional offer.
            print("Dynamic link : \(String(describing: dynamicLink.url))")
            if let url = dynamicLink.url {
                let linkId = url.absoluteString.components(separatedBy: "=")[1]
                let groupId = linkId.components(separatedBy: "&")[0]
                print("groupId:\(groupId)")
                let genId = url.absoluteString.components(separatedBy: "=")[2]
                print("gen id: \(genId)")
                let linkParams = UserDefaults.standard
                linkParams.set(genId, forKey: "generatedId")
                let parameter: VerifyGroupLinkParameter = VerifyGroupLinkParameter(id: genId)
                verifyGroupLink(verifyGroupLinkParameter: parameter)
            }
            return true
        }
        return false
     }
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let dynamicLinks = DynamicLinks.dynamicLinks()
        let handled = dynamicLinks.handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
            // Handle the deep link here.
            // Redirect user to specific screen according to requirement.
            print("Dynamic link : \(String(describing: dynamiclink?.url))")
            if let url = dynamiclink?.url {
                let linkId = url.absoluteString.components(separatedBy: "=")[1]
                print("id: \(linkId)")
                let groupId = linkId.components(separatedBy: "&")[0]
                print("groupId:\(groupId)")
                
                let genId = url.absoluteString.components(separatedBy: "=")[2]
                print("gen id: \(genId)")
                let linkParams = UserDefaults.standard
                linkParams.set(genId, forKey: "generatedId")
                let parameter: VerifyGroupLinkParameter = VerifyGroupLinkParameter(id: genId)
                self.verifyGroupLink(verifyGroupLinkParameter: parameter)
            }
        }
        return handled
    }
    
    

    
    
    var orientationLock = UIInterfaceOrientationMask.allButUpsideDown
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        guard Auth.auth().currentUser != nil else { return .portrait }
        
        return self.orientationLock
    }
    
    
    var applicationStateString: String {
        if UIApplication.shared.applicationState == .active {
            return "active"
        } else if UIApplication.shared.applicationState == .background {
            return "background"
        }else {
            return "inactive"
        }
    }
    
    
    func registerForPushNotifications(application: UIApplication) {
        
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted)
                {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                else{
                    //Do stuff if unsuccessful...
                }
            })
        }
            
        else{ //If user is not on iOS 10 use the old methods we've been using
            let notificationSettings = UIUserNotificationSettings(
                types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
            
        }
        
    }
    
    
    //FOREGROUND NOTIFICATIONS
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        Auth.auth().canHandle(url)
//        return true
//    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Received Remote Notification")
        print("%@", userInfo)
//        managePush(userInfo: userInfo)
        
        
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        // This notification is not auth related, developer should handle it.
//        handleNotification(userInfo)
        
        let state : UIApplication.State = application.applicationState
        switch  state {
        case UIApplication.State.active:
            print("If needed notify user about the message")
            managePush(userInfo: userInfo)
            
            break
        case UIApplication.State.inactive:
            print("If app is inactive")
            managePush(userInfo: userInfo)
            break
        case UIApplication.State.background:
            print("background")
            managePush(userInfo: userInfo)
            break
        default:
            print("Default info")
            break
            
        }
    
    }
    
    func managePush(userInfo: [AnyHashable: Any]) {
        var bodyString = ""
        var title = ""
        var groupId = ""
        print("Manage Push")
        //ftindicator here
        if let aps = userInfo["notification"] as? NSDictionary{
            print("aps: \(aps)")
//            if let alert = aps["title"] as? NSDictionary{
                bodyString = aps["body"] as! String
                title = aps["title"] as! String
//            }
            
            if title.contains(":"){
                print("This was a chat message")
                
                if let groupId = userInfo["groupId"] as? String {
                    print("groupId: \(groupId)")
                    
                    UserDefaults.standard.set(1, forKey: "chatBadge")
                    
                    print("manage push method")
                    
                    SwiftEventBus.post("chats", sender: ChatEvent(groupId_: groupId))
                }
            }else if (title.contains("Revoking admin")) || (title.contains("Make approver")) || (title.contains("Making admin")) || (title.contains("Revoking approver")) || (title.localizedCaseInsensitiveContains("making admin")) || (title.localizedCaseInsensitiveContains("revoking admin")) || (title.localizedCaseInsensitiveContains("revoking approver")) || (title.localizedCaseInsensitiveContains("making approver")) {
                
                print("This is going to the role vote controller")
                if let groupMember = userInfo["groupmember"] as? String {
                    print("group body: \(groupMember)")
//                    let json = groupMember.convertToDictionary()!
//
//                    let groupInfo = try! ApiGroupId(json: json)
                    
//                    print(groupInfo)
                    
            }else if (title.contains("Vote Status")) || (title.localizedCaseInsensitiveContains("vote status")){
                
                print("Do nothing yet")

                }
            }else if (title.contains("New Contribution")) || (title.localizedCaseInsensitiveContains("new contribution")) {
                
                UserDefaults.standard.set(1, forKey: "contributionsBadge")

                print("Contribution has been made")
                
            }else if (title.contains("Remove Member")) || (title.localizedCaseInsensitiveContains("remove member")) {
                
                UserDefaults.standard.set(1, forKey: "memberBadge")

                print("member has been removed")
                
            }else if (title.contains("New Member Joined")) || (title.localizedCaseInsensitiveContains("new member joined group")) {
                
                UserDefaults.standard.set(1, forKey: "memberBadge")

                print("new member joined the group")
                
            }else if (title.contains("Campaign Info")) || (title.localizedCaseInsensitiveContains("campaign info")) {
                
                UserDefaults.standard.set(1, forKey: "campaignsBadge")

                print("campaign info")
            }
        }
        print("body string: \(bodyString)")
        print("title: \(title)")
        if let body = userInfo["group"] as? String {
            print("Group body: \(body)")
            let json = body.convertToDictionary()!
            
            let apiGroupId = try! ApiGroupId(json: json)
            
            print(apiGroupId)
            
            
            //Saving Invitations to Realtime Database
//            let user = Auth.auth().currentUser
//            let invitationsRef = Database.database().reference().child("invites")
//            let inviteProfile = invitationsRef.child("\((user?.uid)!)")
//            let groupInfo = inviteProfile.child("\(apiGroupId.groupId)")
//            
//            groupInfo.child("groupName").setValue("\(apiGroupId.groupName)")
//            groupInfo.child("groupId").setValue("\(apiGroupId.groupId)")
//            groupInfo.child("groupIconPath").setValue("\(apiGroupId.groupIconPath)")
//            groupInfo.child("description").setValue("\(apiGroupId.description)")
//            groupInfo.child("tnc").setValue("\(apiGroupId.tnc)")
//            groupInfo.child("messageBody").setValue("\(bodyString)")
//            
            
            SwiftEventBus.post("push", sender: PushEvent(message_: bodyString))
            
            
        }

        if let uuid = userInfo["uuid"] as? String {
            print("uuid body: \(uuid)")


        }
        
        var gpId = ""
        if let groupId = userInfo["groupId"] as? String {
            print("groupId: \(groupId)")
            gpId = groupId
        }
        
        var voteGpId = ""
        if let groupInfo = userInfo["groupmember"] as? NSDictionary {
            print("groupInfo: \(groupInfo)")
            if let groupArray = groupInfo["groupId"] as? NSDictionary {
              if let voteGpIdd = groupArray["groupId"] as? String {
                print("votes group id: \(voteGpId)")

                    voteGpId = voteGpIdd
                }
            }
        }
        
        //Foreground Stuff
        if let aps = userInfo["aps"] as? NSDictionary{
            print("aps: \(aps)")
                if let alert = aps["alert"] as? NSDictionary{
            bodyString = alert["body"] as! String
            title = alert["title"] as! String
            
            print("title: \(title)")
                    
                    if title.contains(":"){
                        
//                        if let groupId = userInfo["groupId"] as? String {
//                            print("groupId: \(groupId)")
                        
                        print("gpId: \(gpId)")
                        
                            UserDefaults.standard.set(1, forKey: "chatBadge")
                        
                        print("foreground stuff")
                            SwiftEventBus.post("chats", sender: ChatEvent(groupId_: gpId))
                        
                            print("This was a chat message")

//                        }
                    }else if (title.contains("New Member Joined")) || (title.localizedCaseInsensitiveContains("new member joined group")) {
                        
                        UserDefaults.standard.set(1, forKey: "memberBadge")
                        
                        print("new member joined the group")
                        
                    }else if (title.contains("New Campaign")) || (title.localizedCaseInsensitiveContains("new campaign")) {
                        
                        UserDefaults.standard.set(1, forKey: "campaignsBadge")
                        
                        if let campaign = userInfo["campaign"] as? NSDictionary {
                            print("campaign: \(campaign)")
                            if let groupIdArray = campaign["groupId"] as? NSDictionary{
                                
                                groupId = groupIdArray["groupId"] as! String
                            }
                        }
                        
                        SwiftEventBus.post("campaign", sender: CampaignEvent(groupId_: groupId))

                        print("campaign info")
                        
                    }else if (title.contains("Revoking admin")) || (title.contains("Make approver")) || (title.contains("Making admin")) || (title.contains("Revoking approver")) || (title.localizedCaseInsensitiveContains("making admin")) || (title.localizedCaseInsensitiveContains("revoking admin")) || (title.localizedCaseInsensitiveContains("revoking approver")) || (title.localizedCaseInsensitiveContains("making approver")) || (title.localizedCaseInsensitiveContains("vote status")){
                        
                        
                        if let vote = userInfo["groupmember"] as? NSDictionary {
                            print("vote: \(vote)")
                            if let groupIdArray = vote["groupId"] as? NSDictionary{
                                
                                groupId = groupIdArray["groupId"] as! String
                            }
                        }
                        print("group ids \(gpId), \(voteGpId)")
                        SwiftEventBus.post("votes", sender: VoteEvent(groupId_: gpId))
                        
                    }else if (title.contains("Member Invite")) {
                        
                        SwiftEventBus.post("push", sender: PushEvent(message_: bodyString))
                    }
            }
        }
        
        
        }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.unknown)
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        UserDefaults.standard.set(token, forKey: "token")
        print("Device Token:", token)
    }
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
        
        let api_token = UserDefaults.standard.string(forKey: "idToken")
        
        getToken()
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
            
            print("\(NetworkManager().getErrorMessage(response: result))")

        }
    }
    
    func deleteDevice(deleteDeviceParameter: DeleteDeviceParameter) {
        AuthNetworkManager.deleteDevice(parameter: deleteDeviceParameter) { (result) in
            print("result: \(result)")
            
            let memberId = Auth.auth().currentUser?.uid
            
            let idToken = UserDefaults.standard.string(forKey: "idToken")
            
            let parameter: CreateDeviceParameter = CreateDeviceParameter(memberId: memberId!, regToken: idToken!)
            self.createDevice(createDeviceParameter: parameter)
        }
    }
    
    
    //VERIFY GROUP LINK
     func verifyGroupLink(verifyGroupLinkParameter: VerifyGroupLinkParameter) {
         AuthNetworkManager.verifyGroupLink(parameter: verifyGroupLinkParameter) { (result) in
             self.parseVerifyGroupLinkResponse(result: result)
         }
     }
     
     private func parseVerifyGroupLinkResponse(result: DataResponse<VerifyGroupLinkResponse, AFError>){
         switch result.result {
         case .success(let response):
             print(response)
                
                if UserDefaults.standard.bool(forKey: "authenticated"){
                    if response.responseCode == "100" {
                        SwiftEventBus.post("grouplink", sender: GroupLinkEvent(cashoutPolicy_: 0.0, groupDescription_: "", groupId_: "", groupName_: "", tnc_: "", groupIconPath_:  "", generatedId_: "", responseMessage_: response.responseMessage!, responseCode_: response.responseCode!))
                    }else {
                        print("run this")
                        SwiftEventBus.post("grouplink", sender: GroupLinkEvent(cashoutPolicy_: (response.data?.cashoutPolicy)!, groupDescription_: (response.data?.groupDescription)!, groupId_: (response.data?.groupId)!, groupName_: (response.data?.groupName)!, tnc_: (response.data?.tnc)!, groupIconPath_: (response.data?.groupIconPath ?? ""), generatedId_: "", responseMessage_: response.responseMessage!, responseCode_: response.responseCode!))
                    
                    print("info: \(((response.data?.cashoutPolicy)!, groupDescription_: (response.data?.groupDescription)!, groupId_: (response.data?.groupId)!, groupName_: (response.data?.groupName)!, tnc_: (response.data?.tnc)!)))")
                    }
                }
             break
         case .failure( _):
             if result.response?.statusCode == 400 {
//                 sessionTimeout()
//                show time out
             } else if result.response?.statusCode == 500  {
                //show network error
                print("you are not logged in")
                UserDefaults.standard.set(true, forKey: "grouplinkexists")
            }
         }
     }
    
    
    func getToken() {
        Messaging.messaging().token { (token, error) in
            if(error != nil){
                print("Instance ID Error: \(error.debugDescription)")
            }else{
                self.setToken(token: token!)
                
            }
        }
    }
    
    func setToken(token: String){

        UserDefaults.standard.set(token, forKey: "idToken")
    }
    



    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Token: \(fcmToken)")
        
        self.setToken(token: fcmToken!)
    }
    
    
//    func connectToFcm() {
//        Messaging.messaging().connect { (error) in
//            if error != nil {
//                print("Unable to connect with FCM. \(String(describing: error))")
//            } else {
//                print("Connected to FCM.")
//            }
//        }
//    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //AppEventsLogger.activate(application)
//        connectToFcm()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    // iOS10+, called when presenting notification in foreground

    
    // iOS10+, called when received response (default open, dismiss or custom action) for a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("[UserNotificationCenter] applicationState: \(applicationStateString) didReceiveResponse: \(userInfo)")
        //TODO: Handle background notification
        
        managePush(userInfo: userInfo)
        
        completionHandler()
    }
}


extension AppDelegate {
    
    // iOS9, called when presenting notification in foreground
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("[RemoteNotification] didReceiveRemoteNotification for iOS9: \(userInfo)")
        if UIApplication.shared.applicationState == .active {
            //TODO: Handle foreground notification
            managePush(userInfo: userInfo)
            
        } else {
            //TODO: Handle background notification
            managePush(userInfo: userInfo)

        }
    }
    
    
    func authenticationCheck() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            if UserDefaults.standard.bool(forKey: "touchID"){
                let vc: LoginTouchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "touch") as! LoginTouchVC
                self.window?.rootViewController = vc
                print("touchID")
            }else if UserDefaults.standard.bool(forKey: "regular") {
                //old user with no touch or face id
                let vc: LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "in") as! LoginVC
                self.window?.rootViewController = vc
                print("login1")
            }else {
                //first time login or log out
                let vcc: ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "walkthrough") as! ViewController
                self.window?.rootViewController = vcc
            }
        } else {
            // no biometry
            if UserDefaults.standard.bool(forKey: "regular"){
            let vc: LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "in") as! LoginVC
                self.window?.rootViewController = vc
            }else {
                //First time user or logged out.
            let vcc: ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "walkthrough") as! ViewController
            self.window?.rootViewController = vcc
            print("login2")
            }
            
        }
    }
    

    
}
