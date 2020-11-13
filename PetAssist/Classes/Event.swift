//
//  Event.swift
//  PetAssist
//
//  Created by Xcode User on 2020-11-11.
//  Copyright © 2020 Taranpreet Singh Yu Zhang. All rights reserved.
//

import UIKit

class Event: NSObject {
       var id : Int?
       var title: String?
       var details : String?
       var startDate :String?
       var endDate : String?
       
       //function to store data object
       func initWithData(theRow i: Int, theTitle t : String, theDetails d :String, theStartDate sd : String, theEndDate ed : String){
           id = i
           title = t
           details = d
           startDate = sd
           endDate = ed
           
       }
}
