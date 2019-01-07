using Toybox.Graphics;
using Toybox.Lang;
using Toybox.System;

// Renders minor device sensors. This currently includes pressure, temperature, and elevation.
module SimpleClarity {
	module MinorSensors {
		const TEMP_X = 25;
		const Y_POS = 153;
		const X_SEP = 20;
		
		var currentX;
		function render(dc, stepDivisor) {
			currentX = TEMP_X;
			dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
			
			renderTemperature(dc, stepDivisor);
			renderElevation(dc, stepDivisor);
			renderPressure(dc, stepDivisor);
		}
		
		function renderString(dc, str, stepDivisor) {
			dc.drawText(currentX, Y_POS, Graphics.FONT_XTINY, str, Graphics.TEXT_JUSTIFY_LEFT);
			currentX = currentX + X_SEP / stepDivisor + dc.getTextWidthInPixels(str, Graphics.FONT_XTINY);
		}
	
		function renderTemperature(dc, stepDivisor) {
			var temp = Sensors.getLastTemperature();
			if (null == temp) {
				return;
			}
			
			// Convert to deg F if necessary
			var tempStr;
			if (System.getDeviceSettings().temperatureUnits == System.UNIT_STATUTE) {
				temp = ((9.0 / 5.0) * temp) + 32.0;
				tempStr = Lang.format("$1$ F", [temp.format("%.1f")]);
			} else {
				tempStr = Lang.format("$1$ C", [temp.format("%.1f")]);
			}
			
			renderString(dc, tempStr, stepDivisor);
    	}
    
    	function renderElevation(dc, stepDivisor) {
			var elevation = Sensors.getLastElevation();
			if (null == elevation) {
				return;
			}
			
			// Convert to ft if necessary
			var elevationStr;
			if (System.getDeviceSettings().elevationUnits == System.UNIT_STATUTE) {
				elevation = elevation * 3.28084;
				elevationStr = Lang.format("$1$ ft", [elevation.format("%.0f")]);
			} else {
				elevationStr = Lang.format("$1$ m", [elevation.format("%.0f")]);
			}
			
			renderString(dc, elevationStr, stepDivisor);
    	}
    
	    function renderPressure(dc, stepDivisor) {
	    	// Pressure normally is plus or minus 4% of 1 ATM (101,325 Pa), so we render it as a percentage difference from 1 ATM
	    	var pressure = Sensors.getLastPressure();
			if (null == pressure || pressure == 0) {
				return;
			}
			
			var pressureDelta = 100.0 * 101325 / pressure - 100.0;
			var pressureStr = Lang.format("$1$ %", [pressureDelta.format("%+.1f")]);
			
			renderString(dc, pressureStr, stepDivisor);
	    }
	}
}