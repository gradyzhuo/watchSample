//
//  NSDate+FormatString.swift
//  WatchSample
//
//  Created by Grady Zhuo on 7/11/15.
//  Copyright © 2015 Grady Zhuo. All rights reserved.
//

import Foundation

//Extend NSDate to support converting to date format string.
extension NSDate {
    func formatDateString()->String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.stringFromDate(self)
    }
}