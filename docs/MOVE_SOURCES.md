# Poomsae movement data - sources and confidence

Compiled 2026-10-17. One JSON file per form; one array entry per officially counted
Kukkiwon movement: [stance, technique, English gloss, direction, kihap].

## Conventions

- **Direction:** "N" is the way the practitioner faces in the opening junbi position.
  In the Kukkiwon line diagrams that is the front, toward the examiner. Forms that
  progress forward (all Taegeuk, Koryo, Keumgang, Jitae, Cheonkwon and others) move
  toward N, away from the start point. E = practitioner's starting right, W = starting
  left, S = back toward the start. Hansu uses diagonals (NW/SW/NE/SE) for its four
  corners.
- The direction is the facing at the END of the counted movement. For a composite
  count that turns mid-way (e.g. Yuk Jang 6 and 12: kick N, then turn and block W),
  that means the final facing.
- For side techniques done in juchum-seogi or hakdari-seogi (yeop-makki, yeop-jireugi,
  keun/jageun dolcheogi, santeul-makki), the direction is where the technique is aimed
  and the head looks, not where the chest faces.
- **Stance L/R** is the foot that is FORWARD, for every stance including dwit-kubi
  and beom-seogi. (Some English sources, such as the Taekwondo Wiki, name back stance
  by the rear foot instead.) For hakdari-seogi and ogeum-seogi, L/R is the STANDING
  foot. For dwit-kkoa (rear cross stance), L/R is the front, weight-bearing foot.
- **Kicks:** for a kick combined with a hand technique, the stance is the stance
  landed in. "Kick (L leg)" marks a count that is only a kick with no settled stance
  (Sa Jang 7, Cheonkwon 8).
- Romanization is simplified Kukkiwon style, ASCII only (kubi = gubi, makki = makgi,
  jireugi, tzireugi = jjireugi, kodureo = geodeureo, dolcheogi = doljjeogwi).
- Where the textbook sequence had more sub-steps than the official count, I merged
  them into the official count, joined with " + ". Very long combinations are
  shortened in the technique field, and the gloss lists all parts.

## Sources used

- **[A] Yonggi Taekwondo:** written poomsae pages for Taegeuk 1-8, with Korean terms.
  sites.google.com/site/yonggitaekwondo/poomse/...
- **[B] Taekwondo Wiki (taekwondo.fandom.com):** "Written Instructions" for all 17
  forms, read through the MediaWiki API. The pages cite the Kukkiwon and WT poomsae
  references and videos. Several black-belt pages are marked "Under Construction".
