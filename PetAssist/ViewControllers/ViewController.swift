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
import CryptoKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //Username textfield
    @IBOutlet var uname : UITextField!
    //Password field
    @IBOutlet var pass : UITextField!
    //Temporary variable for if else algorithm
    var count = 0
    
    //Variable to use AppDelegate in this class
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    let vc = HomePageViewController()
    
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
            
            
            readAndLoginFromFirebase(username: uname.text!, password: pass.text!)
 
            //If both username and password are correct - segue

        
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
    func readAndLoginFromFirebase(username : String, password : String){
        var rootRef: DatabaseReference!
        
        print("Reading from Database")
        //mainDelegate.people.removeAll()
        //Root of Data
        rootRef = Database.database().reference()
        
        //Child of Root, Accounts
        let accRef = rootRef.child("Accounts")
        accRef.observeSingleEvent(of: .value, with: { snapshot in
            

            
            guard let value = snapshot.value as? [String: Any] else {
                return
            }
            
            var userCountInTotal = value.keys.count
            var userCountNoMatch = 0
            
            //Every Key in Accounts
            for key in value.keys {
                
                
                //Every child in Account in this one time
                accRef.child(key).observeSingleEvent(of: .value, with: {
                    snapshot in
                    
                    if let accDict = snapshot.value as? [String:Any] {
                        let userName = "\(accDict["Username"] ?? "")"
                        let passWord = "\(accDict["Password"] ?? "")"
                        
                        if String(describing: userName) != "" ||
                            String(describing: passWord) != "" {
                        
                            print("\(userName) | \(passWord)")
                            
                                if(username == "\(userName)"){
                                    print("User: \(username)")
                                    let usrNameLower = "\(username)"
                                    var combined =  "\(password)" + usrNameLower.lowercased()
                                    combined = combined.md5()!
                                    
                                    //print(password)
                                    //print(combined)
                                    
                                    if(passWord == combined){
                                        
                                        print("Password Success")
                                        self.mainDelegate.loggedOnID =  username
                                        self.mainDelegate.firstName = accDict["FirstName"] as! String
                                        UserDefaults.standard.set(username, forKey: "Username")
                                        self.mainDelegate.loadCalendarAndTable = 0
                                        UserDefaults.standard.set(true, forKey: "IsUserLoggedIn")
                                        UserDefaults.standard.set("\(self.mainDelegate.firstName)", forKey: "UserFirstName")
                                        self.performSegue(withIdentifier: "unwindtoHomePage", sender: nil)
                                    }else{
                                        
                                        print("Password Failed")
                                        //Incorrect password
                                        let alertController = UIAlertController(title: "Incorrect Password!", message: "Please enter correct password" , preferredStyle: .alert)
                                        
                                        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                        
                                        
                                        alertController.addAction(cancel)
                                       self.present(alertController,animated: true)
                                    }
                                }else{
                                    //Usernaem doesn't match for this user
                                    userCountNoMatch = userCountNoMatch + 1
                                    /*
                                    let alertController = UIAlertController(title: "Incorrect Username", message: "Username that you have entered does not exist. Either register or try again", preferredStyle: .alert)
                                    
                                    let cancel = UIAlertAction(title: "Try Again!", style: .cancel, handler: nil)
                                    
                                    let register = UIAlertAction(title: "Register", style: .default){
                                        (UIAlertAction) in
                                        
                                        self.performSegue(withIdentifier: "SegueToRegister", sender: nil)
                                    }
                                    
                                    alertController.addAction(cancel)
                                    alertController.addAction(register)
                                    self.present(alertController,animated: true)
 */
                                }
                            
                            
                        
                        }else{
                        //Username and Password Not Extracted
                            userCountNoMatch = userCountNoMatch + 1
                        }
                    }
                    
                    if(userCountNoMatch == userCountInTotal){
                        print("User Doesn't Match")
                        
                        let alertController = UIAlertController(title: "Incorrect Username", message: "Username that you have entered does not exist. Either register or try again", preferredStyle: .alert)
                        
                        let cancel = UIAlertAction(title: "Try Again!", style: .cancel, handler: nil)
                        
                        let register = UIAlertAction(title: "Register", style: .default){
                            (UIAlertAction) in
                            
                            self.performSegue(withIdentifier: "SegueToRegister", sender: nil)
                        }
                        
                        alertController.addAction(cancel)
                        alertController.addAction(register)
                        self.present(alertController,animated: true)
                        
                    }
                    
                })
                //After Every Account
            }
 
        })
        
        
        
        
    }
    
    

}






extension String {
    /**
        Get the MD5 hash of this String
     
        - returns: MD5 hash of this String
     */
    func md5() -> String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        
        for i in 0..<digestLength {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deinitialize(count: digestLength)
        
        return String(format: hash as String)
    }
}
