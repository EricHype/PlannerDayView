//
//  MyPlannerEvent.swift
//  DayPlanner
//
//  Created by Eric Heitmuller on 4/30/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//

import Foundation
import UIKit

class MyPlannerEvent : PlannerEvent {
	override var backgroundColor: UIColor{
		get {
			return UIColor.redColor().colorWithAlphaComponent(0.8)
		}
	}
}