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

    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
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
    
    //Add Event to phone
    @IBAction func addEvent(){
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
        
    }
    
    //Add to events database
    
    

}
