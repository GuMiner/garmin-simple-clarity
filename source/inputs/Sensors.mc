using Toybox.Activity;
using Toybox.Lang;
using Toybox.System;

// Reads various on-device sensors. Assumes all sensors are present.
module SimpleClarity {
	module Sensors {
		// Gets the battery percentage, from 0 to 100
		function getBatteryPercentage() {
			return Toybox.System.getSystemStats().battery;
		}
	}
}