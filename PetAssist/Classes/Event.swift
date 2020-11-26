//
//  Event.swift
//  PetAssist
//
//  Created by Xcode User on 2020-11-11.
//  Copyright © 2020 Taranpreet Singh Yu Zhang. All rights reserved.
//

import UIKit

class Event: NSObject {
       var id : String?
       var title: String?
       var details : String?
       var startDate :String?
       var endDate : String?
       var datesInEvent : String?
       var entriesID : String?
    
       //function to store data object
    func initWithData(theRow i: String, theTitle t : String, theDetails d :String, theStartDate sd : String, theEndDate ed : String, datesInEvent datInEv : String, entriesID entID : String){
           id = i
           title = t
           details = d
           startDate = sd
           endDate = ed
           datesInEvent = datInEv
           entriesID = entID
       }
}
