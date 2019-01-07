using Toybox.Graphics;
using Toybox.Math;
using Toybox.System;

// Renders the stair rectangle-based meter
module SimpleClarity {
	module StairMeter {
		function renderStairMeter(dc, SCREEN_SIZE) {
	        var floorsClimbed = GoalTracker.getFloorsClimbed(); // Ensure we always display at least one item
	        var floorsClimbedGoal = GoalTracker.getFloorsClimbedGoal();
			if (floorsClimbed == null || floorsClimbedGoal == null) {
				return;
			}
			
	    	var percentage = Math.ceil(floorsClimbed * 100 / floorsClimbedGoal);
			if (percentage > 100)
			{
				percentage = 100;
			}
			
			var x_c = SCREEN_SIZE / 2;
			var y_c = SCREEN_SIZE / 2;

			var spacerAngle = 7.5 * Math.PI / 180.0; // 180 / 40, 20 steps per quarter circle
			var spacerEnd = 6 * Math.PI / 180.0;
			var spacerHalf = spacerEnd / 2;

			var a_c = Math.PI + 0.2; // Rotation to start at the left and increment CW
			
			var rad_out = SCREEN_SIZE / 2;
			var rad_in = rad_out - 5; // Arbitrary pixel amount
	
			var counter = 0;
			dc.setColor(0xFFFF00, Graphics.COLOR_BLACK);
			for (var i = 0; i <= 10; i++)
			{
				// Change colors to indicate power levels
				if (i > percentage / 10 || floorsClimbed == 0) {
					dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_BLACK);
				}
		
				// Add tick marks appropriately.
				var rad_in_eff = rad_in;
				if (i % 10 == 0)
				{
					rad_in_eff -= 5;
				}
		
				var x_o = x_c + rad_out * Math.cos(a_c + i * spacerAngle);
				var y_o = y_c + rad_out * Math.sin(a_c + i * spacerAngle);
	
				var x_1 = x_c + rad_out * Math.cos(a_c + i * spacerAngle - spacerEnd);
				var y_1 = y_c + rad_out * Math.sin(a_c + i * spacerAngle - spacerEnd);
	
				var x_2 = x_c + rad_in_eff * Math.cos(a_c + i * spacerAngle - spacerEnd);
				var y_2 = y_c + rad_in_eff * Math.sin(a_c + i * spacerAngle - spacerEnd);
	
				var x_3 = x_c + rad_in_eff * Math.cos(a_c + i * spacerAngle);
				var y_3 = y_c + rad_in_eff * Math.sin(a_c + i * spacerAngle);
			
				dc.fillPolygon([[x_o, y_o], [x_1, y_1], [x_2, y_2], [x_3, y_3]]);			
			}
	    }
	}
}