
import UIKit

class createNotificationVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: actions
    @IBAction func sendPushNotification(_ sender: Any) {
        let title: String? = titleTfO.text
        //let to: String? = toTfO.text
        let message: String? = messageTvO.text
        if title == "" /*|| to == ""*/ || message == "" {
            // show alert
            print("title, to, and message text fields must not be blank")
            return
        }
        print("sending push notification... title: \(title!) message: \(message!)")
        sendPushRequest(title: title!, message: message!)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //MARK: custom
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
    private let pushUrlStr = "https://abilitree-intouch-staging.herokuapp.com/push"
    //private let pushUrlStr = "https://abilitree.herokuapp.com/push"
    
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
                print("error: \(String(describing: error))")
                print("connection error")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Status", message: "Connection Error: \(String(describing: error))", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    alert.view.tintColor = UIColor(red: 157/255, green: 200/255, blue: 49/255, alpha: 1)
                    self.present(alert, animated: true)
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("status code: \(httpStatus.statusCode)")
                print("response: \(String(describing: response))")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Status", message: "Server Error: \(response!)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    alert.view.tintColor = UIColor(red: 157/255, green: 200/255, blue: 49/255, alpha: 1)
                    self.present(alert, animated: true)
                    
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                print("status code: \(httpStatus.statusCode)")
                let responseString = String(data: data, encoding: .utf8)
                if responseString == "notification sent" {
                    print("notification has been sent")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Status", message: "Notification successfully sent.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        alert.view.tintColor = UIColor(red: 157/255, green: 200/255, blue: 49/255, alpha: 1)
                        self.present(alert, animated: true)
                        self.titleTfO.text = ""
                        self.messageTvO.text = ""
                    }
                } else {
                    print("invalid token")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Status", message: "Unknown Error", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
        task.resume()
    }
    
    //MARK: variables
    var groups: [String] = [String]()
    
}
