# Hand/leg side per movement (6th field)

Added 2026-10-17. Each move in resources/jsonData/<id>.json now has a 6th element:
the executing side for each technique part, in the same order as the " + "-separated
parts of the technique field (field 2), joined with " + ".

- `Oen` = left hand (or left leg for a kick / knee)
- `Oreun` = right hand (or right leg)
- `Yang` = both hands acting together (wedge/opening blocks, double punch, double
  uppercut, double elbow, mountain block, X-blocks, bull block, pushing postures,
  covered fist, fists-at-waist)

## Rules applied

- Main source: Taekwondo Wiki "Written Instructions" (wikitext read through the
  MediaWiki API, 2026-10-17). It names the hand for nearly every step ("left low
  block", "right inward block"). For Taegeuk 1-8 this agrees with the usual
  Kukkiwon baro/bandae logic and with the other sources listed in MOVE_SOURCES.md.
- `dubeon-jireugi` (double punch), `chettari-jireugi`, `hecheo-makki`,
  `santeul-makki` (both arms raised) and `meongye-chigi` = `Yang`.
- Two-handed techniques with a lead hand get that hand:
  - sonnal momtong makki / kodureo makki / sonnal arae-makki = the front (blocking) hand;
  - jebipoom mok-chigi = the striking knife-hand (not the high-blocking hand);
  - kaljaebi = the striking hand;
  - palkup pyojeok / pyojeok-jireugi = the striking elbow or fist (not the target palm);
  - mureup-kkeokki = the hand that strikes down on the knee.
- `keumgang-makki` and `oesanteul-makki` = the low-block hand. That is the side the head
  looks toward (in crane stance, the lifted-foot side).
- `keun/jageun dolcheogi` = the side the hinge points to, which is the gaze/kick side.
- `gawi-makki` (scissors block) = `Yang`. The two arms block at the same time and no
  arm leads.
- A technique field written WITHOUT " + " counts as one part, even when it combines
  several techniques (for example "Ap-chagi+deungjumeok+makki" or
  "Dollyeo-chagi+makki+jireugi"). For these, the side given is that of the FIRST
  technique named, usually the kick.
- A kick-only count ("Kick (L leg)") gets the kicking leg.

## Validation (script run before finishing)

- All 17 files parse as JSON and are ASCII only.
- Move counts are unchanged: t1 18, t2 18, t3 20, t4 20, t5 20, t6 19, t7 25, t8 24,
  koryo 30, keumgang 27, taebaek 26, pyongwon 21, sipjin 28, jitae 28, cheonkwon 27,
  hansu 27, ilyeo 23.
- Every move has exactly 6 elements.
- The first 5 fields are byte-identical to the pre-edit snapshot. No other line changed.
- Field 6 has the same number of " + " parts as field 2.
- Every part is in {Oen, Oreun, Yang}.
- Every field 6 is 20 characters or fewer.

## Per form: confidence and derived moves

"Derived" means the source does not name the hand. In those cases the side was worked
out from the stance, mirror symmetry, or the rules above.

| Form | Confidence | Derived (not stated by a source) |
|---|---|---|
| t1 | high | none |
| t2 | high | none |
| t3 | high | none |
| t4 | high | none |
| t5 | high | 6, 7 (combined one-part fields: first-technique rule) |
| t6 | high | 6, 8, 18, 19 (one-part combined fields: first-technique rule); 12 low block (wiki text garbled; right, by symmetry with 3/14) |
| t7 | high | 12, 13 (gawi-makki twice = Yang by convention); 15 (one part: knee side) |
| t8 | medium | 2 (one part: first kick, right); 4, 6 (oesanteul = low-block/gaze hand); 1 and 21/24 depend on the 24-count merge noted in MOVE_SOURCES.md |
| koryo | high | 10, 11, 27 (one-part combined fields: first-technique rule); 12, 14 (mureup-kkeokki: striking hand chosen) |
| keumgang | medium | 8, 15, 18, 25 (keumgang-makki: gaze/low-block side); 9, 10, 16, 17, 19, 20, 26, 27 (keun dolcheogi: gaze side; the wiki gives no hand) |
| taebaek | medium-high | 9, 14 (keumgang momtong makki: lead hand inferred from "right/left arm high"); 23, 25 (gawi-makki = Yang) |
| pyongwon | high | 6, 9, 14, 17 (one-part combined fields: first-technique rule); 12, 20 keumgang part (from "left/right arm high" plus gaze) |
| sipjin | medium-high | 2 (palm-assisted block: lead hand from stance); 14 (double knife low block: front hand); 19 (kkeureo-olligi = Yang) |
| jitae | medium | 6, 8, 10 (wiki gives no hand: front-foot side used); 11 (keumgang ap-jireugi: punching hand, right, assumed); 20, 22 dolcheogi part (kick side) |
| cheonkwon | medium-low | 20 (double knife low block: front hand); 21, 23 (one-part fields: first technique); 26, 27 (taesan-milgi: front-foot side, unconfirmed); plus the unverified 8/9 split |
| hansu | medium-low | 3, 5, 7 (oesanteul: front-foot side, unconfirmed); 12, 21 (pyojeok arae-makki: striking hand guessed right/left); 13, 22 (sonnal keumgang-makki: front hand); 14, 23 (jageun dolcheogi: kick side); 24 jebipoom part (the wiki repeats "left arm high"; mirrored to a left strike) |
| ilyeo | medium-low | 3, 10, 17, 21 (keumgang-makki: front hand); 7, 14 oesanteul part (kick side). The wiki labels every back stance "right" and calls punches "reverse" loosely. The hands it names (right punch, right spear) were used as written. |

## Sources

- Taekwondo Wiki (taekwondo.fandom.com), written instructions for all 17 forms,
  fetched through the MediaWiki API on 2026-10-17. This is the primary source for
  explicit hands.
- The cross-checks in MOVE_SOURCES.md (Yonggi, HKU, NBTKDA, UC Berkeley Koryo).
  These agree with the Taegeuk hand assignments.
- Taekwondo Wiki "Outward Mountain Block" page: the head turns toward the low fist.
  This is the basis of the oesanteul rule.
