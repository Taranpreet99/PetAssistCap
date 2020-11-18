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
    var dateSelectedText = ""
    
    var datesWithEvent = [String]()

    //Holds all events that turn into multiple events
    var datesWithNoEvents = [String]()
    
    var datesWithMultipleEvents = [String]()

    //Events for the date
    var eventsForDate = [Event]()
    
    override func viewWillAppear(_ animated: Bool) {
        //Refresh Events
        appDelegate.readEventsFromDatabase()

        
        let eventHolder = appDelegate.events
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "yyyy-MM-dd"
        
        datesWithEvent = []
        datesWithNoEvents = []
        datesWithMultipleEvents = []
        
        //Place events in organized collection
        for event in eventHolder {
            
            let eventStrArray = event.datesInEvent!.components(separatedBy: ",")
            
            // Determine dots in the date
            for eventStr in eventStrArray {
                print(eventStr)
                // Check if event is in the single event collection
                if datesWithEvent.contains(eventStr){
                    // Remove Event from single event collection
                    // Add Event to No Event to prevent readding to Single Collection
                    // Add Event to Multiple Event collection
                    datesWithNoEvents.append(eventStr)
                    
                    datesWithEvent.remove(at: datesWithEvent.firstIndex(of: eventStr)!)
                    print("M:\(eventStr)")
                    datesWithMultipleEvents.append(eventStr)
                }else{
                    //Check if event is being readded
                    if datesWithNoEvents.contains(eventStr){
                    }else{
                        //Add event to single view collection
                        print("E:\(eventStr)")
                        datesWithEvent.append(eventStr)
                    }
                }
                
            }
        }
        
        // Remove all previous events for date for new events to for date selected
        // Add all events for the date and refresh tableview and calendar
        eventsForDate.removeAll()
        let formatter5 = DateFormatter()
        formatter5.dateFormat = "yyyy-MM-dd"
        for event in appDelegate.events{
            let eventStrArray = event.datesInEvent!.components(separatedBy: ",")
            
            // Determine dots in the date
            for eventStr in eventStrArray {
                if dateSelectedText == eventStr {
                    eventsForDate.append(event)
                }
            }
        }
        tableView.reloadData()
        calendar.reloadData()
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.

        calendar.delegate = self
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateText = dateFormatter.string(from: date1)
        
        dateSelectedText = dateFormatter.string(from: Date())
        
       
        
    }
    
    //Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return eventsForDate.count
    }
    
    // Event Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell: CustomCalTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell1" , for: indexPath) as! CustomCalTableViewCell
        
        let calEvents = eventsForDate
        
        cell.calTitle?.text = calEvents[indexPath.row].title
        cell.calDetail?.text = calEvents[indexPath.row].details
        cell.calStartDate?.text = calEvents[indexPath.row].startDate
        cell.calEndDate?.text = calEvents[indexPath.row].endDate

        return cell
    }
    
     
    
    // When the row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        appDelegate.eventID = eventsForDate[indexPath.row].id!
        
        performSegue(withIdentifier: "goToEvent", sender: nil)
    }
    
    
    //Set TableView Cell Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    
    
    
    //Place the dots on the Calendar
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        let formatter3 = DateFormatter()
        formatter3.dateFormat = "yyyy-MM-dd"
        
        let dateString = formatter3.string(from: date)

        if self.datesWithMultipleEvents.contains(dateString) {
            return 2
        }

        if self.datesWithEvent.contains(dateString) {
            return 1
        }
        return 0
    }
    
    //Select date from Calendar UI
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //Save date and print out string 
        let string = dateFormatter.string(from: date)
        print("\(string)")
        //dateText = string
        dateSelectedText = string
        
        // Remove all previous events for date for new events to for date selected
        // Add all events for the date and refresh tableview
        eventsForDate.removeAll()
        let formatter5 = DateFormatter()
        formatter5.dateFormat = "yyyy-MM-dd"
        for event in appDelegate.events{
            let eventStrArray = event.datesInEvent!.components(separatedBy: ",")
            
            // Determine dots in the date
            for eventStr in eventStrArray {
                if dateSelectedText == eventStr {
                    eventsForDate.append(event)
                }
            }
        }
        
        tableView.reloadData()
    }
    
    //Send to Events Creater
    @IBAction func sendDate2(_ sender: Any){
        appDelegate.eventID = -1
        performSegue(withIdentifier: "goToEvent", sender: self)
    }
        
}
    

