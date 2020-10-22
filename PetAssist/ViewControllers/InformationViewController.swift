//
//  InformationViewController.swift
//  PetAssist
//
//  Created by xcode on 2020-10-06.
//  Copyright © 2020 Taranpreet Singh Yu Zhang. All rights reserved.
//

import UIKit

class InformationViewController: UITableViewController{
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBAction func unwindToInformation(sender : UIStoryboardSegue){
        
    }
    
    @IBAction func onClickNewPet(){
        mainDelegate.selectedURL = "https://www.raywenderlich.com/5758454-uiscrollview-tutorial-getting-started"
        performSegue(withIdentifier: "infoToWeb", sender: nil)
        
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
