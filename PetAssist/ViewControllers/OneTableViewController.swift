//
//  ArticlesViewController.swift
//  PetAssist
//
//  Created by xcode on 2020-10-08.
//  Copyright © 2020 Taranpreet Singh Yu Zhang. All rights reserved.
//

import UIKit

class OneTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var tableView : UITableView!
    
    
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
        return mainDelegate.listData.count
    }
    
    // The hight of each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    // Row content
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let rowNum = indexPath.row
        let article = mainDelegate.listData[rowNum]
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
        mainDelegate.selectedURL = mainDelegate.siteData[indexPath.row]
        
        print("\(mainDelegate.selectedURL)")
        
        performSegue(withIdentifier: "OneTableToSite", sender: nil)
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
