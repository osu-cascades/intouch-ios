
import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.adjustsFontForContentSizeCategory = true
        fromLabel.adjustsFontForContentSizeCategory = true
        dateLabel.adjustsFontForContentSizeCategory = true
    }
    
}
