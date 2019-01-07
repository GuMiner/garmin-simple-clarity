using Toybox.Graphics;
using Toybox.Math;
using Toybox.System;

// Renders the battery triangle-based meter.
module SimpleClarity {
	module BatteryMeter {
		function updateColor(dc, idx) {
			if (idx == 0)
			{			
	        	dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        	}
        	else if (idx == 2)
        	{
        		dc.setColor(0xFFAA19, Graphics.COLOR_BLACK);
        	}
        	else if (idx == 10)
        	{
        		dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
        	}
		}
	
		function renderBatteryPercent(dc, SCREEN_SIZE) {
	        var percentage = Sensors.getBatteryPercentage().toNumber();
	
			var x_c = SCREEN_SIZE / 2;
			var y_c = SCREEN_SIZE / 2;
			var a_c = Math.PI / 2;
			
			var rad_out = SCREEN_SIZE / 2;
			var rad_in = rad_out - 10;
			var spacerAngle = 8.0 * Math.PI / 180.0;
			var spacerEnd = 7.0 * Math.PI / 180.0;
			var spacerHalf = spacerEnd / 2;
			
			for (var i = 0; i <= (percentage / 5); i++)
			{
				var x_o = x_c + rad_out * Math.cos(a_c + i * spacerAngle);
				var y_o = y_c + rad_out * Math.sin(a_c + i * spacerAngle);
	
				var x_1 = x_c + rad_out * Math.cos(a_c + i * spacerAngle + spacerEnd);
				var y_1 = y_c + rad_out * Math.sin(a_c + i * spacerAngle + spacerEnd);
	
				var x_2 = x_c + rad_in * Math.cos(a_c + i * spacerAngle + spacerHalf);
				var y_2 = y_c + rad_in * Math.sin(a_c + i * spacerAngle + spacerHalf);
	
				updateColor(dc, i);
				dc.fillPolygon([[x_o, y_o], [x_1, y_1], [x_2, y_2]]);			
			} 		
	    }
	}
}