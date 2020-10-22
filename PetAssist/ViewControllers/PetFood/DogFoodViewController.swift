//
//  PetFoodViewController.swift
//  PetAssist
//
//  Created by xcode on 2020-10-22.
//  Copyright © 2020 Taranpreet Singh Yu Zhang. All rights reserved.
//

import UIKit

class DogFoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listData = ["1. Labrador Retriever", "2. German Shepherd", "3. Golden Retrievers", "4. French Bulldogs", "5. Bulldogs", "6. Beagles", "7. Poodles", "8. Rottweilers", "9. German Shorthaired Pointers", "10. Yorkshire Terriers", "11. Boxers" , "12. Dachshunds", "13. Pembroke Welsh Corgis", "14. Siberian Huskies"  ]
    
    //Array to store source of information URL for each first aid
    var siteData: [String] = ["https://vcahospitals.com/know-your-pet/testing-for-signs-of-bleeding", "https://animals.howstuffworks.com/pets/how-to-give-first-aid-to-your-dog6.htm", "https://www.youtube.com/watch?v=eo_1OHNc_w4", "https://www.youtube.com/watch?v=ZWQXtlBHU6k", "https://www.thesprucepets.com/eye-injuries-in-dogs-4126601", "https://www.youtube.com/watch?v=cMYSVin-Itw"]
    
    
    // Unwind segue to first aid page
    @IBAction func unwindToDogFoodVC(sender : UIStoryboardSegue){
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // The number of rows of table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    // The height of each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //tableView.rowHeight =
        return UITableView.automaticDimension
    }
    
    // Row content
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell : TableCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableCell ?? TableCell(style:UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        let rowNum = indexPath.row
        let article = listData[rowNum]
        
        tableCell.primaryLabel.text =  article
        tableCell.textLabel?.numberOfLines = 0
        
        
        return tableCell
    }
    
    // When the row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        mainDelegate.selectedURL = siteData[indexPath.row]
        
        performSegue(withIdentifier: "FirstAidToSite", sender: nil)
    }
    
    
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


