//
//  PetFoodViewController.swift
//  PetAssist
//
//  Created by xcode on 2020-11-03.
//  Copyright © 2020 Taranpreet Singh Yu Zhang. All rights reserved.
//

import UIKit

class PetFoodViewController: UITableViewController {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func dogFood(sender: Any){
        
        mainDelegate.tableName = "Select dog breed:"
        
         mainDelegate.listData = ["Labrador Retriever", "German Shepherd", "Golden Retrievers", "French Bulldogs", "Bulldogs", "Beagles", "Poodles", "Rottweilers", "German Shorthaired Pointers", "Yorkshire Terriers", "Boxers" , "Dachshunds" ]
        
        //Array to store source of information URL for each first aid
        mainDelegate.siteData = ["https://dogfood.guide/labrador-retrievers/","https://dogfood.guide/german-shepherd/", "https://dogfood.guide/golden-retrievers/", "https://dogfood.guide/french-bulldog/", "https://dogfood.guide/bulldog/", "https://dogfood.guide/beagles/","https://dogfood.guide/poodles/", "https://dogfood.guide/rottweilers/", "https://dogfood.guide/german-shorthaired-pointers/","https://dogfood.guide/yorkshire-terriers/", "https://dogfood.guide/boxers/", "https://dogfood.guide/dachshund/"]
    }
    
    @IBAction func foodsToAvoid(sender: Any){
        mainDelegate.selectedURL = "https://www.caninejournal.com/foods-not-to-feed-dog/"
    }
    
    @IBAction func catFood(sender : Any){
        mainDelegate.selectedURL = "https://www.vet.cornell.edu/departments-centers-and-institutes/cornell-feline-health-center/health-information/feline-health-topics/feeding-your-cat"
    }
    
    @IBAction func birdFood(sender : Any){
        mainDelegate.selectedURL = "https://www.petcoach.co/article/bird-nutrition-feeding-pet-birds-parrot-diets-and-nutrition/"
    }
    
    @IBAction func fishFood(sender : Any){
        mainDelegate.selectedURL = "https://www.thesprucepets.com/feeding-your-aquarium-fish-1380920"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
