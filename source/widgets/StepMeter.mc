using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Math;
using Toybox.System;

// Renders the step square-based meter (percentage-based with text included)
module SimpleClarity {
	module StepMeter {
		function getPercentColor(idx) {
			switch(idx) {
				case 0:
					return Graphics.COLOR_DK_GRAY;
				case 1:
					return Graphics.COLOR_RED;
				case 2:
					return Graphics.COLOR_ORANGE;
				case 3:
					return Graphics.COLOR_ORANGE;
				case 4:
					return Graphics.COLOR_YELLOW;
				case 5:
					return Graphics.COLOR_DK_GREEN;
				case 6:
					return Graphics.COLOR_DK_BLUE;
				case 7:
					return Graphics.COLOR_DK_BLUE;
				case 8:
					return Graphics.COLOR_PURPLE;
				case 9:
					return Graphics.COLOR_PURPLE;
				default:
					return Graphics.COLOR_WHITE;
			}
		}
	
		const RECT_SIZE = 10;
		const STEP_X = 200;
		const STEP_Y = 180;
		
		const STEP_TEXT_X = 180;
		const STEP_TEXT_Y = 205;
		
		function renderStepMeter(dc) {
	        var steps = GoalTracker.getSteps();
	        var stepsGoal = GoalTracker.getStepsGoal();
	        if (null == steps || stepsGoal == null) {
	        	return;
	        }
	
			renderStepText(dc, steps, stepsGoal);
			renderCheckerboard(dc, steps, stepsGoal);	
	    }
	    
	    function renderStepText(dc, steps, stepsGoal) {
	    	 dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_BLACK);
	    	 
	    	 var str = Lang.format("$1$/$2$", [steps, stepsGoal]);
	    	 dc.drawText(STEP_TEXT_X, STEP_TEXT_Y, Graphics.FONT_XTINY, str, Graphics.TEXT_JUSTIFY_RIGHT);
	    }
	    
	    function renderCheckerboard(dc, steps, stepsGoal) {
	    	var stepsToRender = Math.ceil(steps * 10 / stepsGoal);
			if (stepsToRender > 10)
			{
				stepsToRender = 10;
			}
	
			var spacing = 1 + RECT_SIZE;
			for (var i = 0; i <= stepsToRender; i++)
			{
				var wiggle = 0;
				if (i % 2 == 1)
				{
					wiggle = 1;
				}
				
				var x = STEP_X - (i * spacing);
				var y = STEP_Y + (wiggle * spacing);
				dc.setColor(getPercentColor(i), Graphics.COLOR_BLACK);
				dc.fillRectangle(x, y, RECT_SIZE, RECT_SIZE);
			}
	    }
	}
}