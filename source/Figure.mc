import Toybox.Graphics;
import Toybox.Lang;

// Character in a white dobok performing a move, seen from BEHIND: the viewer stands
// behind the practitioner, so the practitioner's left is on the screen's left (Oen =
// screen left). Poses are modelled in 3D units (x = right, y = down, z = forward, in
// 1/100 of the figure size) and projected so forward reads as "up and into" the screen.
// The working arm or kicking leg is outlined in green with a green fist/foot.
module Figure {
    const SKIN = 0xFFAA55;
    const DEPTH = 0.25; // how far up the screen one unit of forward depth moves a point

    // Arm shapes relative to the shoulder, for the RIGHT arm: [ex, ey, ez, hx, hy, hz]
    // (elbow, hand). x is mirrored for the left arm; +x = outward.
    const CHAMBER = [3, 14, -6, 1, 24, -2] as Array<Number>;
    const GUARD = [2, 12, 8, -2, 4, 16] as Array<Number>;
    const GUARD_REAR = [3, 10, 8, -6, 6, 12] as Array<Number>;

    function draw(dc as Dc, cx as Numeric, hipY as Numeric, size as Numeric,
                  stance as String, tech as String, side as String?) as Void {
        var u = size / 100.0;
        var part = firstPart(tech);
        var lower = lowerCase(part);
        var frontLeft = stance.find("L ") == 0;
        var kick = lower.find("chagi") != null;

        // Which side works: from the data if present, otherwise baro/bandae logic.
        var leftWorks;
        var rightWorks;
        if (side == null) {
            leftWorks = lower.find("baro") != null ? !frontLeft : frontLeft;
            rightWorks = !leftWorks;
        } else if (side.equals("Yang")) {
            leftWorks = true;
            rightWorks = true;
        } else {
            leftWorks = side.equals("Oen");
            rightWorks = !leftWorks;
        }

        // Legs: [kx, ky, kz, fx, fy, fz] relative to the hip joint (hips at x = +-5).
        var legs = kick ? kickLegs(lower, leftWorks && !rightWorks) : stanceLegs(stance, frontLeft);
        var lLeg = legs[0];
        var rLeg = legs[1];

        // Arms.
        var work = kick ? GUARD : armShape(lower, stance);
        var rest = CHAMBER;
        if (kick || ((lower.find("sonnal") != null || lower.find("kodureo") != null) && lower.find("arae") == null)) {
            rest = GUARD_REAR;
        }
        var lArm = leftWorks ? work : rest;
        var rArm = rightWorks ? work : rest;

        var shift = lower.find("yeop-chagi") != null ? (leftWorks ? 6 : -6) : 0;

        // Ground line.
        dc.setPenWidth(1);
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(cx - 42 * u, hipY + 47 * u, cx + 42 * u, hipY + 47 * u);

        var lKick = kick && leftWorks && !rightWorks;
        var rKick = kick && rightWorks && !leftWorks;
        // Draw the leg further forward first so the nearer one overlaps it.
        if (lLeg[5] > rLeg[5]) {
            leg(dc, cx, hipY, u, -1, lLeg, lKick);
            leg(dc, cx, hipY, u, 1, rLeg, rKick);
        } else {
            leg(dc, cx, hipY, u, 1, rLeg, rKick);
            leg(dc, cx, hipY, u, -1, lLeg, lKick);
        }

        // Arms reaching forward are hidden behind the back; others are drawn over it.
        var lFwd = lArm[5] > 20;
        var rFwd = rArm[5] > 20;
        if (lFwd) { arm(dc, cx, hipY, u, shift, -1, lArm, !kick && leftWorks); }
        if (rFwd) { arm(dc, cx, hipY, u, shift, 1, rArm, !kick && rightWorks); }
        torso(dc, cx, hipY, u, shift);
        head(dc, cx + shift * u, hipY - 44 * u, u);
        if (!lFwd) { arm(dc, cx, hipY, u, shift, -1, lArm, !kick && leftWorks); }
        if (!rFwd) { arm(dc, cx, hipY, u, shift, 1, rArm, !kick && rightWorks); }

        dc.setPenWidth(1);
    }

    function firstPart(tech as String) as String {
        var plus = tech.find(" + ");
        return plus == null ? tech : tech.substring(0, plus) as String;
    }

