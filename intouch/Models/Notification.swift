
import UIKit

class Notification: NSObject, NSCoding {
    var title: String
    var message: String
    var from: String
    var datetime: String
    var fromUsername: String
    
    init(title: String, from: String, message: String, datetime: String, fromUsername: String) {
        self.title = title
        self.message = message
        self.from = from
        self.datetime = datetime
        self.fromUsername = fromUsername
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
        
            //let randomId = Int(arc4random_uniform(1000))
            
            self.init(title: randomTitle, from: "no author", message: randomMessage, datetime: "", fromUsername: "")
            
        } else {
            self.init(title: "", from: "no author", message:"", datetime: "", fromUsername: "")
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as! String
        datetime = aDecoder.decodeObject(forKey: "datetime") as! String
        from = aDecoder.decodeObject(forKey: "from") as! String
        message = aDecoder.decodeObject(forKey: "message") as! String
        fromUsername = aDecoder.decodeObject(forKey: "fromUsername") as! String
        
        super.init()
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(datetime, forKey: "datetime")
        aCoder.encode(from, forKey: "from")
        aCoder.encode(message, forKey: "message")
        aCoder.encode(fromUsername, forKey: "fromUsername")
    }
    
}
