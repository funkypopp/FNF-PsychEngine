--[[
	Player Global Script by SkyanUltra! :3c

	This script handles the large majority of the player characters actions in-game.

	This massively simplifies the usage and addition of new playable characters and skins because I don't have to fucking duplicate a thousand scripts!
	It also means any changes I make here will affect EVERYTHING, which is good so I don't have to, again, duplicate a thousand scripts!

	CREDIT ME YOU FUCKING NIMROD!!! if you dont... i will KILL YOU!!! GRAAAAAAHHH!!!
	GB Link: https://gamebanana.com/members/1729271
	Bluesky Link: https://bsky.app/profile/skyanultra.bsky.social
]]--

-- vv Enable this for various debug info! vv
local debugTeehee = false

-- Character List Variables (Add any valid characters here!)
local characterList = {
	{name = 'bf%-original', midDance = false, midAmpedDance = false, hasLipsync = true, anims = {'-sick', '-sick', '-good', '-bad', '-bad'}},
	{name = 'bf%-costume', midDance = false, midAmpedDance = true, hasLipsync = true, anims = {'-sick', '-sick', '-good', '-bad', '-bad'}},
	{name = 'bf%-streetwear', midDance = false, midAmpedDance = false, hasLipsync = true, anims = {'-sick', '-sick', '-good', '-bad', '-bad'}},
	{name = 'bf%-outing', midDance = false, midAmpedDance = false, hasLipsync = true, anims = {'-sick', '-sick', '-good', '-bad', '-bad'}},
	{name = 'bf%-holiday', midDance = false, midAmpedDance = false, hasLipsync = true, anims = {'-sick', '-sick', '-good', '-bad', '-bad'}},
	{name = 'bf%-shonen', midDance = false, midAmpedDance = false, hasLipsync = true, anims = {'-sick', '-sick', '-good', '-bad', '-bad'}},
	{name = 'bflucky%-ftt', midDance = false, midAmpedDance = false, hasLipsync = true, anims = {'-sick', '-sick', '-good', '-bad', '-bad'}},
	{name = 'spooky%-playable%-original', midDance = false, midAmpedDance = true, hasLipsync = true, anims = {'-sick', '-sick', '-good', '-bad', '-bad'}},
	{name = 'pico%-playable%-original', midDance = false, midAmpedDance = false, hasLipsync = true, anims = {'-sick', '-sick', '-good', '-bad', '-bad'}},
	{name = 'picoturned%-playable%-original', midDance = false, midAmpedDance = false, hasLipsync = false, anims = {'-good', '-good', '-good', '-bad', '-bad'}},
	{name = 'gf%-playable%-original', midDance = false, midAmpedDance = false, hasLipsync = true, anims = {'-sick', '-sick', '-good', '-bad', '-bad'}},
	{name = 'gf%-playable%-costume', midDance = false, midAmpedDance = false, hasLipsync = true, anims = {'-sick', '-sick', '-good', '-bad', '-bad'}},
	{name = 'gf%-playable%-streetwear', midDance = false, midAmpedDance = false, hasLipsync = true, anims = {'-sick', '-sick', '-good', '-bad', '-bad'}},
	{name = 'gf%-playable%-outing', midDance = false, midAmpedDance = false, hasLipsync = true, anims = {'-sick', '-sick', '-good', '-bad', '-bad'}},
	{name = 'gf%-playable%-holiday', midDance = false, midAmpedDance = false, hasLipsync = true, anims = {'-sick', '-sick', '-good', '-bad', '-bad'}},
}
local characterType = {
	{type = 'bf', tag = 'bf', noteAura = 'BF', auraOffset = {{-25, 200}, {-25, 200}, {-25, 200}, {-25, 200}}, pottyMouthOffsets = {{100, 410}, {100, 560}, {160, 350}, {210, 420}, 0.6}},
	{type = 'spooky', tag = 'spooky-playable', noteAura = 'spooky', auraOffset = {{-75, 200}, {-50, 200}, {-25, 150}, {25, 200}}},
	{type = 'pico', tag = 'pico-playable', noteAura = 'pico', auraOffset = {{-75, 200}, {-25, 250}, {-25, 150}, {0, 200}}, pottyMouthOffsets = {{90, 360}, {150, 540}, {160, 320}, {230, 400}, 0.6}},
	{type = 'gf', tag = 'gf-playable', noteAura = 'GF', auraOffset = {{-250, 200}, {-150, 200}, {-150, 200}, {-50, 200}}}
}

