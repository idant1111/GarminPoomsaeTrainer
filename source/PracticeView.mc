import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.Timer;
import Toybox.WatchUi;

// Steps through one form. Manual mode: START/DOWN advance, UP goes back.
// Paced mode: the watch advances and vibrates every tempo interval; START pauses.
// Finishing the last move counts a rep (and a lap if a workout is recording).
const LOOK_TEXT = 0;
const LOOK_FIGURE = 1;

class PracticeView extends WatchUi.View {
    private var _look as Number = LOOK_TEXT;
    private var _form as Number;
    private var _paced as Boolean;
    private var _moves as Array;
    private var _idx as Number = 0;
    private var _reps as Number = 0;
    private var _done as Boolean = false;
    private var _running as Boolean = false;
    private var _timer as Timer.Timer?;
    private var _compass as CompassGuide?;

    function initialize(form as Number, paced as Boolean) {
        View.initialize();
        _form = form;
        _paced = paced;
        _moves = FormIndex.loadMoves(form);
        _look = PracticeLog.getLook();
        if (PracticeLog.getCompass()) {
            _compass = new CompassGuide();
        }
    }

    function onShow() as Void {
        if (_running) {
            startTimer();
        }
        var c = _compass;
        if (c != null) {
            c.start();
        }
    }

    function onHide() as Void {
        stopTimer();
        var c = _compass;
        if (c != null) {
            c.stop();
        }
    }

    // Compass guide is on but front hasn't been set yet.
    private function needsFront() as Boolean {
        var c = _compass;
        return c != null && !c.isSet() && !_done;
    }

    // Points the compass guide at the current move's facing.
    private function syncCompass() as Void {
        var c = _compass;
        if (c != null && !_done) {
            c.setTarget(Directions.degrees((_moves[_idx] as Array)[3] as String));
        }
    }

    // START button.
    function primary() as Void {
        if (needsFront()) {
            // First press with the compass guide on: save the current heading as front.
            var c = _compass as CompassGuide;
            if (c.setFront()) {
                syncCompass();
                Feedback.onTarget();
            } else {
                _compass = null; // no magnetometer data: carry on without the guide
            }
            WatchUi.requestUpdate();
            return;
        }
        if (_done) {
            restart();
        } else if (!_paced) {
            next();
        } else if (_running) {
            _running = false;
            stopTimer();
        } else {
            _running = true;
            cue();
            startTimer();
        }
        WatchUi.requestUpdate();
    }

    // DOWN button: skip ahead, keeping the paced rhythm aligned to the press.
    function skip() as Void {
        next();
        if (_running) {
            startTimer();
        }
    }

    function next() as Void {
        if (_done) {
            restart();
            return;
        }
        // Compass guide: score the facing of the move that is ending.
        var miss = false;
        var c = _compass;
        if (c != null && c.isSet()) {
            var ok = c.checkMove();
            miss = ok != null && !ok;
        }
        if (_idx < _moves.size() - 1) {
            _idx++;
            syncCompass();
            cue();
            if (miss) {
                Feedback.offTarget();
            }
        } else {
            finishRep();
        }
        WatchUi.requestUpdate();
    }

    function previous() as Void {
        if (!_done && _idx > 0) {
            _idx--;
            syncCompass();
            if (_running) {
                startTimer();
            }
            WatchUi.requestUpdate();
        }
    }

    function onTick() as Void {
        next();
    }

    private function restart() as Void {
        _done = false;
        _idx = 0;
        // Each rep starts from ready stance facing front: re-set front automatically.
        var c = _compass;
        if (c != null) {
            c.resetScore();
            c.setFront();
            syncCompass();
        }
        cue();
        if (_paced) {
            _running = true;
            startTimer();
        }
        WatchUi.requestUpdate();
    }

    private function finishRep() as Void {
        _done = true;
        _running = false;
        stopTimer();
        _reps++;
        PracticeLog.addRep(FormIndex.IDS[_form]);
        getApp().workout.completeRep(_form);
        Feedback.done();
    }

