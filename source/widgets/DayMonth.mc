using Toybox.Graphics;
using Toybox.Math;
using Toybox.System;
using Toybox.Time;

// Renders the day / month view
module SimpleClarity {
	module DayMonth {
		const DAY_MONTH_SPACE = 5;
	
	    function renderDayMonth(dc, SCREEN_SIZE, yStart) {
	    	var now = Time.now();
	        var mediumTimeFormat = Time.Gregorian.info(now, Time.FORMAT_MEDIUM);
	    	
	    	var dayStr = mediumTimeFormat.day_of_week;
	    	var dayNumberStr = Time.Gregorian.info(now, 0).day.format("%d");
	    	var monthStr = mediumTimeFormat.month;
			
			var fontSize = Graphics.FONT_SYSTEM_TINY;
			var dayStrLen =	dc.getTextWidthInPixels(dayStr, fontSize);
			var dayNumberStrLen = dc.getTextWidthInPixels(dayNumberStr, fontSize);
			var monthStrLen = dc.getTextWidthInPixels(monthStr, fontSize);
			
			// Center the font in the view
			var xStart = (SCREEN_SIZE - (dayStrLen + dayNumberStrLen + monthStrLen + 2 * DAY_MONTH_SPACE)) / 2;
			
			dc.setColor(0x888888, Graphics.COLOR_BLACK);
			dc.drawText(xStart, yStart, fontSize, dayStr, Graphics.TEXT_JUSTIFY_LEFT);
			dc.drawText(xStart + dayStrLen + DAY_MONTH_SPACE, yStart, fontSize, dayNumberStr, Graphics.TEXT_JUSTIFY_LEFT);
			dc.drawText(xStart + dayStrLen + dayNumberStrLen + DAY_MONTH_SPACE * 2, yStart, fontSize, monthStr, Graphics.TEXT_JUSTIFY_LEFT);
	    }
    }
}