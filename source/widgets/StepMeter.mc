using Toybox.Application;
using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Math;
using Toybox.System;

// Renders the step square-based meter (percentage-based with text included)
module SimpleClarity {
	module StepMeter {
		const STEP_TEXT_Y = 195;
		
		function renderStepMeter(dc, SCREEN_SIZE) {
	        var steps = GoalTracker.getSteps();
	        var stepsGoal = GoalTracker.getStepsGoal();
	        if (null == steps || stepsGoal == null) {
	        	return;
	        }
	
			renderStepText(dc, steps, stepsGoal, SCREEN_SIZE);
			renderSteps(dc, steps, stepsGoal, SCREEN_SIZE);	
	    }
	    
	    function renderStepText(dc, steps, stepsGoal, SCREEN_SIZE) {
	    	dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
     		
     		var countOrGoal = Application.getApp().getProperty("displayStepCountOrGoal");
     		var str = null;
    		if (countOrGoal != null && countOrGoal == 0) { // Display step goal
    			str = Lang.format("$1$", [stepsGoal]);
    		} else {
    			str = Lang.format("$1$", [steps]);
    		}
    		
    		dc.drawText(SCREEN_SIZE / 2, STEP_TEXT_Y, Graphics.FONT_XTINY, str, Graphics.TEXT_JUSTIFY_CENTER);
	    }
	    
	    function renderSteps(dc, steps, stepsGoal, SCREEN_SIZE) {
	    	var percentage = Math.ceil(steps * 100 / stepsGoal);
			if (percentage > 100)
			{
				percentage = 100;
			}
			
			var x_c = SCREEN_SIZE / 2;
			var y_c = SCREEN_SIZE / 2;

			var spacerAngle = 4.4 * Math.PI / 180.0; // 180 / 40, 20 steps per quarter circle
			var spacerEnd = 2 * Math.PI / 180.0;
			var spacerHalf = spacerEnd / 2;

			var a_c = Math.PI / 2 - spacerEnd; // Rotation to start at the bottom and increment right
			
			var rad_out = SCREEN_SIZE / 2;
			var rad_in = rad_out - 10; // Arbitrary pixel amount
	
			var counter = 0;
			dc.setColor(0x00FFFF, Graphics.COLOR_BLACK);
			for (var i = 0; i <= 40; i++)
			{
				// Change colors to indicate power levels
				if (i > percentage / 2.5) {
					dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
				}
		
				// Add tick marks appropriately.
				var rad_in_eff = rad_in;
				if (i % 5 == 0)
				{
					rad_in_eff -= 5;
				}
				
				if (i % 10 == 0)
				{
					rad_in_eff -= 3;
				}
		
				var x_o = x_c + rad_out * Math.cos(a_c - i * spacerAngle);
				var y_o = y_c + rad_out * Math.sin(a_c - i * spacerAngle);
	
				var x_1 = x_c + rad_out * Math.cos(a_c - i * spacerAngle - spacerEnd);
				var y_1 = y_c + rad_out * Math.sin(a_c - i * spacerAngle - spacerEnd);
	
				var x_2 = x_c + rad_in_eff * Math.cos(a_c - i * spacerAngle - spacerEnd);
				var y_2 = y_c + rad_in_eff * Math.sin(a_c - i * spacerAngle - spacerEnd);
	
				var x_3 = x_c + rad_in_eff * Math.cos(a_c - i * spacerAngle);
				var y_3 = y_c + rad_in_eff * Math.sin(a_c - i * spacerAngle);
			
				dc.fillPolygon([[x_o, y_o], [x_1, y_1], [x_2, y_2], [x_3, y_3]]);			
			}
	    }
	}
}