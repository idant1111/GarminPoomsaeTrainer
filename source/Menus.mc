import Toybox.Lang;
import Toybox.WatchUi;

module Menus {
    function openForms() as Void {
        var menu = new WatchUi.Menu2({ :title => "Forms" });
        for (var i = 0; i < FormIndex.size(); i++) {
            menu.addItem(new WatchUi.IconMenuItem(FormIndex.NAMES[i],
                FormIndex.RANKS[i] + " | " + FormIndex.MEANINGS[i], i, new FormIconDrawable(i), null));
        }
        WatchUi.pushView(menu, new FormMenuDelegate(), WatchUi.SLIDE_UP);
    }

    function openModes(form as Number) as Void {
        var menu = new WatchUi.Menu2({ :title => FormIndex.SHORT[form] });
        menu.addItem(new WatchUi.MenuItem("Step through", "Buttons advance", :manual, null));
        menu.addItem(new WatchUi.MenuItem("Paced",
            PracticeLog.formatTempo(PracticeLog.getTempo()) + " per move", :paced, null));
        WatchUi.pushView(menu, new ModeMenuDelegate(form), WatchUi.SLIDE_LEFT);
    }

    function openOptions() as Void {
        var menu = new WatchUi.Menu2({ :title => "Options" });
        menu.addItem(new WatchUi.MenuItem("Paced tempo",
            PracticeLog.formatTempo(PracticeLog.getTempo()) + " per move", :tempo, null));
        menu.addItem(new WatchUi.MenuItem("History", "Reps per form", :history, null));
        WatchUi.pushView(menu, new OptionsMenuDelegate(), WatchUi.SLIDE_UP);
    }

    function openTempo(parent as WatchUi.MenuItem) as Void {
        var menu = new WatchUi.Menu2({ :title => "Tempo" });
        for (var ms = 1000; ms <= 5000; ms += 500) {
            menu.addItem(new WatchUi.MenuItem(PracticeLog.formatTempo(ms), "per move", ms, null));
        }
        var current = menu.findItemById(PracticeLog.getTempo());
        if (current >= 0) {
            menu.setFocus(current);
        }
        WatchUi.pushView(menu, new TempoMenuDelegate(parent), WatchUi.SLIDE_LEFT);
    }

    function openHistory() as Void {
        var menu = new WatchUi.Menu2({ :title => "History" });
        for (var i = 0; i < FormIndex.size(); i++) {
            var id = FormIndex.IDS[i];
            var reps = PracticeLog.getReps(id);
            var last = PracticeLog.lastPracticed(id);
            var sub = (reps == 0 || last == null) ? "Not practiced" : reps + " reps, last " + last;
            menu.addItem(new WatchUi.MenuItem(FormIndex.SHORT[i], sub, i, null));
        }
        WatchUi.pushView(menu, new HistoryMenuDelegate(), WatchUi.SLIDE_LEFT);
    }

    function openEndWorkout() as Void {
        var menu = new WatchUi.Menu2({ :title => "Workout" });
        menu.addItem(new WatchUi.MenuItem("Resume", null, :resume, null));
        menu.addItem(new WatchUi.MenuItem("Save", getApp().workout.reps + " forms", :save, null));
        menu.addItem(new WatchUi.MenuItem("Discard", null, :discard, null));
        WatchUi.pushView(menu, new EndMenuDelegate(), WatchUi.SLIDE_UP);
    }

    function openDiscardConfirm() as Void {
        var menu = new WatchUi.Menu2({ :title => "Discard?" });
        menu.addItem(new WatchUi.MenuItem("No", null, :no, null));
        menu.addItem(new WatchUi.MenuItem("Yes, discard", null, :yes, null));
        WatchUi.pushView(menu, new DiscardMenuDelegate(), WatchUi.SLIDE_LEFT);
    }
}

class FormMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        Menus.openModes(item.getId() as Number);
    }
}

class ModeMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _form as Number;

    function initialize(form as Number) {
        Menu2InputDelegate.initialize();
        _form = form;
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var view = new PracticeView(_form, item.getId() == :paced);
        WatchUi.pushView(view, new PracticeDelegate(view), WatchUi.SLIDE_LEFT);
    }
}

class OptionsMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();
        if (id == :tempo) {
            Menus.openTempo(item);
        } else if (id == :history) {
            Menus.openHistory();
        }
    }
}

class TempoMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _parent as WatchUi.MenuItem;

    function initialize(parent as WatchUi.MenuItem) {
        Menu2InputDelegate.initialize();
        _parent = parent;
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var ms = item.getId() as Number;
        PracticeLog.setTempo(ms);
        _parent.setSubLabel(PracticeLog.formatTempo(ms) + " per move");
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}

class HistoryMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
    }
}

class EndMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();
        var workout = getApp().workout;
        if (id == :resume) {
            workout.startOrResume();
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        } else if (id == :save) {
            workout.save();
            Feedback.done();
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        } else if (id == :discard) {
            Menus.openDiscardConfirm();
        }
    }
}

class DiscardMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        if (item.getId() == :yes) {
            getApp().workout.discard();
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}
