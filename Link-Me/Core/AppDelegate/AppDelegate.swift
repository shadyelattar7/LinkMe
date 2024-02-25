//
//  AppDelegate.swift
//  Link-Me
//
//  Created by Al-attar on 10/05/2023.
//

import UIKit
import IQKeyboardManagerSwift
import MOLH
import PusherSwift
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MOLHResetable{
    
    // var  coordinator: AppCoordinator!
    var  window: UIWindow?
    var pusherManager = PusherManager.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //        coordinator = AppCoordinator(window: window!)
        //        coordinator.start()
        
        LocalizationManager.shared.delegate = self
        LocalizationManager.shared.setAppInnitLangauge()
        
        MOLH.shared.activate(true)
        setupIQKeyboardManager()
        
        print("Token 🔒: \(UDHelper.token)")
        
        // Configure Pusher using the shared instance
        //        pusherManager.configurePusher()
        
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
      let notifaction = UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            // Handle user's response
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        return true
    }
    
    private func setupIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarConfiguration.placeholderConfiguration.showPlaceholder = false
        
    }
    
    func reset() {
        //        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        //        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        appDelegate.window?.rootViewController = redViewController
        let rootViewController: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        let stry = UIStoryboard(name: "Main", bundle: nil)
        rootViewController.rootViewController = stry.instantiateViewController(withIdentifier: "SplashVC")
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        pusherManager.disconnect()
    }
    
    // print Pusher debug messages
    func debugLog(message: String) {
        print(message)
    }
}


extension AppDelegate: LocalizationDelegate{
    func resetApp() {
        guard let window = window else {return}
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
        vc.window = window
        window.rootViewController = vc
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval  = 0.3
        UIView.transition(with: window, duration: duration,options: options, animations: nil)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Handle incoming notifications when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("userInfo: \(userInfo)")
        if let type = userInfo[AnyHashable("type")] as? String {
            print("Notification Type: \(type)")
        }
        completionHandler([.banner, .sound, .badge])
    }
    
    // Handle tapped notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        if let type = response.notification.request.content.userInfo[AnyHashable("type")] as? String {
//            print("Notification Type: \(type)")
//
//            // Customize actions based on the notification type
//            let acceptAction = UNNotificationAction(
//                identifier: "ACCEPT_ACTION",
//                title: "Accept",
//                options: [.foreground]
//            )
//
//            let rejectAction = UNNotificationAction(
//                identifier: "REJECT_ACTION",
//                title: "Reject",
//                options: [.destructive]
//            )
//
//            let categoryIdentifier: String
//            var actions: [UNNotificationAction]
//
//            if type == "request" {
//                // Display both accept and reject buttons for the "request" type
//                categoryIdentifier = "REQUEST_CATEGORY"
//                actions = [acceptAction, rejectAction]
//            } else {
//                // For other types, you can customize accordingly
//                categoryIdentifier = "DEFAULT_CATEGORY"
//                actions = []
//            }
//
//            let category = UNNotificationCategory(
//                identifier: "REQUEST_CATEGORY",
//                actions: actions,
//                intentIdentifiers: [],
//                options: []
//            )
//
//            UNUserNotificationCenter.current().setNotificationCategories([category])
//        }
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // You can send this token to your server to send push notifications
        print("FCM Token: \(fcmToken ?? "") 📳🔒")
        UDHelper.fcmToken = fcmToken ?? ""
    }
}
