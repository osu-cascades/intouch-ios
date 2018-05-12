
import UIKit

class createNotificationVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: actions
    @IBAction func sendPushNotification(_ sender: Any) {
        let title: String? = titleTfO.text
        //let to: String? = toTfO.text
        let message: String? = messageTvO.text
        if title == "" /*|| to == ""*/ || message == "" {
            onSendBlankMessage()
#if DEBUG
            print("title, to, and message text fields must not be blank")
#endif
            return
        }
#if DEBUG
        print("sending push notification... title: \(title!) message: \(message!)")
#endif
        sendPushRequest(title: title!, message: message!)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //MARK: custom
    
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
        self.titleTfO.text = ""
        self.messageTvO.text = ""
    }
    
    func onNotificationSentFailure() {
        let alert = UIAlertController(title: "Status", message: "User could not be verified", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func onSendBlankMessage() {
        let alert = UIAlertController(title: "Alert", message: "Title and message cannot be blank.", preferredStyle: UIAlertControllerStyle.alert)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        messageTvO!.layer.borderWidth = 1
        messageTvO!.layer.borderColor = UIColor(red:230/255, green:230/255, blue:230/255, alpha: 1).cgColor
        messageTvO!.layer.cornerRadius = 5
        
        self.titleTfO.delegate = self
        self.groupPv.delegate = self
        
        let usertype: String? = Settings.getUserType()
        
        if usertype == "client" {
            groups = ["Art", "Cross-Disability", "Healing Pathways", "Journey"]
        } else {
            groups = ["All", "Clients", "Staff", "Art", "Cross-Disability", "Healing Pathways", "Journey"]
        }
        let username: String? = Settings.getUsername()
        if username == "testuser" {
            groups.insert("test group", at: 0)
        }
        
    }
    
    //MARK: outlets
    @IBOutlet weak var titleTfO: UITextField!
    @IBOutlet weak var groupPv: UIPickerView!
    @IBOutlet weak var messageTvO: UITextView!
    
    //MARK: picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groups.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent: Int) -> String? {
        return groups[row]
    }
    //not being called, why? 
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //group = groups[row] as String
        //print("group: \(group!)")
    }
    
    //MARK: posts
#if DEBUG
    private let pushUrlStr = "https://abilitree-intouch-staging.herokuapp.com/push"
#endif

#if RELEASE
    private let pushUrlStr = "https://abilitree-intouch.herokuapp.com/push"
#endif
    
    func sendPushRequest(title: String?, message: String?) {
        var request = URLRequest(url: URL(string: pushUrlStr)!)
        request.httpMethod = "POST"
        
        let username: String? = Settings.getUsername()
        let password: String? = Settings.getPassword()
        let group = groups[groupPv.selectedRow(inComponent: 0)]
        let postString = "username=\(username!)&password=\(password!)&title=\(title!)&body=\(message!)&group=\(group)"
        request.httpBody = postString.data(using: .utf8)
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
    
    //MARK: variables
    var groups: [String] = [String]()
    
}
