//
//  DayGridView.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 12/30/15.
//  Copyright © 2015 Eric Heitmuller. All rights reserved.
//

import UIKit

class PlannerDayGridView : UIView {

	var  dayView : PlannerDayView!
	var  textColor : UIColor!
	var  textFont : UIFont!
	var  lineX : CGFloat = 0.0

	var lineY : [CGFloat] = [CGFloat](count: 25, repeatedValue: CGFloat()) //25
	var dashedLineY : [CGFloat] = [CGFloat](count: 25, repeatedValue: CGFloat())
	var textRect : [CGRect] = [CGRect](count: 25, repeatedValue: CGRect())


	func timeIs24HourFormat() -> Bool{
		let formatter = NSDateFormatter()
		formatter.dateStyle = NSDateFormatterStyle.NoStyle
		formatter.timeStyle = NSDateFormatterStyle.ShortStyle
		let dateString = formatter.stringFromDate(NSDate())

		let amExists : Bool = dateString.rangeOfString(formatter.AMSymbol) != nil
		let pmExists : Bool = dateString.rangeOfString(formatter.PMSymbol) != nil
		let is24Hour : Bool = (!amExists && !pmExists)
		return is24Hour;
	}
	
	func addEvent(event : PlannerEvent){
		
		//create view for it
		let eventView : PlannerDayEventView = PlannerDayEventView(frame: CGRectZero);
		eventView.dayView = self.dayView;
		eventView.event = event;
		eventView.backgroundColor = event.backgroundColor;
		eventView.title = event.title;
		eventView.textFont = self.dayView.boldFont!;
		eventView.textColor = event.textColor;
		
		//add view and tell myself to redraw
		self.addSubview(eventView);
		self.setNeedsLayout();
	
	}

	let HOURS_AM_PM: [String] = [
	" 12 AM", " 1 AM", " 2 AM", " 3 AM", " 4 AM", " 5 AM", " 6 AM", " 7 AM", " 8 AM", " 9 AM", " 10 AM", " 11 AM",
	" Noon", " 1 PM", " 2 PM", " 3 PM", " 4 PM", " 5 PM", " 6 PM", " 7 PM", " 8 PM", " 9 PM", " 10 PM", " 11 PM", " 12 PM"
	];
	
	let HOURS_24: [String] = [
	" 0:00", " 1:00", " 2:00", " 3:00", " 4:00", " 5:00", " 6:00", " 7:00", " 8:00", " 9:00", " 10:00", " 11:00",
	" 12:00", " 13:00", " 14:00", " 15:00", " 16:00", " 17:00", " 18:00", " 19:00", " 20:00", " 21:00", " 22:00", " 23:00", " 0:00"
	];
	
	let HOURS_IN_DAY = 25; //yes we have an extra hour to show the start of the next day.
	
