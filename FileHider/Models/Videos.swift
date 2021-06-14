//
//  Videos.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 7.06.2021.
//

import Foundation
import UIKit

class Videos: NSObject, NSCoding {
    
    var videoImage: UIImage?
    var videoUrl: URL?
    
    init(videoImage: UIImage, videoUrl: URL ) {
        self.videoImage = videoImage
        self.videoUrl = videoUrl
    }
    
    override init() {
        super.init()    }
    
    required convenience init(coder aCoder: NSCoder) {
        let videoImage = aCoder.decodeObject(forKey: "videoImage") as! UIImage
        let videoUrl = aCoder.decodeObject(forKey: "videoUrl") as! URL

        self.init(videoImage: videoImage,videoUrl: videoUrl )
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(videoImage, forKey: "videoImage")
        coder.encode(videoUrl, forKey: "videoUrl")

    }
    
}
