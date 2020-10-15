//
//  Data.swift
//  PetAssist
//
//  Created by Taranpreet Singh on 2020-03-27.
//  Copyright © 2020 Taranpreet Singh Yu Zhang. All rights reserved.
//

import UIKit

class Data: NSObject {
    
    var id : Int?
    var name: String?
    var email : String?
    var username :String?
    var password : String?
    
    
    //function to store data object
    func initWithData(theRow i: Int, theName n : String, theEmail e :String, theUsername u : String, thePassword p : String){
        id = i
        name = n
        email = e
        username = u
        password = p
        
    }
    
}
