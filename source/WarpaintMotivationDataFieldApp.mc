import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

// Global variables
var motivationalQuoteChangeInterval as Integer = 600;
var lowMemory as Integer = 0;
var displayAlerts as Integer = 0;

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

    //! Constructor
    function initialize() {
        AppBase.initialize();
        setGlobalVariables();
    }

    //! onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    //! onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    //! Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new WarpaintMotivationDataFieldView() ];
    }

    //! New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        setGlobalVariables();

        WatchUi.requestUpdate();
    }

    //! Set global variables
    private function setGlobalVariables() as Void {
        if (Toybox.Application has :Storage) {
			motivationalQuoteChangeInterval = Properties.getValue("MotivationalQuoteChangeInterval");
            lowMemory = Properties.getValue("LowMemoryForMotivationalQuotes");
            displayAlerts = Properties.getValue("DisplayAlerts");
		} else {
			motivationalQuoteChangeInterval = getApp().getProperty("MotivationalQuoteChangeInterval");
            lowMemory = getApp().getProperty("LowMemoryForMotivationalQuotes");
            displayAlerts = getApp().getProperty("DisplayAlerts");  
		}
    }

}

//! Give back App
//! @return App
function getApp() as WarpaintMotivationDataFieldApp {
    return Application.getApp() as WarpaintMotivationDataFieldApp;
}