//
//  CalendarViewController.swift
//  PetAssist
//
//  Created by Xcode User on 2020-10-08.
//  Copyright © 2020 Taranpreet Singh Yu Zhang. All rights reserved.
//

import UIKit
import EventKit

class CalendarViewController: UIViewController,FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    @IBOutlet var calendar: FSCalendar!
    let dateFormatter = DateFormatter()
    let date1 = Date()
    var dateText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calendar.delegate = self
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateText = dateFormatter.string(from: date1)
        
        
        var titles : [String] = []
        var startDates : [NSDate] = []
        var endDates : [NSDate] = []
        
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
            if calendar.title == "Work" {
                
                let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
                let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
                
                let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar])
                
                var events = eventStore.events(matching: predicate)
                
                for event in events {
                    titles.append(event.title)
                    startDates.append(event.startDate as! NSDate)
                    endDates.append(event.endDate as! NSDate)
                }
            }
        }

        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        guard let eventDate = dateFormatter.date(from: "2020-10-28") else { return 0 }
        if date.compare(eventDate) == .orderedSame{
            return 2
        }
        return 0
    }
    
    //Select Calendar
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let string = dateFormatter.string(from: date)
        print("\(string)")
        dateText = string
    }

    //Send to Reminders
    @IBAction func sendDate(_ sender: Any){
        performSegue(withIdentifier: "goToReminder", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var rvc = segue.destination as! EventsViewController
        rvc.chosenDate = self.dateText
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
