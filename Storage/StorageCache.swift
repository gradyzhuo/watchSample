//
//  File.swift
//  WatchSample
//
//  Created by Grady Zhuo on 7/11/15.
//  Copyright © 2015 Grady Zhuo. All rights reserved.
//

import Foundation

internal struct StorageCache< T : Dictionariable> {
    
    var objectIDs:[String] = []
    
    var cache = [String:T]()
    
    mutating func addObject(object:T){
        
        if !self.objectIDs.contains(object.id) {
            self.objectIDs.append(object.id)
        }
        self.cache[object.id] = object
        
    }
    
    mutating func insertObject(object:T, atIndex index:Int){
        
        if !self.objectIDs.contains(object.id) {
            
            let range = self.objectIDs.startIndex..<self.objectIDs.endIndex
            if range.contains(index){
                self.objectIDs.insert(object.id, atIndex: index)
            }else{
                self.objectIDs.append(object.id)
            }
            
            
        }
        
        self.cache[object.id] = object
        
    }
    
    mutating func removeAllObjects() {
        
        self.objectIDs.removeAll(keepCapacity: false)
        self.cache.removeAll(keepCapacity: false)
        
    }
    
    mutating func removeObject(byID id:String){
        self.objectIDs = self.objectIDs.filter({ (item) -> Bool in
            return item != id
        })
        
        self.cache.removeValueForKey(id)
        
    }
    
    mutating func removeObjects(byIDs ids:[String]) {
        
        for id in ids {
            self.removeObject(byID: id)
        }
        
    }
    
}