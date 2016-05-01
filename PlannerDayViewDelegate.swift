//
//  DayViewDelegate.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 1/4/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation

protocol PlannerDayViewDelegate : NSObjectProtocol{
	func dayView(dayView: PlannerDayView, eventTapped: PlannerEvent)
	func dateChanged(newDate : NSDate);
}