//
//  RegisterViewController.swift
//  PetAssist
//
//  Created by Taranpreet Singh on 2020-03-27.
//  Copyright © 2020 Taranpreet Singh . All rights reserved.
//  Developed by Taranpreet Singh

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    //Name textfield
    @IBOutlet var tfName : UITextField!
    //Email textfield
    @IBOutlet var tfEmail : UITextField!
    //Username textfield
    @IBOutlet var tfUsername : UITextField!
    //New password textfield
    @IBOutlet var tfNewPassword : UITextField!
    //Confirm password textfield
    @IBOutlet var tfConfirmPassword : UITextField!
    
    //Function to be performed when add button is clicked
    @IBAction func addPerson(sender : Any){
        
        //Empty fields validation
        if(tfName.text == "" || tfEmail.text == "" || tfUsername.text == "" || tfNewPassword.text == "" || tfConfirmPassword.text == ""){
            
            let alertController = UIAlertController(title: "Missing fields", message: "Please make sure you are not missing any fields." , preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            
            alertController.addAction(cancel)
            present(alertController,animated: true)
            
        }else{
        
        var password : String!
        if(tfNewPassword.text == tfConfirmPassword.text){
            
            password = tfConfirmPassword.text
            
            /*
            //let person : Data = Data.init()
            //person.initWithData(theRow: 0, theName: tfName.text!, theEmail: tfEmail.text!, theUsername: tfUsername.text!, thePassword: password)
            
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            
           //let returnCode = mainDelegate.insertIntoDatabase(person: person)
            
            var returnMsg : String = "Registered Successfully"
            
          if returnCode == false {
                returnMsg = "Register failed"
 
            }
            
            let alertController = UIAlertController(title: "Register", message: returnMsg, preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            let login = UIAlertAction(title: "Login", style: .default){
                (UIAlertAction) in
                
                self.performSegue(withIdentifier: "SegueToLogin", sender: nil)
            }
            
            alertController.addAction(login)
            alertController.addAction(cancel)
            present(alertController,animated: true)
 
            
            
    */
                addAccounttoFirebase()
            
        }else{
            let alertController = UIAlertController(title: "Password Does not match", message: "Please make sure you enter same password in both fields", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            
            alertController.addAction(cancel)
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

        // Do any additional setup after loading the view.
    }
    
    //Add Accounts to firebase -Ryan (Will need to readjust for when register page is completed
    func addAccounttoFirebase(){
        
        var rootRef: DatabaseReference!
        
        rootRef = Database.database().reference()
        
        //Child of Root, Events
        let accRef = rootRef.child("Accounts")

        let childAccRef = accRef.childByAutoId()
        
        let accKeyValue = ["AccountID" : childAccRef.key!,
                             "Address" : "",
                             "DogAge" : "",
                             "DogGender" : "",
                             "DogName" : "",
                             "Email" : tfEmail.text!,
                             "FirstName" : tfName.text!,
                             "LastName" : tfName.text!,
                             "Password" : tfConfirmPassword.text!,
                             "Username" : tfUsername.text!] as [String : Any]
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var returnMsg : String = "Registered Successfully"
        
        childAccRef.setValue(accKeyValue){
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
            returnMsg = "Register failed"
          } else {
            //print("Data saved successfully!")
          }
        }
        
        let alertController = UIAlertController(title: "Register", message: returnMsg, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        let login = UIAlertAction(title: "Login", style: .default){
            (UIAlertAction) in
            
            self.performSegue(withIdentifier: "SegueToLogin", sender: nil)
        }
        
        alertController.addAction(login)
        alertController.addAction(cancel)
        present(alertController,animated: true)
    }
   

}


