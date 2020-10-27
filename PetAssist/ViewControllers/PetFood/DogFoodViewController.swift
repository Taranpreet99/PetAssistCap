//
//  PetFoodViewController.swift
//  PetAssist
//
//  Created by xcode on 2020-10-22.
//  Copyright © 2020 Taranpreet Singh Yu Zhang. All rights reserved.
//

import UIKit

class DogFoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listData = ["Labrador Retriever", "German Shepherd", "Golden Retrievers", "French Bulldogs", "Bulldogs", "Beagles", "Poodles", "Rottweilers", "German Shorthaired Pointers", "Yorkshire Terriers", "Boxers" , "Dachshunds" ]
    
    //Array to store source of information URL for each first aid
    var siteData: [String] = ["https://dogfood.guide/labrador-retrievers/","https://dogfood.guide/german-shepherd/", "https://dogfood.guide/golden-retrievers/", "https://dogfood.guide/french-bulldog/", "https://dogfood.guide/bulldog/", "https://dogfood.guide/beagles/","https://dogfood.guide/poodles/", "https://dogfood.guide/rottweilers/", "https://dogfood.guide/german-shorthaired-pointers/","https://dogfood.guide/yorkshire-terriers/", "https://dogfood.guide/boxers/", "https://dogfood.guide/dachshund/"]
    
    
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
        let article = "\(rowNum+1). " + listData[rowNum]
        
        tableCell.primaryLabel.text =  article
        tableCell.textLabel?.numberOfLines = 0
        
        
        return tableCell
    }
    
    // When the row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        mainDelegate.selectedURL = siteData[indexPath.row]
        
        performSegue(withIdentifier: "DogToSite", sender: nil)
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


