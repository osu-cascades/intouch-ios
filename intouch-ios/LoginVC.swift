
import UIKit

class LoginVC: UIViewController {
    
    var allNotifications: AllNotifications!
    
    //MARK: actions
    @IBAction func login(_ sender: Any) {
        
        UserDefaults.standard.set("true", forKey: "LOGGED_IN")
        
        let controllerId = "TabBar"
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController: UITabBarController = storyboard.instantiateViewController(withIdentifier: controllerId) as! UITabBarController

        let recvVC: ReceivedNotificationsViewController = (tabBarController.viewControllers![0] as! UINavigationController).viewControllers[0] as! ReceivedNotificationsViewController
        recvVC.allNotifications = allNotifications
        self.present(tabBarController, animated: true, completion: nil)
        
    }
    
    //MARK: lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        print(allNotifications)
    }
    
    override func viewDidLoad() {
        print(allNotifications)
    }
    
    //MARK: outlets
    @IBOutlet weak var loginBtn: UIButton!
}
