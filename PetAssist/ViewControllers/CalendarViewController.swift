//
//  CalendarViewController.swift
//  PetAssist
//
//  Created by Xcode User on 2020-10-08.
//  Copyright © 2020 Taranpreet Singh Yu Zhang. All rights reserved.
//

import UIKit
import EventKit

class CalendarViewController: UIViewController,FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "cell")!)
        
        // set the text from the data model
        //cell.textLabel?.text = self.animals[indexPath.row]
        
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var eventContainer: UIView!
    @IBOutlet weak var reminderContainer: UIView!
    //Connected to reminder textfield
    @IBOutlet weak var eventText: UITextField!
    @IBOutlet var calendar: FSCalendar!
    let dateFormatter = DateFormatter()
    let date1 = Date()
    var dateText = ""
    
    //app delegate object ot use AppDelegate in this file
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
    
    
    @IBAction func indexChanged(sender: UISegmentedControl) {

        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            DispatchQueue.main.async {

            
            self.tableView.isHidden = false
                self.eventContainer.isHidden = true
                self.reminderContainer.isHidden = true
            }
        case 1:
            DispatchQueue.main.async {
                self.tableView.isHidden = true
                self.eventContainer.isHidden = false
                self.reminderContainer.isHidden = true
            }

        case 2:
            DispatchQueue.main.async {
            
                self.tableView.isHidden = true
                self.eventContainer.isHidden = true
                self.reminderContainer.isHidden = false
            }
        default:
            break;
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
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let rvc = segue.destination as! EventsViewController
        rvc.chosenDate = self.dateText
    }
*/
    //Function to set event in the event app
    @IBAction func setEvent(_ sender: AnyObject) {
        
        if appDelegate.eventStore == nil {
            appDelegate.eventStore = EKEventStore()
            
            //Request for access to reminders app
            appDelegate.eventStore?.requestAccess(
                to: EKEntityType.event, completion: {(granted, error) in
                    if !granted {
                        print("Access to store not granted")
                        print(error?.localizedDescription)
                    } else {
                        print("Access granted")
                    }
            })
        }
        
        // If access has been granted and reminer has been saved
        if (appDelegate.eventStore != nil) {
            self.createEvents()
            let alert = UIAlertController(title: "Event Saved", message: "Your event has been saved in the app. You will be notified.", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(ok)
            present(alert, animated: true)
        }
    }

    
    //Function to create a event
    func createEvents() {
        
        let event = EKEvent(eventStore: appDelegate.eventStore!)
        
        //set the title of the reminder
        event.title = eventText.text!
        //set date and time
        event.calendar =
            appDelegate.eventStore!.defaultCalendarForNewReminders()
        // Start of Event
        event.startDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        // Entire Day
        event.isAllDay = true
        // End Date required
        event.endDate = event.startDate
        
        do {
            //Try to Save Event
            try appDelegate.eventStore!.save(event, span: .thisEvent, commit: true)
        } catch let error {
            print("Event failed with error \(error.localizedDescription)")
        }
    }
    
    
    func removeEvent() {
        var startDate=NSDate().addingTimeInterval(-60*60*24)
        var endDate=NSDate().addingTimeInterval(60*60*24*3)
        var predicate2 = appDelegate.eventStore!.predicateForEvents(withStart: startDate as Date, end: endDate as Date, calendars: nil)
        
        print("startDate:\(startDate) endDate:\(endDate)")
        var eV = appDelegate.eventStore!.events(matching: predicate2) as [EKEvent]?
        
        if eV != nil {
            for i in eV! {
                print("Title  \(i.title)" )
                print("stareDate: \(i.startDate)" )
                print("endDate: \(i.endDate)" )
                do{
                    (try appDelegate.eventStore!.remove(i, span: EKSpan.thisEvent, commit: true))
                }
                catch let error {
                }
                
            }
        }
    }
        
}
    

