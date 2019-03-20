//
//  PinDatabase.swift
//  udacity_nanodegree_ios_virtual_tourist
//
//  Created by Eduardo Soares on 27/07/2018.
//  Copyright © 2018 Eduardo Soares. All rights reserved.
//

import Foundation
import CoreData

class PinDatabase {
    private let dataManager = DataController.instance
    
    func savePin(latitude:Double,longitude:Double) -> Pin{
        let pin = Pin(context: dataManager.viewContext)
        pin.latitude = latitude
        pin.longitude = longitude
        try? dataManager.viewContext.save()
        return pin
    }
    
    func getPins() -> [Pin]? {
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        if let result = try? dataManager.viewContext.fetch(fetchRequest){
           return result
        }
        return nil
    }
    func getPin(latitude:Double,longitude:Double) -> Pin? {
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "latitude", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "abs(latitude - %f) < 0.0001 AND abs(longitude - %f) < 0.0001", latitude,longitude)
        fetchRequest.predicate = predicate
        if let result = try? dataManager.viewContext.fetch(fetchRequest){
            if(result.isEmpty){
                return nil
            }
            return result[0]
        }
        return nil
    }
    
    func deletePin(pin:Pin){
        dataManager.viewContext.delete(pin)
        try? dataManager.viewContext.save()
    }
    
    func addPhotoToPin(pin:Pin,url:String?, imageData:Data?){
        let photo = Photo(context: dataManager.viewContext)
        photo.imageData = imageData
        photo.url = url
        photo.pin = pin
        try? dataManager.viewContext.save()
    }
    
    func deletePhoto(pin:Pin,photo:Photo){
        dataManager.viewContext.delete(photo)
        try? dataManager.viewContext.save()
    }
    
    func clearPinPhotos(pin:Pin){
        pin.photos = NSSet()
        try? dataManager.viewContext.save()
    }
}