-- These are stages which are compatible with skins. If it doesn't detect one, then it will not switch the player's skins.

local skinCompatibleStages = {'0ftt%-base', '1ftt%-base', '2ftt%-base', '3ftt%-base', '4ftt%-base', '5ftt%-base', '5ftt%-holiday'}
local ftt2Stages = {'0ftt%-base', '1ftt%-base', '2ftt%-base', '3ftt%-base', '', '5ftt%-base', ''}
local ftt2 = false

local ampedSuffix = '-amped'

-- Dynamic Variables (DO NOT TOUCH!!)

local midDance = false
local midAmpedDance = false
local hasLipsync = false
local noteAura = 'BF'
local auraOffset = {{-25, 200}, {-25, 200}, {-25, 200}, {-25, 200}}
local pottyMouthOffsets = {{100, 410}, {100, 560}, {160, 350}, {210, 420}, 0.6}
local characterTag = 'bf'

local curCharacter = 1

local noteAnims = {
	{rating = 'normal', anims = {'singLEFT', 'singDOWN', 'singUP', 'singRIGHT'}},
	{rating = 'killer', anims = {'singLEFT-sick', 'singDOWN-sick', 'singUP-sick', 'singRIGHT-sick'}},
	{rating = 'sick', anims = {'singLEFT-sick', 'singDOWN-sick', 'singUP-sick', 'singRIGHT-sick'}},
	{rating = 'good', anims = {'singLEFT-good', 'singDOWN-good', 'singUP-good', 'singRIGHT-good'}},
	{rating = 'bad', anims = {'singLEFT-bad', 'singDOWN-bad', 'singUP-bad', 'singRIGHT-bad'}},
	{rating = 'shit', anims = {'singLEFT-bad', 'singDOWN-bad', 'singUP-bad', 'singRIGHT-bad'}},
}

local auraToggle = true
local auraJudgement = 'Sick'

local lastRating = 'good'
local lipSyncSuffix = 'a'

local noteAmount = 0
local hypeAmount = 0
local amountNeededForHype = 0

function reloadCurCharacter()
	for i = 1,#characterList do
		if boyfriendName:find(characterList[i].name) then
			curCharacter = i
			midDance = characterList[i].midDance
			midAmpedDance = characterList[i].midAmpedDance
			hasLipsync = characterList[i].hasLipsync

			noteAnims = {
				{rating = 'normal', anims = {'singLEFT', 'singDOWN', 'singUP', 'singRIGHT'}},
				{rating = 'killer', anims = {'singLEFT'..characterList[i].anims[1], 'singDOWN'..characterList[i].anims[1], 'singUP'..characterList[i].anims[1], 'singRIGHT'..characterList[i].anims[1]}},
				{rating = 'sick', anims = {'singLEFT'..characterList[i].anims[2], 'singDOWN'..characterList[i].anims[2], 'singUP'..characterList[i].anims[2], 'singRIGHT'..characterList[i].anims[2]}},
				{rating = 'good', anims = {'singLEFT'..characterList[i].anims[3], 'singDOWN'..characterList[i].anims[3], 'singUP'..characterList[i].anims[3], 'singRIGHT'..characterList[i].anims[3]}},
				{rating = 'bad', anims = {'singLEFT'..characterList[i].anims[4], 'singDOWN'..characterList[i].anims[4], 'singUP'..characterList[i].anims[4], 'singRIGHT'..characterList[i].anims[4]}},
				{rating = 'shit', anims = {'singLEFT'..characterList[i].anims[5], 'singDOWN'..characterList[i].anims[5], 'singUP'..characterList[i].anims[5], 'singRIGHT'..characterList[i].anims[5]}},
			}
		end
	end
	for i = 1,#characterType do
		if characterList[curCharacter].name:find(characterType[i].type) then
			characterName = characterType[i].type
			characterTag = characterType[i].tag
			noteAura = characterType[i].noteAura
			auraOffset = characterType[i].auraOffset
			pottyMouthOffsets = characterType[i].pottyMouthOffsets or pottyMouthOffsets
		end
	end
