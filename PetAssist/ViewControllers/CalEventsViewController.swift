//
//  CalEventsViewController.swift
//  PetAssist
//
//  Created by Xcode User on 2020-11-08.
//  Copyright © 2020 Taranpreet Singh Yu Zhang. All rights reserved.
//

import UIKit
import EventKit


class CalEventsViewController: UIViewController {

    
    let eventStore : EKEventStore = EKEventStore()

    //Buttons on view controllers
    @IBOutlet weak var eventAdd: UIButton!
    @IBOutlet weak var eventEdit: UIButton!
    @IBOutlet weak var eventDelete: UIButton!
    
    //Connected to event textfield
    @IBOutlet weak var eventTitleText: UITextField!
    //Connected to date picker
    @IBOutlet weak var mystartDatePicker: UIDatePicker!
    //Connected to date picker
    @IBOutlet weak var myendDatePicker: UIDatePicker!
    
    @IBAction func unwindToEvents(sender: UIStoryboardSegue){
        
    }
    
    //app delegate object ot use AppDelegate in this file
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //Orginal Values of the id
    var oldEventTitle = ""
    var oldEventDetails = ""
    var oldStartDate = Date()
    var oldEndDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let eventsHolder = appDelegate.events
        let eventIDChosen = self.appDelegate.eventKey
        
        // Do any additional setup after loading the view.
        
