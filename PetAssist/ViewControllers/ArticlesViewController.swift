//
//  ArticlesViewController.swift
//  PetAssist
//
//  Created by xcode on 2020-10-08.
//  Copyright © 2020 Taranpreet Singh Yu Zhang. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBAction func unwindToArticles(sender : UIStoryboardSegue){
        
    }
   

    var listData = ["The Health and Mood-Boosting Benefits of Pets"]
    
     var siteData: [String] = ["https://www.helpguide.org/articles/mental-health/mood-boosting-power-of-dogs.htm"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    // The hight of each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    // Row content
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : TableCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableCell ?? TableCell(style:UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        let rowNum = indexPath.row
        let article = listData[rowNum]
        
        tableCell.primaryLabel.text =  article
        
        tableCell.accessoryType = .disclosureIndicator
        
        return tableCell
    }
    
    // When the row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        mainDelegate.selectedURL = siteData[indexPath.row]
        
        print("\(mainDelegate.selectedURL)")
        
        performSegue(withIdentifier: "ArticleToSite", sender: nil)
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
