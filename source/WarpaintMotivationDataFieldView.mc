import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Attention;

// Global variable
var _motivationString as String;

class WarpaintMotivationDataFieldAlert extends WatchUi.DataFieldAlert {

    //! Constructor
    public function initialize() {
        DataFieldAlert.initialize();
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SMALL, _motivationString, (Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));

        if (Attention has :vibrate) {
            var vibeData = [new Attention.VibeProfile(50, 2000)];
            Attention.vibrate(vibeData);
        }
    }

}

class WarpaintMotivationDataFieldView extends WatchUi.DataField {

    private const MILLISECONDS_TO_SECONDS = 0.001;

    private var _textPositionX as Number;
    private var _textPositionY as Number;

    private var _motivation as Motivation;
    private var _isMotviationalQuoteSet as Boolean;

    private var _lastCheckSeconds as Number;
    private var _startedActivity as Boolean;

    function initialize() {
        DataField.initialize();
        _lastCheckSeconds = 0;
        _isMotviationalQuoteSet = false;
        _startedActivity = false;
        _motivation = new Motivation();
    }

    //! Set the layout here. Anytime the size of obscurity of
    //! the draw context is changed this will be called.
    //! @param dc Device Content
    function onLayout(dc as Dc) as Void {
        var obscurityFlags = DataField.getObscurityFlags();
        var width = dc.getWidth();
        var height = dc.getHeight();

        // Top left quadrant so we'll use the top left layout
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            _textPositionX = width * 0.60;
            _textPositionY = height * 0.60;

        // Top right quadrant so we'll use the top right layout
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            _textPositionX = width * 0.40;
            _textPositionY = height * 0.60;

        // Bottom left quadrant so we'll use the bottom left layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            _textPositionX = width * 0.60;
            _textPositionY = height * 0.40;

        // Bottom right quadrant so we'll use the bottom right layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            _textPositionX = width * 0.40;
            _textPositionY = height * 0.40;

        // Use the generic, centered layout
        } else {
            _textPositionX = width * 0.50;
            _textPositionY = height * 0.50;
        }

        selectFont(width, height);
    }

    //! Select font for quote according to panel size
    //! @param dfPanelWidth The width of the current dc panel
    //! @param dfPanelHeight The height of the current dc panel
    private function selectFont(dfPanelWidth as Integer, dfPanelHeight as Integer) {
        var deviceSettings = System.getDeviceSettings();
        var screenWidth = deviceSettings.screenWidth;
        var screenHeight = deviceSettings.screenHeight;
        var lineWidths = new Number[3];
        var fontBase = 0; // X_TINY

        if  (deviceSettings.screenShape == System.SCREEN_SHAPE_RECTANGLE) {
            lineWidths = [0.92, 0.92, 0.92];
            if (dfPanelHeight < screenHeight / 3) {
                fontBase = Graphics.FONT_MEDIUM;
            } else {
                fontBase = Graphics.FONT_LARGE;
            }
        } else if (dfPanelHeight > screenHeight / 2) {
            lineWidths = [0.85, 0.95, 0.85];
            fontBase = Graphics.FONT_LARGE;
        } else if (dfPanelHeight <= screenHeight / 2 && dfPanelHeight >= screenHeight / 3) {
            lineWidths = [0.65, 0.75, 0.65];
            fontBase = Graphics.FONT_SMALL;
        } else {
            lineWidths = [0.85, 0.95, 0.85];
            fontBase = Graphics.FONT_XTINY;
        }

        // mainly half the screen width
        if (dfPanelWidth < screenWidth * 0.75) {
            fontBase = Graphics.FONT_XTINY;
        }

        _motivation.setLineWidths(lineWidths);
        _motivation.setFontBase(fontBase);
    }

    //! The given info object contains all the current workout information.
    //! Calculate a value and save it locally in this method.
    //! Note that compute() and onUpdate() are asynchronous, and there is no
    //! guarantee that compute() will be called before onUpdate().
    //! @param info as the Activity Info
    function compute(info as Activity.Info) as Void {
        var timerTime = info.timerTime;
        if (!_startedActivity && timerTime != 0) { // equals 0 ms, so does not started the activity
            _startedActivity = true;
        }
        checkMotivationalQuoteRefresh(timerTime);
    }

    //! Check if motivational quote needs refresh
    //! @param timerTime the activity time in ms
    private function checkMotivationalQuoteRefresh(timerTime as Number) as Void {
        var currentSeconds = (timerTime * MILLISECONDS_TO_SECONDS).toNumber(); // current seconds passed in activity
        if (timerTime > 0 && // provide to not change in the first second
            currentSeconds % motivationalQuoteChangeInterval == 1 && //change interval
            _lastCheckSeconds != currentSeconds) { // the activity is on

            _lastCheckSeconds = currentSeconds;
            _isMotviationalQuoteSet = false;
        }
    }

    //! Display the value you computed here. This will be called
    //! once a second when the data field is visible.
    //! @param dc Device Content
    function onUpdate(dc as Dc) as Void {

        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        } else {
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        }
        dc.clear();

        if (!_isMotviationalQuoteSet) {
            if (!_startedActivity || displayAlerts == DISPLAY_ALERT_ONLY) {
                _motivationString = "WARPAINT\nMOTIVATION";
                _motivation.setFont(Graphics.FONT_SMALL);
            } else {
                _motivationString = _motivation.setMotivationalQuote(dc);
            }

            if ((WatchUi.DataField has :showAlert) && displayAlerts != DISPLAY_ALERT_OFF) {
                showAlert(new WarpaintMotivationDataFieldAlert());
            }

            _isMotviationalQuoteSet = true;
        }

        dc.drawText(_textPositionX, _textPositionY, _motivation.font, _motivationString, (Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));
    }
}
