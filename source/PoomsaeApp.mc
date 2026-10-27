import Toybox.Application;
import Toybox.Lang;
import Toybox.Sensor;
import Toybox.WatchUi;

class PoomsaeApp extends Application.AppBase {
    var workout as Workout;

    function initialize() {
        AppBase.initialize();
        workout = new Workout();
    }

    function onStart(state as Dictionary?) as Void {
        Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);
    }

    // Never lose a workout: if the app is closed mid-session, save it.
    function onStop(state as Dictionary?) as Void {
        if (workout.hasSession()) {
            workout.save();
        }
    }

    function getInitialView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] {
        return [new MainView(), new MainDelegate()];
    }
}

function getApp() as PoomsaeApp {
    return Application.getApp() as PoomsaeApp;
}
