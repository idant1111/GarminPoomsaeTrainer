import Toybox.Activity;
import Toybox.ActivityRecording;
import Toybox.FitContributor;
import Toybox.Lang;

// Wraps the FIT recording session. Each completed form becomes a lap, tagged
// with the form index; the session carries the total number of forms performed.
class Workout {
    private var _session as ActivityRecording.Session?;
    private var _repsField as FitContributor.Field?;
    private var _formField as FitContributor.Field?;
    var reps as Number = 0;

    function initialize() {
    }

    function hasSession() as Boolean {
        return _session != null;
    }

    function isRecording() as Boolean {
        var s = _session;
        return s != null && s.isRecording();
    }

    function toggle() as Void {
        if (isRecording()) {
            pause();
        } else {
            startOrResume();
        }
    }

    function startOrResume() as Void {
        var s = _session;
        if (s == null) {
            s = ActivityRecording.createSession({
                :name => "Poomsae",
                :sport => Activity.SPORT_TRAINING,
                :subSport => Activity.SUB_SPORT_CARDIO_TRAINING
            });
            var repsField = s.createField("forms_completed", 0, FitContributor.DATA_TYPE_UINT16,
                { :mesgType => FitContributor.MESG_TYPE_SESSION, :units => "forms" });
            _formField = s.createField("form_index", 1, FitContributor.DATA_TYPE_UINT8,
                { :mesgType => FitContributor.MESG_TYPE_LAP });
            repsField.setData(0);
            _repsField = repsField;
            _session = s;
            reps = 0;
        }
        s.start();
    }

    function pause() as Void {
        var s = _session;
        if (s != null && s.isRecording()) {
            s.stop();
        }
    }

    // Called when a form is finished. Only counts while recording.
    function completeRep(formIndex as Number) as Void {
        var s = _session;
        if (s == null || !s.isRecording()) {
            return;
        }
        reps++;
        var repsField = _repsField;
        var formField = _formField;
        if (repsField != null) {
            repsField.setData(reps);
        }
        if (formField != null) {
            formField.setData(formIndex);
        }
        s.addLap();
    }

    function save() as Void {
        var s = _session;
        if (s != null) {
            s.stop();
            s.save();
        }
        clear();
    }

    function discard() as Void {
        var s = _session;
        if (s != null) {
            s.stop();
            s.discard();
        }
        clear();
    }

    private function clear() as Void {
        _session = null;
        _repsField = null;
        _formField = null;
        reps = 0;
    }
}
