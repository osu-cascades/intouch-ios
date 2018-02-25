
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
    
    @discardableResult func createNotification(title: String, from: String, message: String, datetime: String) -> Notification? {
       
        // need to change this to check for notification id, rails needs to send the id first
        for notification in recvNotifications {
            if (notification.message == message && notification.title == title
                    && notification.from == from && notification.datetime == datetime) {
                return nil
            }
        }
        
        let newNotification = Notification(title: title, from: from, message: message, datetime: datetime)
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
