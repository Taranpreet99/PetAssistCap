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
    
    //To Fix the delete event bug
    @IBAction func unwindToCalendarVC(sender : UIStoryboardSegue){
        
        reloadCalendarViewContoller()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        
        //Alert if user is not logged in
       // if appDelegate.loggedOnID == "-1" {
        if(UserDefaults.standard.bool(forKey: "IsUserLoggedIn") == false){
            
            appDelegate.events.removeAll()
            reloadCalendarViewContoller()
            //Alert
            let alertController = UIAlertController(title: "Not Logged In", message: "Please log in to use calendar." , preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancel)
            present(alertController,animated: true)
        }else{
        
            //Refresh Events
            //appDelegate.readEventsFromDatabaseWithID()
            //let a = readEventsFromFirebase()
            //print("Event Count --- \(a)")
            if appDelegate.loadCalendarAndTable == 0 {
                var rootRef: DatabaseReference!
                rootRef = Database.database().reference()
                let eventRef = rootRef.child("Events")
                eventRef.removeAllObservers()
                
               // readEventsFromFirebaseWithUsername(username: appDelegate.loggedOnID)
                
                //Made this change because of the "Keep user logged in" Feature
                readEventsFromFirebaseWithUsername(username: UserDefaults.standard.string(forKey: "Username") as! String)
                appDelegate.loadCalendarAndTable = 1
            }
            reloadCalendarViewContoller()

        }
    }

    func reloadCalendarViewContoller(){
        determineNumOfEventsForDates()
        getEventsForSelectedDate()
    }
    
    //Function to read all events from firebase, choose the events with right structure
    func readEventsFromFirebase() -> Int{
        var rootRef: DatabaseReference!

        var eventCount = 0
        
        appDelegate.events.removeAll()
        //var newItems: [GroceryItem] = []
        
        //Root of Data
        rootRef = Database.database().reference()
        
        //Child of Root, Events
        let eventRef = rootRef.child("Events")
        eventRef.observe(.value, with: { snapshot in
            
            guard let value = snapshot.value as? [String: Any] else {
                return
            }
            
            //Every Key in Events
            for key in value.keys {
                
                //Every child in Event
                eventRef.child(key).observeSingleEvent(of: .value, with: {
                    snapshot in
                    
                    if let eventDict = snapshot.value as? [String:Any] {
                         //Do not cast print it directly may be score is Int not string
                        //print(userDict.keys)
                        let userName = eventDict["UserName"] ?? "Not There"
                        let title = eventDict["Subject"] ?? "Not There"
                        let sd = eventDict["start"] ?? "Not There"
                        let ed = eventDict["end"] ?? "Not There"
                        if String(describing: userName) != "Not There"{
                            print("\(userName) | \(title) | \(sd) | \(ed)")
                            
                            let title = title
                            let detail = ""
                            let startDate = sd
                            let endDate = ed
                            let dates =  ""
                            let entID = userName
                            
                            let event : Event = Event.init()
                            event.initWithData(theRow: "0" , theTitle: title as! String, theDetails: detail, theStartDate: startDate as! String, theEndDate: endDate as! String, datesInEvent: dates, entriesID: entID as! String)
                            //print("Event ID: \(event.id)")
                            event.key = key
                            
                            self.appDelegate.events.append(event)
                            print("Event Count: \(self.appDelegate.events.count)")
                            eventCount = eventCount + 1
                            self.reloadCalendarViewContoller()
                        }
                    }
                    
                })
                
            }
         
        })
        return eventCount
    }
    
    //Function to read events from firebase
    func readEventsFromFirebaseWithUsername(username: String){
        var rootRef: DatabaseReference!

        var eventCount = 0

        //Root of Data
        rootRef = Database.database().reference()
        
        //Child of Root, Events
        let eventRef = rootRef.child("Events")
        //Observes the Events
        eventRef.observe(.value, with: { snapshot in
            self.appDelegate.events.removeAll() //Remove all events
            
            //Got the snapshots of the firebase database
            guard let value = snapshot.value as? [String: Any] else {
                return
            }
            
            //Every Key in Events
            for key in value.keys {
                
                //Every child in Event
                eventRef.child(key).observeSingleEvent(of: .value, with: {
                    snapshot in
                    
                    //Get the event of the directory
                    if let eventDict = snapshot.value as? [String:Any] {
                        let userName = eventDict["UserName"] ?? "Not There"
                        let title = eventDict["Subject"] ?? "Not There"
                        let sd = eventDict["start"] ?? "Not There"
                        let ed = eventDict["end"] ?? "Not There"
                        if String(describing: userName) == username{
                            print("\(userName) | \(title) | \(sd) | \(ed)")

                            let title = title
                            let detail = ""
                            let startDate = sd
                            let endDate = ed
                            let dates =  ""
                            let entID = userName
                            
                            //Create event
                            let event : Event = Event.init()
                            event.initWithData(theRow: "0" , theTitle: title as! String, theDetails: detail, theStartDate: startDate as! String, theEndDate: endDate as! String, datesInEvent: dates, entriesID: entID as! String)
                            //Add Key
                            event.key = key
                            
                            self.appDelegate.events.append(event)
                            print("Event Count: \(self.appDelegate.events.count)")
                            eventCount = eventCount + 1
                            self.reloadCalendarViewContoller()
                        }
                    }
                })
            }
        })
    }
    
    func getEventsForSelectedDate(){
        
        // Remove all previous events for date for new events to for date selected
        // Add all events for the date and refresh tableview and calendar
        eventsForDate.removeAll()
        let formatter5 = DateFormatter()
        formatter5.dateFormat = "yyyy-MM-dd"
        for event in appDelegate.events{
            //Get events dates in between
            let eventStrArray = getStringfromDate(event: event).components(separatedBy: ",")
            
            // For event in between dates
            for eventStr in eventStrArray {
                //If date matches selected date
                if dateSelectedText == eventStr {
                    //Add to EventsForDate which is a collection date selected events
                    eventsForDate.append(event)
                }
            }
        }
        //Reload Table and Calendar
        tableView.reloadData()
        calendar.reloadData()
    }
    
    func determineNumOfEventsForDates(){
        let eventHolder = appDelegate.events
        print("Holder: \(eventHolder.count)")
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "yyyy-MM-dd"
        
        //Empty all collections
        datesWithEvent = []
        datesWithNoEvents = []
        datesWithMultipleEvents = []
        
        //Place events in organized collection
        for event in eventHolder {
            
            //Get all events dates in between
            let eventStrArray = getStringfromDate(event: event).components(separatedBy: ",")
            
            // Determine dots in the date
            for eventStr in eventStrArray {
                //print(eventStr)
                // Check if event is in the single event collection
                if datesWithEvent.contains(eventStr){
                    // Remove Event from single event collection
                    // Add Event to No Event to prevent readding to Single Collection
                    // Add Event to Multiple Event collection
                    datesWithNoEvents.append(eventStr)
                    
                    datesWithEvent.remove(at: datesWithEvent.firstIndex(of: eventStr)!)
                    //print("M:\(eventStr)")
                    datesWithMultipleEvents.append(eventStr)
                }else{
                    //Check if event is being readded
                    if datesWithNoEvents.contains(eventStr){
                    }else{
                        //Add event to single view collection
                      //  print("E:\(eventStr)")
                        datesWithEvent.append(eventStr)
                    }
                }
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        calendar.delegate = self
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateText = dateFormatter.string(from: date1)
        
        dateSelectedText = dateFormatter.string(from: Date())
        
       // appDelegate.readEventsFromFirebase()

    }
    
    //Get String from date "item1,item2"
    func getStringfromDate(event: Event) -> String{
        var datesInEventStr = ""
        //Get all dates in between start and end date inclusive
        let formatter4 = DateFormatter()
        formatter4.dateFormat = "yyyy-MM-dd"
        //Get dates in yyyy-MM-dd format in Date datatype
        var datePickerStart = formatter4.date(from: String(event.startDate!.prefix(10)))
        var datePickerEnd = formatter4.date(from: String(event.endDate!.prefix(10)))
        //Checking Whether the two dates are the same
        while datePickerStart!.compare(datePickerEnd!) != .orderedSame {
            if datesInEventStr == "" {
                datesInEventStr = datesInEventStr + formatter4.string(from: datePickerStart!)
            }else{
                datesInEventStr = datesInEventStr + "," + formatter4.string(from: datePickerStart!)
            }
            datePickerStart =  datePickerStart!.addingTimeInterval(24*60*60)
            //print(datePickerStart)
        }
        //Last Add to datesInEventStr
        if datesInEventStr == "" {
            datesInEventStr = datesInEventStr + formatter4.string(from: datePickerStart!)
        }else{
            datesInEventStr = datesInEventStr + "," + formatter4.string(from: datePickerStart!)
        }
        //print(datesInEventStr)
        return datesInEventStr
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
        
        let startDateChanged = change24hrsToAmPm(date: calEvents[indexPath.row].startDate!)
        let endDateChanged = change24hrsToAmPm(date: calEvents[indexPath.row].endDate!)
        
        cell.calTitle?.text = calEvents[indexPath.row].title
        cell.calStartDate?.text = startDateChanged
        cell.calEndDate?.text = endDateChanged

        return cell
    }
    
     
    // 24 hrs to AM/PM
    func change24hrsToAmPm(date: String) -> String {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        let dateF = formatter3.date(from: date)
        
        formatter3.dateFormat = "yyyy-MM-dd hh:mm a"
        
        let dateFS = formatter3.string(from: dateF!)
        //print(dateFS)
        
        return dateFS
        
    }
    
    
    // When the row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //appDelegate.eventID = eventsForDate[indexPath.row].id!
        appDelegate.eventKey = eventsForDate[indexPath.row].key!
        performSegue(withIdentifier: "goToEvent", sender: nil)
    }
    
    
    //Set TableView Cell Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
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
        //print("\(string)")
        //dateText = string
        dateSelectedText = string
        
        // Remove all previous events for date for new events to for date selected
        // Add all events for the date and refresh tableview
        eventsForDate.removeAll()
        let formatter5 = DateFormatter()
        formatter5.dateFormat = "yyyy-MM-dd"
        for event in appDelegate.events{
            let eventStrArray = getStringfromDate(event: event).components(separatedBy: ",")
            
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
        //Alert if user is not logged in
       // if appDelegate.loggedOnID == "-1" {
        if(UserDefaults.standard.bool(forKey: "IsUserLoggedIn") == false){
            //Alert
            let alertController = UIAlertController(title: "Not Logged In", message: "Please log in to use calendar features." , preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancel)
            present(alertController,animated: true)
        }else{
            appDelegate.eventKey = "-1"
            performSegue(withIdentifier: "goToEvent", sender: self)
        }
    }
        
}
    

