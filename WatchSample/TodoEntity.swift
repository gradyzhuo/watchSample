//
//  TodoEntity.swift
//  WatchSample
//
//  Created by Grady Zhuo on 7/11/15.
//  Copyright © 2015 Grady Zhuo. All rights reserved.
//

import Foundation
import Storage
import XLForm

enum EntityPriority {
    case priorityValue(Int)
    
    var value:Int{
        switch self {
        case let .priorityValue(p):
            return p
        }
    }
    
    
    
    static var High = EntityPriority.priorityValue(1000)
    static var Medium = EntityPriority.priorityValue(750)
    static var Normal = EntityPriority.priorityValue(500)
    static var Low = EntityPriority.priorityValue(250)
}


typealias Entities = [Entity]

class Entity : Dictionariable {
    
    var id:String{
        set{
            self.dataDict["id"] = newValue
        }
        get{
            return self.dataDict["id"] as! String
        }
    }
    
    var dataDict:[String:AnyObject]
    
    var alarmDate:NSDate{
        set{
            self.dataDict["alarmDate"] = newValue.timeIntervalSince1970
        }
        
        get{
            let defaultValue = Entity.getNextOClock().timeIntervalSince1970
            let timeInterval = self.dataDict["alarmDate"] as? NSTimeInterval
            return NSDate(timeIntervalSince1970: timeInterval ?? defaultValue )
        }
    }
    
    var targetDate:NSDate{
        set{
            self.dataDict["targetDate"] = newValue.timeIntervalSince1970
        }
        get{
            let defaultValue = Entity.getNextOClock(offset: -60*15).timeIntervalSince1970
            let timeInterval = self.dataDict["targetDate"] as? NSTimeInterval
            return NSDate(timeIntervalSince1970: timeInterval ?? defaultValue )
        }
    }
    
    var subject:String{
        
        set{
            self.dataDict["subject"] = newValue
        }
        
        get{
            return self.dataDict["subject"] as? String ?? ""
        }
    }
    
    private var _priority:Int{
        set{
            self.dataDict["priority"] = newValue
        }
        get{
            return self.dataDict["priority"] as? Int ?? EntityPriority.Normal.value
        }
    }
    
    var priority:EntityPriority{
        set{
            self._priority = self.priority.value
        }
        get{
            return EntityPriority.priorityValue(self._priority)
        }
    }
    
    
    var targetDateString:String {
        return self.targetDate.formatDateString()
    }
    
    var alarmDateString:String {
        return self.alarmDate.formatDateString()
    }
    
    init(){
        self.dataDict = [String:AnyObject]()
        self.id = String(NSDate().timeIntervalSince1970)
    }
    
    init(dataDict:[String:AnyObject]){
        self.dataDict = dataDict
    }
    
    class func getNextOClock(offset offset:NSTimeInterval = 0)->NSDate{
        return NSDate()
    }
    
    
    
    
}

func == (lhs:Entity, rhs:Entity)->Bool{
    return lhs.id == rhs.id
}



