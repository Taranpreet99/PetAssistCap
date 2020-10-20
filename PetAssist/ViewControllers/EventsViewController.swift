//
//  EventsViewController.swift
//  PetAssist
//
//  Created by Taranpreet Singh on 2020-04-01.
//  Copyright © 2020 Taranpreet Singh . All rights reserved.
//  Developed by Taranpreet Singh

import UIKit
import EventKit


class EventsViewController: UIViewController {

    //Connected to reminder textfield
    @IBOutlet weak var reminderText: UITextField!
    //Connected to date picker
    @IBOutlet weak var myDatePicker: UIDatePicker!
    
    @IBAction func unwindToEvents(sender: UIStoryboardSegue){
        
    }
    
    //app delegate object ot use AppDelegate in this file
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //Function to set reminder in the reminders app
    @IBAction func setReminder(_ sender: AnyObject) {
        
        if appDelegate.eventStore == nil {
            appDelegate.eventStore = EKEventStore()
            
            //Request for access to reminders app
            appDelegate.eventStore?.requestAccess(
                to: EKEntityType.reminder, completion: {(granted, error) in
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
            self.createReminder()
           let alert = UIAlertController(title: "Reminder Saved", message: "Your reminder has been saved in the reminder app. You will be notified.", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(ok)
            present(alert, animated: true)
        }
    }
    
    //Function to create a reminder
    func createReminder() {
        
        let reminder = EKReminder(eventStore: appDelegate.eventStore!)
        
        //set the title of the reminder
        reminder.title = reminderText.text!
        //set date and time
        reminder.calendar =
            appDelegate.eventStore!.defaultCalendarForNewReminders()
        let date = myDatePicker.date
        let alarm = EKAlarm(absoluteDate: date)
        
        reminder.addAlarm(alarm)
        
        do {
            try appDelegate.eventStore?.save(reminder,
                                             commit: true)
        } catch let error {
            print("Reminder failed with error \(error.localizedDescription)")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        reminderText.endEditing(true)
    }
    
    
    

}
