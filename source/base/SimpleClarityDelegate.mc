using Toybox.WatchUi;
using Toybox.System;

// Receives callbacks when the power limits are exceeded on the watch. Used for debugging only.
class SimpleClarityDelegate extends WatchUi.WatchFaceDelegate {
    function initialize() {
        WatchFaceDelegate.initialize();
    }

    function onPowerBudgetExceeded(powerInfo) {
        System.println( "Average execution time: " + powerInfo.executionTimeAverage );
        System.println( "Allowed execution time: " + powerInfo.executionTimeLimit );
    }
}