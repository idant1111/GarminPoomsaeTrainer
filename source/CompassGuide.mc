import Toybox.Lang;
import Toybox.Math;
import Toybox.Sensor;
import Toybox.Timer;
import Toybox.WatchUi;

// Optional compass guide. START on the first move saves the current heading as
// "front"; each move's target heading is front + its direction (Left = -90, ...).
// The wrist, not the body, is measured, so the guide is tolerant (+-30 degrees) and
// is best read in the same arm position used to set front (pressing a button).
class CompassGuide {
    const TOLERANCE = 30;

    var onTarget as Number = 0;  // moves checked and on target
    var checked as Number = 0;   // moves checked
    private var _front as Float?;
    private var _target as Number = 0;  // degrees clockwise from front
    private var _aligned as Boolean = false;
    private var _timer as Timer.Timer?;

    function initialize() {
    }

    // Compass heading in degrees 0-360 (clockwise), or null without magnetometer data.
    function heading() as Float? {
        var info = Sensor.getInfo();
        if (info has :heading && info.heading != null) {
            return norm360(Math.toDegrees(info.heading as Float));
        }
        return null;
    }

    function isSet() as Boolean {
        return _front != null;
    }

    // Saves the current heading as front. Returns false if there is no heading.
    function setFront() as Boolean {
        _front = heading();
        return _front != null;
    }

    function resetScore() as Void {
        onTarget = 0;
        checked = 0;
    }

    // Sets the move's facing (degrees from front) without buzzing if already aligned.
    function setTarget(relative as Number) as Void {
        _target = relative;
        var e = error();
        _aligned = e != null && e.abs() <= TOLERANCE;
    }

    // Degrees to turn to face the target: positive = turn right. Null if unknown.
    function error() as Float? {
        var front = _front;
        var h = heading();
        if (front == null || h == null) {
            return null;
        }
        return norm180(front + _target - h);
    }

    function isAligned() as Boolean {
        return _aligned;
    }

    // Scores the current move. Returns true / false, or null if it can't be measured.
    function checkMove() as Boolean? {
        var e = error();
        if (e == null) {
            return null;
        }
        checked++;
        var ok = e.abs() <= TOLERANCE;
        if (ok) {
            onTarget++;
        }
        return ok;
    }

    // Live updates (4 per second) while the practice screen is visible.
    function start() as Void {
        stop();
        var t = new Timer.Timer();
        t.start(method(:onTick), 250, true);
        _timer = t;
    }

    function stop() as Void {
        var t = _timer;
        if (t != null) {
            t.stop();
            _timer = null;
        }
    }

    function onTick() as Void {
        var e = error();
        if (e != null) {
            var aligned = e.abs() <= TOLERANCE;
            if (aligned && !_aligned) {
                Feedback.onTarget();
            }
            _aligned = aligned;
        }
        WatchUi.requestUpdate();
    }

    // "Turn R 40" / "Turn L 40" / "On target", or null if unknown.
    function guidance() as String? {
        var e = error();
        if (e == null) {
            return null;
        }
        if (e.abs() <= TOLERANCE) {
            return "On target";
        }
        return (e > 0 ? "Turn R " : "Turn L ") + e.abs().toNumber();
    }

    static function norm360(d as Float) as Float {
        var r = d - 360.0 * Math.floor(d / 360.0);
        return r >= 360.0 ? r - 360.0 : r;
    }

    static function norm180(d as Float) as Float {
        var r = norm360(d);
        return r > 180.0 ? r - 360.0 : r;
    }
}
