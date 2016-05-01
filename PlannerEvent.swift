//
//  Event.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 12/31/15.
//  Copyright © 2015 Eric Heitmuller. All rights reserved.
//

import UIKit

public class PlannerEvent {
	public var title : String!
	public var start : NSDate!
	public var end : NSDate!
	public var displayDate : NSDate!
	
	public var backgroundColor : UIColor {
		get {
			return UIColor.blueColor().colorWithAlphaComponent(0.8)
		}
	}
	public var textColor : UIColor {
		get {
			return UIColor.whiteColor()
		}
	}
	
	public var userInfo = [:]
	
	public func durationInMinutes() -> Int {
		let hourMinuteComponents: NSCalendarUnit = [.Minute]
		let timeDifference = NSCalendar.currentCalendar().components(
			hourMinuteComponents,
			fromDate: start,
			toDate: end,
			options: [])

		let duration = timeDifference.minute
		
		if(duration < 30){
			return 30;
		}
		
		return duration
		
	}
	
	public func minutesSinceMidnight() -> Int {
		let units : NSCalendarUnit = [.Hour, .Minute]
		let components = NSCalendar.currentCalendar().components(units, fromDate: start)
		return 60 * components.hour + components.minute
	}
}