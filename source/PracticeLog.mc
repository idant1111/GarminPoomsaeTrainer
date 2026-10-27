import Toybox.Application.Storage;
import Toybox.Attention;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

// Persistent practice history and settings, stored on the watch.
module PracticeLog {
    const DEFAULT_TEMPO_MS = 2000;

    function getReps(id as String) as Number {
        var v = Storage.getValue("reps_" + id);
        return v == null ? 0 : v as Number;
    }

    function addRep(id as String) as Void {
        Storage.setValue("reps_" + id, getReps(id) + 1);
        Storage.setValue("last_" + id, Time.now().value());
    }

    // "Oct 17", or null if the form was never completed.
    function lastPracticed(id as String) as String? {
        var v = Storage.getValue("last_" + id);
        if (v == null) {
            return null;
        }
        var info = Gregorian.info(new Time.Moment(v as Number), Time.FORMAT_MEDIUM);
        return (info.month as String) + " " + info.day.format("%d");
    }

    function getTempo() as Number {
        var v = Storage.getValue("tempo_ms");
        return v == null ? DEFAULT_TEMPO_MS : v as Number;
    }

    function setTempo(ms as Number) as Void {
        Storage.setValue("tempo_ms", ms);
    }

    // Compass guide: check facing direction with the magnetometer (off by default).
    function getCompass() as Boolean {
        var v = Storage.getValue("compass");
        return v != null && (v as Boolean);
    }

    function setCompass(on as Boolean) as Void {
        Storage.setValue("compass", on);
    }

    // Practice screen look: 0 = text, 1 = figure.
    function getLook() as Number {
        var v = Storage.getValue("look");
        return v == null ? 0 : v as Number;
    }

    function setLook(look as Number) as Void {
        Storage.setValue("look", look);
    }

    function formatTempo(ms as Number) as String {
        return (ms / 1000.0).format("%.1f") + " s";
    }
}

module Feedback {
    // pattern: [[dutyCycle 0-100, lengthMs], ...]
    function vibe(pattern as Array<Array<Number>>) as Void {
        if (!(Attention has :vibrate)) {
            return;
        }
        var profiles = [] as Array<Attention.VibeProfile>;
        for (var i = 0; i < pattern.size(); i++) {
            profiles.add(new Attention.VibeProfile(pattern[i][0], pattern[i][1]));
        }
        Attention.vibrate(profiles);
    }

    function tick() as Void {
        vibe([[60, 120]]);
    }

    function kihap() as Void {
        vibe([[100, 120], [0, 80], [100, 300]]);
    }

    function done() as Void {
        vibe([[100, 500]]);
    }

    // Compass guide: light buzz on reaching the target facing, triple buzz on a wrong facing.
    function onTarget() as Void {
        vibe([[40, 80]]);
    }

    function offTarget() as Void {
        vibe([[100, 90], [0, 70], [100, 90], [0, 70], [100, 90]]);
    }
}
