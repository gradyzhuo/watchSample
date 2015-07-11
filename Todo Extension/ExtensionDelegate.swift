//
//  ExtensionDelegate.swift
//  Todo Extension
//
//  Created by Grady Zhuo on 7/11/15.
//  Copyright © 2015 Grady Zhuo. All rights reserved.
//

import WatchKit
import WatchConnectivity


class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        
        if WCSession.isSupported() {
            
            WCSession.defaultSession().delegate = self
            WCSession.defaultSession().activateSession()
            
        }
        
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {

        
        let manager = EntitiesManager.defaultManager()
        
        for (key, value) in userInfo {

            let entity = Entity(dataDict: value as! [String:AnyObject])
            
            if key == EntitiesManagerNotificationUserInfoKeyAdd {
                manager.addEntity(entity, transferUserInfo: false)
            }else{
                manager.removeEntity(entity, transferUserInfo: false)
            }
        }
        manager.synchronize()
        
        WKInterfaceController.reloadRootControllersWithNames(["EntitiesListInterfaceController"], contexts: nil)
        
        
        
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        
        
        
        
    }
    
}
