//
//  PriorityOption.swift
//  WatchSample
//
//  Created by Grady Zhuo on 7/11/15.
//  Copyright © 2015 Grady Zhuo. All rights reserved.
//

import Foundation
import XLForm

class PriorityOption : NSObject, XLFormOptionObject {
    
    let priority:EntityPriority
    
    init(priority:EntityPriority){
        self.priority = priority
        
    }
    
    func formDisplayText() -> String! {
        switch self.priority.value {
        case 1000:
            return "High"
        case 750:
            return "Medium"
        case 250:
            return "Low"
        default:
            return "Normal"
        }
    }
    
    func formValue() -> AnyObject! {
        return self.priority.value
    }
    
}