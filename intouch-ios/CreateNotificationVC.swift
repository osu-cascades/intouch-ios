
import UIKit

class createNotificationVC: UIViewController, UITextFieldDelegate {
    
    //MARK: actions
    @IBAction func sendPushNotification(_ sender: Any) {
        let title: String? = titleTfO.text
        //let to: String? = toTfO.text
        let message: String? = messegeTfO.text
        if title == "" /*|| to == ""*/ || message == "" {
            // show alert
            print("title, to, and message text fields must not be blank")
            return
        }
        print("sending push notification... title: \(title) message: \(message)")
        sendPushRequest(title: title!, message: message!)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        titleTfO.resignFirstResponder()
        toTfO.resignFirstResponder()
        messegeTfO.resignFirstResponder()
        print("tap")
    }
    
    //MARK: custom
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTfO.resignFirstResponder()
        toTfO.resignFirstResponder()
        messegeTfO.resignFirstResponder()
        return false
    }
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        messegeTfO!.layer.borderWidth = 1
        messegeTfO!.layer.borderColor = UIColor(red:230/255, green:230/255, blue:230/255, alpha: 1).cgColor
        messegeTfO!.layer.cornerRadius = 6
        
        self.titleTfO.delegate = self
        self.toTfO.delegate = self
    }
    
    //MARK: outlets
    @IBOutlet weak var titleTfO: UITextField!
    @IBOutlet weak var toTfO: UITextField!
    @IBOutlet weak var messegeTfO: UITextView!
    
    //MARK: posts
    private let pushUrlStr = "https://abilitree-intouch-staging.herokuapp.com/push"
    //private let authUrlStr = "https://abilitree.herokuapp.com/push"
    
    func sendPushRequest(title: String?, message: String?) {
        var request = URLRequest(url: URL(string: pushUrlStr)!)
        request.httpMethod = "POST"
        
//        let username: String? = UserDefaults.standard.string(forKey: "USERNAME")
//        let password: String? = UserDefaults.standard.string(forKey: "PASSWORD")
        
        let username: String? = "admin"
        let password: String? = "queenannesrevenge"
        
        let postString = "username=\(username!)&password=\(password!)&title=\(title!)&body=\(message!)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error: \(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("status code: \(httpStatus.statusCode)")
                print("response: \(String(describing: response))")
                DispatchQueue.main.async {
                    print("connection error")
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                print("status code: \(httpStatus.statusCode)")
                let responseString = String(data: data, encoding: .utf8)
                if responseString == "notification sent" {
                    print("notification has been sent")
                    DispatchQueue.main.async {
                        self.titleTfO.text = ""
                        self.messegeTfO.text = ""
                    }
                } else {
                    print("invalid token")
                    DispatchQueue.main.async {
                    }
                }
            }
        }
        task.resume()
    }
    
    
}
