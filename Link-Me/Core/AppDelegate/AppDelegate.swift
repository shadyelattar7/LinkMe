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
    
    // var coordinator: AppCoordinator!
    var window: UIWindow?
    var pusherManager = PusherManager.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //  coordinator = AppCoordinator(window: window!)
        
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
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
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
        
        var shouldShowNotification = true
        
        // Access the "aps" dictionary, which contains the custom fields
        if let aps = userInfo["aps"] as? [String: Any],
           let typeString = aps["type"] as? String {
            
            if typeString == "request" {
                shouldShowNotification = false
                
                // Extract the sender_id and chat_id from the "aps" dictionary
                if let senderID = aps["sender_id"] as? Int,
                   let chatID = aps["chat_id"] as? Int {
                    presentFriendRequestViewController(userID: senderID, chatID: chatID)
                }
            } else if typeString == "friend_request" || typeString == "chat_accepted" {
                shouldShowNotification = false
                
                if let chatID = aps["chat_id"] as? Int {
                    if let _ = ActiveViewControllerManager.shared.currentViewController as? ChatViewController {
                        NotificationCenter.default.post(name: .didReceiveFriendRequest, object: nil, userInfo: userInfo)
                    } else {
                        presentRequestChatViewController(chatID: String(chatID))
                    }
                }
            }
        }
        
        if shouldShowNotification {
            completionHandler([.banner, .sound, .badge])
        } else {
            completionHandler([])
        }
    }

    
    
    // Handle tapped notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("userInfo: \(userInfo)")

        // Access the "aps" dictionary, which contains the custom fields
        if let aps = userInfo["aps"] as? [String: Any],
           let typeString = aps["type"] as? String, typeString == "request" {
            
            // Extract the sender_id and chat_id from the "aps" dictionary
            if let senderIDString = aps["sender_id"] as? String,
               let chatIDString = aps["chat_id"] as? String,
               let chatID = Int(chatIDString) {
                let userID = Int(senderIDString) ?? 0
                presentFriendRequestViewController(userID: userID, chatID: chatID)
            }
        }
        
        completionHandler()
    }

    
    func presentFriendRequestViewController(userID: Int, chatID: Int) {
        DispatchQueue.main.async {
            if let topController = UIApplication.shared.keyWindow?.rootViewController {
                let friendRequestVC = NewLinkCardViewController(
                    viewModel: NewLinkCardViewModel(
                        userID: userID,
                        chatID: chatID
                    ),
                    coordinator: AppCoordinator()
                )
                topController.present(friendRequestVC, animated: true, completion: nil)
            }
        }
    }
    
    func presentRequestChatViewController(chatID: String) {
        DispatchQueue.main.async {
            if let topController = UIApplication.shared.keyWindow?.rootViewController {
                let friendRequestVC = RequestChatViewController(
                    viewModel: RequestChatViewModel(
                        chatID: chatID
                    ),
                    coordinator: AppCoordinator()
                )
                topController.present(friendRequestVC, animated: true, completion: nil)
            }
        }
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // You can send this token to your server to send push notifications
        print("FCM Token: \(fcmToken ?? "") 📳🔒")
        UDHelper.fcmToken = fcmToken ?? ""
    }
}
