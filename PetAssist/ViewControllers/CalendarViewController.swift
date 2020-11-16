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
    
    //app delegate object ot use AppDelegate in this file
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var calendar: FSCalendar!
    let dateFormatter = DateFormatter()
    let date1 = Date()
    var dateText = ""
    

    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate.readEventsFromDatabase()
        tableView.reloadData()
        // Do any additional setup after loading the view.
        calendar.delegate = self
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateText = dateFormatter.string(from: date1)
        
        var titles : [String] = []
        var startDates : [NSDate] = []
        var endDates : [NSDate] = []
        
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        
        //Get all events from phone
        for calendar in calendars {
            //Check if calendar has title
                
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
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return appDelegate.events.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell: CustomCalTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell1" , for: indexPath) as! CustomCalTableViewCell
        
        // set the text from the data model
        //cell.textLabel?.text = self.animals[indexPath.row]
        
        let calEvents = appDelegate.events
        
        cell.calTitle?.text = calEvents[indexPath.row].title
        cell.calDetail?.text = calEvents[indexPath.row].details
        cell.calStartDate?.text = calEvents[indexPath.row].startDate
        cell.calEndDate?.text = calEvents[indexPath.row].endDate

        return cell
    }
    
     
    
    // When the row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        appDelegate.eventID = appDelegate.events[indexPath.row].id!
        
        performSegue(withIdentifier: "goToEvent", sender: nil)
    }
    
    
    //Set TableView Cell Row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    //Edit Event
    @IBAction func deleteEvent(){
        
        /*
        eventStore.requestAccess(to: .event) { (granted, error) in
          
          if (granted) && (error == nil) {
              print("granted \(granted)")
              print("error \(error)")
              
            let event:EKEvent = EKEvent(eventStore: self.eventStore)
              
            event.title = self.eventTitleText.text
            event.startDate = self.mystartDatePicker.date
            event.endDate = self.myendDatePicker.date
            event.notes = self.eventDetailText.text
            event.calendar = self.eventStore.defaultCalendarForNewEvents
              do {
                try self.eventStore.save(event, span: .thisEvent)
              } catch let error as NSError {
                  print("failed to save event with error : \(error)")
              }
              print("Saved Event")
          }
          else{
          
              print("failed to save event with error : \(error) or access not granted")
          }
        }
        */
        

    
     
    }
    
    
    
    //Place the dots on the Calendar
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        guard let eventDate = dateFormatter.date(from: "2020-10-29") else { return 0 }
        if date.compare(eventDate) == .orderedSame{
            return 2
        }
        return 0
    }
    
    //Select date from Calendar UI
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //Save date and print out string 
        let string = dateFormatter.string(from: date)
        print("\(string)")
        dateText = string
    }

    //Send to Reminders
    @IBAction func sendDate(_ sender: Any){
        performSegue(withIdentifier: "goToReminder", sender: self)
    }
    
    //Send to Events Creater
    @IBAction func sendDate2(_ sender: Any){
        appDelegate.eventID = -1
        performSegue(withIdentifier: "goToEvent", sender: self)
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
    