end

function onCreate()
	reloadCurCharacter()

	setPropertyFromClass('substates.PauseSubState', 'songName', 'fromTheStop-'..characterName);

	setPropertyFromClass('substates.GameOverSubstate', 'characterName', characterTag..'-dead');
	setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'gameOverDeath-'..characterName);
	setPropertyFromClass('substates.GameOverSubstate', 'loopSoundName', 'gameOverLoop-'..characterName);
	setPropertyFromClass('substates.GameOverSubstate', 'endSoundName', 'gameOverEnd-'..characterName);
end

function onCreatePost()
	if auraToggle then
		makeAnimatedLuaSprite('noteAura', 'noteaura/noteaura_'..noteAura, 0, 0)
		addAnimationByPrefix('noteAura', 'aura', 'aura')
		setProperty('noteAura.visible', false)
		addLuaSprite('noteAura', true)
	end
	makeAnimatedLuaSprite('bfPottyMouth', 'censor', defaultBoyfriendX, defaultBoyfriendY)
	addAnimationByPrefix('bfPottyMouth', 'idle', 'uh oh!', 24, true)
	setProperty('bfPottyMouth.visible', false)
	scaleObject('bfPottyMouth', pottyMouthOffsets[5], pottyMouthOffsets[5])
	addLuaSprite('bfPottyMouth', true)

	if boyfriendName ~= 'maniac' then
        skinUpdate('bf')
		skinUpdate('gf')
    end
end

