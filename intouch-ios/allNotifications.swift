
import UIKit

class AllNotifications {
    
    var recvNotifications = [Notification()]
    
    init() {
        for _ in 0..<25 {
            createNotification()
        }
    }
    
    @discardableResult func createNotification() -> Notification {
        let newNotification = Notification(random: true)
        
        recvNotifications.append(newNotification)
        
        return newNotification
    }
    
}
