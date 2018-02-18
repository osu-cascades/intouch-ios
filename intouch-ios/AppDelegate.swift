//
//  AppDelegate.swift
//  intouch-ios

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let allNotifications = AllNotifications()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerForRemoteNotification()
        
        let navController = window!.rootViewController as! UINavigationController
        let receivedNotificationsViewController = navController.topViewController as! ReceivedNotificationsViewController
        receivedNotificationsViewController.allNotifications = allNotifications
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let success = allNotifications.saveChanges()
        if (success) {
            print("Saved all notifications")
        } else {
            print("Error saving notifications")
        }
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
//        print(token)
//
//        print(deviceToken.description)
//        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
//        print(uuid)
//        }
//        UserDefaults.standard.setValue(token, forKey: "ApplicationIdentifier")
//        UserDefaults.standard.synchronize()
//    }

}

