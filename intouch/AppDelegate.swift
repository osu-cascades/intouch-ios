//
//  AppDelegate.swift
//  intouch

import UIKit
//import PushNotifications
import PusherSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let allNotifications = AllNotifications()
    var pushNotifications: Pusher! = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
#if DEBUG
        print("intouch-dev: debug")
#endif
        
#if RELEASE
        print("intouch: release")
#endif
        
        let options = PusherClientOptions(
            host: .cluster("us2")
        )
        self.pushNotifications = Pusher(
            key: "9d82b24b0c3b8eaf2b9f",
            options: options
        )
        self.pushNotifications.connect()
      
        
        let loggedinStatus: String? = UserDefaults.standard.string(forKey: "LOGGED_IN")
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        // get instance of allNotifications and assign it to the
        // NotificationsViewController allNotifications
        // member variable
        let tabBarControllerId: String = "TabBar"
        let tabBarController: UITabBarController = storyboard.instantiateViewController(withIdentifier: tabBarControllerId) as! UITabBarController
        let viewControllers: [UIViewController]?
        viewControllers = tabBarController.viewControllers
        let recvVC: NotificationsViewController = (viewControllers![0] as! UINavigationController).viewControllers[0] as! NotificationsViewController
        recvVC.allNotifications = allNotifications
        
        
        if loggedinStatus == "true" {
            self.window?.rootViewController = tabBarController
        } else {
            let controllerId: String = "Login"
            let loginViewController: LoginVC = storyboard.instantiateViewController(withIdentifier: controllerId) as! LoginVC
            loginViewController.allNotifications = allNotifications
            loginViewController.pushNotifications = pushNotifications
            print(loginViewController.allNotifications)
            self.window?.rootViewController = loginViewController
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
#if RELEASE
        let tabBarController = window!.rootViewController as! UITabBarController

        if tabBarController.selectedIndex == 0 {
            let notificationsViewController = (tabBarController.viewControllers![0] as! UINavigationController).viewControllers[0] as! NotificationsViewController
        notificationsViewController.allNotifications = allNotifications
        notificationsViewController.addNewNotification(title: title, from: from, message: body, datetime: datetime)
        } else {
            allNotifications.createNotification(title: title, from: from, message: body, datetime: datetime)
        }
#endif
        
#if DEBUG
        allNotifications.createNotification(title: title, from: from, message: body, datetime: datetime)
#endif
    }
}

