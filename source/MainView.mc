import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

// Workout dashboard: state, timer, heart rate, forms completed.
class MainView extends WatchUi.View {
    private var _timer as Timer.Timer?;

    function initialize() {
        View.initialize();
    }

    function onShow() as Void {
        var t = new Timer.Timer();
        t.start(method(:onTick), 1000, true);
        _timer = t;
    }

    function onHide() as Void {
        var t = _timer;
        if (t != null) {
            t.stop();
            _timer = null;
        }
    }

    function onTick() as Void {
        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Dc) as Void {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var cx = w / 2;
        var workout = getApp().workout;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, h * 0.09, Graphics.FONT_XTINY, "POOMSAE", Graphics.TEXT_JUSTIFY_CENTER);

        var state = "READY";
        var stateColor = Graphics.COLOR_GREEN;
        if (workout.isRecording()) {
            state = "RECORDING";
            stateColor = Graphics.COLOR_RED;
        } else if (workout.hasSession()) {
            state = "PAUSED";
            stateColor = Graphics.COLOR_YELLOW;
        }
        dc.setColor(stateColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, h * 0.18, Graphics.FONT_TINY, state, Graphics.TEXT_JUSTIFY_CENTER);

        var info = Activity.getActivityInfo();
        var timerMs = 0;
        var hr = null;
        if (info != null) {
            if (workout.hasSession() && info.timerTime != null) {
                timerMs = info.timerTime as Number;
            }
            hr = info.currentHeartRate;
        }

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, h * 0.29, Graphics.FONT_NUMBER_MEDIUM, formatTime(timerMs), Graphics.TEXT_JUSTIFY_CENTER);

        var hrText = hr == null ? "--" : hr.toString();
        dc.drawText(w * 0.32, h * 0.56, Graphics.FONT_XTINY, "HR", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(w * 0.68, h * 0.56, Graphics.FONT_XTINY, "FORMS", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(w * 0.32, h * 0.62, Graphics.FONT_MEDIUM, hrText, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(w * 0.68, h * 0.62, Graphics.FONT_MEDIUM, workout.reps.toString(), Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, h * 0.78, Graphics.FONT_XTINY, "START record  DOWN forms", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(cx, h * 0.85, Graphics.FONT_XTINY, "Hold UP: options", Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function formatTime(ms as Number) as String {
        var s = ms / 1000;
        var hours = s / 3600;
        var mins = (s % 3600) / 60;
        var secs = s % 60;
        if (hours > 0) {
            return hours.format("%d") + ":" + mins.format("%02d") + ":" + secs.format("%02d");
        }
        return mins.format("%d") + ":" + secs.format("%02d");
    }
}

class MainDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    // START: start / pause recording.
    function onSelect() as Boolean {
        getApp().workout.toggle();
        Feedback.tick();
        WatchUi.requestUpdate();
        return true;
    }

    function onNextPage() as Boolean {
        Menus.openForms();
        return true;
    }

    function onPreviousPage() as Boolean {
        Menus.openForms();
        return true;
    }

    function onMenu() as Boolean {
        Menus.openOptions();
        return true;
    }

    // BACK during a workout opens Resume / Save / Discard instead of exiting.
    function onBack() as Boolean {
        var workout = getApp().workout;
        if (workout.hasSession()) {
            workout.pause();
            Menus.openEndWorkout();
            return true;
        }
        return false;
    }
}
