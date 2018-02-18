
import UIKit

class Notifications {
    
    var recvNotifications = [Notification()]
    
    @discardableResult func createNotification() -> Notification {
        let newNotification = Notification(random: true)
        
        recvNotifications.append(newNotification)
        
        return newNotification
    }
    
}