function skinUpdate(f)
    -- Skin Changes
    for i = 1, (#skinCompatibleStages) do
        if string.find(week, skinCompatibleStages[i]) then
            selectedSkin = getModSetting(f..'Skin')

            if f == 'bf' then
                f = characterTag
            end

            if selectedSkin == 'Original (Week 1)' then selectedSkin = f..'-original'
            elseif selectedSkin == 'Costume (Week 2)' then selectedSkin = f..'-costume'
            elseif selectedSkin == 'Streetwear (Week 3)' then selectedSkin = f..'-streetwear'
            elseif selectedSkin == 'Outing (Week 4)' then selectedSkin = f..'-outing'
            elseif selectedSkin == 'Holiday (Week 5)' then selectedSkin = f..'-holiday'
			elseif selectedSkin == 'Shonen (Week 6)' then selectedSkin = f..'-shonen'
            else selectedSkin = 'Default' end
            if getModSetting('fnfFtt2Mode') and f == 'gf' then 
                if week:find(ftt2Stages[i]) and (songName ~= 'Monster (FTT)' and songName ~= 'Pico (FTT)') then
                    updateSongFiles('Player2')
                    ftt2 = true
                else
                    debugPrint('No unique vocals will be present for this song.', 'FF88AA')
                    debugPrint('This song is incompatible with FNF: FTT 2 Mode!', 'FF0000')
                end
            end
            if selectedSkin ~= 'Default' then
                if f ~= 'gf' then f = 'boyfriend' end
                if week:find('2ftt%-base') and checkFileExists('characters/'..selectedSkin..'-dark.json') then
                    selectedSkin = selectedSkin..'-dark'
                elseif week:find('4ftt%-base') and checkFileExists('characters/'..selectedSkin..'-car.json') then
                    selectedSkin = selectedSkin..'-car'
                end
                if f == 'gf' and week:find('0ftt%-base') then
                    triggerEvent('Change Character', 'dad', selectedSkin)
                    setProperty(f..'.visible', false)
                else
                    triggerEvent('Change Character', f, selectedSkin)
                end
            end
        end
    end
end

function updateSongFiles(postfix)
    callOnHScript('updateSongFiles', {postfix})
end

-- danceMid Code
function onCountdownTick(c)
	if midDance then
		countdownTimer = 30/bpm
		countdownC = c
		happenedBefore = false
		animPlaying = getProperty('boyfriend.atlas.anim.curSymbol.name')
	end
end

function onStepHit()
	if (curStep + 2) % 4 == 0 then
		if midDance then
		-- Checks if the current step is inbetween a beat
			-- Check the name of the current animation playing; if it's a danceLeft or danceRight, then play a danceMid animation!
			if animPlaying == 'danceLeft' or animPlaying == 'danceRight' then
				playAnim('boyfriend', 'danceMid', true)
			end
		end
		if midAmpedDance then
		-- Checks if the current step is inbetween a beat
			-- Check the name of the current animation playing; if it's a danceLeft or danceRight, then play a danceMid animation!
			if animPlaying == 'danceLeft'..ampedSuffix or animPlaying == 'danceRight'..ampedSuffix then
				playAnim('boyfriend', 'danceMid'..ampedSuffix, true)
			end
		end
	end
end

function onSongStart()
	-- This essentially calculates the total amount of notes in the chart on the player's side...
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'mustPress') and not getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
			noteAmount = noteAmount + 1
		end
	end
	-- ... Then takes it all, divides it by 50, and rounds it down just to have it multiplied by 10 again.
	amountNeededForHype = math.floor((noteAmount / 50))*10
	-- Boom! Now its dynamic and adjusts to the chart's difficulty.
	if debugTeehee then debugPrint("Notes on Player Side: "..noteAmount.." | Amount Needed for Hype: "..amountNeededForHype) end
end

function onEndSong()
	if not isAchievementUnlocked('miscFtt_fnfFtt2') and ftt2 then
        addAchievementScore('miscFtt_fnfFtt2', 1, true)
        if isAchievementUnlocked('miscFtt_fnfFtt2') then
            achievementObtained = true
        end
    end
end

function goodNoteHit(id, dir, noteType, isSustainNote)
	-- This needs to be updated because Psych just kind of doesn't check the note type again after it changes?? Really weird shit.
	local noteType = getProperty('notes.members['..id..'].noteType')
	-- This increments a hidden value when non-sustain notes are hit that is for the combo and stores the last rating. (Done this way because its easier, LOL)
	if not isSustainNote then
		hypeAmount = hypeAmount + 1
		lastRating = getPropertyFromGroup('notes', id, 'rating')
	end
	-- Animations to play! Yes!
	if noteType ~= 'No Animation' then
		if hasLipsync then
			if noteType ~= 'a' and noteType ~= 'e' and noteType ~= 'o' and noteType ~= 'beatbox' then
				lipSyncSuffix = 'a'
			else
				lipSyncSuffix = noteType 
			end
		else
			lipSyncSuffix = ''
		end
		if noteType == 'beatbox' then
			playAnim('boyfriend', noteAnims[1].anims[dir+1]..'-beatbox', 'true')
		else
			for i = 1,#noteAnims do
				if lastRating == noteAnims[i].rating then
					playAnim('boyfriend', noteAnims[i].anims[dir+1]..lipSyncSuffix, 'true')
				end
			end
		end
		if not isSustainNote and (lastRating == 'killer' or (lastRating == 'sick' and auraJudgement == 'Sick')) then
			callNoteAura(dir+1)
		end
		if curStage == 'spooky [ftt]' then
			setObjectOrder('bfPottyMouth', getObjectOrder('bfLightning')+1)
		else
			setObjectOrder('bfPottyMouth', getObjectOrder('boyfriendGroup')+1)
		end
		-- ... And finally, the trigger for the amped up idle on combos.
		if hypeAmount >= amountNeededForHype and getProperty('boyfriend.idleSuffix') ~= ampedSuffix and (callMethod('boyfriend.hasAnimation', {'idle'..ampedSuffix}) or callMethod('boyfriend.hasAnimation', {'danceLeft'..ampedSuffix})) then
			triggerEvent('Alt Idle Animation', 'BF', ampedSuffix)
		end
	end
	
	if debugTeehee and not isSustainNote then debugPrint("Rating: "..lastRating.." ("..noteType..") | Hype: "..hypeAmount.."/"..amountNeededForHype) end
