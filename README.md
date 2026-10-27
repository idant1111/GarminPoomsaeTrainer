# Garmin Poomsae Trainer

Kukkiwon / World Taekwondo poomsae trainer for Garmin watches. This Connect IQ app helps you practice Taegeuk 1–8 and the black belt forms Koryo through Ilyeo.

Runs on fēnix 7 / 7S / 7X, fēnix 7 Pro / 7S Pro / 7X Pro, fēnix E, fēnix 8 and fēnix 9, plus the tactix 7 / tactix 8 and Enduro 2 variants that share those builds. It's published in the Connect IQ Store as **Taekwondo Poomsae Trainer**.

## Features

- **Form symbols**: each form shows its traditional symbol. Taegeuk forms show their trigram (Il Jang ☰ Keon through Pal Jang ☷ Gon). Black belt forms show their floor-pattern character (Koryo 士, Keumgang 山, Taebaek 工, Pyongwon 一, Sipjin 十, Jitae ㅗ, Cheonkwon ㅜ, Hansu 水). Ilyeo ("oneness") shows a ring with a centre dot. The symbol appears in the form list, on every movement screen and on the completion screen. The list also shows each form's rank and meaning.
- **Step through**: walk through a form one movement at a time. Each screen shows, in order:
  1. the poomsae name and move number
  2. the direction in blue (Front, Back, Left, Right or a diagonal, relative to where you started), with an arrow and the turn from the previous move (e.g. "L 90")
  3. the hand movement with its side, e.g. "Oen sonnal momtong makki" (Yang = both hands)
  4. the leg movement with its side: any kick, then the stance by its front foot, e.g. "Oreun yeop-chagi x2, Oreun ap-kubi". Back and tiger stances add "(fwd)".

  A KIHAP cue appears at the bottom when due. Hand-side sources and confidence are in [docs/HAND_SIDES.md](docs/HAND_SIDES.md).
- **Character screen**: press LIGHT (or hold UP) on a movement to switch to a full-screen character in a dobok performing the move, seen from behind so your left is on the left. The working arm or kicking leg is outlined in green. Press again to switch back. The app remembers your choice.
- **Compass guide** (Options → Compass guide, off by default): uses the watch's compass to check you face the right way.
  - **Set front:** on the first move, stand facing the examiner and press START. The current heading becomes "front".
  - **Live needle:** the direction arrow points where to turn. It turns green with a light buzz within ±30°; otherwise the status line says "Turn L 40" or "Turn R 90".
  - **Check:** when a move ends (you advance, or the paced beat moves on), a wrong facing gets a triple buzz.
  - **Score:** "Form complete" shows how many moves were on target. START for another rep sets front again automatically.

  The watch measures your wrist, not your body, so the check is deliberately loose. It's most accurate in step mode, where you set front and advance in the same arm position (pressing a button).
- **Paced**: the watch moves to the next movement and vibrates at a set tempo (1–5 s). Kihap movements get a double buzz. START pauses.
- **Workout recording**: press START on the main screen to record a Training activity with heart rate and calories. Every completed form is saved as a lap tagged with the form's number, and the session stores the total forms completed. It syncs to Garmin Connect like any other activity.
- **History**: reps per form and the date you last practiced each one, kept on the watch.

## Buttons

| Screen | START | DOWN / UP | BACK | Hold UP |
|---|---|---|---|---|
| Main | Start/pause recording | Form list | Workout menu (Resume / Save / Discard), or exit if no workout | Options (tempo, history) |
| Practice | Next (step mode) / pause-resume (paced) / repeat when done | Next / previous move | Back to menus | Text ↔ character screen (also LIGHT) |

## Setup (Windows)

1. Install a JDK (e.g. Temurin 17).
2. Install the [Connect IQ SDK Manager](https://developer.garmin.com/connect-iq/sdk/). Use it to download the latest SDK and the **fēnix 7X Pro** device.
3. Install VS Code and the **Monkey C** extension (Garmin).
4. In VS Code, run **Monkey C: Generate a Developer Key**.
5. Open this `poomsae` folder. Run **Monkey C: Build for Device** → `fenix7xpro`, or **Run → Start Debugging** to open the simulator.

Command-line build, if `monkeyc` is on PATH:

```bash
monkeyc -d fenix7xpro -f monkey.jungle -o bin/poomsae.prg -y path/to/developer_key.der
```

Store package for every device in `manifest.xml` (each device must be downloaded in the SDK Manager first):

```bash
monkeyc -e -r -f monkey.jungle -o bin/Poomsae.iq -y path/to/developer_key.der
```

Keep `developer_key.der` private and backed up. Store updates must be signed with the same key. Never commit it; `.gitignore` excludes `*.der` and `bin/`.

## Install on the watch

Connect the watch over USB and copy `bin/poomsae.prg` to `GARMIN\APPS\` on the watch. Disconnect, and the app appears in the apps list. You can also assign it to a hot key.

## Move data

Movement data is in `resources/jsonData/<form>.json`. Each move is `[stance, technique, English, direction, kihap, side]`:
- **stance:** named by the front foot.
- **direction:** relative to the starting facing (N = front).
- **side:** Oen / Oreun / Yang for each " + " part of the technique.

Sources and confidence ratings are in [docs/MOVE_SOURCES.md](docs/MOVE_SOURCES.md) and [docs/HAND_SIDES.md](docs/HAND_SIDES.md). **Check the sequences against your school's curriculum.** Schools differ on small details.

## Store listing

Listing text and images for the Connect IQ Store are in [store/](store/).

## License

MIT. See [LICENSE](LICENSE).
