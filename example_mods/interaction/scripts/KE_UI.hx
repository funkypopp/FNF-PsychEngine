import flixel.text.FlxText;
import flixel.math.FlxMath;
import backend.CoolUtil;
import backend.Difficulty;
import objects.Bar;

var KEVersion = "KE 1.4.2"; // why not make this a var lol
var fullKadeExperience = true;
var hudToggle = true;

var watermark:FlxText;

function onCreatePost() {
	if (hudToggle) {
		FlxG.game.stage.window.title = "fiday niht funin";

		watermark = new FlxText(4, game.healthBar.y + 55, 0, game.curSong + " " + Difficulty.getString() + " - " + KEVersion, 16);
		watermark.setFormat(game.scoreTxt.font, 16, game.color, null, game.scoreTxt.borderStyle, game.scoreTxt.borderColor);
		watermark.cameras = [game.camHUD];
		add(watermark);

		game.scoreTxt.setFormat(watermark.font, watermark.size, watermark.color, null, watermark.borderStyle, watermark.borderColor);
		game.scoreTxt.y = watermark.y;

		/*
		for (object in [game.timeBar, game.timeTxt])
			object.kill();

		var songTxtKade = new FlxText(0, 0, 0, game.curSong, 16);
		songTxtKade.cameras = [game.camHUD];
		songTxtKade.setFormat(watermark.font, watermark.size, watermark.color, null, watermark.borderStyle, watermark.borderColor);
		songTxtKade.screenCenter();
		game.timeBarKade = new Bar(songTxtKade.y, game.timeTxt.y + (game.timeTxt.height / 4) - 10, 'healthBar', function() return game.songPercent, 0, 1);
		game.timeBarKade.scrollFactor.set();
		game.timeBarKade.setColors(FlxColor.LIME, FlxColor.GRAY);
		game.timeBarKade.cameras = [game.camHUD];
		songTxtKade.y = game.timeBarKade.y;
		for (object in [game.timeBarKade, songTxtKade])
			add(object);
		*/

		if (fullKadeExperience) {
			for (note in game.unspawnNotes) {
				if (note.isSustainNote)
					note.offsetY += 20;

				if (note.prevNote != null && note.prevNote.isSustainNote) {
					note.offsetY += 50;
				}
			}
		}
	}
}

function onUpdatePost(elapsed:Float) {
	if (hudToggle) {
	var scoreArray = [
		game.songScore,
		game.songMisses,
		CoolUtil.floorDecimal(game.ratingPercent * 100, 2) + "% | " + generateRanking()
	];

	game.scoreTxt.text = "Score:" + scoreArray[0] + " | Combo Breaks:" + scoreArray[1] + " | Accuracy:" + scoreArray[2];

	game.healthBar.setColors(0xFFFF0000, 0xFF66FF33);

	if (fullKadeExperience)
		for (icon in [game.iconP1, game.iconP2]) {
			icon.scale.x = FlxMath.lerp(icon.scale.x, 1, 0.105);
			icon.scale.y = FlxMath.lerp(icon.scale.y, 1, 0.105);
		}
	}
}

function onBeatHit() {
	if (hudToggle) {
		if (fullKadeExperience) {
			for (icon in [game.iconP1, game.iconP2]) {
				icon.scale.x = FlxMath.lerp(icon.scale.x, 1.30, 0.45);
				icon.scale.y = FlxMath.lerp(icon.scale.y, 1.30, 0.45);
			}
		}
		if (game.curBeat >= 15) {
			disableHUD();
		}
	}
}

function disableHUD() {
	if (hudToggle) {
		hudToggle = false;
		FlxG.game.stage.window.title = "Friday Night Funkin': From the Top!";

		remove(watermark);
	}
}

/**
 * [i yoinked this right from kade tbh]
 * @return String
 */
function generateRanking():String {
	var ranking:String = "";

	// WIFE TIME :)))) (based on Wife3)

	if (game.songMisses == 0 && game.bads == 0 && game.shits == 0 && game.goods == 0) // Marvelous (SICK) Full Combo
		ranking = "(MFC)";
	else if (game.songMisses == 0 && game.bads == 0 && game.shits == 0 && game.goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
		ranking = "(GFC)";
	else if (game.songMisses == 0) // Regular FC
		ranking = "(FC)";
	else if (game.songMisses < 10) // Single Digit Combo Breaks
		ranking = "(SDCB)";
	else
		ranking = "(Clear)";

	var wifeConditions:Array<Bool> = [
		CoolUtil.floorDecimal(game.ratingPercent * 100, 2) >= 99.9935, // AAAAA
		CoolUtil.floorDecimal(game.ratingPercent * 100, 2) >= 99.980, // AAAA:
		CoolUtil.floorDecimal(game.ratingPercent * 100, 2) >= 99.970, // AAAA.
		CoolUtil.floorDecimal(game.ratingPercent * 100, 2) >= 99.955, // AAAA
		CoolUtil.floorDecimal(game.ratingPercent * 100, 2) >= 99.90, // AAA:
		CoolUtil.floorDecimal(game.ratingPercent * 100, 2) >= 99.80, // AAA.
		CoolUtil.floorDecimal(game.ratingPercent * 100, 2) >= 99.70, // AAA
		CoolUtil.floorDecimal(game.ratingPercent * 100, 2) >= 99, // AA:
		CoolUtil.floorDecimal(game.ratingPercent * 100, 2) >= 96.50, // AA.
		CoolUtil.floorDecimal(game.ratingPercent * 100, 2) >= 93, // AA
		CoolUtil.floorDecimal(game.ratingPercent * 100, 2) >= 90, // A:
		CoolUtil.floorDecimal(game.ratingPercent * 100, 2) >= 85, // A.
		CoolUtil.floorDecimal(game.ratingPercent * 100, 2) >= 80, // A
		CoolUtil.floorDecimal(game.ratingPercent * 100, 2) >= 70, // B
		CoolUtil.floorDecimal(game.ratingPercent * 100, 2) >= 60, // C
		CoolUtil.floorDecimal(game.ratingPercent * 100, 2) < 60 // D
	];

	for (i in 0...wifeConditions.length) {
		var b = wifeConditions[i];
		if (b) {
			switch (i) {
				case 0:
					ranking += " AAAAA";
				case 1:
					ranking += " AAAA:";
				case 2:
					ranking += " AAAA.";
				case 3:
					ranking += " AAAA";
				case 4:
					ranking += " AAA:";
				case 5:
					ranking += " AAA.";
				case 6:
					ranking += " AAA";
				case 7:
					ranking += " AA:";
				case 8:
					ranking += " AA.";
				case 9:
					ranking += " AA";
				case 10:
					ranking += " A:";
				case 11:
					ranking += " A.";
				case 12:
					ranking += " A";
				case 13:
					ranking += " B";
				case 14:
					ranking += " C";
				case 15:
					ranking += " D";
			}
			break;
		}
	}

	if (CoolUtil.floorDecimal(game.ratingPercent * 100, 2) == 0)
		ranking = "N/A";

	return ranking;
}
function onDestroy() {
	FlxG.game.stage.window.title = "Friday Night Funkin': Psych Engine";
}