	override func layoutSubviews() {
		var maxTextWidth : CGFloat = 0
		var totalTextHeight : CGFloat = 0
		var hourSize = [CGSize](count:25, repeatedValue: CGSize())
		
		let HOURS : [String] = self.timeIs24HourFormat() ? HOURS_24 : HOURS_AM_PM;
		
		
		for i in 0 ..< HOURS_IN_DAY {
			
			hourSize[i] = HOURS[i].sizeWithAttributes([NSFontAttributeName: self.textFont])
			totalTextHeight += hourSize[i].height;
			
			if (hourSize[i].width > maxTextWidth) {
				maxTextWidth = hourSize[i].width;
			}
		}
		
		var y : CGFloat;
		let  spaceBetweenHours : CGFloat = (self.bounds.size.height - totalTextHeight) / CGFloat(HOURS_IN_DAY - 1)
		var rowY : CGFloat = 0;
		
		for i in 0 ..< HOURS_IN_DAY {
			textRect[i] = CGRectMake(CGRectGetMinX(self.bounds),
				rowY,
				maxTextWidth,
				hourSize[i].height);
			
			y = rowY + ((CGRectGetMaxY(textRect[i]) - CGRectGetMinY(textRect[i])) / 2);
			lineY[i] = y;
			dashedLineY[i] = CGRectGetMaxY(textRect[i]) + (spaceBetweenHours / 2);
			
			rowY += hourSize[i].height + spaceBetweenHours;
		}
		
		lineX = maxTextWidth + (maxTextWidth * 0.3);
		
		let max = subviews.count
		
		
		var curEv : PlannerDayEventView! = nil
		var nextEv  : PlannerDayEventView! = nil
		var firstEvent : PlannerDayEventView! = nil;
		let spacePerMinute : CGFloat  = (lineY[1] - lineY[0]) / 60;
		
		// set initial view positions
		for i in 0 ..< max {
			
			let currentView = subviews[i]
			
			if !(currentView is PlannerDayEventView) {
				continue
			}
			
			curEv = currentView as! PlannerDayEventView
			
			curEv!.frame = CGRectMake(lineX,
				(spacePerMinute * CGFloat(curEv.event.minutesSinceMidnight()) + lineY[0]),
				(self.bounds.size.width - lineX),
				(spacePerMinute * CGFloat(curEv.event.durationInMinutes()) ))
			
			curEv!.setNeedsDisplay()
			
			if (firstEvent == nil || curEv!.frame.origin.y < firstEvent!.frame.origin.y) {
				firstEvent = curEv
			}
			
		}
		
		curEv = nil;
		var shrinkCurEv : Bool = false;
		// check for overlaps and compensate
		for i in 0 ..< max {
			
			let currentView = subviews[i]
			
			if !(currentView is PlannerDayEventView) {
				continue;
			}
			curEv = currentView as! PlannerDayEventView
			
			for j in i+1 ..< max {
				
				let nextView = subviews[j]
				
				if !(nextView is PlannerDayEventView) {
					continue;
				}
				nextEv = nextView as! PlannerDayEventView
				
				/*
				* Layout intersecting events to two columns.
				*/
				
				if (CGRectIntersectsRect(curEv.frame, nextEv.frame))
				{
					if (curEv.frame.origin.x == nextEv.frame.origin.x) {
						shrinkCurEv = true;
					}
					
					
					nextEv.frame = CGRectMake(
						(nextEv.frame.origin.x + ((curEv.frame.origin.x == lineX || curEv.frame.origin.x == nextEv.frame.origin.x) ? (nextEv.frame.size.width / 2) : 0)),
						(nextEv.frame.origin.y),
						(nextEv.frame.size.width / 2),
						(nextEv.frame.size.height));
					
					
					nextEv!.setNeedsDisplay()
				}
			}
			
			if (shrinkCurEv) {
				shrinkCurEv = false;
				curEv!.frame = CGRectMake(
					(curEv!.frame.origin.x),
					(curEv!.frame.origin.y),
					(curEv!.frame.size.width / 2),
					(curEv!.frame.size.height));
				
				curEv!.setNeedsDisplay()
			}
		}
		
		
		if (self.dayView.autoScrollToFirstEvent) {
			var autoScrollPoint : CGPoint
			
			if (firstEvent == nil) {
				autoScrollPoint = CGPointMake(0, 0);
			} else {
				let minutesSinceLastHour : Int = (firstEvent!.event.minutesSinceMidnight() % 60);
				let padding : CGFloat = CGFloat(minutesSinceLastHour) * spacePerMinute + 7.5;
				
				autoScrollPoint = CGPointMake(0, firstEvent!.frame.origin.y - padding);
				let maxY : CGFloat = self.dayView.scrollView.contentSize.height - CGRectGetHeight(self.dayView.scrollView.bounds);
				
				if (autoScrollPoint.y > maxY) {
					autoScrollPoint.y = maxY
				}
			}
			
			self.dayView.scrollView.setContentOffset(autoScrollPoint, animated: true)
		}
	}
	
	override func drawRect(rect: CGRect) {
		let HOURS = (self.timeIs24HourFormat() ? HOURS_24 : HOURS_AM_PM)
		let c : CGContextRef = UIGraphicsGetCurrentContext()!
		
		CGContextSetStrokeColorWithColor(c, UIColor.lightGrayColor().CGColor)
		CGContextSetLineWidth(c, 0.5)
		CGContextBeginPath(c)
		
		for i in 0 ..< HOURS_IN_DAY {
			
			
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
			paragraphStyle.alignment = .Right
			
			
			let attributes = [NSFontAttributeName : self.textFont,
				NSParagraphStyleAttributeName : paragraphStyle]

			
			HOURS[i].drawInRect(textRect[i], withAttributes: attributes)
			CGContextMoveToPoint(c, lineX, lineY[i]);
			CGContextAddLineToPoint(c, self.bounds.size.width, lineY[i])
		}
		
		CGContextClosePath(c)
		CGContextSaveGState(c)
		CGContextDrawPath(c, CGPathDrawingMode.FillStroke)
		CGContextRestoreGState(c)
			
		CGContextSetLineWidth(c, 0.5)
		let dash1: [CGFloat] = [2.0, 1.0]
		CGContextSetLineDash(c, 0.0, dash1, 2)
		
		CGContextBeginPath(c)

		for i in 0 ..< (HOURS_IN_DAY - 1) {
			CGContextMoveToPoint(c, lineX, dashedLineY[i])
			CGContextAddLineToPoint(c, self.bounds.size.width, dashedLineY[i])
		}
		
		CGContextClosePath(c)
		CGContextSaveGState(c)
		CGContextDrawPath(c, CGPathDrawingMode.FillStroke)
		CGContextRestoreGState(c)
		
	}
	
}
