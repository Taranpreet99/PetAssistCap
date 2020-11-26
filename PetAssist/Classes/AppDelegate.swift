//
//  AppDelegate.swift
//  PetAssist
//
//  Created by Taranpreet Singh on 2020-03-10.
//  Copyright © 2020 Taranpreet Singh Yu Zhang. All rights reserved.
//

import UIKit
import SQLite3
import UserNotifications
import EventKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var databaseName : String? = "PetAssistDB.db"
    var databasePath : String?
    var people : [Data] = []
    var events : [Event] = []
    var trainingOptions : [String] = ["Behavioral training", "Obedience training", "Agility training", "Vocational training"]
    
    var tableName : String = "PetAssist"
    
    var eventStore: EKEventStore?
    
    var selectedURL : String = ""
    var eventID : String = "-1"
    
    //See if user is signed in
    var loggedOnID = "-1"
    
    var siteData = [String]()
    var listData = [String]()
    var identifier : String = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        /*
        var ref: DatabaseReference!

        ref = Database.database().reference()
        
        ref.child("Accounts").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                return
            }
            
            print("Value:\(value)")
        })
        */
        // Override point for customization after application launch.
        
        let notiCenter = UNUserNotificationCenter.current()
        notiCenter.requestAuthorization(options: [.alert, .badge, .sound]){ (didAllow, e) in }
        
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentsDir = documentPaths[0]
        
        databasePath = documentsDir.appending("/"+databaseName!)
        checkAndCreateDatabase()
        
        readEventsFromDatabase()
        readDataFromDatabase()

        
        return true
    }

    //Function to read data from the database
    func readDataFromDatabase(){
        
        print("" + self.databasePath!)
        
        people.removeAll()
        
        var db : OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK{
            
            print("successfully opened connection to database at \(self.databasePath)")
            
            var queryStatement : OpaquePointer? = nil
            var queryStatementString : String = "Select * from entries"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                while sqlite3_step(queryStatement) == SQLITE_ROW{
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cname = sqlite3_column_text(queryStatement, 1)
                    let cemail = sqlite3_column_text(queryStatement, 2)
                    let cUsername = sqlite3_column_text(queryStatement, 3)
                    let cPassword = sqlite3_column_text(queryStatement, 4)
                    
                    let name = String(cString : cname!)
                    let email = String(cString : cemail!)
                    let username = String(cString : cUsername!)
                    let password = String(cString : cPassword!)
                    
                    let data : Data = Data.init()
                    data.initWithData(theRow: id, theName: name, theEmail: email, theUsername: username, thePassword: password)
                    people.append(data)
                    
                  //  print("Query result")
                    print("\(id) | \(name) | \(email) | \(username)")
                    
                    
                    
                    
                    
                }
                
                sqlite3_finalize(queryStatement)
                
            }else{
                print("Select statement could not be prepared")
            }
            
            sqlite3_close(db)
            
        }else{
            print("Unable to open database")
        }
        
        
    }
    
    
    
    
    
    
    //Function to read data from the database
    func readEventsFromDatabase(){
        
        print("" + self.databasePath!)
        
        events.removeAll()
        
        var db : OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK{
            
            print("successfully opened connection to database at \(self.databasePath)")
            
            var queryStatement : OpaquePointer? = nil
            var queryStatementString : String = "Select * from events"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                while sqlite3_step(queryStatement) == SQLITE_ROW{
                    let cId = sqlite3_column_text(queryStatement, 0)
                    let ctitle = sqlite3_column_text(queryStatement, 1)
                    let cdetail = sqlite3_column_text(queryStatement, 2)
                    let cStartDate = sqlite3_column_text(queryStatement, 3)
                    let cEndDate = sqlite3_column_text(queryStatement, 4)
                    let cDates = sqlite3_column_text(queryStatement, 5)
                    let cEntID = sqlite3_column_text(queryStatement, 6)
                    
                    let id = String(cString : cId!)
                    let title = String(cString : ctitle!)
                    let detail = String(cString : cdetail!)
                    let startDate = String(cString : cStartDate!)
                    let endDate = String(cString : cEndDate!)
                    let dates =  String(cString: cDates!)
                    let entID = String(cString: cEntID!)
                    
                    let event : Event = Event.init()
                    event.initWithData(theRow: id, theTitle: title, theDetails: detail, theStartDate: startDate, theEndDate: endDate, datesInEvent: dates, entriesID: entID)
                    events.append(event)
                    
                  //  print("Query result")
                    print("\(id) | \(title) | \(detail) | \(startDate) | \(endDate)" )
                    
                    
                    
                    
                    
                }
                
                sqlite3_finalize(queryStatement)
                
            }else{
                print("Select statement could not be prepared")
            }
            
            sqlite3_close(db)
            
        }else{
            print("Unable to open database")
        }
        
        
    }
    
    
    //Function to read data from the database
    func readEventsFromDatabaseWithID(){
        
        print("" + self.databasePath!)
        
        events.removeAll()
        
        var db : OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK{
            
            print("successfully opened connection to database at \(self.databasePath)")
            
            var queryStatement : OpaquePointer? = nil
            var queryStatementString : String = "SELECT * from events WHERE entriesid = ?"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                
                let loggedIDStr = String(loggedOnID) as NSString
                sqlite3_bind_text(queryStatement, 1, loggedIDStr.utf8String, -1, nil)
                
                
                while sqlite3_step(queryStatement) == SQLITE_ROW{
                    let cId = sqlite3_column_text(queryStatement, 0)
                    let ctitle = sqlite3_column_text(queryStatement, 1)
                    let cdetail = sqlite3_column_text(queryStatement, 2)
                    let cStartDate = sqlite3_column_text(queryStatement, 3)
                    let cEndDate = sqlite3_column_text(queryStatement, 4)
                    let cDates = sqlite3_column_text(queryStatement, 5)
                    let cEntID = sqlite3_column_text(queryStatement, 6)
                    
                    let id = String(cString : cId!)
                    let title = String(cString : ctitle!)
                    let detail = String(cString : cdetail!)
                    let startDate = String(cString : cStartDate!)
                    let endDate = String(cString : cEndDate!)
                    let dates =  String(cString: cDates!)
                    let entID = String(cString: cEntID!)
                    
                    let event : Event = Event.init()
                    event.initWithData(theRow: id, theTitle: title, theDetails: detail, theStartDate: startDate, theEndDate: endDate, datesInEvent: dates, entriesID: entID)
                    events.append(event)
                    
                  //  print("Query result")
                    print("\(id) | \(title) | \(detail) | \(startDate) | \(endDate)" )
                    
                    
                    
                    
                    
                }
                
                sqlite3_finalize(queryStatement)
                
            }else{
                print("Select statement could not be prepared")
            }
            
            sqlite3_close(db)
            
        }else{
            print("Unable to open database")
        }
        
        
    }
    
    //Function to insert data into the database
    func insertIntoDatabase(person : Data) -> Bool{
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK{
            var insertStatement : OpaquePointer? = nil
            var insertString : String = "insert into entries values(NULL,?,? ,?,?)"
            
            if sqlite3_prepare(db, insertString, -1, &insertStatement, nil) == SQLITE_OK {
                
                let nameStr = person.name! as NSString
                let emailStr = person.email! as NSString
                let usernameStr = person.username! as NSString
                let passwordStr = person.password! as NSString
                
                sqlite3_bind_text(insertStatement, 1, nameStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, emailStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, usernameStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, passwordStr.utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE{
                    
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted row \(rowID)")
                    
                }else{
                    print("Insert statement could not be prepared")
                    returnCode = false
                    
                }
                
                sqlite3_finalize(insertStatement)
                
                
            }else{
                print("Insert statement could not be prepared")
                returnCode = false
            }
            
            sqlite3_close(insertStatement)
        }else{
            print("Unable to open database")
            returnCode = false
        }
        
        return returnCode
        
    }
    
    //Function to insert data into the database
    func insertEventIntoDatabase(event : Event) -> Bool{
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK{
            var insertStatement : OpaquePointer? = nil
            let insertString : String = "insert into events values(NULL,?,? ,?,?,?,?)"
            
            
            if sqlite3_prepare(db, insertString, -1, &insertStatement, nil) == SQLITE_OK {
                
                let titleStr = event.title! as NSString
                let detailStr = event.details! as NSString
                let startDateStr = event.startDate! as NSString
                let endDateStr = event.endDate! as NSString
                let datesStr = event.datesInEvent! as NSString
                let loggedIDStr = String(loggedOnID) as NSString

                
                sqlite3_bind_text(insertStatement, 1, titleStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, detailStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, startDateStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, endDateStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 5, datesStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 6, loggedIDStr.utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE{
                    
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted row \(rowID)")
                    
                }else{
                    print("Insert statement could not be prepared")
                    returnCode = false
                    
                }
                
                sqlite3_finalize(insertStatement)
                
                
            }else{
                print("Insert statement could not be prepared")
                returnCode = false
            }
            
            sqlite3_close(insertStatement)
        }else{
            print("Unable to open database")
            returnCode = false
        }
        
        return returnCode
        
    }
    
    //Function to insert data into the database
    func editEventIntoDatabase(event : Event) -> Bool{
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK{
            var editStatement : OpaquePointer? = nil
            let editString : String = "UPDATE Events SET Title = ? , Detail = ? , StartDate = ? , EndDate = ? , DatesOfEvent = ? , entriesID = ? WHERE Id = ?;"
            
            
            if sqlite3_prepare(db, editString, -1, &editStatement, nil) == SQLITE_OK {
                
                let eventIDStr = String(event.id!) as NSString
                let titleStr = event.title! as NSString
                let detailStr = event.details! as NSString
                let startDateStr = event.startDate! as NSString
                let endDateStr = event.endDate! as NSString
                let datesStr = event.datesInEvent! as NSString
                let entID = String(event.entriesID!) as NSString
                
                sqlite3_bind_text(editStatement, 1, titleStr.utf8String, -1, nil)
                sqlite3_bind_text(editStatement, 2, detailStr.utf8String, -1, nil)
                sqlite3_bind_text(editStatement, 3, startDateStr.utf8String, -1, nil)
                sqlite3_bind_text(editStatement, 4, endDateStr.utf8String, -1, nil)
                sqlite3_bind_text(editStatement, 5, datesStr.utf8String, -1, nil)
                sqlite3_bind_text(editStatement, 6, entID.utf8String, -1, nil)
                sqlite3_bind_text(editStatement, 7, eventIDStr.utf8String, -1, nil)
                
                if sqlite3_step(editStatement) == SQLITE_DONE{
                    
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("Successfully Edited row \(rowID)")
                    
                }else{
                    print("Edit statement could not be prepared")
                    returnCode = false
                    
                }
                
                sqlite3_finalize(editStatement)
                
                
            }else{
                print("Edit statement could not be prepared")
                returnCode = false
            }
            
            sqlite3_close(editStatement)
        }else{
            print("Unable to open database")
            returnCode = false
        }
        
        return returnCode
        
    }
    
    
    //Function to insert data into the database
       func deleteEventFromDatabase(event : Event) -> Bool{
           var db : OpaquePointer? = nil
           var returnCode : Bool = true
           
           if sqlite3_open(self.databasePath, &db) == SQLITE_OK{
               var editStatement : OpaquePointer? = nil
               let editString : String = "DELETE FROM Events WHERE Id = ?;"
               
               
               if sqlite3_prepare(db, editString, -1, &editStatement, nil) == SQLITE_OK {
                   
                   let eventIDStr = String(event.id!) as NSString
                   
                   sqlite3_bind_text(editStatement, 1, eventIDStr.utf8String, -1, nil)
                
                   if sqlite3_step(editStatement) == SQLITE_DONE{
                       
                       let rowID = sqlite3_last_insert_rowid(db)
                       print("Successfully Deleted row \(rowID)")
                       
                   }else{
                       print("Delete statement could not be prepared")
                       returnCode = false
                       
                   }
                   
                   sqlite3_finalize(editStatement)
                   
                   
               }else{
                   print("Delete statement could not be prepared")
                   returnCode = false
               }
               
               sqlite3_close(editStatement)
           }else{
               print("Unable to open database")
               returnCode = false
           }
           
           return returnCode
           
       }
    
    
    //Check and create database if it does not exists already
    func checkAndCreateDatabase(){
        
        var success = false
        let fileManager = FileManager.default
        
        success = fileManager.fileExists(atPath: databasePath!)
        
        if success{
            return
        }
        
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/"+databaseName!)
        
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
        
        return
        
    }
    
    
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

