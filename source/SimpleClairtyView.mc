using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using SimpleClarity.BatteryMeter;
using SimpleClarity.DayMonth;
using SimpleClarity.GoalTracker;
using SimpleClarity.MinorSensors;
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
    
    function initialize() {
        WatchFace.initialize();
        
        bottomMildFontCutoff = Graphics.getFontDescent(Graphics.FONT_NUMBER_MILD);
        mildFontAscent = Graphics.getFontAscent(Graphics.FONT_NUMBER_MILD);
        topMildFontCutoff = Graphics.getFontHeight(Graphics.FONT_NUMBER_MILD) - mildFontAscent;
        
        tinyFontHeight = Graphics.getFontHeight(Graphics.FONT_TINY);         
        hugeFontDescent = Graphics.getFontDescent(Graphics.FONT_NUMBER_THAI_HOT);
        
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
		BatteryMeter.renderBatteryPercent(dc, SCREEN_SIZE);
		MinorSensors.render(dc, stepDivisor);
		StairMeter.renderStairMeter(dc, SCREEN_SIZE);
		StepMeter.renderStepMeter(dc);

		renderCalories(dc);

		// Render per-second updates (hr and seconds)
		fullUpdate = true;
		onPartialUpdate(dc);
		fullUpdate = false;
    }
    
	const SEC_Y = SCREEN_SIZE / 2 - 15;

    var hrMinXRight = 0;
    function renderHrMin(dc, hours, minutes) {
        // Account for 12 / 24 hour time
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        }
        var timeString = Lang.format("$1$:$2$", [hours, minutes.format("%02d")]);

		var fontSize = Graphics.FONT_NUMBER_THAI_HOT;
		var dim = dc.getTextDimensions(timeString, fontSize);
		var x = SCREEN_SIZE / 2 - 20;
		var y = DAY_MONTH_Y + tinyFontHeight - hugeFontDescent;
        dc.setColor(0xFFFF0F, Graphics.COLOR_BLACK); // Effectively yellow
        dc.drawText(x, y, fontSize, timeString, Graphics.TEXT_JUSTIFY_CENTER);

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
		updateHeartRate(dc);			
	}

	// Minimize the y-clipping area to reduce power consumption and squeeze text in real close.
	var lastSecondsWidth = 0;
	function updateSeconds(dc) {
		var secString = System.getClockTime().sec.format("%d");
		var fontSize = Graphics.FONT_NUMBER_MILD;
		var dim = dc.getTextDimensions(secString, fontSize);

		var x = hrMinXRight + 5; // Small offset from the hours / minutes being rendered
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
	
	// Only updatee every other second to not exceed power budget limitations when on sleep mode.
	var updatedHrLastSecond = false;
	
	var lastHrWidth = 0;
	function updateHeartRate(dc) {
		// Ensure we only do graphics updates when something has changed.
		var hr = Sensors.getLastHeartRate();
		
		// Color the HR as grey if we don't have a valid reading.
		var hrColor = 0xFF0000;
		if (null == hr || hr == 255) {
			hr = lastHr;
			hrColor = 0x303030;
		}
		
		if (fullUpdate || (!updatedHrLastSecond && hr != lastHr))
		{
			lastHr = hr;
			
			var hrString = hr.format("%i");

			var fontSize = Graphics.FONT_NUMBER_MILD;
			var dim = dc.getTextDimensions(hrString, fontSize);
		
			var x = SCREEN_SIZE / 2;
			var y = -topMildFontCutoff;
			
			// Ensure if we fluctuate around 100 BPM, we don't leave junk data behind when the number
			//  being rendered is smaller than the previous number
			if (dim[0] < lastHrWidth)
			{	
				dc.setClip(x - lastHrWidth / 2, y, lastHrWidth, dim[1] - bottomMildFontCutoff + FONT_CLIP_WIGGLE);
	        	dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
	        	dc.fillRectangle(x - lastHrWidth / 2, y, lastHrWidth, dim[1] - bottomMildFontCutoff + FONT_CLIP_WIGGLE);
			}
			
			dc.setClip(x - dim[0] / 2, y, dim[0], dim[1] - bottomMildFontCutoff + FONT_CLIP_WIGGLE);
			
			dc.setColor(hrColor, Graphics.COLOR_BLACK);
			dc.drawText(x, y, fontSize, hrString, Graphics.TEXT_JUSTIFY_CENTER);
			
			lastHrWidth = dim[0];
			updatedHrLastSecond = true;
		}
		else
		{
			updatedHrLastSecond = false;
		}
	}
}