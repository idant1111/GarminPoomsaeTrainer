import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// Traditional symbol of each form, drawn with primitives so it scales to any size.
// Taegeuk 1-8: the Palgwe trigrams (Keon, Tae, Ri, Jin, Seon, Gam, Gan, Gon).
// Black belt forms: the poomsae-seon (floor pattern) character.
module FormIcons {
    // Trigram lines top to bottom: 1 = solid (yang), 0 = broken (yin).
    const TRIGRAMS = [
        [1, 1, 1], // Il Jang   - Keon, heaven
        [0, 1, 1], // Ee Jang   - Tae, lake
        [1, 0, 1], // Sam Jang  - Ri, fire
        [0, 0, 1], // Sa Jang   - Jin, thunder
        [1, 1, 0], // O Jang    - Seon, wind
        [0, 1, 0], // Yuk Jang  - Gam, water
        [1, 0, 0], // Chil Jang - Gan, mountain
        [0, 0, 0]  // Pal Jang  - Gon, earth
    ] as Array<Array<Number>>;

    // Floor-pattern strokes as [x1, y1, x2, y2] on a 0-100 grid (y down).
    const LINES = [
        [[10, 30, 90, 30], [50, 10, 50, 85], [25, 85, 75, 85]],                    // Koryo     士
        [[10, 90, 90, 90], [10, 45, 10, 90], [50, 10, 50, 90], [90, 45, 90, 90]],  // Keumgang  山
        [[20, 15, 80, 15], [50, 15, 50, 85], [10, 85, 90, 85]],                    // Taebaek   工
        [[10, 50, 90, 50]],                                                        // Pyongwon  一
        [[10, 50, 90, 50], [50, 10, 50, 90]],                                      // Sipjin    十
        [[50, 20, 50, 80], [10, 80, 90, 80]],                                      // Jitae     ㅗ
        [[10, 20, 90, 20], [50, 20, 50, 80]],                                      // Cheonkwon ㅜ
        [[50, 10, 50, 90], [12, 35, 38, 35], [38, 35, 12, 80],
         [85, 25, 58, 48], [58, 45, 88, 85]],                                      // Hansu     水
        []                                                                         // Ilyeo: drawn as a circle, see below
    ] as Array<Array<Array<Number>>>;

    // Ilyeo ("oneness") is shown as a ring with a centre dot instead of its floor-pattern character.
    const ILYEO = 16;

    // Draws form `form`'s symbol in a size x size box centred on (cx, cy).
    function draw(dc as Dc, form as Number, cx as Numeric, cy as Numeric, size as Numeric, color as Number) as Void {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        var left = cx - size / 2;
        var top = cy - size / 2;
        if (form == ILYEO) {
            var pen = size / 10;
            dc.setPenWidth(pen < 2 ? 2 : pen.toNumber());
            dc.drawCircle(cx, cy, size * 0.42);
            dc.setPenWidth(1);
            dc.fillCircle(cx, cy, size * 0.1);
        } else if (form < TRIGRAMS.size()) {
            var bars = TRIGRAMS[form];
            var barH = size * 0.18;
            var gap = (size - 3 * barH) / 2;
            var halfW = size * 0.40;
            for (var i = 0; i < 3; i++) {
                var y = top + i * (barH + gap);
                if (bars[i] == 1) {
                    dc.fillRectangle(left, y, size, barH);
                } else {
                    dc.fillRectangle(left, y, halfW, barH);
                    dc.fillRectangle(left + size - halfW, y, halfW, barH);
                }
            }
        } else {
            var strokes = LINES[form - TRIGRAMS.size()];
            var pen = size / 10;
            dc.setPenWidth(pen < 2 ? 2 : pen.toNumber());
            for (var i = 0; i < strokes.size(); i++) {
                var s = strokes[i];
                dc.drawLine(left + s[0] * size / 100, top + s[1] * size / 100,
                            left + s[2] * size / 100, top + s[3] * size / 100);
            }
            dc.setPenWidth(1);
        }
    }
}

// Menu2 icon wrapper: draws the symbol centred in the area the menu provides.
class FormIconDrawable extends WatchUi.Drawable {
    private var _form as Number;

    function initialize(form as Number) {
        Drawable.initialize({});
        _form = form;
    }

    function draw(dc as Dc) as Void {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var size = (w < h ? w : h) * 0.6;
        FormIcons.draw(dc, _form, w / 2, h / 2, size, Graphics.COLOR_WHITE);
    }
}
