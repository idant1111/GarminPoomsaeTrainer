# Connect IQ Store listing: Poomsae

Paste these into the Connect IQ developer portal (apps.garmin.com/developer → Upload an App).

| Field | Value |
|---|---|
| App type | Device App |
| Package | `bin/Poomsae.iq` |
| Title | Taekwondo Poomsae Trainer |
| Category | Training (or Fitness) |
| Version | 1.3.0 (store has 1.2.0) |
| Supported devices | fēnix 7 / 7S / 7X; fēnix 7 Pro / 7S Pro / 7X Pro (Solar and Sapphire); fēnix E; fēnix 8 (43/47/51mm, Pro, Solar 47/51mm, incl. tactix 8 / quatix 8 variants); fēnix 9 (43/47/51mm, Pro 43/47/51mm, Pro Solar 47/51mm). |
| Permissions shown to users | Fit (record activities), FitContributor (custom fields), Sensor (heart rate) |

## Short description

Step-by-step Taekwondo poomsae trainer: Taegeuk 1–8 and Koryo to Ilyeo, with direction, hand and stance for every move.

## Full description

Practice Kukkiwon poomsae from your wrist.

FORMS
• Taegeuk Il Jang to Pal Jang (8th–1st Gup)
• Black belt forms: Koryo, Keumgang, Taebaek, Pyongwon, Sipjin, Jitae, Cheonkwon, Hansu, Ilyeo
• Each form shows its trigram or floor-pattern symbol, rank and meaning

EVERY MOVEMENT SHOWS
• Direction: Front / Back / Left / Right, an arrow, and the turn from the previous move
• Hand technique with its side (Oen / Oreun / Yang)
• Kicks and stance with their side
• KIHAP cue, with a double vibration

CHARACTER VIEW
Press LIGHT (or hold UP) to see a character in a dobok performing the move, viewed from behind so your left is on the left. The working hand or kicking leg is highlighted.

COMPASS GUIDE (optional)
Turn on Compass guide in Options. Face front and press START, and a compass needle shows where to turn for each move. You get a buzz when you're facing the right way, a warning buzz when a move ends facing the wrong way, and a facing score at the end of the form. Your wrist is measured, not your body, so treat it as a guide.

PRACTICE MODES
• Step through: advance with the buttons
• Paced: the watch moves on and vibrates at your tempo (1–5 s per move)

WORKOUT RECORDING
Press START to record a Training activity with heart rate and calories. Each completed form is saved as a lap, and the total number of forms is stored in the activity.

HISTORY
Reps per form and the date you last practiced each one.

SUPPORTED WATCHES
fēnix 7 / 7S / 7X, fēnix 7 Pro / 7S Pro / 7X Pro, fēnix E, fēnix 8 (AMOLED, Pro and Solar), fēnix 9 (all sizes, Pro and Pro Solar), tactix 7, tactix 8 and Enduro 2.

Note: movement data was compiled from published Kukkiwon-style references. Details vary between schools, so check sequences against your instructor's curriculum.

## What's new (1.3.0)

New optional Compass guide (Options → Compass guide): face front and press START. A compass needle then shows which way to turn for every move, with a buzz when you're on target, a warning buzz for a wrong facing, and a facing score when you finish the form.

## What's new (1.2.0)

Now available on every fēnix from the 7 series onward: fēnix 7 / 7S / 7X, 7 Pro / 7S Pro / 7X Pro, fēnix E, fēnix 8 and fēnix 9 (including AMOLED models), plus tactix 7 / tactix 8 and Enduro 2.

## What's new (1.0.0)

First release.

## Images

All images are in `store/upload/`. See [upload/README.md](upload/README.md) for which file goes where.
- Hero: `hero-1440x720.png`
- Cover: `cover-500x500.png`
- Screens, in order:
  1. `screen-1-forms.png`: form list
  2. `screen-2-move.png`: move screen
  3. `screen-3-character.png`: character screen
  4. `screen-4-kihap.png`: KIHAP move
  5. `screen-5-workout.png`: workout screen

## Before submitting

- [x] Build `bin/Poomsae.iq` (fēnix 7X Pro Solar)
- [ ] Test on your own watch (sideload `bin/Poomsae.prg`)
- [ ] Later: add `fenix7xpro` (Sapphire) back to manifest.xml once the SDK Manager has downloaded it, rebuild and upload as 1.0.1
- [ ] Add a support contact (email or URL) in the portal
