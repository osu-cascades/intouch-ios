//
//  CalendarVC.swift
//  intouch
//
//  Created by Bradley Cook on 4/6/19.
//  Copyright © 2019 Aaron. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar

class CalendarVC: UIViewController {
    let formatter = DateFormatter()
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.register(CustomCell.self, forCellWithReuseIdentifier: NSStringFromClass(CustomCell.self))
        calendarView.register(JTAppleCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: NSStringFromClass(JTAppleCollectionReusableView.self))
        
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CalendarVC: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2020 02 01")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate)
        return parameters
    }
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "myCustomCell", for: indexPath) as! CustomCell
        configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
        return myCustomCell
    }
    func configureVisibleCell(myCustomCell: CustomCell, cellState: CellState, date: Date) {
        myCustomCell.dateLabel.text = cellState.text
    }
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // This function should have the same code as the cellForItemAt function
        let myCustomCell = cell as! CustomCell
        configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
    }
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let v = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: NSStringFromClass(JTAppleCollectionReusableView.self), for: indexPath)
        v.backgroundColor = UIColor.red
        return v
    }
}
