//
//  DataManager.swift
//  udacity_nanodegree_ios_virtual_tourist
//
//  Created by Eduardo Soares on 27/07/2018.
//  Copyright © 2018 Eduardo Soares. All rights reserved.
//

import Foundation
import CoreData

class DataController{
    let persistenceContainer:NSPersistentContainer
    private static let DATABASE_NAME="DatabaseModel"
    
    static let instance = DataController(name: DATABASE_NAME)
    
    private init(name:String) {
        self.persistenceContainer = NSPersistentContainer(name: name)
        load()
    }
    
    var viewContext:NSManagedObjectContext {
        return persistenceContainer.viewContext
    }
    
    func load(completion: ( ()->Void)? = nil){
        persistenceContainer.loadPersistentStores(){ storeDescription,error in
            guard  error == nil else{
                fatalError((error?.localizedDescription)!)
            }
            completion?()
        }
    }
}
