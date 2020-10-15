//
//  TutorialsViewController.swift
//  PetAssist
//
//  Created by Taranpreet Singh on 2020-03-28.
//  Copyright © 2020 Taranpreet Singh . All rights reserved.
//

import UIKit

class TutorialsViewController: UIViewController {
    
     let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //unwind segue to this view controller when back button is pressed
    @IBAction func UnwindToTutorials(sender: UIStoryboardSegue){
        
        
    }
    
    //Code to be run when Food tutorials button is pressed
    @IBAction func FoodTutorials(sender: Any){
        
        //URL provided to be run web kit view
        mainDelegate.selectedURL = "https://www.youtube.com/results?search_query=home+cooked+pet+food"
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    

}
