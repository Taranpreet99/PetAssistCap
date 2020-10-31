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
   
    
    @IBOutlet var tableView : UITableView!

    var listData = ["The Health and Mood-Boosting Benefits of Pets","Pet obesity is an epidemic","Obesity in Dogs","11 Facts about pet obesity","How to Prevent Obesity In Pets","Treatment of Obesity in Cats and Dogs","5 Reasons Why Pet Obesity Is a Serious Problem","Everything you should know about feeding human food to Dogs and Cats","People Foods to Avoid Feeding Your Pets"]
    
    var siteData: [String] = ["https://www.helpguide.org/articles/mental-health/mood-boosting-power-of-dogs.htm","https://www.aaha.org/publications/newstat/articles/2020-02/pet-obesity-is-an-epidemic/", "https://vcahospitals.com/know-your-pet/obesity-in-dogs","https://www.dosomething.org/us/facts/11-facts-about-pet-obesity","https://moderndogmagazine.com/articles/how-prevent-obesity-pets/89263","https://todaysveterinarypractice.com/nutrition-notes-treatment-of-obesity/","https://www.pethealthnetwork.com/dog-health/dog-diseases-conditions-a-z/5-reasons-why-pet-obesity-a-serious-problem","https://www.wedgewoodpharmacy.com/blog/posts/everything-you-should-know-about-feeding-human-food-to-dogs-and-cats.html","https://www.aspca.org/pet-care/animal-poison-control/people-foods-avoid-feeding-your-pets"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    // The hight of each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    // Row content
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let rowNum = indexPath.row
        let article = listData[rowNum]
        tableCell.textLabel?.text = "\(rowNum+1). \(article)"
        
        
       // tableCell.primaryLabel.text =  article
        tableCell.textLabel?.numberOfLines = 0
        tableCell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        tableCell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        //tableCell.primaryLabel.numberOfLines = 0
       // /tableCell.primaryLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
        
        //tableCell.accessoryType = .disclosureIndicator
        
        
        
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
