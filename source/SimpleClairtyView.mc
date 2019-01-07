using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using SimpleClarity.BatteryMeter;
using SimpleClarity.DayMonth;
using SimpleClarity.GoalTracker;
using SimpleClarity.Sensors;
using SimpleClarity.StairMeter;
using SimpleClarity.StepMeter;

// Renders the watch
class SimpleClarityView extends WatchUi.WatchFace {
    // Per-device font settings used to ensure fonts aren't cutoff and render properly.
    var bottomMildFontCutoff;
    var mildFontAscent;
    var topMildFontCutoff;
    const FONT_CLIP_WIGGLE = 4;
    
    var tinyFontHeight;
    var hugeFontDescent;
    var stepDivisor;
    
    var specialFont;
    
    function initialize() {
        WatchFace.initialize();
        specialFont = WatchUi.loadResource(Rez.Fonts.TimeFont);
        
        bottomMildFontCutoff = Graphics.getFontDescent(Graphics.FONT_NUMBER_MILD);
        mildFontAscent = Graphics.getFontAscent(Graphics.FONT_NUMBER_MILD);
        topMildFontCutoff = Graphics.getFontHeight(Graphics.FONT_NUMBER_MILD) - mildFontAscent;
        
        tinyFontHeight = Graphics.getFontHeight(Graphics.FONT_TINY);         
        hugeFontDescent = Graphics.getFontDescent(specialFont);
        
        // This hack detects if we are on devices with larger fonts, in which case we need to squish the extra sensors so they all fit in the display.
        stepDivisor = 1;
        if (hugeFontDescent == 0)
        {
        	stepDivisor = 4;
        }
    }   
    
    const SCREEN_SIZE = 240;
	const DAY_MONTH_Y = 55;
	
	var lastHr = 70; // A reasonable default for first-time startup
	var fullUpdate = false;
	
    // Fully updates the watch
    function onUpdate(dc) {
		// Reset the background
        dc.clearClip();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

		// Render time info    	
        var clockTime = System.getClockTime();
        renderHrMin(dc, clockTime.hour, clockTime.min);
        DayMonth.renderDayMonth(dc, SCREEN_SIZE, DAY_MONTH_Y);
        
        // Render all the various sensors
		//BatteryMeter.renderBatteryPercent(dc, SCREEN_SIZE);
		//StairMeter.renderStairMeter(dc, SCREEN_SIZE);
		//StepMeter.renderStepMeter(dc);

		//renderCalories(dc);
		renderColorBoxes(dc);

		// Render per-second updates (hr and seconds)
		fullUpdate = true;
		onPartialUpdate(dc);
		fullUpdate = false;
    }
    
    function setColor(dc, idx) {
    	idx = idx + 1;
    	var idx3 = (idx / 36) % 6;
    	var idx1 = idx % 6;
    	var idx2 = (idx / 6) % 6;
		var steps =  (idx1)*0x000033;
		var steps2 = (idx2)*0x003300;
		var steps3 = (idx3)*0x330000;
		var color = steps + steps2 + steps3;
		dc.setColor(color, Graphics.COLOR_BLACK);
	}
	
    function renderColorBoxes(dc) {
    	var percentage = Sensors.getBatteryPercentage().toNumber();
	
		var x_c = SCREEN_SIZE / 2;
		var y_c = SCREEN_SIZE / 2;
		var a_c = 0;
			
		var rad_out = SCREEN_SIZE / 2;
		var rad_in = rad_out - 10;
		var spacerAngle = 12 * Math.PI / 180.0;
		var spacerEnd = 10 * Math.PI / 180.0;
		var spacerHalf = spacerEnd / 2;
			
		var counter = 0;
		for (var i = 0; i < 30; i++)
		{
			var x_o = x_c + rad_out * Math.cos(a_c - i * spacerAngle);
			var y_o = y_c + rad_out * Math.sin(a_c - i * spacerAngle);
	
			var x_1 = x_c + rad_out * Math.cos(a_c - i * spacerAngle - spacerEnd);
			var y_1 = y_c + rad_out * Math.sin(a_c - i * spacerAngle - spacerEnd);
	
			var x_2 = x_c + rad_in * Math.cos(a_c - i * spacerAngle - spacerEnd);
			var y_2 = y_c + rad_in * Math.sin(a_c - i * spacerAngle - spacerEnd);
	
			var x_3 = x_c + rad_in * Math.cos(a_c - i * spacerAngle);
			var y_3 = y_c + rad_in * Math.sin(a_c - i * spacerAngle);
	
			setColor(dc, i + counter);
			dc.fillPolygon([[x_o, y_o], [x_1, y_1], [x_2, y_2], [x_3, y_3]]);			
		}
    }
    
	const SEC_Y = SCREEN_SIZE / 2 + 30;

    var hrMinXRight = 0;
    function renderHrMin(dc, hours, minutes) {
        // Account for 12 / 24 hour time and midnight inconsistencies
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else if (hours == 0) {
        	hours = 12;
    	}
        var timeString = Lang.format("$1$:$2$", [hours, minutes.format("%02d")]);

		var dim = dc.getTextDimensions(timeString, specialFont);
		var x = SCREEN_SIZE / 2;
		var y = DAY_MONTH_Y + tinyFontHeight - hugeFontDescent;
        dc.setColor(0xFFFFFF, Graphics.COLOR_BLACK);
        dc.drawText(x, y, specialFont, timeString, Graphics.TEXT_JUSTIFY_CENTER);

		// Used to properly position the seconds         
		hrMinXRight = x + dim[0] / 2;
    }
    
    function renderCalories(dc) {
    	var cal = GoalTracker.getCalories();
    	if (null == cal) {
    		return;
    	}
    	
    	var str = cal.format("%d");    
	    dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
    	dc.drawText(SCREEN_SIZE / 2, mildFontAscent - topMildFontCutoff, Graphics.FONT_XTINY, str, Graphics.TEXT_JUSTIFY_CENTER);
    }

	function onPartialUpdate(dc) {
		updateSeconds(dc);		
	}

	// Minimize the y-clipping area to reduce power consumption and squeeze text in real close.
	var lastSecondsWidth = 0;
	function updateSeconds(dc) {
		var secString = System.getClockTime().sec.format("%d");
		var fontSize = Graphics.FONT_NUMBER_MILD;
		var dim = dc.getTextDimensions(secString, fontSize);

		var x = SCREEN_SIZE / 2 - dim[0]; // Small offset from the hours / minutes being rendered
		var y = SEC_Y;

		// Used to ensure we don't leave junk pixels behind
		if (dim[0] < lastSecondsWidth)
		{
			dc.setClip(x, y, lastSecondsWidth, dim[1] - bottomMildFontCutoff + FONT_CLIP_WIGGLE);
	        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
	        dc.fillRectangle(x, y, lastSecondsWidth, dim[1] - bottomMildFontCutoff + FONT_CLIP_WIGGLE);
		}

		dc.setClip(x, y, dim[0], dim[1] - bottomMildFontCutoff + FONT_CLIP_WIGGLE);
		dc.setColor(0xFFFF66, Graphics.COLOR_BLACK);		
		dc.drawText(x, y, fontSize, secString, Graphics.TEXT_JUSTIFY_LEFT);

		lastSecondsWidth = dim[0];
	}
}