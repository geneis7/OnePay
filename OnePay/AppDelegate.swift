//
//  AppDelegate.swift
//  BonoCard
//
//  Created by 유하늘 on 2017. 12. 6..
//  Copyright © 2017년 유하늘. All rights reserved.
//
import UIKit
import UserNotifications
import Firebase
import Alamofire
import SwiftyJSON
import FirebaseMessaging


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    let ud = UserDefaults.standard
    var colourView = UIImageView(image: UIImage(named: ""))
    
    

    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        ud.set("", forKey: "notiCheck")
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // [END register_for_notifications]
        
        // 상단 스테이터스 바 색상 변경
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
////            statusBar.backgroundColor = UIColor.init(hexString: "#332003FF")
//            statusBar.backgroundColor = UIColor.newColor_Gray
//        }

        
        // 앱 런치화면 딜레이 시간 설정
        Thread.sleep(forTimeInterval: 0.5)
        
        // 앱 상태 스타일 설정
//        UIApplication.shared.statusBarStyle = .lightContent
//        UIApplication.shared.statusBarStyle = .lightContent
        // window를 만들어준다.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let tutorialStoryboard = UIStoryboard(name: "Main", bundle: nil)

        // 뷰 컨트롤러 인스턴스
        let viewController = tutorialStoryboard.instantiateViewController(withIdentifier: "FirstNaviStoryID")
//        let viewController = tutorialStoryboard.instantiateViewController(withIdentifier: "SmartConStoryID")
        
        // 윈도우의 루트 뷰 컨트롤러 설정
        self.window?.rootViewController = viewController
        // 화면에 보여준다.
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //        #if DEBUG
        //            InstanceID.instanceID().setAPNSToken(deviceToken, type: .sandbox)
        //        #else
        //            InstanceID.instanceID().setAPNSToken(deviceToken, type: .prod)
        //        #endif
        Messaging.messaging().apnsToken = deviceToken
        print("APNs token retrieved: \(deviceToken)")
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            Data_MemberInfo.shared.fcm_key = refreshedToken
        }
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
    
    // 백그라운드 -> 앱
    func applicationWillEnterForeground(_ application: UIApplication) {
        if let viewWithTag = colourView.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
    }
    
    // 앱 -> 백그라운드
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        window?.addSubview(colourView)
        window?.bringSubviewToFront(colourView)
        colourView.tag = 100
        colourView.backgroundColor = UIColor.newColor_Cranberry
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.colourView.alpha = 1
        })
    }

    // 홈 버튼 더블 클릭
    func applicationWillResignActive(_ application: UIApplication) {

        window?.addSubview(colourView)
        window?.bringSubviewToFront(colourView)
        colourView.backgroundColor = UIColor.newColor_Cranberry
        colourView.tag = 100
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.colourView.alpha = 1
        })
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        window?.addSubview(colourView)
        window?.bringSubviewToFront(colourView)
        colourView.tag = 100
        colourView.backgroundColor = UIColor.newColor_Cranberry
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.colourView.alpha = 1
        })
        if let viewWithTag = colourView.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
    }
    
    
}

// [START ios_10_message_handling]ㅇ
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // 포어그라운드 알림 설정
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        let content = notification.request.content
        // Process notification content
        print("\(content.userInfo)")
        
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .sound]) // Display notification as
        //        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        Data_Default.shared.new_FcmToken = fcmToken
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}
