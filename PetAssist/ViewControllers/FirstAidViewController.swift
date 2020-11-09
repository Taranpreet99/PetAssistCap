//
//  FirstAidViewController.swift
//  PetAssist
//
//  Created by Xcode User on 2020-03-27.
//  Copyright © 2020 . All rights reserved.

import UIKit

class FirstAidViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //array to store -List of injuries
    var listData = ["Bleeding Skin", "Burns", "Choking", "Convulsions", "Eye Injury", "Resuscitation" ]
    
    //Array to store source of information URL for each first aid
    var siteData: [String] = ["https://vcahospitals.com/know-your-pet/first-aid-for-bleeding-in-dogs", "https://animals.howstuffworks.com/pets/how-to-give-first-aid-to-your-dog6.htm", "https://www.youtube.com/watch?v=eo_1OHNc_w4", "https://www.youtube.com/watch?v=ZWQXtlBHU6k", "https://www.thesprucepets.com/eye-injuries-in-dogs-4126601", "https://www.youtube.com/watch?v=cMYSVin-Itw"]
    
    //Array to store image name of each injury
    var imageData: [String] = ["bleeding.png", "burns.png", "choking.png", "convulsions.png", "eyeinjury.png", "resuscitation.png"]
    
    // Unwind segue to first aid page
    @IBAction func unwindToFirstAidVC(sender : UIStoryboardSegue){
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // The number of rows of table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    // The hight of each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Row content
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : SiteCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SiteCell ?? SiteCell(style:UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        let rowNum = indexPath.row
        let injury = listData[rowNum]
        let imgName = UIImage(named:imageData[rowNum])
        
        tableCell.primaryLabel.text =  injury
        tableCell.myImageView.image = imgName
        
        tableCell.accessoryType = .disclosureIndicator
        
        return tableCell
    }
    
    // When the row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        mainDelegate.selectedURL = siteData[indexPath.row]
        
        performSegue(withIdentifier: "FirstAidToSite", sender: nil)
    }
    


}
