import Toybox.Lang;
import Toybox.WatchUi;

// Static catalogue of forms. Movement data lives in resources/jsonData/<id>.json
// and is loaded only when a form is opened, to keep memory use low.
module FormIndex {
    const IDS = [
        "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8",
        "koryo", "keumgang", "taebaek", "pyongwon", "sipjin",
        "jitae", "cheonkwon", "hansu", "ilyeo"
    ] as Array<String>;

    const NAMES = [
        "Taegeuk Il Jang", "Taegeuk Ee Jang", "Taegeuk Sam Jang", "Taegeuk Sa Jang",
        "Taegeuk O Jang", "Taegeuk Yuk Jang", "Taegeuk Chil Jang", "Taegeuk Pal Jang",
        "Koryo", "Keumgang", "Taebaek", "Pyongwon", "Sipjin",
        "Jitae", "Cheonkwon", "Hansu", "Ilyeo"
    ] as Array<String>;

    const SHORT = [
        "Taegeuk 1", "Taegeuk 2", "Taegeuk 3", "Taegeuk 4",
        "Taegeuk 5", "Taegeuk 6", "Taegeuk 7", "Taegeuk 8",
        "Koryo", "Keumgang", "Taebaek", "Pyongwon", "Sipjin",
        "Jitae", "Cheonkwon", "Hansu", "Ilyeo"
    ] as Array<String>;

    const RANKS = [
        "8th Gup", "7th Gup", "6th Gup", "5th Gup",
        "4th Gup", "3rd Gup", "2nd Gup", "1st Gup",
        "1st Dan", "2nd Dan", "3rd Dan", "4th Dan", "4th Dan",
        "5th Dan", "6th Dan", "7th Dan", "8th Dan"
    ] as Array<String>;

    // Symbol and meaning of each form.
    const MEANINGS = [
        "Keon - Heaven", "Tae - Lake", "Ri - Fire", "Jin - Thunder",
        "Seon - Wind", "Gam - Water", "Gan - Mountain", "Gon - Earth",
        "Seonbae - Scholar", "Diamond", "Bright mountain", "Vast plain", "Longevity",
        "Earth", "Heaven", "Water", "Oneness"
    ] as Array<String>;

    // Official Kukkiwon movement counts.
    const COUNTS = [
        18, 18, 20, 20, 20, 19, 25, 24,
        30, 27, 26, 21, 28, 28, 27, 27, 23
    ] as Array<Number>;

    function size() as Number {
        return IDS.size();
    }

    // Each move: [stance, technique (Korean), English gloss, direction, kihap 0/1].
    // Direction is relative to the starting facing direction (N).
    function loadMoves(i as Number) as Array {
        var res = [
            Rez.JsonData.t1, Rez.JsonData.t2, Rez.JsonData.t3, Rez.JsonData.t4,
            Rez.JsonData.t5, Rez.JsonData.t6, Rez.JsonData.t7, Rez.JsonData.t8,
            Rez.JsonData.koryo, Rez.JsonData.keumgang, Rez.JsonData.taebaek,
            Rez.JsonData.pyongwon, Rez.JsonData.sipjin, Rez.JsonData.jitae,
            Rez.JsonData.cheonkwon, Rez.JsonData.hansu, Rez.JsonData.ilyeo
        ];
        var data = WatchUi.loadResource(res[i] as ResourceId) as Dictionary;
        return data["moves"] as Array;
    }
}
