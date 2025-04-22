using flixel.util.FlxSpriteUtil;

var noteColors:Array<Dynamic> = [0xFFC24B99, 0xFF00FFFF, 0xFF12FA05, 0xFFF9393F];

var cirNum = 1;
function createCircle(dataNum:Int, char:String) {
	var radius = FlxG.random.int(50, 250);
	var thickness = 15;
	var diameter = radius * 2 + thickness;

	var cirSprite = new Circle(0,0,diameter,diameter,noteColors[dataNum]);
	if (char == 'dad') cirSprite.setPosition(FlxG.random.int(-450, 125), FlxG.random.int(0, 720));
	else if (char == 'bf') cirSprite.setPosition(FlxG.random.int(50, 550), FlxG.random.int(0, 720));

	cirSprite.cameras = [getVar('camBG')];
	cirSprite.scrollFactor.set(0.8, 0.8);

	insert(members.indexOf(game.getLuaObject("shadows")), cirSprite);


	FlxTween.num(1, 1.2, 1.1, { ease: FlxEase.expoOut },
		(r) -> {
			cirSprite.scale.set(r,r);
			// cirSprite.fill(FlxColor.TRANSPARENT);
			// cirSprite.drawCircle(diameter / 2, diameter / 2, r, FlxColor.TRANSPARENT, style);
		}
	);
	FlxTween.tween(cirSprite, {alpha: 0}, 0.50, {
		ease: FlxEase.quadIn,
		onComplete: function(_) {
			cirSprite.kill();
			game.remove(cirSprite, true);
		},
		startDelay: 0.25
		}
	);
}

function opponentNoteHit(note){
    if ((!note.isSustainNote) && ((curBeat >= 48 && curBeat < 80) || (curBeat >= 98 && curBeat < 128))) {
		createCircle(note.noteData, 'dad');
	}
}
function goodNoteHit(note){
    if ((!note.isSustainNote) && ((curBeat >= 48 && curBeat < 80) || (curBeat >= 98 && curBeat <= 128))) {
		createCircle(note.noteData, 'bf');
	}
}