//
//  MainTableViewController.swift
//  WatchSample
//
//  Created by Grady Zhuo on 7/8/15.
//  Copyright © 2015 Grady Zhuo. All rights reserved.
//

import UIKit
import XLForm
import Storage

class MainTableViewController: UITableViewController {
    
    
    let manager = EntitiesManager.defaultManager()
    var entities = Entities()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "add:")
        self.navigationItem.rightBarButtonItem = addBarButtonItem
        
        self.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func add(sender:AnyObject){
        
        let navigationController = self.createFormViewControllerWithNavigationController()
        self.presentViewController(navigationController, animated: true, completion: nil)

    }
    
    
    func createFormViewController(entity:Entity? = nil)->EntityFormViewController {
        
        let formViewController = EntityFormViewController(entity: entity)
        formViewController.delegate = self
        
        formViewController.form.disabled = (entity != nil)
        
        return formViewController
        
    }
    
    
    func createFormViewControllerWithNavigationController(entity:Entity? = nil)->UINavigationController {
        
        let formViewController = self.createFormViewController(entity)
        return UINavigationController(rootViewController: formViewController)
        
    }
    
        
    func reloadData(){
        
        self.manager.getEntities {[weak self] (entities) -> Void in
            self?.entities = entities
            self?.tableView.reloadData()
        }
        
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.entities.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ENTITY", forIndexPath: indexPath)

        
        let e = self.entities[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = e.subject
        cell.detailTextLabel?.text = e.targetDateString
        
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let entity = self.entities[indexPath.row]
            self.manager.removeEntity(entity)
            self.entities.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let entity = self.entities[indexPath.row]
        let formViewController = self.createFormViewController(entity)
        self.showViewController(formViewController, sender: nil)
        
    }

}

extension MainTableViewController : EntityFormViewControllerDelegate{
    
    func entityFormViewController(entityFormViewController: EntityFormViewController, didPressDoneWithEntityDataDict dataDict: [String : AnyObject]) {
        
        if let entity = entityFormViewController.entity {
            entity.dataDict = dataDict
        }else{
            self.manager.addEntity(Entity(dataDict: dataDict))
            
        }
        
        self.reloadData()

        
    }


}
