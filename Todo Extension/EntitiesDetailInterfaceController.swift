//
//  EntitiesDetailInterfaceController.swift
//  WatchSample
//
//  Created by Grady Zhuo on 7/12/15.
//  Copyright © 2015 Grady Zhuo. All rights reserved.
//

import WatchKit
import Foundation


class EntitiesDetailInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var subjectLabel:WKInterfaceLabel!
    @IBOutlet weak var targetDateLabel:WKInterfaceLabel!
    @IBOutlet weak var priorityLabel:WKInterfaceLabel!
    
    var entity:Entity?{
        didSet{
            self.refreshUI()
        }
    }
    
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
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    //MARK: - 
    func refreshUI(){
        if let e = self.entity {
            
            self.setTitle(e.subject)
            
            self.subjectLabel.setText(e.subject)
            self.priorityLabel.setText(e.priority.formDisplayText())
            self.targetDateLabel.setText(e.targetDateString)

            
        }
    }
    
    @IBAction func delete(){
        if let entity = self.entity {
            EntitiesManager.defaultManager().removeEntity(entity)
            WKInterfaceController.reloadRootControllersWithNames(["EntitiesListInterfaceController"], contexts: nil)
            self.popController()
        }
    }
    
}
