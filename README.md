# PlannerDayView
A Day planner view written in swift!

A loose recreation of the UI from https://github.com/muhku/calendar-ui this day planner view is written 100% in swift.

<img width="308" alt="screen shot 2016-04-30 at 9 30 30 pm" src="https://cloud.githubusercontent.com/assets/2164582/14940173/ca00e814-0f1e-11e6-9801-cbb181733c20.png">

# Getting Started


1) Clone the Repo and copy evertything in the group "Day Planner" to your own project.
2) Set up a view controller that contains a PlannerDayView and conforms to the PlannerDayViewDelegate protocol.

   import UIKit
   class ViewController: UIViewController, PlannerDayViewDelegate {
    @IBOutlet weak var plannerDayView: PlannerDayView!
    var selectedDay : NSDate!
    
    override func viewDidLoad() {
		super.viewDidLoad()
		
		//normally date is set via a segue from a calendar control
		self.selectedDay = NSDate()
		
		self.plannerDayView.delegate = self
		self.plannerDayView.setDate(self.selectedDay)
		
		reloadData()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func reloadData() {
		
		//imagine an API call was here instead
		let event1 = PlannerEvent()
		event1.start = NSDate().atMidnight().addHours(9)
		event1.end = event1.start.addHours(2)
		event1.title = "Event 1"
		event1.userInfo = ["SomeId":"ABC123"]
		
		let event2 = MyPlannerEvent()
		event2.start = NSDate().atMidnight().addHours(12)
		event2.end = event2.start.addHours(2)
		event2.title = "Event 2"
		event2.userInfo = ["SomeId":"123ABC"]
		

		self.plannerDayView.events = [event1, event2]
		self.plannerDayView.reloadData()
	}

	//handle tapping
	func dayView(dayView: PlannerDayView, eventTapped: PlannerEvent) {
		if(eventTapped.userInfo["SomeId"] != nil){
			let _ = eventTapped.userInfo["SomeId"] as? String
			//do something with Id such as a segue
		}
	}
	
	func dateChanged(newDate : NSDate) {
		self.selectedDay = newDate
		reloadData()
	}
	
	
  }

