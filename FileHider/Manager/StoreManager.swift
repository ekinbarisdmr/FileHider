//
//  StoreManager.swift
//  FileHider
//
//  Created by Ekin Barış Demir on 4.06.2021.
//

import Foundation
import UIKit

class StoreManager {
    
    static let shared = StoreManager()
    
    
    private static func storeNote(data : [Notes]) -> NSData {
        
        return NSKeyedArchiver.archivedData(withRootObject: data as NSArray) as NSData
    }
    
    
    
    private static func storePeople(data : [People]) -> NSData {
        
        return NSKeyedArchiver.archivedData(withRootObject: data as NSArray) as NSData
    }
    
    
    private static func storePhotos(data : [Photos]) -> NSData {
        
        return NSKeyedArchiver.archivedData(withRootObject: data as NSArray) as NSData
    }
    
    private static func storeVideo(data : [Videos]) -> NSData {
        
        return NSKeyedArchiver.archivedData(withRootObject: data as NSArray) as NSData
    }
    
    
    
    func loadNote() -> [Notes]? {
        
        if let unarchivedObject = UserDefaults.standard.object(forKey: "notes") as? Data {
            
            return NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as? [Notes]
        }
        
        return nil
    }
    
    
    func loadPeople() -> [People]? {
        
        if let unarchivedObject = UserDefaults.standard.object(forKey: "people") as? Data {
            
            return NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as? [People]
        }
        
        return nil
    }
    
    
    func loadPhotos() -> [Photos]? {
        
        if let unarchivedObject = UserDefaults.standard.object(forKey: "photos") as? Data {
            
            return NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as? [Photos]
        }
        
        return nil
    }
    
    func loadVideos() -> [Videos]? {
        
        if let unarchivedObject = UserDefaults.standard.object(forKey: "videos") as? Data {
            
            return NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as? [Videos]
        }
        
        return nil
    }
    

    
    func getNote() -> [Notes] {
        var notes: [Notes] = [Notes]()
        if StoreManager.shared.loadNote() == nil {
            StoreManager.shared.saveNote(data: notes)
        }
        else {
            notes = StoreManager.shared.loadNote() ?? []
        }
        return notes
    }
    
    
    func getPeople() -> [People] {
        var people: [People] = [People]()
        if StoreManager.shared.loadPeople() == nil {
            StoreManager.shared.savePeople(data: people)
        }
        else {
            people = StoreManager.shared.loadPeople() ?? []
        }
        return people
    }
    
    func getGallery() -> [Photos] {
        var photos: [Photos] = [Photos]()
        if StoreManager.shared.loadPhotos() == nil {
            StoreManager.shared.savePhotos(data: photos)
        }
        else {
            photos = StoreManager.shared.loadPhotos() ?? []
        }
        return photos
    }
    
    func getVideos() -> [Videos] {
        var videos: [Videos] = [Videos]()
        if StoreManager.shared.loadVideos() == nil {
            StoreManager.shared.saveVideos(data: videos)
        }
        else {
            videos = StoreManager.shared.loadVideos() ?? []
        }
        return videos
    }
    

    
    
    func saveNote(data : [Notes]?) {
        
        let archivedObject = StoreManager.storeNote(data: data!)
        UserDefaults.standard.set(archivedObject, forKey: "notes")
        
        UserDefaults.standard.synchronize()
    }
    
    
    func savePeople(data : [People]?) {
        
        let archivedObject = StoreManager.storePeople(data: data!)
        UserDefaults.standard.set(archivedObject, forKey: "people")
        
        UserDefaults.standard.synchronize()
    }
    
    
    func savePhotos(data : [Photos]?) {
        
        let archivedObject = StoreManager.storePhotos(data: data!)
        UserDefaults.standard.set(archivedObject, forKey: "photos")
        
        UserDefaults.standard.synchronize()
    }
    
    func saveVideos(data : [Videos]?) {
        
        let archivedObject = StoreManager.storeVideo(data: data!)
        UserDefaults.standard.set(archivedObject, forKey: "videos")
        
        UserDefaults.standard.synchronize()
    }
    
}
