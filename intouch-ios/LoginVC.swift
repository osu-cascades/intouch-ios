
import UIKit

class LoginVC: UIViewController {
    
    //MARK: actions
    
    @IBAction func login(_ sender: Any) {
        
        UserDefaults.standard.set("true", forKey: "LOGGED_IN")
        
        let controllerId = "TabBar"
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initViewController: UITabBarController = storyboard.instantiateViewController(withIdentifier: controllerId) as! UITabBarController
        self.present(initViewController, animated: true, completion: nil)
        
    }
    
    //MARK: outlets
    @IBOutlet weak var loginBtn: UIButton!
}
