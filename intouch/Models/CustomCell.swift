//
//  CustomCell.swift
//  intouch
//
//  Created by Bradley Cook on 4/6/19.
//  Copyright © 2019 Aaron. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CustomCell: JTAppleCell {
    @IBOutlet weak var dateLabel: UILabel!
    var is_selected = false
    var event: Event? = nil
    
}

