
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
            onBlankLogin()
#if DEBUG
            print("Username and Password cannot be blank")
#endif
            return
        }
        
        sendAuthRequest(username: username, password: password)
        
    }
    
    //MARK: custom

    func onBlankLogin() {
        let alert = UIAlertController(title: "Alert", message: "Username and Password cannot be blank.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.view.tintColor = UIColor(red: 157/255, green: 200/255, blue: 49/255, alpha: 1)
        self.present(alert, animated: true, completion: nil)
    }
    
    func onConnectionError() {
        let alert = UIAlertController(title: "Alert", message: "Connection Error. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.view.tintColor = UIColor(red: 157/255, green: 200/255, blue: 49/255, alpha: 1)
        self.present(alert, animated: true, completion: nil)
    }
    
    func onLoginFailure() {
        let alert = UIAlertController(title: "Alert", message: "Username and/or password is invalid.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.view.tintColor = UIColor(red: 157/255, green: 200/255, blue: 49/255, alpha: 1)
        self.present(alert, animated: true, completion: nil)
    }
    
    func onLoginSuccess(username: String?, password: String?, userType: String?) {
        
        // save username, password, usertype
        Settings.setUsernamePasswordUserType(username: username!, password: password!, userType: userType!)
        
        // switch view controllers
        let controllerId = "TabBar"
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController: UITabBarController = storyboard.instantiateViewController(withIdentifier: controllerId) as! UITabBarController
        
        let recvVC: NotificationsViewController = (tabBarController.viewControllers![0] as! UINavigationController).viewControllers[0] as! NotificationsViewController
        recvVC.allNotifications = self.allNotifications
        recvVC.pushNotifications = self.pushNotifications
        try? recvVC.pushNotifications.subscribe(interest: "\(Settings.getUsername())")
        
        self.present(tabBarController, animated: true, completion: nil)
    }
    
    func onServerError(response: URLResponse?) {
        let alert = UIAlertController(title: "Status", message: "Server Error: \(response!)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.view.tintColor = UIColor(red: 157/255, green: 200/255, blue: 49/255, alpha: 1)
        self.present(alert, animated: true)
    }
    
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
#if DEBUG
    private let authUrlStr = "https://abilitree-intouch-staging.herokuapp.com/auth"
#endif
    
#if RELEASE
    private let authUrlStr = "https://abilitree-intouch.herokuapp.com/auth"
#endif
    
    func sendAuthRequest(username: String, password: String) {
        print(authUrlStr)
        var request = URLRequest(url: URL(string: authUrlStr)!)
        request.httpMethod = "POST"
        let postString = "username=\(username)&password=\(password)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                self.onConnectionError()
#if DEBUG
                print("error: \(String(describing: error))")
#endif
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
#if DEBUG
                print("status code: \(httpStatus.statusCode)")
                print("response: \(String(describing: response))")
#endif
                DispatchQueue.main.async {
                    self.onServerError(response: response) 
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                print("status code: \(httpStatus.statusCode)")
                let responseString = String(data: data, encoding: .utf8)
                if responseString?.range(of: "usertype") != nil {
                    var responseArray = responseString?.components(separatedBy:" ")
#if DEBUG
//                    print("usertype: \(responseArray![1])")
#endif
                    DispatchQueue.main.async {
                        self.onLoginSuccess(username: username, password: password, userType: responseArray![0])
                    }
                } else {
#if DEBUG
                    print("username and/or password is invalid")
#endif
                    DispatchQueue.main.async {
                        self.onLoginFailure()
                    }
                }
            }
        }
        task.resume()
    }
}
