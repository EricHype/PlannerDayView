//
//  PlannerEvent.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 12/30/15.
//  Copyright © 2015 Eric Heitmuller. All rights reserved.
//
import Foundation
import UIKit

class PlannerDayEventView : TapDetectingView, TapDetectingViewDelegate{
	
	let DEFAULT_LABEL_FONT_SIZE        = 12;
	let kAlpha : CGFloat        = 1.0;
	let kCornerRadius : CGFloat = 10.0;
	let kCorner : CGFloat       = 5.0;
	
	var title : String!
	var textColor : UIColor!
	var textFont : UIFont!
	weak var dayView : PlannerDayView?
	var event : PlannerEvent!
	var textRect : CGRect!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupCustomInitialisation()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupCustomInitialisation()
	}
	
	
	
	func setupCustomInitialisation(){
		twoFingerTapIsPossible = false;
		multipleTouches = false;
		delegate = self;
		
		self.alpha = kAlpha;
		let layer : CALayer = self.layer;
		layer.masksToBounds = true;
		layer.cornerRadius = kCornerRadius;

	}
	
	override func layoutSubviews() {
		textRect = CGRectMake((CGRectGetMinX(self.bounds) + kCorner),
			(CGRectGetMinY(self.bounds) + kCorner),
			(CGRectGetWidth(self.bounds) - 2*kCorner),
			(CGRectGetHeight(self.bounds) - 2*kCorner))
		
		let sizeNeeded : CGSize = self.title.sizeWithAttributes([NSFontAttributeName: self.textFont])
		if (textRect.size.height > sizeNeeded.height) {
			textRect.origin.y =  ((textRect.size.height - sizeNeeded.height) / 2 + kCorner);
		}
	}
	
	override func drawRect(rect: CGRect) {
		textColor.set()
		
		
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
		paragraphStyle.alignment = .Left

		
		let attributes = [NSFontAttributeName : self.textFont,
			NSParagraphStyleAttributeName : paragraphStyle,
			NSForegroundColorAttributeName : textColor]
		
		self.title.drawInRect(textRect, withAttributes: attributes)
	}
	func tapDetectingView(view: TapDetectingView, gotDoubleTapAtPoint: CGPoint){
	
	}
	
	func tapDetectingView(view: TapDetectingView, gotSingleTapAtPoint: CGPoint) {
		
		if let myDayView = self.dayView{
			myDayView.delegate.dayView(self.dayView!, eventTapped: self.event)
		}
	}
	
	func tapDetectingView(view: TapDetectingView, gotTwoFingerTapAtPoint: CGPoint) {
		
	}
	
}
