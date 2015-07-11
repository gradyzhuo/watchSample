//
//  Storage+WatchSample.swift
//  WatchSample
//
//  Created by Grady Zhuo on 7/11/15.
//  Copyright © 2015 Grady Zhuo. All rights reserved.
//

import Foundation
import Storage

extension Storage {
    
    var userDefaults:NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    func saveToUserDefaults(){

        self.getObjects {[weak self] (objects) -> Void in
            
            if let weakSelf = self {
                
                let entities = objects.map{ (obj) -> Entity in
                    return obj as! Entity
                }
                
                let dataDicts = entities.map{ return $0.dataDict }
                weakSelf.userDefaults.setObject(dataDicts, forKey: "Entities")
                
            }
            
        }
        
        self.userDefaults.synchronize()
        
    }
    
    
    func synchronizeEntitiesFromUserDefaults(){
        
        self.userDefaults.synchronize()
        
        guard let objects = self.userDefaults.objectForKey("Entities") as? [[String:AnyObject]] else {
            return
        }
        
        for object in objects {
            
            let entity = Entity(dataDict: object)
            self.addObject(entity as! T)
            
        }
        
        
    }
    
}