//
//  HomePageViewController.swift
//  PetAssist
//
//  Created by Taranpreet Singh on 2020-03-27.
//  Copyright © 2020 Taranpreet Singh. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var logoutButton : UIBarButtonItem!
    
    
    @IBOutlet var lblWelcome : UILabel!
    
    @IBAction func unwindToHomePage(sender : UIStoryboardSegue){
        
        homePageItems()
        
        
        
    }
    
    @IBAction func onClickLogin(){
        
        if(UserDefaults.standard.bool(forKey: "IsUserLoggedIn") == true){
            
            alertAlreadyLoggedIn(message: "A user is already logged in, do you want to logout current user?", title: "Already logged In")
            
        }else{
            
            self.performSegue(withIdentifier: "segueToLogin", sender: nil)
            
        }
        
    }
    
    func homePageItems(){
        if(UserDefaults.standard.bool(forKey: "IsUserLoggedIn") == true){
        
            lblWelcome.text = "Hi \(UserDefaults.standard.object(forKey: "UserFirstName") as! String ), Welcome to PetAssist!"
            logoutButton.title = "Logout"
            
         }else{
            
            lblWelcome.text = "Welcome to PetAssist!"
            logoutButton.title = "login"
        }
    }
    
    
    @IBAction func onClickNewPet(){
        mainDelegate.tableName = "Getting a new pet?"
        
        mainDelegate.listData = ["Take a Dog breed selector quiz", "Things to Consider before getting a pet","Find adoptable pets near you", "Items to Put on Your Shopping List", "Preparing your home for new pet", "Pet Health Insurance", "Dog Grooming Tips", "Travelling with a Pet"]
        mainDelegate.siteData = [ "https://dogtime.com/quiz/dog-breed-selector","https://www.petmd.com/dog/care/evr_multi_10_things_consider_before_pet_adoption","https://www.petsmart.com/adoption/people-saving-pets/ca-adoption-landing.html","http://www.vetstreet.com/our-pet-experts/new-dog-owner-guide-21-items-to-put-on-your-shopping-list", "https://www.petcoach.co/article/8-tips-to-prepare-your-home-for-a-new-pet/","https://www.petinsurance.com/healthzone/ownership-adoption/pet-ownership/pet-owner-topics/8-tips-for-choosing-pet-health-insurance/", "https://www.dogviously.com/basic-dog-grooming-tips/", "https://www.mentalfloss.com/article/586073/pet-travel-safety-tips"]

        
        
    }
    
    @IBAction func logout(sender: Any){
        
        if(UserDefaults.standard.bool(forKey: "IsUserLoggedIn") == true){
                      
                        alertAlreadyLoggedIn(message: "Do you want to logout?", title: "Loogut Request")
                          
                       }else{
                          
                           self.performSegue(withIdentifier: "segueToLogin", sender: nil)
                          
                      }
        
        
    }


    func logoutFunc(){
               
                   logoutButton.title = "Login"
        lblWelcome.text = "Welcome to PetAssist!"
        UserDefaults.standard.set(false, forKey: "IsUserLoggedIn")
            
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

                
         homePageItems()

        
        // Do any additional setup after loading the view.
    }
    
    
    func alertAlreadyLoggedIn(message: String, title: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                                      
                                      let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                                      
                                      let logout = UIAlertAction(title: "Logout", style: .default){
                                          (UIAlertAction) in
                                          
                                        self.logoutFunc()
                                      }
                                      
                                      alertController.addAction(cancel)
                                      alertController.addAction(logout)
                                      self.present(alertController,animated: true)
        
    }

   

}
