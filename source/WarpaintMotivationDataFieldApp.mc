import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

// Global variables
var motivationalQuoteChangeInterval as Number;
var lowMemory as Integer;

enum { 
    QUOTES_BASIC,
    QUOTES_STANDARD,
    QUOTES_EXTRA
}

enum { 
    DISPLAY_ALERT_OFF,
    DISPLAY_ALERT_ONLY,
    DISPLAY_ALERT_TOO
}

class WarpaintMotivationDataFieldApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
        setGlobalVariables();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    //! Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new WarpaintMotivationDataFieldView() ] as Array<Views or InputDelegates>;
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        setGlobalVariables();
    }

    //! Set global variables
    private function setGlobalVariables() as Void {
        if (Toybox.Application has :Storage) {
			motivationalQuoteChangeInterval = Properties.getValue("MotivationalQuoteChangeInterval");
            lowMemory = Properties.getValue("LowMemoryForMotivationalQuotes");
		} else {
			motivationalQuoteChangeInterval = getApp().getProperty("MotivationalQuoteChangeInterval");
            lowMemory = getApp().getProperty("LowMemoryForMotivationalQuotes");
		}
    }

}

function getApp() as WarpaintMotivationDataFieldApp {
    return Application.getApp() as WarpaintMotivationDataFieldApp;
}