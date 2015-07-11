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
        return self.priority.formDisplayText()
    }
    
    func formValue() -> AnyObject! {
        return self.priority.formValue()
    }
    
}