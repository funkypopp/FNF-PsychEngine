import psychlua.LuaUtils;
import states.PlayState;
import shaders.RGBPalette;
import shaders.RGBPalette.RGBShaderReference;
import backend.ClientPrefs;

var whateverShader:RGBShaderReference;
var whateverGroup:FlxTypedGroup<FlxSprite>;
var wienerButt:Bool = false;

function onCreatePost() {
    add(whateverGroup);
}

function spawnStupid() {
    var whatever = new FlxSprite(0, 0).loadGraphic(Paths.image("stuff/thingrounddascreen"));
    whatever.scale.set(0.7, 0.7);
    whatever.alpha = 0.8;
    whatever.cameras = [camHUD];
    whatever.screenCenter();
    add(whatever);
    whateverShader = new RGBShaderReference(whatever, new RGBPalette());
    wienerButt = true;
    trace('fuck');
    FlxTween.tween(whatever, {alpha: 0}, 0.5, {ease: FlxEase.cubeInOut, onComplete: function() {
        whatever.kill();
        wienerButt = false;
    }});
}

function goodNoteHit(note) {
    if (!game.curSong == 'Pixel Galaxy') {
        if (!note.isSustainNote) {
            spawnStupid();
        } 
        var arr:Array<FlxColor> = ClientPrefs.data.arrowRGB[note.noteData];
        switch (Math.abs(note.noteData)) {
            case 0: whateverShader.set_r(arr[0]);
            case 1: whateverShader.set_r(arr[0]);
            case 2: whateverShader.set_r(arr[0]);
            case 3: whateverShader.set_r(arr[0]);
        }
    }
    else if(game.curSong == 'Pixel Galaxy' && curBeat >= 32) {
        if (!note.isSustainNote) {
            spawnStupid();
        } 
        var arr:Array<FlxColor> = ClientPrefs.data.arrowRGB[note.noteData];
        switch (Math.abs(note.noteData)) {
            case 0: whateverShader.set_r(arr[0]);
            case 1: whateverShader.set_r(arr[0]);
            case 2: whateverShader.set_r(arr[0]);
            case 3: whateverShader.set_r(arr[0]);
        }  
    }

}