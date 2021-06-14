//
//  Notes.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 4.06.2021.
//

import Foundation
import UIKit

class Notes: NSObject, NSCoding {
    
    var note: String?
    var title: String?

    init(note:String, title: String) {
        self.note = note
        self.title = title
    }
    
    override init() {
        super.init() 
    }
    
    required convenience init(coder aCoder: NSCoder) {
        let note = aCoder.decodeObject(forKey: "note") as! String
        let title = aCoder.decodeObject(forKey: "title") as! String
        self.init(note: note, title: title)
    }
    
    func encode(with acoder: NSCoder) {
        acoder.encode(note,forKey: "note")
        acoder.encode(title,forKey: "title")
        
    }
}
