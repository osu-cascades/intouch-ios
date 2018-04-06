
import UIKit
import PushNotifications

class LoginVC: UIViewController, UITextFieldDelegate {
    
    var allNotifications: AllNotifications!
    var pushNotifications = PushNotifications.shared
    
    //MARK: actions
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    @IBAction func login(_ sender: Any) {

        let username: String = (usernameTf?.text)!
        let password: String = (passwordTf?.text)!
        if username == "" || password == "" {
            // create alert
            print("Username and Password must not be blank")
            return
        }
        
        sendAuthRequest(username: username, password: password)
        
    }
    
    //MARK: custom
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //MARK: lifecycle
    override func viewWillAppear(_ animated: Bool) {
        usernameTf.placeholder = "username"
        passwordTf.placeholder = "password"
    }
    
    override func viewDidLoad() {
        self.usernameTf.delegate = self
        self.passwordTf.delegate = self
    }
    
    //MARK: outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    
    //MARK: posts
    private let authUrlStr = "https://abilitree-intouch-staging.herokuapp.com/auth"
    //private let authUrlStr = "https://abilitree.herokuapp.com/auth"
    
    func sendAuthRequest(username: String, password: String) {
        var request = URLRequest(url: URL(string: authUrlStr)!)
        request.httpMethod = "POST"
        let postString = "username=\(username)&password=\(password)"
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
                    //alert connection error
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                print("status code: \(httpStatus.statusCode)")
                let responseString = String(data: data, encoding: .utf8)
                if responseString == "authenticated: \(username)" {
                    print("\(username) has been authenticated")
                    DispatchQueue.main.async {
                        Settings.setUsernameAndPassword(username: username, password: password)
                        let controllerId = "TabBar"
                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabBarController: UITabBarController = storyboard.instantiateViewController(withIdentifier: controllerId) as! UITabBarController
                        
                        let recvVC: ReceivedNotificationsViewController = (tabBarController.viewControllers![0] as! UINavigationController).viewControllers[0] as! ReceivedNotificationsViewController
                        recvVC.allNotifications = self.allNotifications
                        recvVC.pushNotifications = self.pushNotifications
                        
                        self.present(tabBarController, animated: true, completion: nil)
                    }
                } else {
                    print("username and/or password is invalid")
                    DispatchQueue.main.async {
                        // alert "username and/or password is invalid"
                    }
                }
            }
        }
        task.resume()
    }
}
