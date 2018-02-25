
import UIKit

class Notification: NSObject, NSCoding {
    var title: String
    var message: String
    //var id: Int
    var from: String
    var date: NSDate
    
    init(title: String, from: String, message: String) {
        self.title = title
        self.message = message
        //self.id = id
        self.from = from
        self.date = NSDate()
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
            
            self.init(title: randomTitle, from: "no author", message: randomMessage)
            
        } else {
            self.init(title: "", from: "no author", message:"")
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as! String
        date = aDecoder.decodeObject(forKey: "date") as! NSDate
        from = aDecoder.decodeObject(forKey: "from") as! String
        message = aDecoder.decodeObject(forKey: "message") as! String
        
        super.init()
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(from, forKey: "from")
        aCoder.encode(message, forKey: "message")
    }
    
}