        //Setup for either Adding Event or Removing/Editing Event
        if eventIDChosen != "-1" {
            //Remove/Editing Event
            eventAdd.isHidden = true
            eventEdit.isHidden = false
            eventDelete.isHidden = false
            
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "yyyy-MM-dd'T'HH:mm"
            
            //Get the event for chosen event
            for event in eventsHolder {
                if eventIDChosen == event.key {
                    //Set the values in the view controller
                    eventTitleText.text = event.title
                    mystartDatePicker.date = formatter3.date(from: event.startDate!)!
                    myendDatePicker.date = formatter3.date(from: event.endDate!)!
                    print("\(event.startDate) | \(event.endDate)")
                    //Save values
                    oldEventTitle = event.title!
                    //oldEventDetails = event.details!
                    oldStartDate = formatter3.date(from: event.startDate!)!
                    oldEndDate = formatter3.date(from: event.endDate!)!
                }
            }
        }else{
            //Adding Event
            eventAdd.isHidden = false
            eventEdit.isHidden = true
            eventDelete.isHidden = true
        }
        
    }
    
    //Add Event
    @IBAction func addEvent(){

        

        

        //Add Event in SQLLite Database
        //Empty fields validation
        if(eventTitleText.text == "" || mystartDatePicker.date > myendDatePicker.date){
                   
                   let alertController = UIAlertController(title: "Missing fields", message: "Please make sure you are not missing any fields." , preferredStyle: .alert)
                   
                   let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                   
                   
                   alertController.addAction(cancel)
                   present(alertController,animated: true)
                   
               }else{
               
            //After tehe check
            
            saveEventInPhone()
            
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "yyyy-MM-dd'T'HH:mm"
            let startDate = formatter3.string(from: mystartDatePicker.date)
            let endDate = formatter3.string(from: myendDatePicker.date)
            var datesInEventStr = ""
            
            
                   let event : Event = Event.init()
            //event.initWithData(theRow: "1", theTitle: eventTitleText.text!, theDetails: "", theStartDate: startDate, theEndDate: endDate, datesInEvent: datesInEventStr, entriesID: appDelegate.loggedOnID)

            event.initWithData(theRow: "1", theTitle: eventTitleText.text!, theDetails: "", theStartDate: startDate, theEndDate: endDate, datesInEvent: datesInEventStr, entriesID: UserDefaults.standard.string(forKey: "Username") as! String)

                   let mainDelegate = UIApplication.shared.delegate as! AppDelegate
                   
            addEventtoFirebase(event: event)
            
        }
        
        //appDelegate.loadCalendarAndTable = 1
        //Go back to previous view controller
           _ = navigationController?.popViewController(animated: true)
    }
    
    
    func addEventtoFirebase(event: Event){
        let eventKeyValue = ["end" : event.endDate!,
                             "start" : event.startDate!,
                             "Subject" : event.title!,
                             "UserName" : event.entriesID!] as [String : Any]
        
        var rootRef: DatabaseReference!
        
        rootRef = Database.database().reference()
        
        //Child of Root, Events
        let eventRef = rootRef.child("Events")

        let childEventRef = eventRef.childByAutoId()
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        childEventRef.setValue(eventKeyValue){
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print("Data saved successfully!")
          }
        }
    }
    
    
    //Edit Event
    @IBAction func editEvent(){
        
        //Edit Event in Phone
        

        
        
        //Edited Event from database
        //Empty fields validation
        if(eventTitleText.text == "" || mystartDatePicker.date > myendDatePicker.date){
                   
                   let alertController = UIAlertController(title: "Missing fields", message: "Please make sure you are not missing any fields." , preferredStyle: .alert)
                   
                   let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                   
                   
                   alertController.addAction(cancel)
                   present(alertController,animated: true)
                   
        }else{
            //After the check
            
            deleteEventFromPhone()
            saveEventInPhone()
            
            
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "yyyy-MM-dd'T'HH:mm"
            let startDate = formatter3.string(from: mystartDatePicker.date)
            let endDate = formatter3.string(from: myendDatePicker.date)
            
            var datesInEventStr = ""
            
            let eventsID = appDelegate.eventID
            
            let event : Event = Event.init()
            event.initWithData(theRow: eventsID, theTitle: eventTitleText.text!, theDetails: "", theStartDate: startDate, theEndDate: endDate, datesInEvent: datesInEventStr, entriesID: appDelegate.loggedOnID)
                   

          
            
            editEventinFirebase(event: event)
            
        }
        
        appDelegate.loadCalendarAndTable = 1
     //Go back to previous view controller
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    func editEventinFirebase(event: Event){
        let eventKeyValue = ["end" : event.endDate!,
                             "start" : event.startDate!,
                             "Subject" : event.title!,
                             "UserName" : event.entriesID!] as [String : Any]
        
        var rootRef: DatabaseReference!
        
        rootRef = Database.database().reference()
        
        //Child of Root, Events
        let eventRef = rootRef.child("Events")

        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        eventRef.child(mainDelegate.eventKey).updateChildValues(eventKeyValue){
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Edit Data could not be saved: \(error).")
          } else {
            print("Edit Data saved successfully!")
          }
        }
    }
    
    //Delete Event
    @IBAction func deleteEvent(){
        
            deleteEventFromPhone()
            
            deleteEventFromFirebase()
           
        appDelegate.loadCalendarAndTable = 1
        
        //Go back to previous view controller
           _ = navigationController?.popViewController(animated: true)
           
    }
    
    
    func deleteEventFromFirebase(){
        var rootRef: DatabaseReference!
        
        rootRef = Database.database().reference()
        
        //Child of Root, Events
        let eventRef = rootRef.child("Events")
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        eventRef.child(mainDelegate.eventKey).removeValue(){
        //child(mainDelegate.eventKey).updateChildValues(eventKeyValue){
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be removed: \(error).")
          } else {
            print("Data removed successfully!")
          }
        }
        
        //Go back to previous view controller
        //   _ = navigationController?.popViewController(animated: true)

    }
        
    
    func deleteEventFromPhone(){
        
        //Delete Event from phone
        let calendars = eventStore.calendars(for: .event)
        
        //Get all events from phone
        for calendar in calendars {
            //Check if calendar has title
                
                let timeAgo = NSDate(timeIntervalSinceNow: -20*30*24*3600)
                let timeAfter = NSDate(timeIntervalSinceNow: +20*30*24*3600)
                
                let predicate = eventStore.predicateForEvents(withStart: timeAgo as Date, end: timeAfter as Date, calendars: [calendar])
                
                var events = eventStore.events(matching: predicate)
                
                for event in events {
                    if event.title == oldEventTitle
                        {
                            
                            //  &&
                            let formatter3 = DateFormatter()
                            formatter3.dateFormat = "yyyy-MM-dd'T'HH:mm"
                            print("Event Found")
                            
                            if(formatter3.string(from: event.startDate!) == formatter3.string(from: oldStartDate) && formatter3.string(from: event.endDate!) == formatter3.string(from: oldEndDate)){
                                    print("Event Matched")
                                    do{
                                        (try eventStore.remove(event, span: EKSpan.thisEvent, commit: true))
                                    }
                                    catch let error {
                                        print(error.localizedDescription)
                                    }
                            
                            }
                            
                         

                       // eventPhoneId = event.eventIdentifier

                    }else{
                        //It will print the if the event is found and won't if it isn't
                        //print("No Events Found")
                    }
                }
        }
    }
    
    func saveEventInPhone(){
        
        //Save Event in Phone
        eventStore.requestAccess(to: .event) { (granted, error) in
          
          if (granted) && (error == nil) {
              print("granted \(granted)")
              print("error \(error)")
              
            let event:EKEvent = EKEvent(eventStore: self.eventStore)
              
            event.title = self.eventTitleText.text
            event.startDate = self.mystartDatePicker.date
            event.endDate = self.myendDatePicker.date
            //event.notes = self.eventDetailText.text
            event.calendar = self.eventStore.defaultCalendarForNewEvents
            var addedAlarms = 0
            var evStartDate = event.startDate
            while evStartDate!.compare(event.endDate) == .orderedAscending {
                let alarm = EKAlarm(absoluteDate: evStartDate!)
                addedAlarms = addedAlarms + 1
                evStartDate = evStartDate!.addingTimeInterval(24*60*60)
                event.addAlarm(alarm)
            }
            if addedAlarms == 0 {
                let alarm = EKAlarm(absoluteDate: evStartDate!)
                addedAlarms = addedAlarms + 1
                event.addAlarm(alarm)
            }
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
    }
    
    //Hide keyboard when touched outside text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }

}

