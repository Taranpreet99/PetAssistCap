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
    
    @IBAction func unwindToHomePage(sender : UIStoryboardSegue){
        
    }
    
    @IBAction func onClickNewPet(){
        mainDelegate.tableName = "Getting a new pet?"
        
        mainDelegate.listData = ["Things to Consider before getting a pet", "Items to Put on Your Shopping List", "Preparing your pet for new Home", "Pet Health Insurance", "Dog Grooming Tips", "Travelling with a Pet"]
        mainDelegate.siteData = ["https://www.petmd.com/dog/care/evr_multi_10_things_consider_before_pet_adoption","http://www.vetstreet.com/our-pet-experts/new-dog-owner-guide-21-items-to-put-on-your-shopping-list", "https://www.petcoach.co/article/8-tips-to-prepare-your-home-for-a-new-pet/","https://www.petinsurance.com/healthzone/ownership-adoption/pet-ownership/pet-owner-topics/8-tips-for-choosing-pet-health-insurance/", "https://www.dogviously.com/basic-dog-grooming-tips/", "https://www.mentalfloss.com/article/586073/pet-travel-safety-tips"]
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   

}
