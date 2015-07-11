//
//  EntitiesManager.swift
//  WatchSample
//
//  Created by Grady Zhuo on 7/11/15.
//  Copyright © 2015 Grady Zhuo. All rights reserved.
//

import Foundation
import Storage

class EntitiesManager {
    
    let storage:Storage<Entity> = {
        let s = Storage<Entity>()
        s.synchronizeEntitiesFromUserDefaults()
        return s
    }()
    
    
    private static let singleton = EntitiesManager()
    
    class func defaultManager()->EntitiesManager{
        return singleton
    }
    
    func addEntity(entity:Entity){
        self.storage.addObject(entity)
    }
    
    func removeEntity(entity:Entity){
        self.storage.removeObject(entity)
    }
    
    func getEntities(completionHandler:(entities:Entities)->Void){
        self.storage.getObjects { (objects) -> Void in
            completionHandler(entities: objects)
        }
    }
    
    func synchronize(){
        self.storage.saveToUserDefaults()
    }
    
}