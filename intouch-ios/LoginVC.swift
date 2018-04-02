
import UIKit

class LoginVC: UIViewController {
    
    //MARK: actions
    
    @IBAction func login(_ sender: Any) {
        let controllerId = "RecvVC"
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: controllerId) as UIViewController
        self.present(initViewController, animated: true, completion: nil)
        
    }
    
    //MARK: outlets
    @IBOutlet weak var loginBtn: UIButton!
}
