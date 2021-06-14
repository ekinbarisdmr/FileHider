//
//  Photos.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 4.06.2021.
//

import Foundation
import UIKit

class Photos: NSObject, NSCoding {
    
    var selectedImage: UIImage?
    
    init(selectedImage: UIImage) {
        self.selectedImage = selectedImage
    }
    
    override init() {
        super.init()
    }
    required convenience init(coder aCoder: NSCoder) {
        let selectedImage = aCoder.decodeObject(forKey: "selectedImage") as! UIImage
        self.init(selectedImage: selectedImage)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(selectedImage, forKey: "selectedImage")
    }
    
}
