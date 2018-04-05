
import UIKit

class LoginVC: UIViewController {
    
    var allNotifications: AllNotifications!
    
    //MARK: actions
    @IBAction func login(_ sender: Any) {
        
        //send request
        let username: String = (usernameTf?.text)!
        let password: String = (passwordTf?.text)!
        //print(password)
        if username == "" || password == "" {
            print("Username and Password must not be blank")
        }
        
        sendAuthRequest(username: username, password: password)
        
        UserDefaults.standard.set("true", forKey: "LOGGED_IN")
        
        let controllerId = "TabBar"
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController: UITabBarController = storyboard.instantiateViewController(withIdentifier: controllerId) as! UITabBarController

        let recvVC: ReceivedNotificationsViewController = (tabBarController.viewControllers![0] as! UINavigationController).viewControllers[0] as! ReceivedNotificationsViewController
        recvVC.allNotifications = allNotifications
        self.present(tabBarController, animated: true, completion: nil)
        
    }
    
    //MARK: custom
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //MARK: lifecycle
    override func viewWillAppear(_ animated: Bool) {
        usernameTf.placeholder = "username"
        passwordTf.placeholder = "password"
        print(allNotifications)
    }
    
    override func viewDidLoad() {
        print(allNotifications)
    }
    
    //MARK: outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    
    //MARK: posts
    //private let authUrlStr = "https://abilitree-intouch-staging.herokuapp.com/auth"
    private let authUrlStr = "https://abilitree.herokuapp.com/auth"
    
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
                    self.responseL.text = "connection error"
                }
                // error handle
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                print("status code: \(httpStatus.statusCode)")
                let responseString = String(data: data, encoding: .utf8)
                if responseString == "authenticated: \(username)" {
                    print("\(username) has been authenticated")
                    DispatchQueue.main.async {
                        //self.responseL.text = "User authenticated"
                        SettingsBundleHelper.setUsernameAndPassword(username: username, password: password)
                        self.usernameTf.text = ""
                        self.passwordTf.text = ""
                        //sleep(3)
                        self.performSegue(withIdentifier: "showNotifications", sender: nil)
                    }
                } else {
                    print("username and/or password is invalid")
                    DispatchQueue.main.async {
                        self.responseL.text = "username and/or password is invalid"
                    }
                }
            }
        }
        task.resume()
    }
}
