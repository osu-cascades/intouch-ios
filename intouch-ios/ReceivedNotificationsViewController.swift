

import UIKit

class ReceivedNotificationsViewController: UITableViewController {
    
    var allNotifications: AllNotifications!
    
    //MARK: Actions
    @IBAction func toggleEditMode(_ sender: UIButton) {
        
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
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
        
    }
    
}
