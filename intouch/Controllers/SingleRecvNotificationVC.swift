
import UIKit

class SingleRecvNotificationVC: UIViewController {
    
    // MARK: Outlets
    #if DEBUG
    private let senderUrlStr = "https://abilitree-intouch-staging.herokuapp.com/reply_to_sender"
    private let replyAllUrlStr = "https://abilitree-intouch-staging.herokuapp.com/reply_all"
    #endif
    
    #if RELEASE
    private let senderUrlStr = "https://abilitree-intouch.herokuapp.com/reply_to_sender"
    private let replyAllUrlStr = "https://abilitree-intouch.herokuapp.com/reply_all"
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
    
    //MARK: Variables
    var notification: Notification! {
        didSet {
            navigationItem.title = notification.title
        }
    }
    let username: String? = Settings.getUsername()
    let password: String? = Settings.getPassword()
    
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
    
    
    @IBAction func showReplyTextField(_ sender: Any) {
        sendBtn.isHidden.toggle()
        replyTextField.isHidden.toggle()
        replyTextField.isEnabled.toggle()
        replyTextField.becomeFirstResponder()
    }
    
    @IBAction func showReplyAllTextField(_ sender: Any) {
        sendAllReplyBtn.isHidden.toggle()
        replyAllTextField.isEnabled.toggle()
        replyAllTextField.isHidden.toggle()
        replyAllTextField.becomeFirstResponder()
    }
    
    @IBAction func sendReply(_ sender: Any) {
        let message: String? = replyTextField.text
        let sender = self.notification.fromUsername
        let postString = "username=\(username!)&password=\(password!)&body=\(message!)&sender=\(sender)"
        
        
        pushReply(urlString: senderUrlStr, postString: postString, message: message)
        sendBtn.isHidden.toggle()
        replyTextField.isHidden.toggle()
        replyTextField.isEnabled.toggle()
    }
    
    @IBAction func sendAllReply(_ sender: Any) {
        let message: String? = replyAllTextField.text
        let groupRecipients: String? = self.notification.groupRecipients.joined(separator: ", ")
        let postString = "username=\(username!)&password=\(password!)&body=\(message!)&group_recipients=\(groupRecipients!)"
        
        pushReply(urlString: replyAllUrlStr, postString: postString, message: message)
        replyToAllbtn.isHidden.toggle()
        replyAllTextField.isEnabled.toggle()
        replyAllTextField.isHidden.toggle()
    }
    
    func pushReply(urlString : String?, postString: String?, message: String?) {
        var request = URLRequest(url: URL(string: urlString!)!)
        if message == "" {
            onSendBlankMessage()
            return
        }
        request.httpMethod = "POST"
        request.httpBody = postString!.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
#if DEBUG
                print("connection error: \(String(describing: error))")
#endif
                DispatchQueue.main.async {
                    self.onConnectionError(error: error as? String)
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
#if DEBUG
                print("status code: \(httpStatus.statusCode)")
                print("response: \(String(describing: response))")
#endif
                DispatchQueue.main.async {
                    self.onServerError(error: error as? String)
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                let responseString = String(data: data, encoding: .utf8)
                if responseString == "notification sent" {
#if DEBUG
                    print("notification has been sent")
#endif
                    DispatchQueue.main.async {
                        self.onNotificationSent()
                    }
                } else {
#if DEBUG
                    print("invalid username/password")
#endif
                    DispatchQueue.main.async {
                        
                    }
                }
            }
        }
        task.resume()
    }
    
    func onConnectionError(error: String?) {
        let alert = UIAlertController(title: "Status", message: "Connection Error: \(String(describing: error))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.view.tintColor = UIColor(red: 157/255, green: 200/255, blue: 49/255, alpha: 1)
        self.present(alert, animated: true)
    }
    
    func onNotificationSent() {
        let alert = UIAlertController(title: "Status", message: "Notification successfully sent.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.view.tintColor = UIColor(red: 157/255, green: 200/255, blue: 49/255, alpha: 1)
        self.present(alert, animated: true)
        self.replyAllTextField.text = ""
        self.replyTextField.text = ""
    }
    
    func onNotificationSentFailure() {
        let alert = UIAlertController(title: "Status", message: "User could not be verified", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func onSendBlankMessage() {
        let alert = UIAlertController(title: "Alert", message: "Message cannot be blank.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.view.tintColor = UIColor(red: 157/255, green: 200/255, blue: 49/255, alpha: 1)
        self.present(alert, animated: true, completion: nil)
    }
    
    func onServerError(error: String?) {
        let alert = UIAlertController(title: "Status", message: "Server Error: \(String(describing: error))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.view.tintColor = UIColor(red: 157/255, green: 200/255, blue: 49/255, alpha: 1)
        self.present(alert, animated: true)
    }
    
}
