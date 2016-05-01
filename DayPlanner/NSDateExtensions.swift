//
//  NSDateExtensions.swift
//  DayPlanner
//
//  Created by Eric Heitmuller on 4/30/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation


extension NSDate {

	public func addDays(numberOfDays:Int) -> NSDate! {
        
        let calendar : NSCalendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(abbreviation: "UTC")!
        
        let components : NSDateComponents = NSDateComponents()
        components.day = numberOfDays
        
        return calendar.dateByAddingComponents(components, toDate: self, options: NSCalendarOptions())
    }

	public func addHours(numberOfHours: Int) -> NSDate!{
		let calendar : NSCalendar = NSCalendar.currentCalendar()
		calendar.timeZone = NSTimeZone(abbreviation: "UTC")!
		
		let components : NSDateComponents = NSDateComponents()
		components.hour = numberOfHours
		
		return calendar.dateByAddingComponents(components, toDate: self, options: NSCalendarOptions())
	}
	
	public func addMinutes(numberOfMinutes: Int) -> NSDate! {
		let calendar : NSCalendar = NSCalendar.currentCalendar()
		calendar.timeZone = NSTimeZone(abbreviation: "UTC")!
		
		let components : NSDateComponents = NSDateComponents()
		components.minute = numberOfMinutes
		
		return calendar.dateByAddingComponents(components, toDate: self, options: NSCalendarOptions())
	}
	
	public func atMidnight()-> NSDate {
		let cal = NSCalendar.currentCalendar()
		return cal.dateBySettingHour(0, minute: 0, second: 0, ofDate: self, options: NSCalendarOptions())!
	}
}