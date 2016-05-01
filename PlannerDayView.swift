//
//  DayEventView.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 12/29/15.
//  Copyright © 2015 Eric Heitmuller. All rights reserved.
//

import UIKit

//MAdayview
class PlannerDayView : UIView {
	
	let HOURS_IN_DAY                   = 25; // Beginning and end of day is included, so we end up with an extra hour
	let MINUTES_IN_HOUR                = 60;
	let SPACE_BETWEEN_HOUR_LABELS      = 3;
	let DEFAULT_LABEL_FONT_SIZE : CGFloat        = 12;
	let ALL_DAY_VIEW_EMPTY_SPACE       = 3;
	
	let ARROW_LEFT                     = 0;
	let ARROW_RIGHT                    = 1;
	let ARROW_WIDTH                    = 48;
	let ARROW_HEIGHT                   = 38;
	let TOP_BACKGROUND_HEIGHT          = 35;
	
	var topBackground : UIImageView?
	var leftArrow : UIButton?
	var rightArrow : UIButton?
	var dateLabel : UILabel?
	
	var scrollView : UIScrollView!
	var gridView : PlannerDayGridView!
	
	var autoScrollToFirstEvent = true
	var labelFontSize : CGFloat = 12
	var regularFont : UIFont?
	var boldFont : UIFont?
	
	var currentDate : NSDate?
	
	var swipeLeftRecognizer : UISwipeGestureRecognizer!
	var swipeRightRecognizer : UISwipeGestureRecognizer!
	
