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
    var trainingOptions : [String] = ["Behavioral training", "Obedience training", "Agility training", "Vocational training"]
    
    var eventStore: EKEventStore?
    
    var selectedURL : String = ""
    
    var siteData = [String]()
    var listData = [String]()
    var identifier : String = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let notiCenter = UNUserNotificationCenter.current()
        notiCenter.requestAuthorization(options: [.alert, .badge, .sound]){ (didAllow, e) in }
        
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentsDir = documentPaths[0]
        
        databasePath = documentsDir.appending("/"+databaseName!)
        
        checkAndCreateDatabase()
        
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
                   // print("\(id) | \(name) | \(email) | \(username)")
                    
                    
                    
                    
                    
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

