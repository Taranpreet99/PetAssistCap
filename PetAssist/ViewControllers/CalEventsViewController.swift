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
                    eventTitleText.text = event.title
                    eventDetailText.text = event.details
                    mystartDatePicker.date = formatter3.date(from: event.startDate!)!
                    myendDatePicker.date = formatter3.date(from: event.endDate!)!
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
