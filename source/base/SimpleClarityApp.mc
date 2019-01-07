using Toybox.Application;
using Toybox.WatchUi;

// Sets up the application and the view for the watchface.
class SimpleClarityApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        return [ new SimpleClarityView(), new SimpleClarityDelegate() ];
    }
}