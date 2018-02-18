
import UIKit

class Notification: NSObject {
    var title: String
    var message: String
    var id: Int
    var from: String
    var date: Date
    
    init(title: String, message: String, id: Int) {
        self.title = title
        self.message = message
        self.id = id
        self.from = "no author"
        self.date = Date()
        super.init()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let titles = ["Alert", "News", "Reminder"]
            let messages = ["Meeting cancelled", "Dance party tonight!", "Remember your happy face"]
            
            var idx = arc4random_uniform(UInt32(titles.count))
            let randomTitle = titles[Int(idx)]
            
            idx = arc4random_uniform(UInt32(messages.count))
            let randomMessage = messages[Int(idx)]
        
            let randomId = Int(arc4random_uniform(1000))
            
            self.init(title: randomTitle, message: randomMessage, id: randomId)
            
        } else {
            self.init(title: "", message:"", id: 0)
        }
    }
    
}
