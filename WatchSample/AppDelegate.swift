//
//  AppDelegate.swift
//  WatchSample
//
//  Created by Grady Zhuo on 7/7/15.
//  Copyright © 2015 Grady Zhuo. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        if WCSession.isSupported() {
            
            WCSession.defaultSession().delegate = self
            WCSession.defaultSession().activateSession()
            
        }
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        EntitiesManager.defaultManager().synchronize()
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        EntitiesManager.defaultManager().synchronize()
    }
    
}

//Implement WCSessionDelegate
extension AppDelegate : WCSessionDelegate {
    
    //handle data when receives UserInfo from sender slide.
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
        
        NSNotificationCenter.defaultCenter().postNotificationName(EntitiesManagerNotificationName, object: self, userInfo: userInfo)
        
    }
    
    //handle message from sender slide.
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        
        let alert = UIAlertController(title: message["title"] as? String, message: message["message"] as? String, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "CallBack", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            replyHandler(["title":"Message From iOS"])
            
        }))
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
}

