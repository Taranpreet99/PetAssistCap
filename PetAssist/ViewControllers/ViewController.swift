//
//  ViewController.swift
//  PetAssist
//  Created by Taranpreet Singh on 2020-03-10.
//  Copyright © 2020 Taranpreet Singh . All rights reserved.
//  Developed by Taranpreet Singh
// Testing
// Testing 2

import UIKit



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
        
       //For loop to compare entered value with every value in the database
        for i in 0..<mainDelegate.people.count{
            
            if(mainDelegate.people[i].username == uname.text){
                
                //Username is there in the database - Time to test password
                if(mainDelegate.people[i].password == pass.text){
                    
                    count = 2
                    mainDelegate.loggedOnID =  mainDelegate.people[i].id!
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
        
            //If both username and password are correct - segue
        if(count == 2){
            self.navigationController?.popToRootViewController(animated: true)
            //self.performSegue(withIdentifier: "SegueToHomePage", sender: nil)
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
      mainDelegate.readDataFromDatabase()
        
        // Do any additional setup after loading the view.
    }


}

