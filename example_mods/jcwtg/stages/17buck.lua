function onCreate() 
	setProperty('skipCountdown',true)
	setProperty('camGame.bgColor', getColorFromHex('FFFFFF'))

	makeLuaSprite('skyan', 'characters/Skyan_bucks',150,0)
	setScrollFactor('skyan',0.95,0.95)
	addLuaSprite('skyan',false)
end

function onCreatePost()
    setProperty('scoreTxt.visible',false)
    setProperty('botplayTxt.visible',false)
    setProperty('timeBar.visible',false)
	setProperty('gf.visible',false)
end

function onEndSong()
		saveFile('mirrorman/weeks/weekwro.json',
[[{
	"songs": [
		[
			"mirror-man",
			"mirrorman",
			[
				215,
				20,
				0
			]
		]
	],
	"hiddenUntilUnlocked": false,
	"hideFreeplay": false,
	"weekBackground": "stage",
	"difficulties": "normal",
	"weekCharacters": [
		"dad",
		"bf",
		"gf"
	],
	"storyName": "Your New Week",
	"weekName": "Custom Week",
	"freeplayColor": [
		146,
		113,
		253
	],
	"hideStoryMode": true,
	"weekBefore": "tutorial",
	"startUnlocked": true
	}]])
		end