
import UIKit

class SingleRecvNotificationVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var titleField: UITextField!
    @IBOutlet var dateField: UITextField!
    @IBOutlet var fromField: UITextField!
    @IBOutlet var messageView: UITextView!

    var notification: Notification!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleField.text = notification.title
        dateField.text = "\(notification.dateCreated)"
        fromField.text = notification.from
        messageView.text = notification.message
    }
    

    
}
