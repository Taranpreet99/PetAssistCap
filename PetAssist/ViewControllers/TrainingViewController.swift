//
//  TrainingViewController.swift
//  PetAssist
//
//  Created by xcode on 2020-11-07.
//  Copyright © 2020 Taranpreet Singh Yu Zhang. All rights reserved.
//

import UIKit

class TrainingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var videos : [String] = ["https://www.youtube.com/embed/GkuYhyfkL1g" ,"https://www.youtube.com/embed/dKbWFBIEa9U","https://www.youtube.com/embed/FG9xSgN86BM", "https://www.youtube.com/embed/yLEG7ci-y_I","https://www.youtube.com/embed/JRl1FhIBeKc","https://www.youtube.com/embed/G3-hec29wII", "https://www.youtube.com/embed/jFMA5ggFsXU", "https://www.youtube.com/embed/xpzjtHPQpOk" ]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath) as! TableDataClass
        
        let rownum = indexPath.row
        
        let videourl = NSURL(string: self.videos[rownum])
        
        let requestObj = URLRequest(url: videourl as! URL)
        
        cell.webView.load(requestObj)
        
        return cell
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
