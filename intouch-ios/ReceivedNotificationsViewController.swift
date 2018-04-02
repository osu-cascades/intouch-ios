

import UIKit

class ReceivedNotificationsViewController: UITableViewController {
    
    var allNotifications: AllNotifications!
    
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
        
            return allNotifications.recvNotifications.count

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
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
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
