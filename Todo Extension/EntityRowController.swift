//
//  EntityRowController.swift
//  WatchSample
//
//  Created by Grady Zhuo on 7/11/15.
//  Copyright © 2015 Grady Zhuo. All rights reserved.
//

import Foundation
import WatchKit

//Row Controller to show a Entity subject
class EntityRowController: NSObject {
    
    @IBOutlet var labelObject:WKInterfaceLabel!
    
    var entity:Entity?{
        didSet{
            self.labelObject.setText(entity?.subject)
        }
    }
    
}