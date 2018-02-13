
import UIKit
import PusherSwift
import UserNotifications

class ViewController: UIViewController, PusherDelegate {
    
    var pusher: Pusher! = nil
    
    var APP_ID: String! = "436697"
    var KEY: String! = "6fd53017f3f4e0fb720f"
    var SECRET: String! = "8f3ecbd48c9f279257f6"
    var CLUSTER: String! = "us2"

    
    @IBOutlet var notification: UITextView!
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // all the Pusher setup
        let options = PusherClientOptions(host: .cluster(CLUSTER))
        //print("options set")
        pusher = Pusher(key: KEY, options: options)
        //print("pusher set, connecting...")
        pusher.delegate = self
        pusher.connect()
        
        let channel = pusher.subscribe("my-channel")
        //print("channel subscribed")
        
        let _ = channel.bind(eventName: "my-event", callback: { (data: Any?) -> Void in
            if let data = data as? [String : AnyObject] {
                if let message = data["message"] as? String {
                    self.setTextView(message)
                    print(message)
                    // shared UNUserNotificationCenter object
                    let center = UNUserNotificationCenter.current()
                    
                    // error handle
                    center.getNotificationSettings { (settings) in
                        if settings.authorizationStatus != .authorized {
                            // Notifications not allowed
                        }
                    }
                    
                    // notification
                    let content = UNMutableNotificationContent()
                    content.title = "Abilitree"
                    content.body = message
                    
                    // trigger
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                                    repeats: false)
                    
                    // add to notification center - scheduling
                    let identifier = "Notification"
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    center.add(request, withCompletionHandler: { (error) in
                        if let error = error {
                            print(error)
                        }
                    })
                    
                    // Custom actions
                    let dismissAction = UNNotificationAction(identifier: "Dimiss",
                                                             title: "Dismiss", options: [.destructive])
                    let viewAction = UNNotificationAction(identifier: "ViewAction",
                                                          title: "View", options: [])
                    // create category with actions
                    let category = UNNotificationCategory(identifier: "NotificationCategory",
                                                          actions: [dismissAction,viewAction],
                                                          intentIdentifiers: [], options: [])
                    //register category with notification center
                    center.setNotificationCategories([category])
                    
                    // set category in notification center
                    content.categoryIdentifier = "NotificationCategory"
                    
                    
                    
                }
            }
        })
        //print("bound channel")
        
        
    }
    
    
    func setTextView(_ message: String) {
        notification.text = message
    }
    
}
