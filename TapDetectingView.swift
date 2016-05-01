//
//  TapDetectingView.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 12/31/15.
//  Copyright © 2015 Eric Heitmuller. All rights reserved.
//

import UIKit

protocol TapDetectingViewDelegate : NSObjectProtocol {
	func tapDetectingView(view: TapDetectingView, gotSingleTapAtPoint: CGPoint);
	func tapDetectingView(view: TapDetectingView, gotDoubleTapAtPoint: CGPoint);
	func tapDetectingView(view: TapDetectingView, gotTwoFingerTapAtPoint: CGPoint);
}


class TapDetectingView : UIView {
	
	let DOUBLE_TAP_DELAY = 0.35
	
	var delegate : TapDetectingViewDelegate!
	var tapLocation : CGPoint!
	var multipleTouches: Bool = false
	var twoFingerTapIsPossible : Bool = false;
	
	override init(frame: CGRect) {
		super.init(frame: frame);
		self.userInteractionEnabled = true;
		self.multipleTouchEnabled = true;
		twoFingerTapIsPossible = true;
		multipleTouches = false;
	}

	required init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		// cancel any pending handleSingleTap messages 	
		NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(TapDetectingView.handleSingleTap), object: nil)

		// update our touch state
		if event!.touchesForView(self)!.count > 1 {
			multipleTouches = true
		}
		if event!.touchesForView(self)!.count > 2 {
			twoFingerTapIsPossible = false
		}
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		let allTouchesEnded: Bool = (touches.count == event!.touchesForView(self)!.count)
		
		// first check for plain single/double tap, which is only possible if we haven't seen multiple touches
		if !multipleTouches {
			let touch: UITouch = touches.first!
			tapLocation = touch.locationInView(self)
			if touch.tapCount == 1 {
				self.performSelector(#selector(TapDetectingView.handleSingleTap), withObject: nil, afterDelay: DOUBLE_TAP_DELAY)
			}
			else if touch.tapCount == 2 {
				self.handleDoubleTap()
			}
		}  else if (multipleTouches && twoFingerTapIsPossible) {
			
			// case 1: this is the end of both touches at once
			if touches.count == 2 && allTouchesEnded {
				var i: Int = 0
				var tapCounts = [0,0]
				var tapLocations: [CGPoint] = [CGPoint(), CGPoint()]
				for touch: UITouch in touches {
					tapCounts[i] = touch.tapCount
					tapLocations[i] = touch.locationInView(self)
					i += 1
				}
				if tapCounts[0] == 1 && tapCounts[1] == 1 {
					// it's a two-finger tap if they're both single taps
					tapLocation = midpointBetweenPoints(tapLocations[0], b: tapLocations[1])
					self.handleTwoFingerTap()
				}
			}
			// case 2: this is the end of one touch, and the other hasn't ended yet
			else if (touches.count == 1 && !allTouchesEnded) {
				let touch: UITouch = touches.first!
				if touch.tapCount == 1 {
					// if touch is a single tap, store its location so we can average it with the second touch location
					tapLocation = touch.locationInView(self)
				}
				else {
					twoFingerTapIsPossible = false
				}
			}
			// case 3: this is the end of the second of the two touches
			else if (touches.count == 1 && allTouchesEnded) {
				let touch: UITouch = touches.first!
				if touch.tapCount == 1 {
					// if the last touch up is a single tap, this was a 2-finger tap
					tapLocation = midpointBetweenPoints(tapLocation, b: touch.locationInView(self))
					self.handleTwoFingerTap()
				}
			}
		
		}
		
		// if all touches are up, reset touch monitoring state
		if (allTouchesEnded) {
			twoFingerTapIsPossible = true;
			multipleTouches = false;
		}		
	}
	
	override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		twoFingerTapIsPossible = false;
		multipleTouches = true;
	}
	
	
	func handleSingleTap(){
			delegate.tapDetectingView(self, gotSingleTapAtPoint: tapLocation)
	}
	
	func handleDoubleTap(){
			delegate.tapDetectingView(self, gotDoubleTapAtPoint: tapLocation)
	}

	func handleTwoFingerTap(){
			delegate.tapDetectingView(self, gotTwoFingerTapAtPoint: tapLocation)
	}
	
	
	func midpointBetweenPoints( a : CGPoint, b : CGPoint) -> CGPoint {
		let x = (a.x + b.x) / 2.0;
		let y = (a.y + b.y) / 2.0;
		return CGPointMake(x, y);
	}
}



