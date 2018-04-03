//
//  AppDelegate.swift
//  intouch-ios

import UIKit
import PushNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let allNotifications = AllNotifications()
    let pushNotifications = PushNotifications.shared
    let INSTANCE_ID: String = "9313976c-3ca4-4a1c-9538-1627280923f4"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.pushNotifications.start(instanceId: INSTANCE_ID)
        self.pushNotifications.registerForRemoteNotifications()
        
        let controllerId: String
        let loggedinStatus: String? = UserDefaults.standard.string(forKey: "LOGGED_IN")
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if loggedinStatus == "true" {
            controllerId = "TabBar"
            let initViewController: UITabBarController = storyboard.instantiateViewController(withIdentifier: controllerId) as! UITabBarController
            self.window?.rootViewController = initViewController
            print(initViewController)
            
            let viewControllers: [UIViewController]?
            viewControllers = initViewController.viewControllers
            let recvVC: ReceivedNotificationsViewController = (viewControllers![0] as! UINavigationController).viewControllers[0] as! ReceivedNotificationsViewController
            print(recvVC)
            
            recvVC.allNotifications = allNotifications
        } else {
            controllerId = "Login"
            let initViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: controllerId) as UIViewController
            self.window?.rootViewController = initViewController
        }
        
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            print("launched with notification")
            let aps = notification["aps"] as! [String: AnyObject]
            // alert must have title and body as keys
            let alert = aps["alert"] as! [String: AnyObject]
            let body = alert["body"] as! String
            let title = alert["title"] as! String
            let from = alert["from"] as! String
            let datetime = alert["datetime"] as! String
            allNotifications.createNotification(title: title, from: from, message: body, datetime: datetime)
        }
        
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
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }

        let token = tokenParts.joined()
        print("Device Token: \(token)")
        self.pushNotifications.registerDeviceToken(deviceToken) {
            try? self.pushNotifications.subscribe(interest: "abilitree_dev")
        }
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let aps = userInfo["aps"] as! [String: AnyObject]
        let alert = aps["alert"] as! [String: AnyObject]
        // must have title and body as keys in alert
        let body = alert["body"] as! String
        let title = alert["title"] as! String
        let from = alert["from"] as! String
        let datetime = alert["datetime"] as! String
        
        let tabBarController = window!.rootViewController as! UITabBarController

        if tabBarController.selectedIndex == 0 {
            let receivedNotificationsViewController = (tabBarController.viewControllers![0] as! UINavigationController).viewControllers[0] as! ReceivedNotificationsViewController
        receivedNotificationsViewController.allNotifications = allNotifications
        receivedNotificationsViewController.addNewNotification(title: title, from: from, message: body, datetime: datetime)
        } else {
            allNotifications.createNotification(title: title, from: from, message: body, datetime: datetime)
            
        }
        
    }

}

