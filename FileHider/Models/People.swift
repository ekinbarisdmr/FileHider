//
//  People.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 4.06.2021.
//

import Foundation
import UIKit

class People: NSObject, NSCoding {
    
    var name: String?
    var number: String?
    var mail: String?
    var img: UIImage?

    init(name: String, number: String, mail: String, img: UIImage) {
        
        self.name = name
        self.number = number
        self.mail = mail
        self.img = img
    }
    
    override init() {
        super.init()
    }
    
    required convenience init(coder aCoder: NSCoder) {
        let name = aCoder.decodeObject(forKey: "name") as! String
        let number = aCoder.decodeObject(forKey: "number") as! String
        let mail = aCoder.decodeObject(forKey: "mail") as! String
        let img = aCoder.decodeObject(forKey: "img") as! UIImage
        
        self.init(name: name, number: number, mail: mail, img: img)
    }
    
    func encode(with acoder: NSCoder) {
        acoder.encode(name,forKey: "name")
        acoder.encode(number,forKey: "number")
        acoder.encode(mail,forKey: "mail")
        acoder.encode(img,forKey: "img")
        
    }
}
