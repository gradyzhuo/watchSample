//
//  ComplicationController.swift
//  Todo Extension
//
//  Created by Grady Zhuo on 7/11/15.
//  Copyright © 2015 Grady Zhuo. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.Forward, .Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        
        if complication.family == CLKComplicationFamily.ModularLarge {
        
            EntitiesManager.defaultManager().getEntities({ (entities:Entities) -> Void in
                
                let sortedEntities = entities.sort({ (lhs:Entity, rhs:Entity) -> Bool in
                    return rhs.targetDate.timeIntervalSinceDate(lhs.targetDate) > 0
                })
                
                var date = sortedEntities.first?.targetDate
                date = date?.dateByAddingTimeInterval(-86400)
                
                handler(date)
                
            })
        
        }
        
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        if complication.family == CLKComplicationFamily.ModularLarge {
            
            EntitiesManager.defaultManager().getEntities({ (entities:Entities) -> Void in
                
                let sortedEntities = entities.sort({ (lhs:Entity, rhs:Entity) -> Bool in
                    return rhs.targetDate.timeIntervalSinceDate(lhs.targetDate) > 0
                })
                
                var date = sortedEntities.last?.targetDate
                date = date?.dateByAddingTimeInterval(86400)
                
                handler(date)
                
            })
            
        }
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        
        
        print("complication.family:\(complication.family)")
        if complication.family == CLKComplicationFamily.ModularLarge {
            
            EntitiesManager.defaultManager().getEntities({ (entities:Entities) -> Void in
                
                let filtedEntities = entities.filter({ (entity:Entity) -> Bool in
                    let offset = entity.targetDate.timeIntervalSinceDate(NSDate())
                    return offset >= -59 && offset <= 59
                })
                
                let entry:CLKComplicationTimelineEntry
                guard let topEntity = filtedEntities.first else {
                    entry = self.createEntry(nil)
                    handler(entry)
                    return
                }
                
                entry = self.createEntry(topEntity)
                handler(entry)
                
            })

        }
        
        
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        
        if complication.family == CLKComplicationFamily.ModularLarge {
            
            EntitiesManager.defaultManager().getEntities({ (entities:Entities) -> Void in
                
                var filtedEntities = entities.filter({ (entity:Entity) -> Bool in
                    let offset = entity.targetDate.timeIntervalSinceDate(date)
                    return offset < 0
                })
                
                if filtedEntities.count > limit {
                    filtedEntities = Entities(filtedEntities[0..<limit])
                }
                
                let entries = filtedEntities.map{ return self.createEntry($0) }
                handler(entries)
                
            })
            
            
        }
        
        handler(nil)
        
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
//        if complication.family == CLKComplicationFamily.ModularLarge {
//            
//            EntitiesManager.defaultManager().getEntities({ (entities:Entities) -> Void in
//                
//                var filtedEntities = entities.filter({ (entity:Entity) -> Bool in
//                    let offset = entity.targetDate.timeIntervalSinceDate(date)
//                    return offset >= 0
//                })
//                
//                if filtedEntities.count > limit {
//                    filtedEntities = Entities(filtedEntities[0..<limit])
//                }
//                
//                let entries = filtedEntities.map{ return self.createEntry($0) }
//                handler(entries)
//                
//            })
//            
//            
//        }
        handler(nil)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(nil);
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
    
    
    //MARK: - Entry Creator
    
    func createEntry(entity:Entity?)->CLKComplicationTimelineEntry{
        
        let date = entity?.targetDate ?? NSDate()
        let template = self.createTemplate(date, entity: entity)
        
        return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
    }
    
    
    func createTemplate(date:NSDate, entity:Entity?)->CLKComplicationTemplate {
        
        
        
        let template = CLKComplicationTemplateModularLargeStandardBody()
        let header = CLKSimpleTextProvider(text: entity?.subject ?? "No Data")
        let dateText = CLKDateTextProvider(date: date, units: [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute])
        template.headerTextProvider = header
        template.body1TextProvider = dateText
        return template
    }
}