    private function cue() as Void {
        if (isKihap(_idx)) {
            Feedback.kihap();
        } else {
            Feedback.tick();
        }
    }

    private function isKihap(i as Number) as Boolean {
        var m = _moves[i] as Array;
        return (m[4] as Number) == 1;
    }

    private function startTimer() as Void {
        stopTimer();
        var t = new Timer.Timer();
        t.start(method(:onTick), PracticeLog.getTempo(), true);
        _timer = t;
    }

    private function stopTimer() as Void {
        var t = _timer;
        if (t != null) {
            t.stop();
            _timer = null;
        }
    }

    function onUpdate(dc as Dc) as Void {
        var w = dc.getWidth();
        var h = dc.getHeight();

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        if (_done) {
            drawDone(dc, w, h);
            return;
        }

        var m = _moves[_idx] as Array;
        var hand = m.size() > 5 ? m[5] as String : null;

        if (_look == LOOK_FIGURE) {
            drawFigureScreen(dc, m, hand);
            return;
        }

        // Order: poomsae name, direction (blue), [side] hand movement, [side] leg movement.
        // Lines are stacked by real font height so nothing overlaps.
        var y = drawHeader(dc, m, h * 0.06);
        var lines = movementLines(m, hand);
        y = drawWrapped(dc, lines[0], y, Graphics.COLOR_WHITE);
        y = drawWrapped(dc, lines[1], y, Graphics.COLOR_YELLOW);
        drawStatus(dc, y);
    }

