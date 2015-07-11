//
//  CreateEntityFormViewController.swift
//  WatchSample
//
//  Created by Grady Zhuo on 7/11/15.
//  Copyright © 2015 Grady Zhuo. All rights reserved.
//

import Foundation
import XLForm

let kFormValueSubject = "subject"
let kFormValueTargetDate = "target"
let kFormValueAlarmDate = "alarm"
let kFormValuePriority = "priority"

@objc protocol EntityFormViewControllerDelegate {
    
    optional func entityFormViewController(entityFormViewController:EntityFormViewController, didPressDoneWithEntityDataDict dataDict:[String:AnyObject])
    optional func entityFormViewControllerDidPressCancel(entityFormViewController:EntityFormViewController)
    
    
}

class EntityFormViewController: XLFormViewController {
    
    var delegate:EntityFormViewControllerDelegate?
    
    var entity:Entity?
    
    init(entity:Entity? = nil){
        super.init(nibName: nil, bundle: nil)
        
        self.entity = entity
        self.form = self.createForm()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setEditing(self.entity == nil, animated: false)
        
        
        
        
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel:")
            self.navigationItem.setLeftBarButtonItem(cancelBarButtonItem, animated: animated)
            
            let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "done:")
            self.navigationItem.setRightBarButtonItem(doneBarButtonItem, animated: animated)
        }else{
            self.navigationItem.setLeftBarButtonItem(nil, animated: animated)
            let editBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "modifyEditing:")
            self.navigationItem.rightBarButtonItem = editBarButtonItem
        }
        
        
        self.form.disabled = !editing
        self.tableView.reloadData()
        
    }
    
    
    func modifyEditing(sender:AnyObject){
        self.setEditing(!self.editing, animated: true)
    }
    
    //MARK: - Initialize methods
    func createForm()->XLFormDescriptor {
        let form = XLFormDescriptor(title: "Todo")
        let section = XLFormSectionDescriptor()
        
        let subjectRow = XLFormRowDescriptor(tag: kFormValueSubject, rowType: XLFormRowDescriptorTypeText, title:"Subject")
        subjectRow.required = true
        subjectRow.value = self.entity?.subject
        subjectRow.cellConfig = ["textField.textAlignment":NSTextAlignment.Right.rawValue]
        section.addFormRow(subjectRow)
        
        let priorityRow = XLFormRowDescriptor(tag: kFormValuePriority, rowType: XLFormRowDescriptorTypeSelectorActionSheet, title: "Priority")
        let priorities = [PriorityOption(priority: .High),PriorityOption(priority: .Medium),PriorityOption(priority: .Normal),PriorityOption(priority: .Low)]
        priorityRow.selectorOptions = priorities
        
        if let priority = self.entity?.priority {
            priorityRow.value = PriorityOption(priority: priority)
        }else{
            
        }
        priorityRow.value = priorities.first
        section.addFormRow(priorityRow)
        
        let nowDate = NSDate()
        
        let targetDateRow = XLFormRowDescriptor(tag: kFormValueTargetDate, rowType: XLFormRowDescriptorTypeDateTime, title: "Target Date")
        targetDateRow.noValueDisplayText = nowDate.formatDateString()
        targetDateRow.value = self.entity?.targetDate ?? nowDate
        section.addFormRow(targetDateRow)
        
        let alarmDateRow = XLFormRowDescriptor(tag: kFormValueAlarmDate, rowType: XLFormRowDescriptorTypeDateTime, title: "Alarm Date")
        alarmDateRow.noValueDisplayText = nowDate.formatDateString()
        alarmDateRow.value = self.entity?.alarmDate ?? nowDate
        section.addFormRow(alarmDateRow)
        
        form.addFormSection(section)
        
        return form
    }
    
    
    //MARK: - Validator
    
    func validateForm()->[String]{
        
        let values = self.formValues() as! [String:AnyObject]
        
        let invalidatedtKeys = values.keys.filter { (key) -> Bool in
            let value = values[key]
            print("value:\(value)")
            
            if let value = value {
                return value is NSNull
            }
            
            return true
        }
        
        return invalidatedtKeys.array
    }
    
    
    func validateFormWithAlert()->Bool{
        
        let result = self.validateForm()
        
        let message = result.reduce("") { (current, key) -> String in
            return "\n" + current + "\(key)"
        }
        
        if result.count > 0 {
            let alert = UIAlertController(title: "Please comfirm these data.", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
        return result.count == 0
    }
    
    
    
    
    
    //MARK: - Action Handler
    func close(){
        if self.presentingViewController != nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            self.setEditing(false, animated: true)
        }
        
    }
    
    func cancel(sender:AnyObject){
        self.close()
        
        self.delegate?.entityFormViewControllerDidPressCancel?(self)
        
    }
    
    func done(sender:AnyObject){
        
        if self.validateFormWithAlert() {
            self.close()
            self.delegate?.entityFormViewController?(self, didPressDoneWithEntityDataDict: self.createEntityDataDict())
        }
        
    }
    
    
    //MARK: - Entity Creator
    func createEntityDataDict()->[String:AnyObject] {
        
        let values = self.formValues()
        
        let nowDate = NSDate()
        
        let entity = Entity()
        entity.subject = (values[kFormValueSubject] ?? "") as! String
        entity.priority = (values[kFormValuePriority] as? PriorityOption)?.priority ?? .High
        entity.targetDate = (values[kFormValueTargetDate] ?? nowDate) as! NSDate
        entity.alarmDate = (values[kFormValueTargetDate] ?? nowDate) as! NSDate
        
        return entity.dataDict
    }
}