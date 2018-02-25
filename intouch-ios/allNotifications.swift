
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
        
        recvNotifications.insert(newNotification, at: 0)
        
        return newNotification
    }
    
    @discardableResult func createNotification(title: String, from: String, message: String) -> Notification {
        let newNotification = Notification(title: title, from: from, message: message)
        
        recvNotifications.insert(newNotification, at: 0)
        
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
    
    init() {
        if let archivedNotifications = NSKeyedUnarchiver.unarchiveObject(withFile: notificationsArchiveURL.path) as? [Notification] {
            recvNotifications = archivedNotifications
        } 
    }
    
    
}
