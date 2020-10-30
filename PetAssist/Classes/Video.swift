//
//  Video.swift
//  PetAssist
//
//  Created by Xcode User on 2020-10-29.
//  Copyright © 2020 Taranpreet Singh Yu Zhang. All rights reserved.
//

import UIKit

class Video: NSObject {

    var videoId:String = ""
    var videoTitle:String = ""
    var videoDescription:String = ""
    
    init( videoId: String, videoTitle: String, videoDescription: String){
        self.videoId = videoId
        self.videoTitle = videoTitle
        self.videoDescription = videoDescription
    }
    
}