    function lowerCase(s as String) as String {
        return s.toLower();
    }

    // [left leg, right leg] for a stance. Front leg steps forward (+z), back leg back (-z).
    function stanceLegs(stance as String, frontLeft as Boolean) as Array<Array<Number>> {
        var front;
        var back;
        // x is "outward" for each leg (mirrored by side when drawn).
        if (stance.find("juchum") != null) {
            return [[14, 20, 4, 16, 45, 0], [14, 20, 4, 16, 45, 0]];
        } else if (stance.find("moa") != null || stance.find("naranhi") != null) {
            return [[-2, 22, 0, -2, 45, 0], [-2, 22, 0, -2, 45, 0]];
        } else if (stance.find("hakdari") != null || stance.find("ogeum") != null) {
            var stand = [0, 22, 0, 0, 45, 0];
            var lift = [7, 12, 8, -4, 24, 2];
            return frontLeft ? [stand, lift] : [lift, stand];
        } else if (stance.find("ap-kubi") != null) {
            front = [2, 20, 22, 2, 45, 30];
            back = [1, 22, -14, 1, 45, -28];
        } else if (stance.find("dwit-kubi") != null) {
            front = [-1, 22, 12, -3, 45, 22];
            back = [5, 20, -6, 2, 45, -12];
        } else if (stance.find("beom-seogi") != null) {
            front = [0, 22, 10, -1, 43, 12];
            back = [4, 20, -4, 2, 45, -6];
        } else if (stance.find("kkoa") != null) {
            front = [0, 22, 6, -2, 45, 8];
            back = [-4, 24, 0, -7, 44, 2];
        } else { // ap-seogi and others
            front = [0, 22, 8, 0, 45, 14];
            back = [0, 22, -6, 0, 45, -12];
        }
        return frontLeft ? [front, back] : [back, front];
    }

    // [left leg, right leg] for a kick; the other leg supports.
    function kickLegs(lower as String, leftKicks as Boolean) as Array<Array<Number>> {
        var k;
        if (lower.find("yeop") != null) {
            k = [14, -6, 2, 32, -16, 2];
        } else if (lower.find("dollyeo") != null) {
            k = [10, -6, 12, 14, -18, 24];
        } else { // ap-chagi and others
            k = [3, -4, 16, 3, -16, 32];
        }
        var support = [1, 22, 0, 1, 45, 0];
        return leftKicks ? [k, support] : [support, k];
    }

    function armShape(lower as String, stance as String) as Array<Number> {
        // Side techniques (aimed to the side, usually from juchum-seogi) reach outward.
        if (lower.find("yeop") != null || (stance.find("juchum") != null && lower.find("pyojeok") == null
                && (lower.find("jireugi") != null || lower.find("makki") != null))) {
            return [14, 2, 0, 28, 2, 0];
        } else if (lower.find("palkup") != null) {
            return [-4, 0, 14, -10, -2, 4];
        } else if (lower.find("nulleo") != null) {
            return [2, 10, 10, -4, 16, 18];
        } else if (lower.find("hecheo") != null) {
            return [8, 8, 10, 4, -8, 12];
        } else if (lower.find("olgul") != null && lower.find("makki") != null) {
            return [3, -8, 10, -10, -16, 10];
        } else if (lower.find("arae") != null) {
            return [2, 14, 6, 4, 30, 14];
        } else if (lower.find("jireugi") != null || lower.find("tzireugi") != null || lower.find("pyojeok") != null) {
            return lower.find("olgul") != null ? [-1, -4, 14, -6, -8, 30] : [-1, 2, 14, -6, 2, 30];
        } else if (lower.find("chigi") != null || lower.find("kaljaebi") != null) {
            return [-1, -2, 12, -4, -4, 26];
        } else if (lower.find("bakkat") != null || lower.find("sonnal") != null) {
            return [7, 10, 10, 9, -6, 12];
        } else if (lower.find("makki") != null) {
            return [6, 10, 10, 2, -6, 14];
        }
        return GUARD;
    }

    // Projects a body point (x, y, z) to screen coordinates.
    function pt(cx as Numeric, cy as Numeric, u as Float, x as Numeric, y as Numeric, z as Numeric) as Array<Numeric> {
        return [cx + x * u, cy + (y - z * DEPTH) * u];
    }