- **[C] NBTKDA (nbtkda.com):** per-form pages giving kihap placement, Kukkiwon
  descriptive text, and a technique and stance inventory with Kukkiwon romanized names.
  Taegeuk 8 also has a count chart (its own counting, not Kukkiwon's).
- **[D] HKU Taekwondo Club / HKSSF pattern sheets:** Taegeuk 1-8 numbered step lists,
  for example "PATTERN 8 (24 Steps)". tkdclub.studsoc.hku.hk/pattern/Pattern-N.pdf
- **[E] UC Berkeley (ocf.berkeley.edu/~beno/koryo.html):** Koryo, 30 numbered moves.
- **[F] TaeKwonDo Nation:** step-by-step pages for Taegeuk 8, Koryo and Keumgang.
  Lower quality, used only as a tie-breaker.

The official Kukkiwon textbook was not available online in full text, and
kukkiwon.or.kr's poomsae pages returned 404. No form was checked line by line against
the textbook. Where sources counted differently, I grouped moves to reach the official
counts you specified, using the textbook's usual grouping logic: a kick merges with the
hand technique that lands from it.

## Per form

**Taegeuk Il Jang (t1), 18 moves.** Sources: A, B, D, C (kihap).
- All sources agree on the sequence and the count.
- Kihap on 18.
- Confidence: HIGH.

**Taegeuk Ee Jang (t2), 18 moves.** Sources: A, B, D, C.
- The sources agree. Moves 8 and 10 are high punches (olgul).
- Kihap on 18.
- Confidence: HIGH.

**Taegeuk Sam Jang (t3), 20 moves.** Sources: A, B, D, C.
- The sources agree. Moves 17-20 merge the block and punch, and the kick, into one count each.
- Kihap on 20.
- Confidence: HIGH.

**Taegeuk Sa Jang (t4), 20 moves.**
- Sources: B, D, C, plus A (A counts 21 because it splits move 7).
- Following B: 7 = left side kick alone; 8 = right side kick + sonnal makki; 15/16 and
  17/18 are block, then punch, as separate counts.
- Kihap on 20 (C: "second strike of double punch").
- Confidence: HIGH.

**Taegeuk O Jang (t5), 20 moves.** Sources: A, B, D, C.
- The sources agree.
- Moves 2 and 4 are in oen-seogi / oreun-seogi. B notes that some schools use ap-seogi there.
- Kihap on 20 (front kick, jump in, dwit-kkoa backfist).
- Confidence: HIGH.

**Taegeuk Yuk Jang (t6), 19 moves.**
- Sources: A, B, C. D counts 23 because it splits the kicks from the hand techniques.
- 6 = roundhouse kick + olgul bakkat-makki + punch (ends facing W).
- 12 = left roundhouse kick + arae-makki after a 270-degree turn (ends facing W).
- 16-19 are done stepping BACKWARD while facing N.
- Kihap on 12, the roundhouse kick (A, B; C: "final turn kick").
- Confidence: HIGH.

**Taegeuk Chil Jang (t7), 25 moves.** Sources: A, B, D, C.
- All sources agree on 25 moves.
- 21 and 23: the body faces E/W in juchum-seogi, and the strike goes S.
- Kihap on 25.
- Confidence: HIGH.

**Taegeuk Pal Jang (t8), 24 moves.**
- The technique sequence is consistent across A, B, D, C and F.
- The COUNTING DIFFERS between sources:
  - A and B list 27 steps. They split the elbow / backfist / punch groups.
  - D lists exactly 24.
  - F lists 20.
  - C uses its own 17 counts.
- I used D's 24-step grouping:
  - 1 = bakkat-makki + baro-jireugi;
  - 20/23 = palkup alone;
  - 21/24 = deungjumeok + bandae-jireugi.
- Caution: D does not follow Kukkiwon counting in its other sheets (its Yuk Jang has 23
  steps), so the exact merge points are UNVERIFIED against the textbook. Only the total of 24 is.
- Directions: 4-5 face E and 6-7 face W. 8-10 face N, with 10 retreating two steps to
  line 2. This follows the turn descriptions in B and F and B's line labels.
- Kihap on 2 and 18 (C, D).
- Confidence: MEDIUM. The sequence is high; the count grouping is medium.

**Koryo, 30 moves.** Sources: B, E, F, C.
- B and E both give 30 with the same grouping.
- 18/23 = cross step + side kick, then turning 180 into a low spear-hand thrust.
- 26 = moa-seogi, facing N; 27-30 go back toward the start (S).
- B describes move 9's turn as "clockwise" but labels it Ga (forward). E says "90 left",
  and I used N.
- Kihap on 11 and 30 (C: "3rd arc hand" and "final arc hand"; B agrees).
- Confidence: MEDIUM-HIGH.

**Keumgang, 27 moves.** Sources: B, C, F.
- B gives 27, and the stomp/kihap pattern matches C.
- Kihap on 11 and 21 (C: first and third stomp + mountain block).
- F splits differently, into 28 steps.
- Directions for the side sections (8-27) are uncertain:
  - Travel W (8-11), then E (15-21), then W (24-27) is solid.
  - Facings for 12-13 and 22-23 (wedge blocks, which I assumed face S) and the gaze
    for the santeul-makki moves are my interpretation. No source states them clearly.
- Confidence: MEDIUM for the sequence, LOW for the directions of 11-14 and 21-24.

**Taebaek, 26 moves.** Sources: B, C.
- B gives 26. Kihap on 8 and 22, which matches C ("third reverse punch", "third forward punch").
- Disagreement: C's technique list includes "mejumeok bakkat-chigi" and "geodeo-makki"
  and NO side punch. B has "side punch" at 11 and 16.
- I kept B's version (momtong yeop-jireugi), but moves 11 and 16 are UNVERIFIED and may
  actually be a hammerfist strike.
- B also keeps 10/15 (teok-jireugi) in dwit-kubi, which is unverified.
- Confidence: MEDIUM.

**Pyongwon, 21 moves.** Sources: B, C.
- B gives 21 and its techniques match C's inventory: palkup ollyeo-chigi, dwidora
  yeop-chagi, kodureo olgul yeop-makki, dangkyeo deungjumeok, meongye-chigi, hecheo
  santeul-makki, keumgang-makki + jageun dolcheogi.
- Kihap on 9 and 17 (C).
- C also lists "mejumeok bakkat-chigi", which B does not name; it may accompany the
  side kick at 21.
- Confidence: MEDIUM.

**Sipjin, 28 moves.** Sources: B, C.
- B gives 28, and it matches C's inventory closely: hwangso-makki, palmok dollyeo,
  bawi-milgi, the "stand up and clench both fists" special skill (move 18),
  kkeureo-olligi, chettari-jireugi, sonnal eotgeoreo arae-makki, and assisted backfist
  with a stomp.
- Three kihaps, on 5, 10 and 23 (C, B).
- I wrote move 18's stance as "Wide stance" because the Kukkiwon stance name is
  uncertain.
- Confidence: MEDIUM-HIGH.

**Jitae, 28 moves.** Sources: B, C.
- B gives 28. Every technique matches C's inventory, including keumgang ap-jireugi and
  baro dubeon-jireugi.
- Kihap on 18 (mejumeok pyojeok an-chigi) and 24 (bandae-jireugi), per C and B.
- Two changes from B:
  - I regrouped the crane-stance moves symmetrically: 20/22 = small hinge + side kick,
    and 23 = punch. B has 22 = hinge and 23 = kick + punch. The total is unchanged.
  - Directions 15-22 are my derivation. The body faces W in juchum-seogi; the low side
    block goes S, then the head turns 180 for the knife-hand side block and hammerfist
    to the N. The N-side crane sequence comes first, then the S side, and the form
    returns S at 23-24.
- Confidence: MEDIUM.

**Cheonkwon, 27 moves.** Sources: B, C.
- B gives only 26. To reach 27, I split B's step 8 into 8 = side kick (KIHAP) and
  9 = arae-makki. C puts the kihap on the side kick, which supports treating it as its
  own count, but this split is my choice and is UNVERIFIED.
- C lists "nineunja-seogi" and "jageun ap-kubi", which B never names. B uses back
  stance for 11-16. Those stances may be wrong.
- The directions of 24-27 are uncertain: I assumed the final taesan-milgi steps face S
  and the form ends with a turn back to N.
- Confidence: LOW-MEDIUM.

**Hansu, 27 moves.** Sources: B, C.
- B gives 27 with compass directions for its four diagonal corners.
- The techniques match C's inventory: du mejumeok an-chigi, oesan-makki + baro-jireugi,
  ageumson geodeureo ap-chigi, dujumeok jecheo-jireugi in kyeotdari-seogi, pyojeok
  arae-makki, sonnal keumgang-makki, and the others.
- Kihap on 16 and 25 (stomp + backfist, per C).
- C lists "nulleo-makki", which B does not place.
- Confidence: MEDIUM.

**Ilyeo, 23 moves.** Sources: B, C.
- B gives 23 and matches C's inventory: ogeum-seogi with pressing block + vertical spear
  thrust (kihap on 6 and 13), oesan-makki + side kick, eotgeoreo olgul-makki, the wrist
  twist-and-pull + punch, the "du jumeok heori junbi" posture (counted as 18 and 22),
  and the jumping side kick.
- B's page is internally inconsistent: it calls the move-2 punch a "reverse" punch from
  a right front stance, and its turn wording is loose. I recorded move 2 as a plain
  "Momtong jireugi".
- The 90-degree counterclockwise rotations are as B states them. The
  directions after 7, 14, 19 and 23 are my derivation.
- Confidence: LOW-MEDIUM.

## Summary

- **High confidence:** Taegeuk 1-7.
- **Medium-high:** Koryo, Sipjin.
- **Medium:** Taegeuk 8 (count grouping), Keumgang (directions low in places), Taebaek,
  Pyongwon, Jitae, Hansu.
- **Low-medium:** Cheonkwon, Ilyeo.

No black-belt form was cross-checked against two independent COMPLETE written lists,
except Koryo (B and E). For the others, the second source (C) confirms the technique
inventory and the kihap placement but not the order. Before relying on the black-belt
data, check it against the Kukkiwon textbook or the official Kukkiwon videos.