end

function noteMiss(id, direction, noteType, isSustainNote)
	-- Special animation for when you break a combo while amped! (And obviously also resets combo counter and the idle)
	if getProperty('boyfriend.idleSuffix') == ampedSuffix then
		triggerEvent('Alt Idle Animation', 'BF', '')
	end
	if hypeAmount >= amountNeededForHype then
		if debugTeehee then debugPrint("C-C-C-C-COMBO BREAKER!! | New Hype: "..hypeAmount.." -> "..hypeAmount / (misses + 1)) end
	elseif debugTeehee then debugPrint("you dumb fuck. | New Hype: "..hypeAmount.." -> "..hypeAmount / (misses + 1)) end
	hypeAmount = hypeAmount / (misses + 1)
    hypeAmount = math.floor(hypeAmount) 
end

function onUpdatePost()
	animPlaying = getProperty('boyfriend.atlas.anim.curSymbol.name') -- axor i freaking love you man
	if lastAnim ~= animPlaying then
		lastAnim = animPlaying
		local possibleDirs = {'left', 'down', 'up', 'right'}
		for i = 1,#possibleDirs do
			if animPlaying:find(possibleDirs[i]) then
				setProperty('bfPottyMouth.x', defaultBoyfriendX + pottyMouthOffsets[i][1])
				setProperty('bfPottyMouth.y', defaultBoyfriendY + pottyMouthOffsets[i][2])
			end
		end
	end
end

function onTimerCompleted(t)
	if t == 'noteAura' then
		setProperty('noteAura.visible', false)
	elseif t == 'reloadCurCharacter' then
		reloadCurCharacter()
	end
end

function callNoteAura(dirOffset)
	if auraToggle then
		playAnim('noteAura', 'aura', true)
		setProperty('noteAura.x', getProperty('boyfriend.x') - getProperty('boyfriend.positionArray[0]') + auraOffset[dirOffset][1])
		setProperty('noteAura.y', getProperty('boyfriend.y') - getProperty('boyfriend.positionArray[1]') + auraOffset[dirOffset][2])
		setScrollFactor('noteAura', getProperty('boyfriend.scrollFactor.x'), getProperty('boyfriend.scrollFactor.y'))
		setProperty('noteAura.color', getProperty('boyfriend.color'))
		setProperty('noteAura.visible', true)
		if curStage == 'spooky [ftt]' then
			setObjectOrder('noteAura', getObjectOrder('bfLightning')+2) -- edging my case rn
		else
			setObjectOrder('noteAura', getObjectOrder('boyfriendGroup')+2)
		end
		cancelTimer('noteAura')
		runTimer('noteAura', 0.33)
	end
end

function onEvent(n, v1, v2)
	if n == 'Change Character' and (v1:find('bf') or v1:find('boyfriend')) then
		runTimer('reloadCurCharacter', 0.0001)
	elseif n == 'Hey!' and not (v1:find('gf') or v1:find('GF')) then
		callNoteAura(3)
	end
end