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
    
    var formatter = DateFormatter()
    var eventList: [String:Event] = [:]
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var event: UIView!
    @IBOutlet var currentTitle: UILabel!
    @IBOutlet var currentDescription: UILabel!
    @IBOutlet var CurrentTime: UILabel!
    @IBOutlet var CurrentPlace: UILabel!
    @IBOutlet var currentNotes: UILabel!
    @IBOutlet var currentGroupParticipants: UILabel!
    @IBOutlet var currentHostedBy: UILabel!
    @IBOutlet var eventsScroll: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCalendarView()
        
    }
    
    
    
    func setUpCalendarView() {
        calendarView.visibleDates{(visibleDates) in
            self.formatter.dateFormat = "yyyy"
            let date = visibleDates.monthDates.first!.date
            self.year.text = self.formatter.string(from: date)
            self.formatter.dateFormat = "MMMM"
            self.month.text = self.formatter.string(from: date)
            self.calendarView.scrollToDate(Date(), animateScroll: false)
            
        }
    }
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? CustomCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellEvents(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: CustomCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
        } else {
            cell.dateLabel.textColor = UIColor.gray
        }
    }
    
    func handleCellEvents(cell: CustomCell, cellState: CellState) {
        self.formatter.dateFormat = "dd-MMM-yyyy"
        let dateString = formatter.string(from: cellState.date)
        if eventList[dateString] != nil {
            cell.event = eventList[dateString]
            let colorHex = eventList[dateString]!.color
            print("Hex color: \(colorHex)")
            cell.dateLabel.textColor = UIColor(hexString: colorHex)
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }

}

extension CalendarVC: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        
        let startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        let endDate = Calendar.current.date(byAdding: .year, value: 3, to: Date())
        
        let parameters = ConfigurationParameters(startDate: startDate!,
                                                 endDate: endDate!)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "myCustomCell", for: indexPath) as! CustomCell
        if cellState.isSelected {
            myCustomCell.backgroundColor = UIColor(red: 119/255, green: 145/255, blue: 45/255, alpha: 1.0)
        } else {
            myCustomCell.backgroundColor = nil
        }
        self.calendar(calendar, willDisplay: myCustomCell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
        return myCustomCell
    }
    
    func configureVisibleCell(myCustomCell: CustomCell, cellState: CellState, date: Date) {
        myCustomCell.dateLabel.text = cellState.text
    }
   
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let v = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: NSStringFromClass(JTAppleCollectionReusableView.self), for: indexPath)
        v.backgroundColor = UIColor.red
        return v
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let selectedCell = cell as? CustomCell else { return }
            selectedCell.backgroundColor = UIColor(red: 119/255, green: 145/255, blue: 45/255, alpha: 1.0)
        event.isHidden.toggle()
        calendarView.reloadData(withanchor: date)
        currentTitle.text = selectedCell.event?.title
        currentNotes.text = selectedCell.event?.notes
        currentHostedBy.text = selectedCell.event?.hostedBy
        currentDescription.text = selectedCell.event?.description
        CurrentTime.text = selectedCell.event?.time
        currentGroupParticipants.text = selectedCell.event?.groupParticipants.joined(separator: ", ")
        CurrentPlace.text = selectedCell.event?.place
       
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let selectedCell = cell as? CustomCell else { return }
        calendarView.sizeToFit()
        selectedCell.backgroundColor = nil
    }
}
