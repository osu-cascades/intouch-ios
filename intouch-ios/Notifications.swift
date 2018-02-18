
import UIKit

class allNotifications {
    
    var recvNotifications = [Notification()]
    
    init() {
        for _ in 0..<5 {
            createNotification()
        }
    }
    
    @discardableResult func createNotification() -> Notification {
        let newNotification = Notification(random: true)
        
        recvNotifications.append(newNotification)
        
        return newNotification
    }
    
}
