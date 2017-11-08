//
//  AppDelegate.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 2. 27..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit
import UserNotifications

import SnapKit
import Alamofire
import Firebase
import FirebaseMessaging
import SwiftyJSON
import Kingfisher
import ManualLayout
import SwiftyImage
import Fabric
import Crashlytics
import SwiftyBeaver
import FBSDKCoreKit
import URLNavigator
import RxSwift
import RxCocoa


let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  /// `AppDelegate`의 인스턴스를 반환합니다.
  static var instance: AppDelegate? {
    return UIApplication.shared.delegate as? AppDelegate
  }
  
  var urlCheeseData: CheeseResultByDate.Data?
  
  var paymentViewController: PaymentViewController?
  let gcmMessageIDKey = "gcm.message_id"
  var window: UIWindow?
  let parameter: [String:String] = [:]
  let customURLScheme = "cheesecounter"

  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
    
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    
    Fabric.with([Crashlytics.self])
    Crashlytics.sharedInstance().debugMode = false
    
    HTTPCookieStorage.shared.cookieAcceptPolicy = .always
    
    FirebaseApp.configure()
    FirebaseOptions.defaultOptions()?.deepLinkURLScheme = self.customURLScheme
    
    Messaging.messaging().delegate = self
    
    URLNavigationMap.initialize()
    
    if #available(iOS 10.0, *)
    {
      // For iOS 10 display notification (sent via APNS)
      UNUserNotificationCenter.current().delegate = self
      
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { (granted, error) in
          if granted == true {
            log.info("allow")
            DispatchQueue.main.async {
              UIApplication.shared.registerForRemoteNotifications()
            }
          }else {
            log.info("Don't Allow")
          }
      })
      
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
    
    NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.kakaoSessionDidChangeWithNotification),
                                           name: NSNotification.Name.KOSessionDidChange,
                                           object: nil)
    
    application.registerForRemoteNotifications()
    
    loggingSetting()
    configureAppearance()
    reloadRootViewController()
    
    if let dictionary = launchOptions?[UIApplicationLaunchOptionsKey.userActivityDictionary] as? NSDictionary{
      log.info(dictionary["UIApplicationLaunchOptionsUserActivityTypeKey"] is String)
    }
    
    return true
  }
  
  func logUser(email:String,userIdentifier:String,name:String) {
    // TODO: Use the current user's information
    // You can call any combination of these three methods
    Crashlytics.sharedInstance().setUserEmail(email)
    Crashlytics.sharedInstance().setUserIdentifier(userIdentifier)
    Crashlytics.sharedInstance().setUserName(name)
  }
  
  func loggingSetting(){
    
    let console = ConsoleDestination()  // log to Xcode Console
    let cloud = SBPlatformDestination(appID: "VQnakm", appSecret: "ijpnVkji0funquPkTahs2efbst7gYihY", encryptionKey: "thylVjoZtl71krs32ogtM8ainhtgXzow") // to cloud
    
    
    console.format = "$DHH:mm:ss$d $C$L$c $N.$F:$l - $M"
    
    log.addDestination(console)
    log.addDestination(cloud)
  }
  
  func reloadRootViewController() {
    
    let isOpened = KOSession.shared().isOpen()
    
    if isOpened{
      KOSessionTask.meTask(completionHandler: {[weak self] (result, error) in
        if (result != nil){
          if let user = result as? KOUser{
            let email = user.email ?? ""
            let userId = "\(user.id)"
            let nickname = user.property(forKey: KOUserNicknamePropertyKey) as? String
            self?.logUser(email: email, userIdentifier: userId, name: nickname ?? "")
          }
        }
      })
    }
    self.window?.rootViewController = isOpened ? SplashViewController() : KakaoLoginController()
//    self.window?.rootViewController = CycleViewController()
  }
  
  func configureAppearance() {
    
    let navigationBarBackGroundImage =  UIImage.resizable().color(.white).image
    UINavigationBar.appearance().setBackgroundImage(navigationBarBackGroundImage, for: .default)
    UIBarButtonItem.appearance().tintColor = .black
    UINavigationBar.appearance().tintColor = .black
    UINavigationBar.appearance().backgroundColor = UIColor.cheeseColor()
    UITabBar.appearance().tintColor = .white
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    
    if let messageID = userInfo[gcmMessageIDKey] {
      log.verbose(messageID)
    }
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    if let messageID = userInfo[gcmMessageIDKey] {
      log.info("메시지 아이디 \(messageID)")
    }
    
    // Print full message.
    log.info("userInfo:\(userInfo)")
    
    completionHandler(UIBackgroundFetchResult.newData)
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    var token = ""
    for i in 0..<deviceToken.count {
      token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
    }
    
    #if DEBUG
      Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
      log.debug("DEBUG")
    #else
      Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
      log.debug("PRODUCTION")
    #endif
    log.debug("디바이스토큰:\(token)")
  }
  
  func kakaoSessionDidChangeWithNotification() {
    reloadRootViewController()
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    FBSDKAppEvents.activateApp()
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    KOSession.handleDidEnterBackground()
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    KOSession.handleDidBecomeActive()
  }
  
  func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
    if KOSession.isKakaoAccountLoginCallback(url) {
      return KOSession.handleOpen(url)
    }
    return false
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    log.error("didFailToRegisterForRemoteNotificationsWithError=\(error.localizedDescription)")
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
    return application(app, open: url, sourceApplication: nil, annotation: [:])
  }
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    
    let dynamicLink = DynamicLinks.dynamicLinks()?.dynamicLink(fromCustomSchemeURL: url)
    if let dynamicLink = dynamicLink {
      
      let message = generateDynamicLinkMessage(dynamicLink)
      log.info(message)
      
      if Navigator.open(url) {
        return true
      }
      
      if Navigator.present(url, wrap: true) != nil {
        return true
      }
      return true
    }
    
    if Navigator.open(url) {
      return true
    }
    
    if KOSession.isKakaoAccountLoginCallback(url) {
      return KOSession.handleOpen(url)
    }
    
    return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
  }
  
  func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
    guard let dynamicLinks = DynamicLinks.dynamicLinks() else {
      return false
    }
    let handled = dynamicLinks.handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
      let message = self.generateDynamicLinkMessage(dynamiclink!)
      self.showDeepLink(of: message)
    }
  
    if !handled {
      let message = userActivity.webpageURL?.query?.components(separatedBy: "=")[1] ?? ""
      showDeepLink(of: message)
    }
    return handled
  }
  
  func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
    completionHandler(true)
  }
  
  func generateDynamicLinkMessage(_ dynamicLink: DynamicLink) -> String {
    if dynamicLink.matchConfidence == .weak {
    } else {
    }
    return (dynamicLink.url?.query?.components(separatedBy: "=")[1]) ?? "0"
  }
  
  @available(iOS 8.0, *)
  func showDeepLink(of surveyId: String) {
//    guard surveyId != "0" else {return}
//    loginConfirm = LoginConfirmController(surveyId: surveyId)
//    loginConfirm.openViewFromUrl()
  }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
  
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      log.debug("메시지 ID: \(messageID)")
    }
    
    // Print full message.
    log.debug(userInfo)
    
    // Change this to your preferred presentation option
    completionHandler([.alert,.badge,.sound])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      log.debug("메시지 ID: \(messageID)")
    }
    
    // Print full message.
    log.debug(userInfo)
    
    completionHandler()
  }
}

extension AppDelegate : MessagingDelegate {
  // [START refresh_token]
  func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
    UserService.sendFcmToken()
    log.info("Firebase registration token: \(fcmToken)")
  }

  func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    log.info("Received data message: \(remoteMessage.appData)")
  }
  // [END ios_10_data_message]
}

