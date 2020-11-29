//
//  ViewController.swift
//  PetAssist
//  Created by Taranpreet Singh on 2020-03-10.
//  Copyright © 2020 Taranpreet Singh . All rights reserved.
//  Developed by Taranpreet Singh
// Testing
// Testing 2

import UIKit
import CommonCrypto
import Foundation

class ViewController: UIViewController, UITextFieldDelegate {
    
    //Username textfield
    @IBOutlet var uname : UITextField!
    //Password field
    @IBOutlet var pass : UITextField!
    //Temporary variable for if else algorithm
    var count = 0
    
    //Variable to use AppDelegate in this class
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //Unwind the segue to this page
    @IBAction func unwindToHome(sender : UIStoryboardSegue){
        
    }
    
    //Code to be run when login button is clicked
    @IBAction func login(sender: UIButton){
        
        //Making sure fields are not left empty
        if(uname.text == "" || pass.text == "" ){
            
            let alertController = UIAlertController(title: "Missing fields", message: "Please make sure you enter username and password." , preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            
            alertController.addAction(cancel)
            present(alertController,animated: true)
            
        }else{
        /*
       //For loop to compare entered value with every value in the database
        for i in 0..<mainDelegate.people.count{
            
            if(mainDelegate.people[i].username == uname.text){
                
                //Username is there in the database - Time to test password
                if(mainDelegate.people[i].password == pass.text){
                    
                    count = 2
                    //Test Name for the logged in user
                    mainDelegate.loggedOnID =  "testacc"
                    mainDelegate.loadCalendarAndTable = 0
                    break
                   
                }else{
                   
                    //Incorrect password
                    let alertController = UIAlertController(title: "Incorrect Password!", message: "Please enter correct password" , preferredStyle: .alert)
                    
                    let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    
                    alertController.addAction(cancel)
                    present(alertController,animated: true)
                    
                }
                
            }else{
                count = 1
            }
            
            
        }
 */
            
            
            count =  readAndLoginFromFirebase(username: uname.text!, password: pass.text!)
            print(count)
 
            //If both username and password are correct - segue
        if(count == 2){
            UserDefaults.standard.set(true, forKey: "IsUserLoggedIn")
            self.performSegue(withIdentifier: "unwindtoHomePage", sender: nil)
        
            
        }
        else{//else username is incorrect
                
                let alertController = UIAlertController(title: "Incorrect Username", message: "Username that you have entered does not exist. Either register or try again", preferredStyle: .alert)
                
                let cancel = UIAlertAction(title: "Try Again!", style: .cancel, handler: nil)
                
                let register = UIAlertAction(title: "Register", style: .default){
                    (UIAlertAction) in
                    
                    self.performSegue(withIdentifier: "SegueToRegister", sender: nil)
                }
                
                alertController.addAction(cancel)
                alertController.addAction(register)
                present(alertController,animated: true)
                
        }
        
        }
        
        
    }
    
    //Hide keyboard when touched outside text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
      //mainDelegate.readDataFromDatabase()
        
        // Do any additional setup after loading the view.
    }

    func MD5(string: String) -> Data {
        let messageData = string.data(using:.utf8)!
        var digestData = Data.init(count: Int(CC_MD5_DIGEST_LENGTH))
        
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }

        return digestData
    }
    
    //Function to read all People from firebase, choose the person with right username and  - Ryan
    func readAndLoginFromFirebase(username : String, password : String) -> Int{
        var rootRef: DatabaseReference!
        
        print("Reading from Database")
        //mainDelegate.people.removeAll()
        var count = 0
        //Root of Data
        rootRef = Database.database().reference()
        
        //Child of Root, Accounts
        let accRef = rootRef.child("Accounts")
        accRef.observeSingleEvent(of: .value, with: { snapshot in
            
            guard let value = snapshot.value as? [String: Any] else {
                return
            }
            
            //Every Key in Accounts
            for key in value.keys {
                
                //Every child in Account
                accRef.child(key).observeSingleEvent(of: .value, with: {
                    snapshot in
                    
                    if let accDict = snapshot.value as? [String:Any] {
                        let userName = accDict["Username"] ?? "Not There"
                        let passWord = accDict["Password"] ?? "Not There"
                        if String(describing: userName) != "Not There" ||
                            String(describing: passWord) != "Not There" {
                            print("\(userName) | \(passWord)")
                            
                            if(count != 2){
                                if(username == "\(userName)"){
                                    print("User: \(username)")
                                    let md5Data = self.MD5(string:"\(username)" + password)
                                    let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
                                    print("md5Hex: \(md5Hex)")

                                    let md5Base64 = md5Data.base64EncodedString()
                                    print("md5Base64: \(md5Base64)")
                                    
                                    
                                    if(password == "\(passWord)"){
                                        
                                        print("Success")
                                        self.mainDelegate.loggedOnID =  username
                                        self.mainDelegate.loadCalendarAndTable = 0
                                        count = 2
                                    }else{
                                        //print("Success")
                                        //Incorrect password
                                        let alertController = UIAlertController(title: "Incorrect Password!", message: "Please enter correct password" , preferredStyle: .alert)
                                        
                                        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                        
                                        
                                        alertController.addAction(cancel)
                                       self.present(alertController,animated: true)
                                    }
                                }else{
                                    count = 1
                                }
                            }
                          
                        
                        }
                    }
                    
                })
                
            }
         
        })
        return count
    }
    
    

}

