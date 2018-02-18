

import UIKit

class ReceivedNotificationsViewController: UITableViewController {
    
    var allNotifications: AllNotifications!
    
    //MARK: Actions
    @IBAction func addNewNotification(_ sender: UIButton) {
        
        let newNotification = allNotifications.createNotification()
        if let index = allNotifications.recvNotifications.index(of: newNotification) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        if isEditing {
            sender.setTitle("Edit", for: .normal)
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", for: .normal)
            setEditing(true, animated: true)
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
    
    //MARK: tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allNotifications.recvNotifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let item = allNotifications.recvNotifications[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.message
        
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
        
        //tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 65
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
}
