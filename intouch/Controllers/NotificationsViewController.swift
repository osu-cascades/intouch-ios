

import UIKit
import PushNotifications

class NotificationsViewController: UITableViewController {
    
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
    func addNewNotification(title: String, from: String, message: String, datetime: String, fromUsername: String, groupRecipients: [String]) {
        let newNotification = allNotifications.createNotification(title: title, from: from, message: message, datetime: datetime, fromUsername: fromUsername, groupRecipients: groupRecipients)
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
    
    @objc func recievedNewNotification(){
        tableView.reloadData()
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.recievedNewNotification), name: NSNotification.Name("reloadTable"), object: nil)
        
        let username: String = Settings.getUsername()
        let password: String? = Settings.getPassword()
        try? self.pushNotifications.subscribe(interest: "\(username)")
        print(self.allNotifications.recvNotifications);
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = insets
        tableView.rowHeight = 65
        
        #if DEBUG
        let getGroupUrl = "https://abilitree-intouch-staging.herokuapp.com/get_groups"
        #endif
        
        #if RELEASE
        let getGroupUrl = "https://abilitree-intouch.herokuapp.com/get_groups"
        #endif
        
        let postString = "username=\(username)&password=\(password!)"
        var request = URLRequest(url: URL(string: getGroupUrl)!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data)
                let groups = json as! [String]
                let createTab = self.tabBarController?.viewControllers?[1] as! createNotificationVC
                createTab.groups = groups
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        
        task.resume()
        
        populateEventList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    func populateEventList() {
        #if DEBUG
        let eventUrlStr = "https://abilitree-intouch-staging.herokuapp.com/get_events"
        #endif
        
        #if RELEASE
        let eventUrlStr = "https://abilitree-intouch.herokuapp.com/get_events"
        #endif
        let username: String = Settings.getUsername()
        let password: String? = Settings.getPassword()
        let postString = "username=\(username)&password=\(password!)"
        var request = URLRequest(url: URL(string: eventUrlStr)!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        var eventList:[String:Event] = [:]
        let calendarTab = self.tabBarController?.viewControllers?[2] as! CalendarVC
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: data)
                
                let response = json as! [String: Any]
                let events = response["events"] as! [Dictionary<String, AnyObject>]
                print(data)
                let eventDateFormatter = DateFormatter()
                eventDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                eventDateFormatter.timeZone = TimeZone.current
                let dateFormatterKey = DateFormatter()
                dateFormatterKey.dateFormat = "dd-MMM-yyyy"
                let calendar = Calendar.current
                
                for event in events{
                    print(event)
                    let time = event["time"] as? String ?? ""
                    let title = event["title"] as? String ?? ""
                    let description = event["description"] as? String ?? ""
                    let place = event["place"] as? String ?? ""
                    let notes = event["notes"] as? String ?? ""
                    let groupParticipants = event["group_participants"] as? String ?? ""
                    let hostedBy = event["hosted_by"] as? String ?? ""
                    let color = event["color"] as? String ?? ""
                    
                    eventDateFormatter.locale = Locale.current
                    if let date =  eventDateFormatter.date(from: time){
                        let components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute], from: date)
                        print(components.hour)
                        
                        eventList[dateFormatterKey.string(from: date)] =
                            Event(title: title ?? "", description: description ?? "", time: "\(components.hour!):\(components.minute!)", place: place ??  "", notes: notes ?? "", groupParticipants: [groupParticipants ?? ""], hostedBy: hostedBy ?? "", color: color ?? "")
                    }
                }
                calendarTab.eventList = eventList
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            
        }
        task.resume()
    }
    

}
