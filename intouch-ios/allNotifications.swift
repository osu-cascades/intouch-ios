
import UIKit

class AllNotifications {
    
    var recvNotifications = [Notification()]
    let notificationsArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("notifications.archive")
    }()
    
    @discardableResult func createNotification() -> Notification {
        let newNotification = Notification(random: true)
        
        recvNotifications.append(newNotification)
        
        return newNotification
    }
    
    func removeNotification(_ notification: Notification) {
        if let index = recvNotifications.index(of: notification) {
            recvNotifications.remove(at: index)
        }
    }
    
    func saveChanges() -> Bool {
        //print("Saving notifications to: \(notificationsArchiveURL.path)")
        return NSKeyedArchiver.archiveRootObject(recvNotifications, toFile: notificationsArchiveURL.path)
    }
    
}
