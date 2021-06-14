//
//  Utility.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 8.06.2021.
//

import Foundation
import UIKit
import SystemConfiguration

class Utility {
    
    static var isPremium: Bool {
        
        get {
            let isEnabled = Defaults.value(forKey: UserDefaultsKey.premium) as? Bool
            return isEnabled ?? false
        }
        
        set {
            Defaults.setValue(newValue, forKey: UserDefaultsKey.premium)
        }
    }
    
    static var photoRight: Int {
        
        get {
            let photoRight = Defaults.value(forKey: UserDefaultsKey.photo) as? Int
            return photoRight ?? 3
        }
        
        set {
            Defaults.setValue(newValue, forKey: UserDefaultsKey.photo)
        }
    }
    
    static var noteRight: Int {
        
        get {
            let noteRight = Defaults.value(forKey: UserDefaultsKey.note) as? Int
            return noteRight ?? 3
        }
        
        set {
            Defaults.setValue(newValue, forKey: UserDefaultsKey.note)
        }
    }
    
    static var personRight: Int {
        
        get {
            let noteRight = Defaults.value(forKey: UserDefaultsKey.people) as? Int
            return noteRight ?? 3
        }
        
        set {
            Defaults.setValue(newValue, forKey: UserDefaultsKey.people)
        }
    }
    
    static var isPassword: String {
        
        get {
            let password = Defaults.value(forKey: UserDefaultsKey.password) as? String
            return password ?? ""
        }
        
        set {
            Defaults.setValue(newValue, forKey: UserDefaultsKey.password)
        }
    }
    
    
}

let Defaults = UserDefaults.standard

struct UserDefaultsKey {
    
    static let premium = "isPremium"
    static let photo = "photoRight"
    static let note = "noteRight"
    static let people = "peopleRight"
    static let password = "isPassword"

}
