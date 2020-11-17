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
          
    // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'

    
    

    @IBOutlet weak var eventAdd: UIButton!
    @IBOutlet weak var eventEdit: UIButton!
    @IBOutlet weak var eventDelete: UIButton!
    
    //Connected to event textfield
    @IBOutlet weak var eventTitleText: UITextField!
    //Connected to event textfield
    @IBOutlet weak var eventDetailText: UITextView!
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
        let eventIDChosen = self.appDelegate.eventID
        
        // Do any additional setup after loading the view.
        if eventIDChosen != -1 {
            eventAdd.isHidden = true
            eventEdit.isHidden = false
            eventDelete.isHidden = false
            
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "yyyy-MM-dd hh:mm"
            
            for event in eventsHolder {
                if eventIDChosen == event.id {
                    //Set the values in the view controller
                    eventTitleText.text = event.title
                    eventDetailText.text = event.details
                    mystartDatePicker.date = formatter3.date(from: event.startDate!)!
                    myendDatePicker.date = formatter3.date(from: event.endDate!)!
                    //Save values
                    oldEventTitle = event.title!
                    oldEventDetails = event.details!
                    oldStartDate = formatter3.date(from: event.startDate!)!
                    oldEndDate = formatter3.date(from: event.endDate!)!
                }
            }
        }else{
            eventAdd.isHidden = false
            eventEdit.isHidden = true
            eventDelete.isHidden = true
        }
        
    }
    
    //Add Event
    @IBAction func addEvent(){

        //Add event to phone
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

        //Add Event in Database
        //Empty fields validation
        if(eventTitleText.text == "" || eventDetailText.text == "" || mystartDatePicker.date > myendDatePicker.date){
                   
                   let alertController = UIAlertController(title: "Missing fields", message: "Please make sure you are not missing any fields." , preferredStyle: .alert)
                   
                   let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                   
                   
                   alertController.addAction(cancel)
                   present(alertController,animated: true)
                   
               }else{
               
            
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "yyyy-MM-dd hh:mm"
            let startDate = formatter3.string(from: mystartDatePicker.date)
            let endDate = formatter3.string(from: myendDatePicker.date)
            
                   let event : Event = Event.init()
            event.initWithData(theRow: 0, theTitle: eventTitleText.text!, theDetails: eventDetailText.text!, theStartDate: startDate, theEndDate: endDate)
                   
                   let mainDelegate = UIApplication.shared.delegate as! AppDelegate
                   
            let returnCode = mainDelegate.insertEventIntoDatabase(event: event);
                   
                   var returnMsg : String = "Inserted Successfully"
                   
                 if returnCode == false { returnMsg = "Insertion failed"}
                    
                 print("\(returnMsg)")
               }
        
        //Go back to previous view controller
           _ = navigationController?.popViewController(animated: true)
    }
    
    
    //Edit Event
    @IBAction func editEvent(){
        
        //Edit Event in Phone
        
        //Delete Event in Phone
        var eventPhoneId = ""
        let calendars = eventStore.calendars(for: .event)
               
        //Get all events from phone
        for calendar in calendars {
                   //Check if calendar has title
                       
                       let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
                       let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
                       
                       let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar])
                       
                       var events = eventStore.events(matching: predicate)
                       
                       for event in events {
                           if event.title == oldEventTitle && event.notes == oldEventDetails && event.startDate == oldStartDate &&
                               event.endDate == oldEndDate
                               {
                              // eventPhoneId = event.eventIdentifier
                                   do{
                                       (try eventStore.remove(event, span: EKSpan.thisEvent, commit: true))
                                        print("Passed Removed")
                                   }
                                   catch let error {
                                    print(error.localizedDescription)
                                   }
                           }
                       }
        }
        
        //Save Event in Phone
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
        
        //Edited Event from database
        //Empty fields validation
        if(eventTitleText.text == "" || eventDetailText.text == "" || mystartDatePicker.date > myendDatePicker.date){
                   
                   let alertController = UIAlertController(title: "Missing fields", message: "Please make sure you are not missing any fields." , preferredStyle: .alert)
                   
                   let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                   
                   
                   alertController.addAction(cancel)
                   present(alertController,animated: true)
                   
               }else{
               
            
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "yyyy-MM-dd hh:mm"
            let startDate = formatter3.string(from: mystartDatePicker.date)
            let endDate = formatter3.string(from: myendDatePicker.date)
            
            let eventsID = appDelegate.eventID
            
                   let event : Event = Event.init()
            event.initWithData(theRow: eventsID, theTitle: eventTitleText.text!, theDetails: eventDetailText.text!, theStartDate: startDate, theEndDate: endDate)
                   
                   let mainDelegate = UIApplication.shared.delegate as! AppDelegate
                   
            let returnCode = mainDelegate.editEventIntoDatabase(event: event);
                   
                   var returnMsg : String = "Edited Row Successfully"
                   
                 if returnCode == false { returnMsg = "Edited Row failed"}
                    
                 print("\(returnMsg)")
               }
        
     //Go back to previous view controller
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    //Delete Event
    @IBAction func deleteEvent(){
        
        //Delete Event from phone
        
        var eventPhoneId = ""
        let calendars = eventStore.calendars(for: .event)
        
        //Get all events from phone
        for calendar in calendars {
            //Check if calendar has title
                
                let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
                let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
                
                let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar])
                
                var events = eventStore.events(matching: predicate)
                
                for event in events {
                    if event.title == oldEventTitle && event.notes == oldEventDetails && event.startDate == oldStartDate &&
                        event.endDate == oldEndDate
                        {
                       // eventPhoneId = event.eventIdentifier
                            do{
                                (try eventStore.remove(event, span: EKSpan.thisEvent, commit: true))
                            }
                            catch let error {
                                print(error.localizedDescription)
                            }
                    }
                }
        }
       // return

        /*
        let eventIDChosen = self.appDelegate.eventID
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "yyyy-MM-dd hh:mm"
        var stDate = Date() as NSDate?
        var enDate = Date() as NSDate?
        for event in appDelegate.events {
            if eventIDChosen == event.id {
                let stDate = formatter3.date(from: event.startDate!)! as NSDate?
                let enDate = formatter3.date(from: event.endDate!)! as NSDate?
            }
        }
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
               var startDate = stDate
               var endDate = enDate
            let predicate2 = self.appDelegate.eventStore!.predicateForEvents(withStart: startDate! as Date, end: endDate! as Date, calendars: nil)
               
               print("startDate:\(startDate) endDate:\(endDate)")
            var eV = self.appDelegate.eventStore!.events(matching: predicate2) as [EKEvent]?
               
               if eV != nil {
                   for i in eV! {
                       print("Title  \(i.title)" )
                       print("stareDate: \(i.startDate)" )
                       print("endDate: \(i.endDate)" )
                       do{
                        (try self.appDelegate.eventStore!.remove(i, span: EKSpan.thisEvent, commit: true))
                       }
                       catch let error {
                       }
                       
                   }
               }
        }
        */
           //Delete Events from database
           //Empty fields validation
           if(eventTitleText.text == "" || eventDetailText.text == "" || mystartDatePicker.date > myendDatePicker.date){
                      
                      let alertController = UIAlertController(title: "Missing fields", message: "Please make sure you are not missing any fields." , preferredStyle: .alert)
                      
                      let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                      
                      
                      alertController.addAction(cancel)
                      present(alertController,animated: true)
                      
                  }else{
                  
               
               let formatter3 = DateFormatter()
               formatter3.dateFormat = "yyyy-MM-dd hh:mm"
               let startDate = formatter3.string(from: mystartDatePicker.date)
               let endDate = formatter3.string(from: myendDatePicker.date)
               
                let eventsID = appDelegate.eventID
            
                      let event : Event = Event.init()
               event.initWithData(theRow: eventsID, theTitle: eventTitleText.text!, theDetails: eventDetailText.text!, theStartDate: startDate, theEndDate: endDate)
                      
                      let mainDelegate = UIApplication.shared.delegate as! AppDelegate
                      
               let returnCode = mainDelegate.deleteEventFromDatabase(event: event);
                      
                      var returnMsg : String = "Deleted Row Successfully"
                      
                    if returnCode == false { returnMsg = "Delete Row failed"}
                       
                    print("\(returnMsg)")
                  }
           
        //Go back to previous view controller
           _ = navigationController?.popViewController(animated: true)
           
       }
    
    
    //Hide keyboard when touched outside text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    
    //Add to events database
    
    

}
