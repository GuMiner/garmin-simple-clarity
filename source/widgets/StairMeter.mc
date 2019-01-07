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
			
	    	var floorsToRender = Math.ceil(floorsClimbed * 10 / floorsClimbedGoal) + 1;
			if (floorsToRender > 11)
			{
				floorsToRender = 11;
			}
	
			var x_c = SCREEN_SIZE / 2;
			var y_c = SCREEN_SIZE / 2;
			var a_c = 0.41; // Math.PI / 8 plus a bit
			
			var rad_out = SCREEN_SIZE / 2;
			var rad_in = rad_out - 5;
			var spacerAngle = 8.0 * Math.PI / 180.0;
			var spacerEnd = 6.0 * Math.PI / 180.0;
			var spacerHalf = spacerEnd / 2;
			
			dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_BLACK);
			for (var i = 0; i < 11; i++)
			{
				var x_o = x_c + rad_out * Math.cos(a_c - i * spacerAngle);
				var y_o = y_c + rad_out * Math.sin(a_c - i * spacerAngle);
	
				var x_1 = x_c + rad_out * Math.cos(a_c - i * spacerAngle - spacerEnd);
				var y_1 = y_c + rad_out * Math.sin(a_c - i * spacerAngle - spacerEnd);
	
				var x_2 = x_c + rad_in * Math.cos(a_c - i * spacerAngle - spacerEnd);
				var y_2 = y_c + rad_in * Math.sin(a_c - i * spacerAngle - spacerEnd);
	
				var x_3 = x_c + rad_in * Math.cos(a_c - i * spacerAngle);
				var y_3 = y_c + rad_in * Math.sin(a_c - i * spacerAngle);
	
				if (i == 1)
				{
					dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
				}
				else if (i == floorsToRender) 
				{
					dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
				}
				
				dc.fillPolygon([[x_o, y_o], [x_1, y_1], [x_2, y_2], [x_3, y_3]]);			
			} 		
	    }
	}
}