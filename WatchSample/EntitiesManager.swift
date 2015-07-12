//
//  EntitiesManager.swift
//  WatchSample
//
//  Created by Grady Zhuo on 7/11/15.
//  Copyright © 2015 Grady Zhuo. All rights reserved.
//

import Foundation

import WatchConnectivity

#if os(iOS)
import Storage
#else
import StorageWatch
#endif

let EntitiesManagerNotificationName = "EntitiesManagerNotificationName"
let EntitiesManagerNotificationUserInfoKeyAdd = "EntitiesManagerNotificationUserInfoKeyAdd"
let EntitiesManagerNotificationUserInfoKeyRemove = "EntitiesManagerNotificationUserInfoKeyRemove"

//A singleton manager to manage Entities
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
    
    /// add entity and should send to recevier slide?
    func addEntity(entity:Entity, transferUserInfo:Bool = true){
        self.storage.addObject(entity)
        
        if transferUserInfo {
            let session = WCSession.defaultSession()
            
            session.transferUserInfo([EntitiesManagerNotificationUserInfoKeyAdd:entity.dataDict])
            do{
                try session.updateApplicationContext(entity.dataDict)
            }catch{
                print("when updateApplicationContext error happened. [Error]:\(error)")
            }
        }
        
    }
    
    /// remove entity and should send to recevier slide?
    func removeEntity(entity:Entity, transferUserInfo:Bool = true){
        

        let session = WCSession.defaultSession()
        
        if transferUserInfo {
            self.getEntities { (entities) -> Void in
            
            
                let existEntities = entities.filter({ (existEntity) -> Bool in
                    return entity != existEntity
                })
                
                if let topEntity = existEntities.first {
                    
                    do{
                        try session.updateApplicationContext(topEntity.dataDict)
                    }catch{
                        print("when updateApplicationContext error happened. [Error]:\(error)")
                    }
                    
                }
            }
            
        }
        
        self.storage.removeObject(entity)
        if transferUserInfo {
            session.transferUserInfo([EntitiesManagerNotificationUserInfoKeyRemove:entity.dataDict])
        }

        
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