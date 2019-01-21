
import UIKit

class SingleRecvNotificationVC: UIViewController {
    
    // MARK: Outlets
    #if DEBUG
    private let pushUrlStr = "https://abilitree-intouch-staging.herokuapp.com/reply_to_sender"
    #endif
    
    #if RELEASE
    private let pushUrlStr = "https://abilitree-intouch.herokuapp.com/reply_to_sender"
    #endif
    @IBOutlet var titleField: UITextField!
    @IBOutlet var dateField: UITextField!
    @IBOutlet var fromField: UITextField!
    @IBOutlet var messageView: UITextView!
    @IBOutlet weak var replyToSenderBtn: UIButton!
    @IBOutlet weak var replyTextField: UITextField!
    @IBOutlet weak var replyAllTextField: UITextField!
    @IBOutlet weak var replyToAllbtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var sendAllReplyBtn: UIButton!
    
    @IBAction func showReplyTextField(_ sender: Any) {
        sendBtn.isHidden.toggle()
        replyTextField.isHidden.toggle()
        replyTextField.isEnabled.toggle()
        replyTextField.becomeFirstResponder()
    }

    @IBAction func sendReply(_ sender: Any) {
        let message: String? = replyTextField.text
        let sender = self.notification.fromUsername
        var request = URLRequest(url: URL(string: pushUrlStr)!)
        request.httpMethod = "POST"
        
        let username: String? = Settings.getUsername()
        let password: String? = Settings.getPassword()
        //let group = groups[groupPv.selectedRow(inComponent: 0)]
        let postString = "username=\(username!)&password=\(password!)&body=\(message!)&sender=\(sender)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            
        }
        
        task.resume()
        sendBtn.isHidden.toggle()
        replyTextField.isHidden.toggle()
        replyTextField.isEnabled.toggle()
    }
    
    @IBAction func replyAll(_ sender: Any) {
        replyAllTextField.isEnabled.toggle()
        replyAllTextField.isHidden.toggle()
        replyAllTextField.becomeFirstResponder()
        let createTab = self.tabBarController?.viewControllers?[1] as! createNotificationVC
    }
    @IBAction func sendAllReply(_ sender: Any) {
        let message: String? = replyAllTextField.text
        
        
        replyToAllbtn.isHidden.toggle()
        replyAllTextField.isEnabled.toggle()
        replyAllTextField.isHidden.toggle()
    }
    
    //MARK: Variables
    var notification: Notification! {
        didSet {
            navigationItem.title = notification.title
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        replyTextField.isEnabled = false
        replyAllTextField.isEnabled = false
        replyTextField.isHidden = true
        replyAllTextField.isHidden = true
        sendBtn.isHidden = true
        sendAllReplyBtn.isHidden = true
        titleField.text = notification.title
        dateField.text = notification.datetime
        fromField.text = notification.from
        messageView.text = notification.message
        print(self.notification.groupRecipients)
        titleField.isUserInteractionEnabled = false
        dateField.isUserInteractionEnabled = false
        fromField.isUserInteractionEnabled = false
        messageView.isUserInteractionEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    
}