    // Pants leg from the hip joint; s = -1 for left, 1 for right. Heel/foot at the end.
    function leg(dc as Dc, cx as Numeric, cy as Numeric, u as Float, s as Number, l as Array<Number>,
                 working as Boolean) as Void {
        var hip = pt(cx, cy, u, 5 * s, 0, 0);
        var knee = pt(cx, cy, u, (5 + l[0]) * s, l[1], l[2]);
        var foot = pt(cx, cy, u, (5 + l[3]) * s, l[4], l[5]);
        segments(dc, [hip[0], hip[1], knee[0], knee[1], foot[0], foot[1]], px(9 * u),
                 Graphics.COLOR_WHITE, working ? Graphics.COLOR_GREEN : Graphics.COLOR_LT_GRAY);
        dc.setColor(working ? Graphics.COLOR_GREEN : SKIN, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(foot[0], foot[1] + 2 * u, 3.2 * u);
    }

    // Sleeve from the shoulder; fist at the end.
    function arm(dc as Dc, cx as Numeric, cy as Numeric, u as Float, shift as Numeric, s as Number,
                 a as Array<Number>, working as Boolean) as Void {
        var sh = pt(cx, cy, u, shift + 10 * s, -32, 0);
        var el = pt(cx, cy, u, shift + (10 + a[0]) * s, -32 + a[1], a[2]);
        var hd = pt(cx, cy, u, shift + (10 + a[3]) * s, -32 + a[4], a[5]);
        segments(dc, [sh[0], sh[1], el[0], el[1], hd[0], hd[1]], px(6 * u),
                 Graphics.COLOR_WHITE, working ? Graphics.COLOR_GREEN : Graphics.COLOR_LT_GRAY);
        dc.setColor(working ? Graphics.COLOR_GREEN : SKIN, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(hd[0], hd[1], 3.2 * u);
    }

    // Back of the jacket with the belt across it.
    function torso(dc as Dc, cx as Numeric, cy as Numeric, u as Float, shift as Numeric) as Void {
        var outline = [
            [cx + (shift - 12) * u, cy - 35 * u], [cx + (shift + 12) * u, cy - 35 * u],
            [cx + 10 * u, cy + 4 * u], [cx - 10 * u, cy + 4 * u]
        ];
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(outline);
        var body = [
            [cx + (shift - 11) * u, cy - 34 * u], [cx + (shift + 11) * u, cy - 34 * u],
            [cx + 9 * u, cy + 3 * u], [cx - 9 * u, cy + 3 * u]
        ];
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(body);
        // Black collar band at the back of the neck, and the belt.
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(cx + (shift - 4) * u, cy - 34 * u, 8 * u, 2.5 * u);
        dc.fillRectangle(cx - 10 * u, cy - 4 * u, 20 * u, 4 * u);
    }

    // Back of the head: hair, with the neck below.
    function head(dc as Dc, x as Numeric, y as Numeric, u as Float) as Void {
        dc.setColor(SKIN, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(x - 2.5 * u, y + 4 * u, 5 * u, 7 * u);
        dc.fillCircle(x - 7 * u, y + 1 * u, 1.8 * u);
        dc.fillCircle(x + 7 * u, y + 1 * u, 1.8 * u);
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x, y, 7 * u);
    }

    // Draws a polyline [x0,y0,x1,y1,...] as a thick rounded limb: outline pass, then fill pass.
    function segments(dc as Dc, p as Array<Numeric>, w as Number, fill as Number, outline as Number) as Void {
        var passes = [[w + 2, outline], [w, fill]];
        for (var k = 0; k < 2; k++) {
            var pw = passes[k][0] as Number;
            dc.setColor(passes[k][1] as Number, Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(pw);
            for (var i = 0; i + 3 < p.size(); i += 2) {
                dc.drawLine(p[i], p[i + 1], p[i + 2], p[i + 3]);
            }
            for (var i = 0; i + 1 < p.size(); i += 2) {
                dc.fillCircle(p[i], p[i + 1], pw / 2.0);
            }
        }
    }

    function px(v as Numeric) as Number {
        var n = v.toNumber();
        return n < 1 ? 1 : n;
    }
}
