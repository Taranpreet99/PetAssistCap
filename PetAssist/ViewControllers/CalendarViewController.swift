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

    var eventsForDate = [Event]()
    
    override func viewWillAppear(_ animated: Bool) {
        appDelegate.readEventsFromDatabase()

        
        let eventHolder = appDelegate.events
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "yyyy-MM-dd"
        
        datesWithEvent = []
        datesWithNoEvents = []
        datesWithMultipleEvents = []
        
        for event in eventHolder {
            let eventStrSub = event.startDate!.prefix(10)
            let eventStr = String(eventStrSub)
            
            
            if datesWithEvent.contains(eventStr){
                datesWithNoEvents.append(eventStr)
                
                datesWithEvent.remove(at: datesWithEvent.firstIndex(of: eventStr)!)
                print("M:\(eventStr)")
                datesWithMultipleEvents.append(eventStr)
            }else{
                if datesWithNoEvents.contains(eventStr){
                }else{
                    print("E:\(eventStr)")
                    datesWithEvent.append(eventStr)
                }
            }
        }
        
        eventsForDate.removeAll()
        let formatter5 = DateFormatter()
        formatter5.dateFormat = "yyyy-MM-dd"
        for event in appDelegate.events{
            let eventStrSub = event.startDate?.prefix(10)
            let eventStr = String(eventStrSub!)
            if dateSelectedText == eventStr {
                eventsForDate.append(event)
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
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return eventsForDate.count
    }
    
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
    
    
    //Set TableView Cell Row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
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
        
        
        eventsForDate.removeAll()
        let formatter5 = DateFormatter()
        formatter5.dateFormat = "yyyy-MM-dd"
        for event in appDelegate.events{
            let eventStrSub = event.startDate?.prefix(10)
            let eventStr = String(eventStrSub!)
            if dateSelectedText == eventStr {
                eventsForDate.append(event)
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
    