	var events : [PlannerEvent] = []
	var delegate : PlannerDayViewDelegate!
	
	
	var firstDate : NSDate?
	var lastDate : NSDate?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initialize()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initialize()
	}
	
	
	func initialize(){
		
		//fonts
		self.regularFont = UIFont.systemFontOfSize(labelFontSize)
		self.boldFont = UIFont.boldSystemFontOfSize(labelFontSize)
		
		//construct the top section
		topBackground = UIImageView(image: UIImage(named:"topBackground"))
		leftArrow = UIButton(type: UIButtonType.Custom)
		leftArrow?.tag = 0
		leftArrow?.setImage(UIImage(named: "leftArrow"), forState: UIControlState.Normal)
		leftArrow?.addTarget(self, action: #selector(PlannerDayView.changeDay(_:)), forControlEvents: UIControlEvents.TouchUpInside)
		
		rightArrow = UIButton(type: UIButtonType.Custom)
		rightArrow?.tag = 1
		rightArrow?.setImage(UIImage(named: "rightArrow"), forState: UIControlState.Normal)
		rightArrow?.addTarget(self, action: #selector(PlannerDayView.changeDay(_:)), forControlEvents: UIControlEvents.TouchUpInside)

		dateLabel = UILabel()
		dateLabel?.textAlignment = NSTextAlignment.Center
		dateLabel?.backgroundColor = UIColor.clearColor()
		//dateLabel?.backgroundColor = UIColor.blueColor()
		
		let fontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
		let boldFontDescriptor = fontDescriptor.fontDescriptorWithSymbolicTraits(.TraitBold)
		dateLabel?.font = UIFont(descriptor: boldFontDescriptor, size: 18)
		dateLabel?.textColor = UIColor(colorLiteralRed: 59/255, green: 73/255, blue: 88/255, alpha: 1)
	
		self.labelFontSize = DEFAULT_LABEL_FONT_SIZE
		self.currentDate = NSDate()
		
		self.addSubview(topBackground!)
		self.addSubview(leftArrow!)
		self.addSubview(rightArrow!)
		self.addSubview(dateLabel!)
		
		
		
		//construct the main body
		
		scrollView = UIScrollView()
		scrollView.backgroundColor      = UIColor.whiteColor()
		scrollView.scrollEnabled        = true;
		scrollView.alwaysBounceVertical = true;
		
		self.addSubview(scrollView)

		//SKIP AllDayGrid
		
		gridView = PlannerDayGridView()
		gridView.backgroundColor = UIColor.whiteColor()
		gridView.textFont = self.boldFont!
		gridView.textColor = UIColor.blackColor()
		gridView.dayView = self;

		
		scrollView.addSubview(self.gridView);
		
		
		//add gesture recognizers
		self.swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PlannerDayView.handleSwipeFrom(_:)))
		self.swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirection.Left;
	
		self.swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PlannerDayView.handleSwipeFrom(_:)))
		self.swipeRightRecognizer.direction = UISwipeGestureRecognizerDirection.Right;
		
		self.gridView.addGestureRecognizer(self.swipeLeftRecognizer!);
		self.gridView.addGestureRecognizer(self.swipeRightRecognizer!);
		
	}

	override func layoutSubviews() {
		self.topBackground!.frame = CGRectMake(CGRectGetMinX(self.bounds),
			CGRectGetMinY(self.bounds),
			CGRectGetWidth(self.bounds),
			CGFloat(TOP_BACKGROUND_HEIGHT + 10));
		self.leftArrow!.frame = CGRectMake(CGRectGetMinX(self.topBackground!.bounds),
				((CGRectGetHeight(self.topBackground!.bounds) - CGFloat(ARROW_HEIGHT)) / 2) + CGFloat(6),
				CGFloat(ARROW_WIDTH),
				CGFloat(ARROW_HEIGHT));
		self.rightArrow!.frame = CGRectMake(CGRectGetWidth(self.topBackground!.bounds) - CGFloat(ARROW_WIDTH),
			((CGRectGetHeight(self.topBackground!.bounds) - CGFloat(ARROW_HEIGHT)) / 2) + 6,
			CGFloat(ARROW_WIDTH),
			CGFloat(ARROW_HEIGHT));
		self.dateLabel!.frame = CGRectMake(
			CGRectGetMaxX(self.leftArrow!.bounds),
			((CGRectGetHeight(self.topBackground!.bounds) - CGFloat(ARROW_HEIGHT)) / 2) + 6,
			CGRectGetWidth(self.topBackground!.bounds) - CGRectGetWidth(self.leftArrow!.bounds) - CGRectGetWidth(self.rightArrow!.bounds),
			CGFloat(ARROW_HEIGHT));

	
		let sizeNeeded : CGSize = "FOO".sizeWithAttributes([NSFontAttributeName: self.boldFont!])
		
		self.gridView.frame = CGRectMake(
			0,
			0,
			CGRectGetWidth(self.bounds),
			sizeNeeded.height * CGFloat(SPACE_BETWEEN_HOUR_LABELS) * CGFloat(HOURS_IN_DAY));
		
		self.scrollView.frame = CGRectMake(
			CGRectGetMinX(self.bounds),
			CGRectGetMaxY(self.topBackground!.bounds),
			CGRectGetWidth(self.bounds),
			CGRectGetHeight(self.bounds) - CGRectGetHeight(self.topBackground!.bounds));
		
		self.scrollView.contentSize = CGSizeMake(
			CGRectGetWidth(self.bounds),
			CGRectGetHeight(self.gridView.bounds));
		
		self.gridView.setNeedsDisplay()
		
	}
	
	func changeDay(sender: UIButton?){
		
		var newDate : NSDate;
		
		if(sender!.tag == leftArrow!.tag){
			newDate = currentDate!.addDays(-1)
		} else{
			newDate = currentDate!.addDays(1)
		}
		setDate(newDate)
		delegate?.dateChanged(newDate)
	}
	
	func setDate(date: NSDate){
		
		let formatter = NSDateFormatter()
		formatter.dateStyle = NSDateFormatterStyle.ShortStyle
		let calendar = NSCalendar.currentCalendar()
		let timeUnits : NSCalendarUnit = [.Year, .Month, .WeekOfMonth, .Weekday, .WeekdayOrdinal, .Day, .Hour, .Minute, .Second]
		
		let components = calendar.components(timeUnits, fromDate: date)
		components.calendar = NSCalendar.currentCalendar();
		components.hour = 0
		components.minute = 0
		components.second = 0
		
		currentDate = calendar.dateFromComponents(components)

		let shortDayFormatter = NSDateFormatter()
		shortDayFormatter.setLocalizedDateFormatFromTemplate("EEE");
		
		
		self.dateLabel?.text =  shortDayFormatter.stringFromDate(date) + " " + formatter.stringFromDate(date)
		
		
		
		reloadData()
	}
	
	func reloadData(){
		
		//clear existing data
		for view in self.gridView.subviews {
			if (view is PlannerDayEventView) {
				view.removeFromSuperview()
			}
		}
		
		self.events.sortInPlace(){
			let event1StartMinutes = $0.minutesSinceMidnight()
			let event2StartMinutes = $1.minutesSinceMidnight()

			if(event1StartMinutes < event2StartMinutes){
				return true;
			}
			
			if(event1StartMinutes > event2StartMinutes){
				return false;
			}
			
			//Event start time is the same, compare by duration.
			let d1 = $0.durationInMinutes();
			let d2 = $1.durationInMinutes();
			
			if (d1 < d2) {
				/*
				* Event with a shorter duration is after an event
				* with a longer duration. Looks nicer when drawing the events.
				*/
				return false
			}
			
			if (d1 > d2) {
				return true
			}
			
			return $0.title < $1.title;
		}
		
		for event in self.events {
			event.displayDate = self.currentDate;
			self.gridView.addEvent(event)
		}
	}
	
	func handleSwipeFrom(recognizer : UISwipeGestureRecognizer){
		if (recognizer.direction == UISwipeGestureRecognizerDirection.Left) {
			changeDay(self.rightArrow);
		} else  if (recognizer.direction == UISwipeGestureRecognizerDirection.Right) {
			changeDay(self.leftArrow);
		}
	}
	
}
