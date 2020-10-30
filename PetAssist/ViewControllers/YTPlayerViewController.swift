//
//  YTPlayerViewController.swift
//  PetAssist
//
//  Created by Xcode User on 2020-10-29.
//  Copyright © 2020 Taranpreet Singh Yu Zhang. All rights reserved.
//

import UIKit
import AVKit

class YTPlayerViewController: UIViewController {

    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    let videoUrl = "https://www.youtube.com/watch?v=NIOMtSzfpck"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = URL(string: videoUrl)
        self.getThumbanilFromImage(url: url!) { (thumbImage) in
            self.thumbnailImageView.image = thumbImage
            
        }
    }
    

    func getThumbanilFromImage(url: URL, completion: @escaping ((_ image: UIImage?)->Void))
    {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            
            let thumbnailTimes = CMTimeMake(value: 7, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumbnailTimes, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                
                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            }catch{
                print(error.localizedDescription)
            }
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

}
