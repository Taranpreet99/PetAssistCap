//
//  TrainingVideoViewController.swift
//  PetAssist
//
//  Created by Xcode User on 2020-10-22.
//  Copyright © 2020 Taranpreet Singh Yu Zhang. All rights reserved.
//
import UIKit

class TrainingVideoViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var playerView: YTPlayerView!
    
    var items: [String] = ["48kekFLZkXU", "B5-1_aR20rE"]
    //var ytVideos = [Video]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath) as! CustomTableViewCell
        
       // cell.ytImage.image = UIImage ( named : ytVideos[indexPath.row].)
        cell.ytVideoName.text = items[indexPath.row]
        print("\(items[indexPath.row])")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.playerView.load(withVideoId: items[indexPath.row])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        //self.playerView.load(withVideoId: "M7lc1UVf-VE")
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
