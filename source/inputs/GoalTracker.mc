using Toybox.ActivityMonitor;
using Toybox.Lang;
using Toybox.System;

// Reads stats about goal tracing. Results returned may be null.
module SimpleClarity {
	module GoalTracker {
		// Returns the aclories burned (kCal) in the current day
		function getCalories() {
			var info = ActivityMonitor.getInfo();
			if (!(info has :calories)) {
				return null;
			} 
			
			return info.calories;
		} 
	
		// Returns the number of floors climbed (integer)
		function getFloorsClimbed() {
			var info = ActivityMonitor.getInfo();
			if (!(info has :floorsClimbed)) {
				return null;
			}
			
			return info.floorsClimbed;
		}
		
		function getFloorsClimbedGoal() {
			var info = ActivityMonitor.getInfo();
			if (!(info has :floorsClimbedGoal)) {
				return null;
			}
			
			return info.floorsClimbedGoal;
		}
		
		// Returns the number of steps clibmed (integer)
		function getSteps() {
			var info = ActivityMonitor.getInfo();
			if (!(info has :steps)) {
				return null;
			}
			
			return info.steps;
		}
		
		function getStepsGoal() {
			var info = ActivityMonitor.getInfo();
			if (!(info has :stepGoal)) {
				return null;
			}

			return info.stepGoal;
		}
	}
}