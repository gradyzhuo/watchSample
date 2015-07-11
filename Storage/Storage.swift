//
//  Storage.swift
//
//  Created by Grady Zhuo on 3/22/15.
//  Copyright (c) 2015 . All rights reserved.
//

import Foundation

public enum StorageFetchType {
    case All
    case Part(fetchRange:Range<Int>)
    case Optional(IDs:[String])
}

//MARK: -

/// A Generic Storage, and what will be added, should confirm to Dictionariable protocol.
public class Storage < T : Dictionariable > {
    
    internal var leadingObjects:[T] = []
    internal var tailObjects:[T] = []
    
    internal var objects:[T]{
        
        var objects:[T] = [] + self.leadingObjects
        
        for id in self.privatedObjectCache.objectIDs {
            if let obj = self.privatedObjectCache.cache[id] {
                objects.append(obj)
            }
        }
        
        objects.extend(self.tailObjects)
        
        return objects
    }
    
    private lazy var privatedObjectCache = StorageCache<T>()
    
    
    public init(){
        
    }
    
    /**
    insert objects into the front of the storage.
    
    - parameter objects: the object what you want to insert.
    */
    public func insertObjectsAtFront(objects:[T]){
        self.insertObjects(objects, inRange: 0..<objects.count)
    }
    
    /**
    insert objects into the range of the storage.
    
    - parameter objects: the object what you want to insert.
    - parameter range: the index range you want to place objects.
    */
    public func insertObjects(objects:[T], inRange range:Range<Int>){
        
        var generator = range.generate()

        for object in objects {
            let i = generator.next() ?? 0
            self.privatedObjectCache.insertObject(object, atIndex: i)
        }
        
    }
    
    /**
    place a object into the location you want.
    
    - parameter object: the object what you want to insert.
    - parameter index: the index you want to place the object.
    */
    public func insertObject(object:T, atIndex index:Int){
        self.privatedObjectCache.insertObject(object, atIndex: index)
    }
    
    
    /**
    Add a Object into the storage.
    
    - parameter object: the object what you want to add.
    */
    public func addObject(object:T){
        
        self.privatedObjectCache.addObject(object)
        
    }
    
    /**
    Add the array of objects into the storage.
    
    - parameter objects: the objects what you want to add.
    */
    public func addObjects(objects:[T]){
        
        for object  in objects {
            
            self.privatedObjectCache.addObject(object)
        }
        
    }
    
    /**
    remove the array of ids of objects from the storage.
    
    - parameter objects: the ids of objects what you want to remove.
    */
    public func removeObjects(byObjectIDs objectIds:[String]){
        self.privatedObjectCache.removeObjects(byIDs: objectIds)
    }
    
    /**
    remove the specific object from the storage.
    
    - parameter object: the specific object what you want to remove.
    */
    public func removeObject(object:T){
        
        self.privatedObjectCache.removeObject(byID: object.id)
        
    }
    
    /**
    remove the specific objects from the storage.
    
    - parameter objects: the specific objects what you want to remove.
    */
    public func removeObjects(objects:[T]){
        
        for object in objects {
            self.removeObject(object)
        }
        
    }
    
    /**
    remove all of objects from the storage.
    
    - parameter keepCapacity: keep capacity if you want.
    */
    public func removeAll(keepCapacity: Bool = false){
        self.privatedObjectCache.removeAllObjects()
    }
    
    
    /**
    get all of objects from the storage.
    
    - parameter completionHandler: the handler to return the result of fetching objects.
    */
    public func getObjects(completionHandler:(objects:[T])->Void){
        self.getObjects(byFetchType: .All, completionHandler: completionHandler)
    }
    
    
    /**
    get specific fetchType of objects from the storage.
    
    - parameter fetchType: specific fetch type. It can be All, Part, Optional type of StorageFetchType
    - parameter completionHandler: the handler to return the result of fetching objects.
    */
    public func getObjects(byFetchType fetchType:StorageFetchType, completionHandler:(objects:[T])->Void){
        
        var objects = self.objects

        
        switch fetchType {
        case .All :
            completionHandler(objects: objects)
        case let .Part(fetchRange):
            let sliceObjects = objects[fetchRange]
            completionHandler(objects: [T](sliceObjects))
            
        case let .Optional(objectIDs):
            let filtedObjects:[T] = objects.filter { (object:T) -> Bool in
                return objectIDs.contains(object.id)
            }
            completionHandler(objects: filtedObjects)
        }

    }
    
    
    
    /**
    get the extendObjects what you assigned.
    
    - parameter position: the position of extendObjects. It can be Leading or Trail of StorageExtendObjectsPosition.
    - parameter completionHandler: the handler when the objects fetched.
    */
    public func getExtendObjects(atPosition position:StorageExtendObjectsPosition, completionHandler:(objs:[T])->Void){
        
        switch position {
            
        case .Leading:
            completionHandler(objs: self.leadingObjects)
        case .Tail:
            completionHandler(objs: self.tailObjects)
        }
        
        
    }
    
    /**
    add the extendObjects what you want to assign.
    
    - parameter position: the position of extendObjects. It can be Leading or Trail of StorageExtendObjectsPosition.
    */
    public func addExtendObjects(objects:[T], atPosition position:StorageExtendObjectsPosition){
        switch position {
            
        case .Leading:
            self.leadingObjects.extend(objects)
        case .Tail:
            self.tailObjects.extend(objects)
        }
        
    }
    
    /**
    remove the extendObjects at the position.
    
    - parameter position: the position of extendObjects. It can be Leading or Trail of StorageExtendObjectsPosition.
    */
    public func removeAllExtendObjects(atPosition position:StorageExtendObjectsPosition){
        
        switch position {
            
        case .Leading:
            self.removeExtendObjects(self.leadingObjects, atPosition: position)
        case .Tail:
            self.removeExtendObjects(self.tailObjects, atPosition: position)
            
        }
        
    }
    
    /**
    remove the specific extendObjects at the position.
    
    - parameter objects: specific extendObjects will be removed.
    - parameter position: the position of extendObjects. It can be Leading or Trail of StorageExtendObjectsPosition.
    */
    public func removeExtendObjects(objects:[T], atPosition position:StorageExtendObjectsPosition){
        
        let ids:[String] = objects.map{ return $0.id }
        self.removeExtendObjects(by: ids, atPosition: position)
        
    }
    
    /**
    remove the specific ids of extendObjects at the position.
    
    - parameter objectIDs: specific ids of extendObjects will be removed.
    - parameter position: the position of extendObjects. It can be Leading or Trail of StorageExtendObjectsPosition.
    */
    public func removeExtendObjects(by objectIDs:[String], atPosition position:StorageExtendObjectsPosition){
        
        switch position {
            
        case .Leading:
            self.leadingObjects = self.leadingObjects.filter({ obj -> Bool in
                
                return !objectIDs.contains(obj.id)
            })
        case .Tail:
            self.tailObjects = self.tailObjects.filter({ obj -> Bool in
                return !objectIDs.contains(obj.id)
            })
        }
        
        
    }
    
    
}