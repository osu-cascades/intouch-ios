
import UIKit

class SingleRecvNotificationVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var titleField: UITextField!
    @IBOutlet var dateField: UITextField!
    @IBOutlet var fromField: UITextField!
    @IBOutlet var messageView: UITextView!
    @IBOutlet weak var replyToSenderBtn: UIButton!
    @IBOutlet weak var replyTextField: UITextField!
   
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBAction func showReplyTextField(_ sender: Any) {
        sendBtn.isHidden.toggle()
        replyTextField.isHidden.toggle()
        replyTextField.becomeFirstResponder()
    }

    @IBAction func sendReply(_ sender: Any) {
//        var request = URLRequest(url: URL(string: pushUrlStr)!)
//        request.httpMethod = "POST"
//        
//        let username: String? = Settings.getUsername()
//        let password: String? = Settings.getPassword()
//        //let group = groups[groupPv.selectedRow(inComponent: 0)]
//        let postString = "username=\(username!)&password=\(password!)&title=\(title!)&body=\(message!)&group=\(to!)"
//        request.httpBody = postString.data(using: .utf8)
        sendBtn.isHidden.toggle()
        replyTextField.isHidden.toggle()
    }
    
    //MARK: Variables
    var notification: Notification! {
        didSet {
            navigationItem.title = notification.title
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        replyTextField.isHidden = true
        sendBtn.isHidden = true
        titleField.text = notification.title
        dateField.text = notification.datetime
        fromField.text = notification.from
        messageView.text = notification.message
        
        titleField.isUserInteractionEnabled = false
        dateField.isUserInteractionEnabled = false
        fromField.isUserInteractionEnabled = false
        messageView.isUserInteractionEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    
}
