//
//  GlanceController.swift
//  Todo Extension
//
//  Created by Grady Zhuo on 7/11/15.
//  Copyright © 2015 Grady Zhuo. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class GlanceController: EntitiesDetailInterfaceController {
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        if let entity = context as? Entity {
            self.entity = entity
        }
    }
    

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
        if self.entity == nil {
            
            let session = WCSession.defaultSession()
            if !session.receivedApplicationContext.keys.isEmpty {
                let entity = Entity(dataDict: session.receivedApplicationContext)
                self.entity = entity
                
            }else if !session.applicationContext.keys.isEmpty{
                let entity = Entity(dataDict: session.applicationContext)
                self.entity = entity
            }else{
                EntitiesManager.defaultManager().getEntities({[weak self] (entities:Entities) -> Void in
                    
                    self?.entity = entities.last
                    
                })
            }

        }
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
