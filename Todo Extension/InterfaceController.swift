//
//  InterfaceController.swift
//  Todo Extension
//
//  Created by Grady Zhuo on 7/11/15.
//  Copyright © 2015 Grady Zhuo. All rights reserved.
//

import WatchKit
import Foundation
import ClockKit
import WatchConnectivity

class InterfaceController: WKInterfaceController {

    @IBOutlet var entitiesTable:WKInterfaceTable!
    @IBOutlet var noEntitiesTipLabel:WKInterfaceLabel!
    
    var entities:Entities = []
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.

        if let context = context as? Entities {
            self.entities = context
            self.reloadTableData()
        }else{
            self.reloadTableData(true)
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
    
    
    func reloadTableData(refreshSource:Bool = false){

        
        let reloadTableControllerAction:()->Void = {
            
            self.entitiesTable.setNumberOfRows(self.entities.count, withRowType: "EntityRow")
            
            for (idx, entity) in self.entities.enumerate() {
                
                let rowController = self.entitiesTable.rowControllerAtIndex(idx) as? EntityRowController
                rowController?.entity = entity
                
            }
            
            if self.entities.count == 0 {
                
                
                self.noEntitiesTipLabel.setAlpha(1.0)
                
                
            }else{
                self.noEntitiesTipLabel.setAlpha(0.0)
            }
            
        }
        
        if refreshSource {
            //如果有要重新Source, 就從Manager重新fetch data進行reload
            EntitiesManager.defaultManager().getEntities {[weak self] (entities) -> Void in
                print("entities:\(entities)")
                
                self?.entities = entities
                reloadTableControllerAction()
            }
        }else{
            //若沒有，則僅更新現在的畫面
            reloadTableControllerAction()
        }
        
        
        
    }
    
    //MARK: - handle table selection
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let entity = self.entities[rowIndex]
        print(entity.subject)
        
        self.pushControllerWithName("EntitiesDetailInterfaceController", context: entity)
    }
    
    //MARK: - handle menu item
    @IBAction func connectToiOS(){
        
        let session = WCSession.defaultSession()
        
        //先檢查是否可以reach
        if session.reachable {
            //再send Message 到 另一端系統
            session.sendMessage(["title":"Message From Watch"], replyHandler: { (userInfo) -> Void in
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.presentAlertControllerWithTitle(userInfo["title"] as? String, message: userInfo["message"] as? String, preferredStyle: WKAlertControllerStyle.Alert, actions: [WKAlertAction(title: "OK", style: WKAlertActionStyle.Default, handler: { () -> Void in
                        
                    })])
                })
                
                
                }) { (error) -> Void in
                    print("sendMessage error happened. \(error)")
            }
        }
        
        
    }
    
}