    // Draws `text` centred in up to two lines (FONT_SMALL, else FONT_TINY). Returns the next y.
    private function drawWrapped(dc as Dc, text as String, y as Numeric, color as Number) as Numeric {
        if (text.length() == 0) {
            return y;
        }
        var w = dc.getWidth() * 0.84;
        var font = Graphics.FONT_SMALL;
        // fitTextToArea needs a little slack beyond two font heights to allow a second line.
        var fit = Graphics.fitTextToArea(text, font, w, dc.getFontHeight(font) * 2 + 8, false);
        if (fit == null) {
            font = Graphics.FONT_TINY;
            fit = Graphics.fitTextToArea(text, font, w, dc.getFontHeight(font) * 2 + 8, true);
        }
        var out = fit as String;
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, y, font, out, Graphics.TEXT_JUSTIFY_CENTER);
        return y + (out.find("\n") == null ? 1 : 2) * dc.getFontHeight(font) + 2;
    }

    // Splits a move into [hand line, leg line], each part prefixed with Oen / Oreun / Yang:
    // hand techniques go on the hand line; kicks then the stance go on the leg line.
    private function movementLines(m as Array, hand as String?) as Array<String> {
        var parts = splitPlus(m[1] as String);
        var sides = hand == null ? [] as Array<String> : splitPlus(hand);
        var handText = "";
        var legText = "";
        for (var i = 0; i < parts.size(); i++) {
            var p = parts[i];
            var side = null;
            if (sides.size() == parts.size()) {
                side = sides[i];
            } else if (i == 0 && sides.size() > 0) {
                side = sides[0];
            }
            var text = side == null ? p : side + " " + lowerFirst(p);
            if (p.toLower().find("chagi") != null) {
                legText = legText.length() == 0 ? text : legText + " + " + text;
            } else {
                handText = handText.length() == 0 ? text : handText + " + " + text;
            }
        }
        var stance = stanceText(m[0] as String);
        legText = legText.length() == 0 ? stance : legText + ", " + stance;
        return [handText, legText];
    }

    // "L ap-kubi" -> "Oen ap-kubi" (side = front foot). Back and tiger stances add
    // "(fwd)" because schools name those by either foot.
    private function stanceText(raw as String) as String {
        if (raw.length() > 2 && raw.substring(1, 2).equals(" ")) {
            var foot = raw.substring(0, 1);
            if (foot.equals("L") || foot.equals("R")) {
                var name = raw.substring(2, raw.length()) as String;
                var out = (foot.equals("L") ? "Oen " : "Oreun ") + name;
                if (name.find("dwit-kubi") != null || name.find("beom-seogi") != null) {
                    out += " (fwd)";
                }
                return out;
            }
        }
        return raw;
    }

    // "a + b+c" -> ["a", "b", "c"], trimmed.
    private function splitPlus(s as String) as Array<String> {
        var out = [] as Array<String>;
        var rest = s;
        var i = rest.find("+");
        while (i != null) {
            out.add(trim(rest.substring(0, i) as String));
            rest = rest.substring(i + 1, rest.length()) as String;
            i = rest.find("+");
        }
        out.add(trim(rest));
        return out;
    }

    private function trim(s as String) as String {
        var a = 0;
        var b = s.length();
        while (a < b && s.substring(a, a + 1).equals(" ")) { a++; }
        while (b > a && s.substring(b - 1, b).equals(" ")) { b--; }
        return s.substring(a, b) as String;
    }

    private function lowerFirst(s as String) as String {
        return s.length() == 0 ? s : s.substring(0, 1).toLower() + s.substring(1, s.length());
    }

    // Header: form symbol + "Koryo 1/30", then arrow + "Left  L 90". Returns the next y.
    private function drawHeader(dc as Dc, m as Array, y as Numeric) as Numeric {
        var cx = dc.getWidth() / 2;
        var tiny = dc.getFontHeight(Graphics.FONT_TINY);

        var title = FormIndex.SHORT[_form] + "  " + (_idx + 1) + "/" + _moves.size();
        var iconSize = tiny * 0.6;
        // Near the top the round screen is narrow: measure title plus icon ("WW" ~ icon + gap).
        var titleFont = fitFont(dc, title + "WW", y, Graphics.FONT_TINY, Graphics.FONT_XTINY);
        var tw = dc.getTextWidthInPixels(title, titleFont);
        var x = cx - (iconSize + 8 + tw) / 2;
        FormIcons.draw(dc, _form, x + iconSize / 2, y + tiny / 2, iconSize, Graphics.COLOR_WHITE);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + iconSize + 8, y + (tiny - dc.getFontHeight(titleFont)) / 2, titleFont, title, Graphics.TEXT_JUSTIFY_LEFT);
        y += tiny;

        var dir = m[3] as String;
        var prevDir = _idx == 0 ? "N" : (_moves[_idx - 1] as Array)[3] as String;
        var turn = Directions.turn(prevDir, dir);
        var label = turn.equals("") ? Directions.label(dir) : Directions.label(dir) + "  " + turn;
        var font = fitFont(dc, label, y, Graphics.FONT_SMALL, Graphics.FONT_TINY);
        var fh = dc.getFontHeight(font);
        var r = fh * 0.32;
        tw = dc.getTextWidthInPixels(label, font);
        x = cx - (r * 2 + 8 + tw) / 2;
        drawDirectionArrow(dc, x + r, y + fh / 2, r, dir);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + r * 2 + 8, y, font, label, Graphics.TEXT_JUSTIFY_LEFT);
        return y + fh;
    }

    // Figure screen (LIGHT toggles): just the character performing the move, drawn
    // large, with the move counter on top and a KIHAP cue when due.
    private function drawFigureScreen(dc as Dc, m as Array, hand as String?) as Void {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var cx = w / 2;
        var tiny = dc.getFontHeight(Graphics.FONT_TINY);

        var counter = (_idx + 1) + "/" + _moves.size();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, h * 0.05, Graphics.FONT_TINY, counter, Graphics.TEXT_JUSTIFY_CENTER);
        var c = _compass;
        if (c != null && c.isSet()) {
            // Compass needle beside the move counter.
            var r = tiny * 0.32;
            var nx = cx - dc.getTextWidthInPixels(counter, Graphics.FONT_TINY) / 2 - r - 8;
            drawDirectionArrow(dc, nx, h * 0.05 + tiny / 2, r, m[3] as String);
        }

        var top = h * 0.05 + tiny;
        var bottom = h * 0.90;
        var area = bottom - top;
        var side = hand == null ? null : Figure.firstPart(hand);
        Figure.draw(dc, cx, top + area * 0.53, area, m[0] as String, m[1] as String, side);

        if (needsFront()) {
            dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
            var prompt = "Face front: START";
            dc.drawText(cx, h * 0.86, fitFont(dc, prompt, h * 0.86, Graphics.FONT_TINY, Graphics.FONT_XTINY),
                prompt, Graphics.TEXT_JUSTIFY_CENTER);
        } else if (isKihap(_idx)) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(cx, h * 0.86, Graphics.FONT_TINY, "KIHAP!", Graphics.TEXT_JUSTIFY_CENTER);
        }
        if (getApp().workout.isRecording()) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.fillCircle(cx, h * 0.95, 4);
        }
    }

    // Bottom line: KIHAP cue takes priority over the status text.
    private function drawStatus(dc as Dc, y as Numeric) as Void {
        var cx = dc.getWidth() / 2;
        var h = dc.getHeight();
        var status;
        var statusColor = Graphics.COLOR_WHITE;
        var c = _compass;
        var guide = (c != null && c.isSet()) ? c.guidance() : null;
        if (needsFront()) {
            status = "Face front: START";
            statusColor = Graphics.COLOR_YELLOW;
        } else if (isKihap(_idx)) {
            status = "KIHAP!";
            statusColor = Graphics.COLOR_RED;
        } else if (_paced && !_running) {
            status = _idx == 0 ? "START: go" : "Paused";
        } else if (guide != null && c != null) {
            status = guide;
            statusColor = c.isAligned() ? Graphics.COLOR_GREEN : Graphics.COLOR_ORANGE;
        } else if (!_paced) {
            status = "Rep " + (_reps + 1);
        } else if (_running) {
            status = "Paced " + PracticeLog.formatTempo(PracticeLog.getTempo());
        } else if (_idx == 0) {
            status = "START: go";
        } else {
            status = "Paused";
        }
        var statusY = h * 0.82;
        if (y > statusY) {
            statusY = y;
        }
        dc.setColor(statusColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, statusY, fitFont(dc, status, statusY, Graphics.FONT_TINY, Graphics.FONT_XTINY),
            status, Graphics.TEXT_JUSTIFY_CENTER);

        if (getApp().workout.isRecording()) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.fillCircle(cx, h * 0.95, 4);
        }
    }

    // LIGHT (or hold UP): switch between the text look and the figure look.
    function toggleLook() as Void {
        _look = _look == LOOK_FIGURE ? LOOK_TEXT : LOOK_FIGURE;
        PracticeLog.setLook(_look);
        WatchUi.requestUpdate();
    }

    // Picks `preferred` if the text fits the round screen's width at line top `y`, else `fallback`.
    private function fitFont(dc as Dc, text as String, y as Numeric, preferred as Graphics.FontType,
                             fallback as Graphics.FontType) as Graphics.FontType {
        var radius = dc.getWidth() / 2.0;
        var mid = y + dc.getFontHeight(preferred) / 2.0 - radius;
        var chord = 2 * Math.sqrt(radius * radius - mid * mid) * 0.92;
        return dc.getTextWidthInPixels(text, preferred) <= chord ? preferred : fallback;
    }

    private function drawDone(dc as Dc, w as Number, h as Number) as Void {
        var cx = w / 2;
        FormIcons.draw(dc, _form, cx, h * 0.17, h * 0.15, Graphics.COLOR_WHITE);
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, h * 0.3, Graphics.FONT_MEDIUM, "Form complete", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, h * 0.42, Graphics.FONT_SMALL, "This set: " + _reps, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(cx, h * 0.51, Graphics.FONT_SMALL,
            "All time: " + PracticeLog.getReps(FormIndex.IDS[_form]), Graphics.TEXT_JUSTIFY_CENTER);
        var c = _compass;
        if (c != null && c.checked > 0) {
            // Compass guide score for this rep.
            dc.setColor(c.onTarget == c.checked ? Graphics.COLOR_GREEN : Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
            dc.drawText(cx, h * 0.61, Graphics.FONT_TINY,
                "Facing: " + c.onTarget + "/" + c.checked + " on target", Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        }
        dc.drawText(cx, h * 0.72, Graphics.FONT_TINY, "START: again", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(cx, h * 0.81, Graphics.FONT_TINY, "BACK: exit", Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Direction arrow. Normally the move's facing relative to the start (front = up, blue).
    // With the compass guide set it becomes a needle: up = where the watch points,
    // rotated toward the target; green when within tolerance, orange otherwise.
    private function drawDirectionArrow(dc as Dc, cx as Numeric, cy as Numeric, r as Numeric, dir as String) as Void {
        var c = _compass;
        var e = (c != null && c.isSet()) ? c.error() : null;
        if (c != null && e != null) {
            drawArrow(dc, cx, cy, r, e, c.isAligned() ? Graphics.COLOR_GREEN : Graphics.COLOR_ORANGE);
        } else {
            drawArrow(dc, cx, cy, r, Directions.degrees(dir), Graphics.COLOR_BLUE);
        }
    }

    private function drawArrow(dc as Dc, cx as Numeric, cy as Numeric, r as Numeric, degrees as Numeric,
                               color as Number) as Void {
        var a = Math.toRadians(degrees);
        var cos = Math.cos(a);
        var sin = Math.sin(a);
        var shape = [[0, -r], [r * 0.6, r * 0.6], [0, r * 0.25], [-r * 0.6, r * 0.6]];
        var pts = [];
        for (var i = 0; i < shape.size(); i++) {
            var x = shape[i][0];
            var y = shape[i][1];
            pts.add([cx + x * cos - y * sin, cy + x * sin + y * cos]);
        }
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(pts);
    }
}

// Converts the data's compass codes (relative to the starting facing, N = front)
// into what a practitioner thinks in: front / back / left / right, and the turn.
module Directions {
    const CODES = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"] as Array<String>;
    const LABELS = ["Front", "Front-right", "Right", "Back-right",
                    "Back", "Back-left", "Left", "Front-left"] as Array<String>;
    // Turn from the previous facing, indexed by clockwise 45-degree steps.
    const TURNS = ["", "R 45", "R 90", "R 135",
                   "180", "L 135", "L 90", "L 45"] as Array<String>;

    function index(code as String) as Number {
        var i = CODES.indexOf(code);
        return i < 0 ? 0 : i;
    }

    function degrees(code as String) as Number {
        return index(code) * 45;
    }

    function label(code as String) as String {
        return LABELS[index(code)];
    }

    function turn(from as String, to as String) as String {
        return TURNS[(index(to) - index(from) + 8) % 8];
    }
}

class PracticeDelegate extends WatchUi.BehaviorDelegate {
    private var _view as PracticeView;

    function initialize(view as PracticeView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onSelect() as Boolean {
        _view.primary();
        return true;
    }

    function onNextPage() as Boolean {
        _view.skip();
        return true;
    }

    function onPreviousPage() as Boolean {
        _view.previous();
        return true;
    }

    // LIGHT switches look. Some watches keep LIGHT for the backlight and never send
    // it to apps, so hold UP (menu) does the same.
    function onKey(evt as WatchUi.KeyEvent) as Boolean {
        if (evt.getKey() == WatchUi.KEY_LIGHT) {
            _view.toggleLook();
            return true;
        }
        return false;
    }

    function onMenu() as Boolean {
        _view.toggleLook();
        return true;
    }
}
