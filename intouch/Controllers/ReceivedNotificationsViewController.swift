

import UIKit
import PushNotifications

class ReceivedNotificationsViewController: UITableViewController {
    
    var allNotifications: AllNotifications!
    var pushNotifications = PushNotifications.shared
    
    //MARK: actions
    @IBAction func logout(_ sender: Any) {
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to log off?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.logout()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.view.tintColor = UIColor(red: 157/255, green: 200/255, blue: 49/255, alpha: 1)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: Custom
    func addNewNotification(title: String, from: String, message: String, datetime: String) {
        let newNotification = allNotifications.createNotification(title: title, from: from, message: message, datetime: datetime)
        if newNotification != nil {
            if let index = allNotifications.recvNotifications.index(of: newNotification!) {
                let indexPath = IndexPath(row: index, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func logout() {
        let channel: String = Settings.getUsername()
        try? pushNotifications.unsubscribe(interest:"\(channel)")
        Settings.clearUsernamePasswordUserType()
        
        let controllerId = "Login"
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController: LoginVC = storyboard.instantiateViewController(withIdentifier: controllerId) as! LoginVC
        loginViewController.allNotifications = allNotifications
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showNotification"?:
            if let row = tableView.indexPathForSelectedRow?.row {
                let notification = allNotifications.recvNotifications[row]
                let singleRecvNotificationVC = segue.destination as! SingleRecvNotificationVC
                singleRecvNotificationVC.notification = notification
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    //MARK: outlets
    @IBOutlet weak var logoutBrBtn: UIBarButtonItem!
    
    //MARK: tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let notifications = allNotifications?.recvNotifications {
            return notifications.count
        } else {
            return 0
        }

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        let notification = allNotifications.recvNotifications[indexPath.row]
        
        cell.titleLabel.text = notification.title
        cell.fromLabel.text = notification.from
        cell.dateLabel.text = notification.datetime
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let notification = allNotifications.recvNotifications[indexPath.row]
            let title = "Delete \(notification.title)?"
            let message = "Are you sure you want to delete this notification?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
                (action) -> Void in
                self.allNotifications.removeNotification(notification)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
            present(ac, animated: true, completion: nil)
            
        }
    }
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let username: String = Settings.getUsername()
        try? self.pushNotifications.subscribe(interest: "\(username)")
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = insets
        tableView.rowHeight = 65
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.leftBarButtonItem = editButtonItem
    }
    

}
