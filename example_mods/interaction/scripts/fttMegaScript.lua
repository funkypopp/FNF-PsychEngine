--[[

FTT Mega Script by SkyanUltra! :3c

    This is a massive fucking script built specifically for FTT and a few of its major features. This is probably my greatest work programming wise.
    As great as I think it is, there's definitely room for improvement. But that's the cool thing about being a programmer!

    Contains:
        - Skin Selection Code
        - Sound Handling Code
        - Results Screen with Saving Data
        - "Killer!!" and "Miss..." Judgement (with a recreation of the judgement pop-ups for the miss in specific)
        - KFC, SFC, and GFC Judgement Skins for Judgements
        - Achievement Handling Code

    Please ask me for credit before using this script or a modified version of it in your mod! I don't care that much, but its a bit annoying to
    see your code being used without any sort of credit given.
    
    GB Link: https://gamebanana.com/members/1729271
    Bluesky Link: https://bsky.app/profile/skyanultra.bsky.social

Special thanks to the coders of Funk Mix Advance for their saving code, which I used to learn how Psych's LUA saving functions works.
Special thanks to Pumpsuki on the Psych Engine discord for their millisecond accuracy LUA script, which I used as a framework for the millisecond accuracy calculation.

]]--

local fttVersion = '5.1.1'
-- DON'T FORGET TO UPDATE THIS NUMBER FOR NEW VERSIONS!

local compatibleCharacters = {'bf', 'gf', 'pico'}
local incompatibleCharacters = {'maniac', 'bfsit'}
local minimalResultsScreen = true
-- These are characters which are compatible with the results screen. If it doesn't detect one, it will use a simpler version.

local achievementObtained = false

local ratingArray = {
    {value = 0, name = 'F', poof = 'Shit', result = 'bad'},
    {value = 0.6, name = 'D', poof = 'Shit', result = 'bad'},
    {value = 0.7, name = 'C', poof = 'Standard', result = 'bad'},
    {value = 0.8, name = 'B', poof = 'Standard', result = 'good'},
    {value = 0.9, name = 'A', poof = 'Star', result = 'good'},
    {value = 0.95, name = 'S', poof = 'Star', result = 'good'},
}

local judgementArray = {
    {name = 'killer', offset = -5, hit = 0},
    {name = 'sick', offset = -5, hit = 0},
    {name = 'good', offset = 0, hit = 0},
    {name = 'bad', offset = -10, hit = 0},
    {name = 'shit', offset = -10, hit = 0},
}

local extraJudgementArray = {
    {name = 'stylish', offset = 0, hit = 0},
    {name = 'dodged', offset = -5, hit = 0},
    {name = 'hit', offset = -5, hit = 0},
}

local creditsList = {
    {song = 'Interaction', style = 'Cassette', art = 'debug'}
}

local songPlaylist = {}
local allowStoryResults = true

local showExtraJudgements = false
local stylishMax = 0

local killerHitWindow = 22
local originalComboOffset = getPropertyFromClass('backend.ClientPrefs', 'data.comboOffset')
local keybinds = getPropertyFromClass('backend.ClientPrefs', 'keyBinds')
local creditsStyle = 'Default'

local playstate = 'PlayState'
local currentMode = isStoryMode and 'Story Mode' or 'Freeplay'
local allowCountdown = false
local allowEnd = false
local allowAchievementsPause = false

local finalRank = 'S'
local finalResult = 'bad'
local finalPoof = 'Star'
local finalComboRating = 'KFC'
local ivePlayedTheseGamesBefore = false
local newBest = false

local ratingNumber = 0
local noteAmount = 0
local bestCombo = 0
local judgement = 0
local ratingFCID = 0

local msInfo = {
    ms = 0,
    msTimings = {},
    msAcc = 0,
}

local devIntendedValid = true

precacheImage('miss')

for i = 1,2 do
    if devIntendedValid then
        if (keybinds.note_left[i] == 37 and keybinds.note_down[i] == 40 and keybinds.note_up[i] == 38 and keybinds.note_right[i] == 39) or (keybinds.note_left[i] == nil and keybinds.note_down[i] == nil and keybinds.note_up[i] == nil and keybinds.note_right[i] == nil) then
            devIntendedValid = true
        else
            devIntendedValid = false
        end
    end
end

-- Utility Functions
function roundToDecimal(number, decimalPlaces)
    if number ~= 0 then
        local multiplier = 10 ^ decimalPlaces
        return math.floor(number * multiplier + 0.5) / multiplier
    else
        return 0
    end
end

function calculateMilliAccuracy()
    local devSum = 0
    local noteCount = #msInfo.msTimings
    for index, noteHitTime in ipairs(msInfo.msTimings) do devSum = devSum + math.abs(noteHitTime) end
    local averageDev = devSum / noteCount
    local latest_earliest_canHit = 166
    local factor = 1 - (averageDev / latest_earliest_canHit)
    local scaledAcc = factor * 100
    local msAcc = math.max(0, math.min(100, scaledAcc))
    return hits > 0 and roundToDecimal(msAcc, 2) or 0
end

function getIconColor(chr, valR, valG, valB)
    return rgbToHex(getProperty(chr .. ".healthColorArray"), valR, valG, valB)
end

function rgbToHex(array, valR, valG, valB)
    return string.format('%.2x%.2x%.2x', math.min(array[1]*valR,255), math.min(array[2]*valG,255), math.min(array[3]*valB,255))
end

function soundHandler(char, sound, volume)
    if volume == nil then volume = 0.7 end
    local folder = ''
    local special = false
    local soundNum = 0
    if char == 'dad' then
        char = dadName
    elseif char == 'gf' then
        char = gfName
    else
        char = boyfriendName
    end
    if char:find('bf')then
        char = 'bf'
    end

    if sound:find('attack') then
        folder = 'attack/'
    elseif sound:find('hurt') then
        folder = 'hurt/'
    elseif sound:find('lowHP') then
        folder = 'lowHP/'
    elseif sound:find('good') or sound:find('bad') then
        folder = 'results/'
    end
    if dadName:find('gf') then
        dadNamePost = 'gf'
    else
        dadNamePost = dadName
    end
    if (getRandomInt(1,2) == 2 or special) and (checkFileExists('sounds/sfx/'..folder..sound..'-'..char..'-'..dadNamePost..'.ogg') or checkFileExists('sounds/sfx/'..folder..sound..'1-'..char..'-'..dadNamePost..'.ogg')) then
        if checkFileExists('sounds/sfx/'..folder..sound..'-'..char..'-'..dadNamePost..'.ogg') then
            playSound('sfx/'..folder..sound..'-'..char..'-'..dadNamePost, volume)
        elseif checkFileExists('sounds/sfx/'..folder..sound..'1-'..char..'.ogg') then
            soundNum = 2
            while checkFileExists('sounds/sfx/'..folder..sound..soundNum..'-'..char..'-'..dadNamePost..'.ogg') do
                soundNum = soundNum + 1
            end
            playSound('sfx/'..folder..sound..getRandomInt(1,soundNum-1)..'-'..char..'-'..dadNamePost, volume)
        end
    elseif checkFileExists('sounds/sfx/'..folder..sound..'-'..char..'.ogg') then
        playSound('sfx/'..folder..sound..'-'..char, volume)
    elseif checkFileExists('sounds/sfx/'..folder..sound..'1-'..char..'.ogg') then
        soundNum = 2
        while checkFileExists('sounds/sfx/'..folder..sound..soundNum..'-'..char..'.ogg') do
            soundNum = soundNum + 1
        end
        playSound('sfx/'..folder..sound..getRandomInt(1,soundNum-1)..'-'..char, volume)
    end
end

runHaxeCode([[
	createGlobalCallback("fttSoundHandler", function(char:String, sound:String) {parentLua.call("soundHandler", [char, sound]);});
    createGlobalCallback("fttResultsScreen", function(fakeout:Bool) {parentLua.call("fttResultsScreen", [fakeout]);});
]])

function splitStringHyphen(input)
    local first_part, second_part = input:match("([^%-]+)%-(.+)")
    if first_part and second_part then
        return {first_part, second_part}
    else
        return input, nil  -- Return the original string if no hyphen is found
    end
end

function onEventPushed(n, v1, v2, eventTime)
    if n == 'Change Character Style' and v2 ~= '' then
        local precacheCharacter = ''
        if v1 == 'dad' then
            precacheCharacter = splitStringHyphen(dadName)
        elseif v1 == 'gf' then
            precacheCharacter = splitStringHyphen(gfName)
        else
            v1 = 'bf'
            precacheCharacter = splitStringHyphen(boyfriendName)
        end
        addCharacterToList(precacheCharacter[1]..v2..'-'..precacheCharacter[2], v1)
    end
end

-- Game Functions
function onCreate()
    initSavedSong()
    flushSaveData(savedSong)
    setVar('fakeoutPlayed', true)

    if downscroll then
        setPropertyFromClass('backend.ClientPrefs', 'data.comboOffset', {89, 152-540, 191, 204-380})
    else
        setPropertyFromClass('backend.ClientPrefs', 'data.comboOffset', {89, 152, 191, 204})
    end
end

function onCreatePost()
    changeDiscordClientID('1315898015583834173')

    getSongPlaylist()

    createInstance('killer', 'backend.Rating', {'killer'})
    setProperty('killer.hitWindow', killerHitWindow)
    setProperty('killer.score', 400)
    setProperty('killer.ratingMod', 1)
    callMethod('ratingsData.insert', {0, instanceArg('killer')})
    setProperty('ratingsData[1].ratingMod', 0.975)
    setProperty('ratingsData[2].ratingMod', 0.65)
    setProperty('ratingsData[3].ratingMod', 0.3)

    setProperty('ratingsData[0].image', 'killerKFC')
    setProperty('ratingsData[1].image', 'sickSFC')
    setProperty('ratingsData[2].image', 'goodGFC')

    for i = 1, (#compatibleCharacters) do
        if boyfriendName:find(compatibleCharacters[i]) then
            minimalResultsScreen = false
        end
    end

    for i = 1, (#incompatibleCharacters) do
        if boyfriendName == incompatibleCharacters[i] then
            minimalResultsScreen = true
        end
    end

    for i = 0, getProperty('unspawnNotes.length')-1 do
        if getPropertyFromGroup('unspawnNotes', i, 'mustPress') and not getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
            noteAmount = noteAmount + 1
        end
    end
end

function getSongPlaylist()
    if isStoryMode and not week:find('holiday') then
        songPlaylist = runHaxeCode([[
            import backend.WeekData;
            var songList:Array<String> = [];

            for (songData in WeekData.getCurrentWeek().songs)
                songList.push(songData[0]);
            return songList;
        ]])
        if getVar('fakeoutPlayed') == false then
            for i, v in ipairs(songPlaylist) do
                if v == songName then
                    -- Keep only elements up to and including `target`
                    for j = #songPlaylist, i + 1, -1 do
                        table.remove(songPlaylist)
                    end
                    break
                end
            end
            allowStoryResults = false
        end
    else
        songPlaylist = {songName}
    end
end

function goodNoteHit(id, dir, noteType, isSustainNote)
	if not (isSustainNote or botPlay) then
		noteRating = getPropertyFromGroup('notes', id, 'rating')
        for i = 1,#judgementArray do
            if noteRating == judgementArray[i].name then
                judgementArray[i].hit = judgementArray[i].hit + 1
            end
        end
        msInfo.ms = roundToDecimal((getPropertyFromGroup('notes', id, 'strumTime') - getSongPosition() + getPropertyFromClass('backend.ClientPrefs', 'data.ratingOffset')) / playbackRate, 3)
        table.insert(msInfo.msTimings, msInfo.ms)
        msInfo.msAcc = calculateMilliAccuracy()
    end

    for i = 1,#judgementArray do
        if misses <= 0 then
            if judgementArray[2].hit <= 0 and judgementArray[3].hit <= 0 and judgementArray[4].hit <= 0 and judgementArray[5].hit <= 0 then
                setRatingFC('KFC')
                setProperty('ratingsData[0].image', 'killerKFC')
                ratingFCID = 4
            elseif judgementArray[3].hit <= 0 and judgementArray[4].hit <= 0 and judgementArray[5].hit <= 0 then
                setRatingFC('SFC')
                setProperty('ratingsData[0].image', 'killerSFC')
                setProperty('ratingsData[1].image', 'sickSFC')
                ratingFCID = 3
            elseif judgementArray[4].hit <= 0 and judgementArray[5].hit <= 0 then
                setRatingFC('GFC')
                setProperty('ratingsData[0].image', 'killerGFC')
                setProperty('ratingsData[1].image', 'sickGFC')
                setProperty('ratingsData[2].image', 'goodGFC')
                ratingFCID = 2
            else
                setRatingFC('FC')
                ratingFCID = 1
            end
        elseif misses <= 10 then
            setRatingFC('SDCB')
            ratingFCID = 0
        else
            setRatingFC('Clear')
            ratingFCID = 0
        end
    end

    if ratingFC ~= 'KFC' and ratingFC ~= 'SFC' and ratingFC ~= 'GFC' then
        setProperty('ratingsData[0].image', 'killer')
        setProperty('ratingsData[1].image', 'sick')
        setProperty('ratingsData[2].image', 'good')
    end

    local ratingIndex = getProperty('comboGroup.length') - (getProperty('showCombo') and 2 or 1)
    if getProperty('showComboNum') then
        if combo >= 1000 then 
            ratingIndex = ratingIndex - 4
        else
            ratingIndex = ratingIndex - 3
        end
    end

    scaleObject('comboGroup.members['..ratingIndex..']', 0.5, 0.5)
    if noteRating == 'killer' then
        setProperty('comboGroup.members['..ratingIndex..'].offset.x', 170)
        if not isAchievementUnlocked('counterFtt_killerRatings') and not isSustainNote then
            addAchievementScore('counterFtt_killerRatings', 1, true)
        end
    elseif noteRating == 'sick' then
        setProperty('comboGroup.members['..ratingIndex..'].offset.x', 90)
    elseif noteRating == 'good' then
        setProperty('comboGroup.members['..ratingIndex..'].offset.x', 75)
    elseif noteRating == 'bad' then
        setProperty('comboGroup.members['..ratingIndex..'].offset.x', 40)
    elseif noteRating == 'shit' then
        setProperty('comboGroup.members['..ratingIndex..'].offset.x', 30)
    end
    if getProperty('showComboNum') then
        ratingIndexBig = ratingIndex + (combo >= 1000 and 4 or 3)
        for i = ratingIndex+1,ratingIndexBig do
            scaleObject('comboGroup.members['..i..']', 0.4, 0.4)
        end
    end

    if combo >= bestCombo then bestCombo = combo end
end

function noteMiss(id, direction, noteType, isSustainNote)
    setProperty('totalNotesHit', totalNotesHit - 1)
    if not isSustainNote then
        customRatingPopup('miss', 30)
    end
end

function onEndSong()
    if not allowEnd and getVar('fakeoutPlayed') == true and ((songName == songPlaylist[#songPlaylist] and allowStoryResults) or not isStoryMode) then
        fttResultsScreen(false)
        return Function_Stop
    end
    if (not botPlay and not practice) then
        fttSaveData()
        achievementHandler()
    end
    if achievementObtained and allowStoryResults and (songName ~= songPlaylist[#songPlaylist] and isStoryMode) then
        playAnim('boyfriend', 'hey', true)
        playAnim('gf', 'cheer', true)
        runTimer('endSong', 2)
        ncskyan_toggle_natural_bump(false)
        achievementObtained = false
        return Function_Stop
    end
    return Function_Continue
end

function onDestroy()
    flushSaveData(savedSong)
    setPropertyFromClass('backend.ClientPrefs', 'data.comboOffset', originalComboOffset)
end

function onUpdate()
    if playstate == 'ResultState' and not minimalResultsScreen then
        bfframe = getProperty('boyfriend.atlas.anim.curSymbol.name')
        if not string.find(bfframe, "results") then
            playAnim('boyfriend', 'results-'..finalResult, true)
        end
        if getProperty('gf.visible') then
            gfframe = getProperty('gf.atlas.anim.curSymbol.name')
            if not string.find(gfframe, gfAnim) then
                playAnim('gf', gfAnim, true)
            end
        end
    end

    if playstate == 'MidResultState' and keyJustPressed('accept') then
        playstate = 'ResultState'
        cancelTimer('boom1')
        cancelTimer('boom2')
        cancelTimer('boom3')
        cancelTimer('boom-'..finalResult)
        cancelTimer('minimalShuffle')
        cancelTimer('resultIntro')
        cancelTimer('resultPost')
        cancelTimer('resultPost2')

        stopSound('resultsIntro')
        stopSound('resultsSFX')
        stopSound('drumroll')

        cancelTween('rankScale')

        addLuaText('score', true)
        addLuaText('scoreVal', true)
        addLuaText('accuracy', true)
        addLuaText('accuracyVal', true)
        addLuaText('misses', true)
        addLuaText('missesVal', true)

        startTween('scoreScale', 'score.scale', {x = 0.75, y = 0.75}, 0.5, {ease = 'circOut'})
        doTweenColor('scoreColor', 'score', 'ffffff', 0.5, 'circOut')
        startTween('scoreValScale', 'scoreVal.scale', {x = 0.75, y = 0.75}, 0.5, {ease = 'circOut'})
        doTweenColor('scoreValColor', 'scoreVal', 'ffffff', 0.5, 'circOut')
        startTween('accuracyScale', 'accuracy.scale', {x = 0.75, y = 0.75}, 0.5, {ease = 'circOut'})
        doTweenColor('accuracyColor', 'accuracy', 'ffffff', 0.5, 'circOut')
        startTween('accuracyValScale', 'accuracyVal.scale', {x = 0.75, y = 0.75}, 0.5, {ease = 'circOut'})
        doTweenColor('accuracyValColor', 'accuracyVal', 'ffffff', 0.5, 'circOut')
        startTween('missesScale', 'misses.scale', {x = 0.75, y = 0.75}, 0.5, {ease = 'circOut'})
        doTweenColor('missesColor', 'misses', 'ffffff', 0.5, 'circOut')
        startTween('missesValScale', 'missesVal.scale', {x = 0.75, y = 0.75}, 0.5, {ease = 'circOut'})
        doTweenColor('missesValColor', 'missesVal', 'ffffff', 0.5, 'circOut')

        if not minimalResultsScreen then
            runTimer('boom-'..finalResult, 0.0001)
            runTimer('resultIntro', 0.5)
            runTimer('resultPost', 1.5)
            runTimer('resultPost2', 4.5)
        else
            runTimer('resultIntro', 0.0001)
            runTimer('resultPost', 1)
            runTimer('resultPost2', 4)
        end
    elseif playstate == 'ResultState' and not allowEnd and keyJustPressed('accept') then
        allowEnd = true
        endSong()
    end
end

function onUpdatePost()
    discordRPCStatus()
end

function discordRPCStatus()
    changeDiscordClientID('1315898015583834173')
    if playstate == 'PlayState' then
        changeDiscordPresence(currentMode, songName..' ('..difficultyName..')', dadName, false, 0)
    elseif playstate == 'MidResultState' or playstate == 'FakeResultState' then
        changeDiscordPresence('Waiting for Results...', songName..' ('..difficultyName..')')
    elseif playstate == 'ResultState' then
        local lowerRank = finalRank.lower(finalRank)
        changeDiscordPresence('Results Screen', songName..' ('..difficultyName..')', lowerRank, false, 0, finalResult..'win')
    end
end

function fttResultsScreen(fakeout)
    if fakeout then
        playstate = 'FakeResultState'
    else
        playstate = 'MidResultState'
    end
    getSongPlaylist()
    playerMid()
    
    nc_lock(false, false)
    skyan_realCinema('false', '')
    ncskyan_toggle_natural_bump(false)
    doTweenAlpha('camHUD', 'camHUD', 0, 1, 'sineOut')

    if totalNotesHit < 0 then
        setProperty('totalNotesHit', 0)
    end

    if not minimalResultsScreen then
        nc_reloadTargets()
        local camOffset = boyfriendName:match("^(.*)-")
        if camOffset:find('gf%-playable') then
            camOffset = {0, 30}
        else
            camOffset = {0, 0}
        end
        nc_set_target('plr', bfMidX+camOffset[1], bfMidY+camOffset[2])
        nc_focus('plr', 3, 'circOut', true)
        nc_zoom('g', 0.8, 5, 'sineInOut')
    end

    getResults()
    songSpecificEvents('resultStart')

    if not minimalResultsScreen then
        playSound('resultsIntro', 1, 'resultsIntro')

        makeLuaSprite('resultsBg', '', bfMidX-3250, bfMidY-2000)
        makeGraphic('resultsBg', 6500, 4000, '000000')
        setProperty('resultsBg.camera', instanceArg('camGame'), false, true)
        setProperty('resultsBg.alpha', 0)
        setObjectOrder('resultsBg', getObjectOrder('gfGroup'))
        setScrollFactor('resultsBg', 0, 0)
        doTweenAlpha('resultsBgTween', 'resultsBg', 0.5, 4, 'linear')
        addLuaSprite('resultsBg')

        if fakeout then
            runTimer('bfAnim', 0.125)
            runTimer('boom1', 6)
            runTimer('boom2', 6.5)
            runTimer('boom3', 7)
            runTimer('boom-fakeout', 7.5)
        else
            runTimer('bfAnim', 0.125)
            runTimer('boom1', 6)
            runTimer('boom2', 6.5)
            runTimer('boom3', 7)
            runTimer('boom-'..finalResult, 7.5)
            runTimer('resultIntro', 8)
            runTimer('resultPost', 9)
            runTimer('resultPost2', 13)
        end
    else
        screenCoolEffect()

        makeLuaSprite('resultsBg', '', 0, 0)
        makeGraphic('resultsBg', screenWidth, screenHeight, '000000')
        setProperty('resultsBg.camera', instanceArg('camOther'), false, true)
        setProperty('resultsBg.alpha', 0)
        setObjectOrder('resultsBg', -1000)
        doTweenAlpha('resultsBgTween', 'resultsBg', 0.5, 2, 'expoOut')
        addLuaSprite('resultsBg')

        runTimer('boom1', 1)
        runTimer('boom2', 1.5)
        runTimer('boom3', 2)
        runTimer('minimalShuffle', 2.5)
        runTimer('resultIntro', 4)
        runTimer('resultPost', 5)
        runTimer('resultPost2', 9)
    end
end

function getResults()
    -- Freeplay Rating Grab
    if not botPlay then
        for i = 1,#ratingArray do
            if rating >= ratingArray[i].value then
                finalRank = ratingArray[i].name
                finalResult = ratingArray[i].result
                finalPoof = ratingArray[i].poof
            end
        end
        finalComboRating = ratingFC
    else
        finalRank = 'S'
        finalResult = 'bad'
        finalPoof = 'Star'
        finalComboRating = 'KFC'
    end

    if getDataFromSave(savedSong, 'cleared', false) == true then
        ivePlayedTheseGamesBefore = true
    end

    fttSaveData()
    achievementHandler()

    local finalRankResults = getRank(songPlaylist, false)
    finalRank = finalRankResults[1]
    finalResult = finalRankResults[2]
    finalPoof = finalRankResults[3]
    finalComboRating = finalRankResults[4]

    if finalResult == 'good' then
        winState = 'win0'
        gfAnim = 'cheer'
    elseif finalResult == 'bad' then
        winState = 'winLOSE'
        gfAnim = 'sad'
    end
    
    for i = 0,1 do
        makeAnimatedLuaSprite('resultsCloud'..i, 'results/resultscloud', -300 + (975 * i), -400 + (1100 * i))
        addAnimationByPrefix('resultsCloud'..i, 'idle', 'resultscloud', 24, true)
        setProperty('resultsCloud'..i..'.camera', instanceArg('camOther'), false, true)
        setProperty ('resultsCloud'..i..'.angle', 180 - (i*180))
        addLuaSprite('resultsCloud'..i)
    end

    if ivePlayedTheseGamesBefore then
        makeLuaSprite('pb', 'results/PB', 10, -200)
        setProperty('pb.camera', instanceArg('camOther'), false, true)
        scaleObject('pb', 0.667, 0.667)
        addLuaSprite('pb')

        local pbRankVar = getRank(songPlaylist, true)
        pbRankVar = pbRankVar[1]
        makeLuaSprite('pbRank', 'results/rankicon'..pbRankVar, 150, -200)
        setProperty('pbRank.camera', instanceArg('camOther'), false, true)
        scaleObject('pbRank', 0.667, 0.667)
        addLuaSprite('pbRank')

        makeLuaText('pbScore', 'Score: ', 0, 25, 90)
        setProperty('pbScore.camera', instanceArg('camOther'), false, true)
        setTextFont('pbScore', 'phantomMuff.ttf')
        setTextColor('pbScore', 'bbffff')
        setTextSize('pbScore', 16)
        setTextAlignment('pbScore', 'left')

        makeLuaText('pbScoreVal', getDataFromPlaylist(songPlaylist, 'scoreBest', 0, 'total'), 175, 25, 90)
        setProperty('pbScoreVal.camera', instanceArg('camOther'), false, true)
        setTextFont('pbScoreVal', 'phantomMuff.ttf')
        setTextColor('pbScoreVal', 'bbffff')
        setTextSize('pbScoreVal', 16)
        setTextAlignment('pbScoreVal', 'right')

        makeLuaText('pbAccuracy', 'Accuracy: ', 0, 25, 110)
        setProperty('pbAccuracy.camera', instanceArg('camOther'), false, true)
        setTextFont('pbAccuracy', 'phantomMuff.ttf')
        setTextColor('pbAccuracy', 'bbffff')
        setTextSize('pbAccuracy', 16)
        setTextAlignment('pbAccuracy', 'left')

        makeLuaText('pbAccuracyVal', getDataFromPlaylist(songPlaylist, 'accuracyBest', 0, 'average')..'%', 175, 25, 110)
        setProperty('pbAccuracyVal.camera', instanceArg('camOther'), false, true)
        setTextFont('pbAccuracyVal', 'phantomMuff.ttf')
        setTextColor('pbAccuracyVal', 'bbffff')
        setTextSize('pbAccuracyVal', 16)
        setTextAlignment('pbAccuracyVal', 'right')

        makeLuaText('pbMisses', 'Misses: ', 0, 25, 130)
        setProperty('pbMisses.camera', instanceArg('camOther'), false, true)
        setTextFont('pbMisses', 'phantomMuff.ttf')
        setTextColor('pbMisses', 'bbffff')
        setTextSize('pbMisses', 16)
        setTextAlignment('pbMisses', 'left')

        makeLuaText('pbMissesVal', getDataFromPlaylist(songPlaylist, 'missesBest', 0, 'total'), 175, 25, 130)
        setProperty('pbMissesVal.camera', instanceArg('camOther'), false, true)
        setTextFont('pbMissesVal', 'phantomMuff.ttf')
        setTextColor('pbMissesVal', 'bbffff')
        setTextSize('pbMissesVal', 16)
        setTextAlignment('pbMissesVal', 'right')
    end

    makeAnimatedLuaSprite('win', 'results/win', 475, -250)
    addAnimationByPrefix('win', 'win', winState, 24, true)
    setProperty('win.camera', instanceArg('camOther'), false, true)
    scaleObject('win', 0.7, 0.7)
    setProperty('win.visible', false)
    addLuaSprite('win')

    makeAnimatedLuaSprite('poof', 'results/poof'..finalPoof, 810, 90)
    addAnimationByPrefix('poof', 'poof', 'poof', 24, false)
    setProperty('poof.camera', instanceArg('camOther'), false, true)
    setProperty('poof.visible', false)
    addLuaSprite('poof')

    makeAnimatedLuaSprite('rank', 'results/ranks', 990, 110)
    addAnimationByPrefix('rank', 'rank', 'rank_'..finalRank, 24, true)
    addAnimationByPrefix('rank', 'shuffle', 'cycle', 24, true)
    addOffset('rank', 'rank', 0, 0)
    addOffset('rank', 'shuffle', 0, 0)
    setProperty('rank.camera', instanceArg('camOther'), false, true)
    setProperty('rank.visible', false)
    scaleObject('rank', 0.85, 0.85)
    setProperty('rank.origin.x', getGraphicMidpointX(getProperty('rank')))
    setProperty('rank.origin.y', getGraphicMidpointY(getProperty('rank')))
    addLuaSprite('rank')

    if newBest then
        local newBestOffset = {0, 0.2}
        if ivePlayedTheseGamesBefore then newBestOffset = {190, 0} end
        makeAnimatedLuaSprite('newBest', 'results/newbest', 10+newBestOffset[1], 10)
        scaleObject('newBest', 0.7 + newBestOffset[2], 0.7 + newBestOffset[2])
        addAnimationByPrefix('newBest', 'intro', 'intro', 24, false)
        addAnimationByPrefix('newBest', 'idle', 'idle', 24, true)
        addOffset('newBest', 'intro', 0, 4)
        addOffset('newBest', 'idle', 0, 0)
        setProperty('newBest.camera', instanceArg('camOther'), false, true)
    end

    if checkFileExists('images/results/stamp'..finalComboRating..'.png') then
        makeLuaSprite('stamp', 'results/stamp'..finalComboRating, 0, 0)
        setProperty('stamp.camera', instanceArg('camOther'), false, true)
        scaleObject('stamp', 0.667, 0.667)
        screenCenter('stamp', 'xy')
        setProperty('stamp.x', getProperty('stamp.x') + 375)
        setProperty('stamp.y', getProperty('stamp.y') + 225)
        setProperty('stamp.visible', false)
        addLuaSprite('stamp')

        if string.len(finalComboRating) == 3 then
            makeAnimatedLuaSprite('stampStars', 'results/stampStars', 0, 0)
            setProperty('stampStars.camera', instanceArg('camOther'), false, true)
            addAnimationByPrefix('stampStars', 'stars', 'stars'..finalComboRating, 24, true)
            playAnim('stampStars', 'stars', true)
            scaleObject('stampStars', 0.667, 0.667)
            screenCenter('stampStars', 'xy')
            setProperty('stampStars.x', getProperty('stampStars.x') + 375)
            setProperty('stampStars.y', getProperty('stampStars.y') + 225)
            setProperty('stampStars.alpha', 0)
            addLuaSprite('stampStars')
        end

        makeAnimatedLuaSprite('stampHand', 'results/stamphand', 745, 435)
        scaleObject('stampHand', 0.7, 0.7)
        addAnimationByPrefix('stampHand', 'stamp', 'stamp', 24, false)
        setProperty('stampHand.camera', instanceArg('camOther'), false, true)
        setProperty('stampHand.visible', false)
        addLuaSprite('stampHand')
    end

    if isStoryMode and #songPlaylist > 1 then
        songNameFinal = 'Week '..week:sub(1, 1)
    else
        if string.find(songName, '(FTT)') then
            songNameFinal = songName:sub(1, string.len(songName)-5)
        else
            songNameFinal = songName
        end
    end
    makeLuaText('songName', songNameFinal, 0, -800, 240)
    setProperty('songName.camera', instanceArg('camOther'), false, true)
    setTextFont('songName', 'tardlingFilled.ttf')
    setTextColor('songName', getIconColor('dad', 1, 1, 1))
    setTextBorder('songName', 5, getIconColor('dad', 0.2, 0.2, 0.2))
    setTextSize('songName', 50)
    setTextAlignment('songName', 'left')

    if not botPlay then
        makeLuaText('difficulty', '('..difficultyName..')', 0, 55, 275)
    else
        makeLuaText('difficulty', '('..difficultyName..', Botplay)', 0, 55, 275)
    end
    setProperty('difficulty.camera', instanceArg('camOther'), false, true)
    setTextFont('difficulty', 'phantomMuff.ttf')
    setTextColor('difficulty', '99aabb')
    setTextSize('difficulty', 20)
    setTextAlignment('difficulty', 'left')
    setProperty('difficulty.alpha', 0)

    makeLuaText('score', 'Score: ', 0, 50, 300)
    setProperty('score.camera', instanceArg('camOther'), false, true)
    setTextFont('score', 'phantomMuff.ttf')
    setTextColor('score', 'ffff00')
    setTextSize('score', 40)
    setTextAlignment('score', 'left')

    makeLuaText('scoreVal', getDataFromPlaylist(songPlaylist, 'score', 0, 'total'), 350, 150, 300)
    setProperty('scoreVal.camera', instanceArg('camOther'), false, true)
    setTextFont('scoreVal', 'phantomMuff.ttf')
    setTextColor('scoreVal', 'ffff00')
    setTextSize('scoreVal', 40)
    setTextAlignment('scoreVal', 'right')

    makeLuaText('accuracy', 'Accuracy: ', 0, 40, 340)
    setProperty('accuracy.camera', instanceArg('camOther'), false, true)
    setTextFont('accuracy', 'phantomMuff.ttf')
    setTextColor('accuracy', 'ffff00')
    setTextSize('accuracy', 40)
    setTextAlignment('accuracy', 'left')

    makeLuaText('accuracyVal', getDataFromPlaylist(songPlaylist, 'accuracy', 0, 'average')..'%', 355, 147, 340)
    setProperty('accuracyVal.camera', instanceArg('camOther'), false, true)
    setTextFont('accuracyVal', 'phantomMuff.ttf')
    setTextColor('accuracyVal', 'ffff00')
    setTextSize('accuracyVal', 40)
    setTextAlignment('accuracyVal', 'right')

    makeLuaText('misses', 'Misses: ', 0, 50, 380)
    setProperty('misses.camera', instanceArg('camOther'), false, true)
    setTextFont('misses', 'phantomMuff.ttf')
    setTextColor('misses', 'ffff00')
    setTextSize('misses', 40)
    setTextAlignment('misses', 'left')

    makeLuaText('missesVal', getDataFromPlaylist(songPlaylist, 'misses', 0, 'total'), 350, 150, 380)
    setProperty('missesVal.camera', instanceArg('camOther'), false, true)
    setTextFont('missesVal', 'phantomMuff.ttf')
    setTextColor('missesVal', 'ffff00')
    setTextSize('missesVal', 40)
    setTextAlignment('missesVal', 'right')

    makeLuaText('bestCombo', 'Best Combo: ', 0, 70, 430)
    setProperty('bestCombo.camera', instanceArg('camOther'), false, true)
    setTextFont('bestCombo', 'phantomMuff.ttf')
    setTextColor('bestCombo', '99aabb')
    setTextSize('bestCombo', 20)
    setTextAlignment('bestCombo', 'left')

    makeLuaText('bestComboVal', getDataFromPlaylist(songPlaylist, 'combo', 0, 'total')..' / '..getDataFromPlaylist(songPlaylist, 'comboMax', 0, 'total'), 385, 70, 430)
    setProperty('bestComboVal.camera', instanceArg('camOther'), false, true)
    setTextFont('bestComboVal', 'phantomMuff.ttf')
    setTextColor('bestComboVal', '99aabb')
    setTextSize('bestComboVal', 20)
    setTextAlignment('bestComboVal', 'right')

    makeLuaText('accuracyMS', 'Accuracy (Milliseconds): ', 0, 70, 460)
    setProperty('accuracyMS.camera', instanceArg('camOther'), false, true)
    setTextFont('accuracyMS', 'phantomMuff.ttf')
    setTextColor('accuracyMS', '99aabb')
    setTextSize('accuracyMS', 20)
    setTextAlignment('accuracyMS', 'left')

    makeLuaText('accuracyValMS', getDataFromPlaylist(songPlaylist, 'accuracyMs', 0, 'average')..'%', 385, 70, 460)
    setProperty('accuracyValMS.camera', instanceArg('camOther'), false, true)
    setTextFont('accuracyValMS', 'phantomMuff.ttf')
    setTextColor('accuracyValMS', '99aabb')
    setTextSize('accuracyValMS', 20)
    setTextAlignment('accuracyValMS', 'right')
end

function achievementHandler()
    local finalRankResults = getRank({songName}, false)
    finalRank = finalRankResults[1]
    finalResult = finalRankResults[2]
    finalPoof = finalRankResults[3]
    finalComboRating = finalRankResults[4]

    achievementObtained = false

    -- Week Complete Achievement
    if achievementExists(week..'-'..difficultyName..'_storyComplete') and not isAchievementUnlocked(week..'-'..difficultyName..'_storyComplete') and songName == songPlaylist[#songPlaylist] then
        unlockAchievement(week..'-'..difficultyName..'_storyComplete')
        achievementObtained = true
    end
    -- Song Specific S Rank Achievement
    if achievementExists(savedSong..'_sickRank') and not isAchievementUnlocked(savedSong..'_sickRank') and getDataFromSave(savedSong, 'rank') == 'S' then
        unlockAchievement(savedSong..'_sickRank')
        achievementObtained = true
    -- D/F Rank Achievement
    elseif not isAchievementUnlocked('miscFtt_failingRank') and (finalRank == 'D' or finalRank == 'F') then
        unlockAchievement('miscFtt_failingRank')
        achievementObtained = true
    end
    -- FC Achievement
    if not isAchievementUnlocked('miscFtt_fullClear') and misses <= 0 then
        unlockAchievement('miscFtt_fullClear')
        achievementObtained = true
    end
    -- Triple S Achievement
    if not isAchievementUnlocked('hiddenFtt_tripleS') and (finalRank == 'S' and ratingFC == 'SFC' and getVar('stylishCount') == stylishMax and stylishMax > 0) then
        unlockAchievement('hiddenFtt_tripleS')
        achievementObtained = true
    end
    -- KFC Achievement
    if not isAchievementUnlocked('hiddenFtt_killerFullClear') and misses <= 0 and judgementArray[1].hit > 0 and judgementArray[2].hit == 0 and judgementArray[3].hit == 0 and judgementArray[4].hit == 0 and judgementArray[5].hit == 0 then
        unlockAchievement('hiddenFtt_killerFullClear')
        achievementObtained = true
    end
    -- Dev Intended Achievement
    if not isAchievementUnlocked('miscFtt_devIntended') and devIntendedValid and (finalRank == 'A' or finalRank == 'S') then
        unlockAchievement('miscFtt_devIntended')
        achievementObtained = true
    end
    -- Counter Achievements
    if not isAchievementUnlocked('counterFtt_score') then
        addAchievementScore('counterFtt_score', score, true)
        if isAchievementUnlocked('counterFtt_score') then
            achievementObtained = true
        end
    end
    -- Misc. Achievements
    if not isAchievementUnlocked('miscFtt_playtimeExpert') and (difficultyName == 'Baby' and ratingFC:find('FC')) then
        addAchievementScore('miscFtt_playtimeExpert', 1, true)
        if isAchievementUnlocked('miscFtt_playtimeExpert') then
            achievementObtained = true
        end
    end
end

function fttSaveData()
    initSavedSong()
    if (not botPlay and not practice) then
        -- Global Stats
        setDataFromSave(savedSong, 'cleared', true)
        setDataFromSave(savedSong, 'timesPlayed', getDataFromSave(savedSong, 'timesPlayed', 0)+1)
        setDataFromSave(savedSong, 'comboMax', noteAmount)
        -- Temporary Stats (Last Played)
        setDataFromSave(savedSong, 'versionPlayed', fttVersion)
        setDataFromSave(savedSong, 'rank', finalRank)
        setDataFromSave(savedSong, 'fc', ratingFC)
        setDataFromSave(savedSong, 'fcID', ratingFCID)
        setDataFromSave(savedSong, 'score', score)
        setDataFromSave(savedSong, 'accuracy', roundToDecimal(rating * 100, 2))
        setDataFromSave(savedSong, 'misses', misses)
        setDataFromSave(savedSong, 'accuracyMs', msInfo.msAcc)
        setDataFromSave(savedSong, 'combo', bestCombo)
        for i = 1,#judgementArray do
            setDataFromSave(savedSong, judgementArray[i].name..'Hits', judgementArray[i].hit)
        end
        -- Best Stats (Updates if your Score or Accuracy is higher than your last best.)
        if score > getDataFromSave(savedSong, 'scoreBest', 0) or rating > getDataFromSave(savedSong, 'accuracyBest', 0) or ratingFCID > getDataFromSave(savedSong, 'fcIDBest', 0) then
            setDataFromSave(savedSong, 'versionPlayedBest', fttVersion)
            setDataFromSave(savedSong, 'rankBest', finalRank)
            setDataFromSave(savedSong, 'fcBest', ratingFC)
            setDataFromSave(savedSong, 'fcIDBest', ratingFCID)
            setDataFromSave(savedSong, 'scoreBest', score)
            setDataFromSave(savedSong, 'accuracyBest', roundToDecimal(rating * 100, 2))
            setDataFromSave(savedSong, 'missesBest', misses)
            setDataFromSave(savedSong, 'accuracyMsBest', msInfo.msAcc)
            setDataFromSave(savedSong, 'comboBest', bestCombo)
            for i = 1,#judgementArray do
                setDataFromSave(savedSong, judgementArray[i].name..'HitsBest', judgementArray[i].hit)
            end
            newBest = true
        end
        flushSaveData(savedSong)
	end
end

function getDataFromPlaylist(songArray, saveData, defaultValue, dataType)
    local totalAmount = 0
    if dataType == 'lowest' then
        totalAmount = nil
    end
    for i = 1,#songArray do
        initSaveData(string.gsub(songArray[i], " ", "-")..'-'..difficultyName, 'FromTheTop')
        if dataType == 'lowest' then
            if totalAmount == nil or totalAmount > getDataFromSave(string.gsub(songArray[i], " ", "-")..'-'..difficultyName, saveData, defaultValue) then
                totalAmount = getDataFromSave(string.gsub(songArray[i], " ", "-")..'-'..difficultyName, saveData, defaultValue)
            end
        else
            totalAmount = totalAmount + getDataFromSave(string.gsub(songArray[i], " ", "-")..'-'..difficultyName, saveData, defaultValue)
        end
    end
    if dataType == 'average' then
        return roundToDecimal(totalAmount / #songArray, 2)
    else
        return totalAmount
    end
end

function getRank(songArray, bestRank)
    local rankOutput = 'S'
    local rankResult = 'bad'
    local rankPoof = 'Star'
    local rankFC = 'KFC'
    if not botPlay then
        for i = 1,#ratingArray do
            if bestRank ~= nil and bestRank == true then
                if (getDataFromPlaylist(songArray, 'accuracyBest', 0, 'average')/100) >= ratingArray[i].value then
                    rankOutput = ratingArray[i].name
                    rankResult = ratingArray[i].result
                    rankPoof = ratingArray[i].poof
                end
            else
                if (getDataFromPlaylist(songArray, 'accuracy', 0, 'average')/100) >= ratingArray[i].value then
                    rankOutput = ratingArray[i].name
                    rankResult = ratingArray[i].result
                    rankPoof = ratingArray[i].poof
                end
            end
        end
        if bestRank ~= nil and bestRank == true then
            rankFC = getDataFromPlaylist(songArray, 'fcIDBest', 4, 'lowest')
        else
            rankFC = getDataFromPlaylist(songArray, 'fcID', 4, 'lowest')
        end
        local fcTable = {'Clear', 'FC', 'GFC', 'SFC', 'KFC'}
        rankFC = fcTable[rankFC+1]
    end
    return {rankOutput, rankResult, rankPoof, rankFC}
end

function initSavedSong()
	savedSong = string.gsub(songName, " ", "-")..'-'..difficultyName
    initSaveData(savedSong, 'FromTheTop')
end

function onTimerCompleted(t)
    if t == 'poofGone' then
        setProperty('poof.visible', false)
    elseif t == 'bfAnim' then
        playAnim('boyfriend', 'resultsIntro-'..finalResult, true)
    elseif t == 'stampAppear' then
        setProperty('stamp.visible', true)
        if string.len(finalComboRating) == 3 then
            doTweenAlpha('stampStarsTween', 'stampStars', 1, 0.5, 'circOut')
        end
    elseif t == 'stampDisappear' then
        setProperty('stampHand.visible', false)
    elseif t == 'endSong' then
        endSong()
    elseif t == 'boom1' then
        addLuaText('score', true)
        addLuaText('scoreVal', true)

        startTween('scoreScale', 'score.scale', {x = 0.75, y = 0.75}, 0.5, {ease = 'circOut'})
        doTweenColor('scoreColor', 'score', 'ffffff', 0.5, 'circOut')
        startTween('scoreValScale', 'scoreVal.scale', {x = 0.75, y = 0.75}, 0.5, {ease = 'circOut'})
        doTweenColor('scoreValColor', 'scoreVal', 'ffffff', 0.5, 'circOut')

        if not minimalResultsScreen then
            nc_snap_zoom('g', 0.9)
        else
            playSound('scrollMenu', 1, 'resultsSFX')
            setSoundPitch('resultsSFX', 1)
        end

    elseif t == 'boom2' then
        addLuaText('accuracy', true)
        addLuaText('accuracyVal', true)

        startTween('accuracyScale', 'accuracy.scale', {x = 0.75, y = 0.75}, 0.5, {ease = 'circOut'})
        doTweenColor('accuracyColor', 'accuracy', 'ffffff', 0.5, 'circOut')
        startTween('accuracyValScale', 'accuracyVal.scale', {x = 0.75, y = 0.75}, 0.5, {ease = 'circOut'})
        doTweenColor('accuracyValColor', 'accuracyVal', 'ffffff', 0.5, 'circOut')

        if not minimalResultsScreen then
            nc_snap_zoom('g', 1)
        else
            playSound('scrollMenu', 1, 'resultsSFX')
            setSoundPitch('resultsSFX', 1.08)
        end

    elseif t == 'boom3' then
        addLuaText('misses', true)
        addLuaText('missesVal', true)

        startTween('missesScale', 'misses.scale', {x = 0.75, y = 0.75}, 0.5, {ease = 'circOut'})
        doTweenColor('missesColor', 'misses', 'ffffff', 0.5, 'circOut')
        startTween('missesValScale', 'missesVal.scale', {x = 0.75, y = 0.75}, 0.5, {ease = 'circOut'})
        doTweenColor('missesValColor', 'missesVal', 'ffffff', 0.5, 'circOut')

        if not minimalResultsScreen then
            nc_snap_zoom('g', 1.1)
        else
            playSound('scrollMenu', 1, 'resultsSFX')
            setSoundPitch('resultsSFX', 1.16)
        end

    elseif t == 'boom-fakeout' then
        nc_snap_zoom('g', 1.5)
        nc_snap_target('plr')

        songSpecificEvents('resultBoom')
        
        setProperty('score.visible', false)
        setProperty('scoreVal.visible', false)
        setProperty('accuracy.visible', false)
        setProperty('accuracyVal.visible', false)
        setProperty('misses.visible', false)
        setProperty('missesVal.visible', false)

        playAnim('boyfriend', 'resultsIntro-bad', true, false, 177)
        playSound('resultsSting-fakeout', 1, 'resultsSting')

        minimalResultsScreen = true
        setVar('fakeoutPlayed', true)

    elseif t == 'boom-bad' then
        nc_snap_zoom('g', 1.7)
        nc_snap_target('plr')

        songSpecificEvents('resultBoom')
        
        setProperty('score.visible', false)
        setProperty('scoreVal.visible', false)
        setProperty('accuracy.visible', false)
        setProperty('accuracyVal.visible', false)
        setProperty('misses.visible', false)
        setProperty('missesVal.visible', false)

        makeLuaText('dumbfuckYouSuck', getDataFromPlaylist(songPlaylist, 'misses', 0, 'total'), 0, 0, 0)
		setProperty('dumbfuckYouSuck.camera', instanceArg('camOther'), false, true)
        doTweenAlpha('dumbfuckYouSuck', 'dumbfuckYouSuck', 0.5, 0.4, 'circOut')
        setBlendMode('dumbfuckYouSuck', 'add')
        setTextBorder('dumbfuckYouSuck', 15, '220022', 'outline_fast')
        setTextWidth('dumbfuckYouSuck', screenWidth)
        setTextHeight('myText', screenHeight)
        setTextAlignment('dumbfuckYouSuck', 'center')
        setTextFont('dumbfuckYouSuck', 'tardling.ttf')
        setTextColor('dumbfuckYouSuck', 'ff0022')
        setTextSize('dumbfuckYouSuck', 720)
		addLuaText('dumbfuckYouSuck', true)

        playAnim('boyfriend', 'resultsIntro-'..finalResult, true, false, 177)
        playSound('resultsSting-'..finalResult, 1, 'resultsSting')

    elseif t == 'boom-good' then
        nc_snap_zoom('g', 1.5)
        nc_snap_target('plr')

        songSpecificEvents('resultBoom')

        playAnim('rank', 'shuffle', true)
        scaleObject('rank', 0.9, 0.9)
        setProperty('rank.visible', true)

        playAnim('boyfriend', 'resultsIntro-'..finalResult, true, false, 177)
        playSound('resultsSting-'..finalResult, 1, 'resultsSting')

    elseif t == 'minimalShuffle' then
        playAnim('rank', 'shuffle', true)
        playSound('drumroll', 1, 'drumroll')
        setObjectOrder('rank', 100000)
        scaleObject('rank', 0.9, 0.9)
        startTween('rankScale', 'rank.scale', {x = 1.15, y = 1.15}, 1.5, {ease = 'sineInOut'})
        setProperty('rank.visible', true)
        setObjectOrder('stamp', 100001)
        setObjectOrder('stampStars', 100002)
        setObjectOrder('stampHand', 100003)
    elseif t == 'resultIntro' then
        playerMid()
        playstate = 'ResultState'

        songSpecificEvents('resultIntro')

        if luaTextExists('dumbfuckYouSuck') then removeLuaText('dumbfuckYouSuck') end

        stopSound('resultsSting')
        stopSound('drumroll')
        cancelTween('rankScale')
        cancelTween('resultsBgTween')

        setProperty('resultsBg.alpha', 0.5)

        setProperty('score.visible', true)
        setProperty('scoreVal.visible', true)
        setProperty('accuracy.visible', true)
        setProperty('accuracyVal.visible', true)
        setProperty('misses.visible', true)
        setProperty('missesVal.visible', true)

        if not minimalResultsScreen then
            screenCoolEffect()
            nc_set_target('plr', bfMidX, bfMidY)
            nc_focus('plr', 0, 'linear', true)
            nc_snap_zoom('g', 1)

            playAnim('boyfriend', 'results-'..finalResult, true)
            if getProperty('gf.visible') then
                playAnim('gf', gfAnim, true)
            end
        end

        if ivePlayedTheseGamesBefore then
            doTweenY('pbTween', 'pb', 30, 1, 'circOut')
            doTweenY('pbRankTween', 'pbRank', 30, 1, 'circOut')
        end

        if newBest then
            playAnim('newBest', 'intro', true)
            addLuaSprite('newBest')
        end

        playAnim('poof', 'poof', true)
        setProperty('poof.visible', true)
        runTimer('poofGone', 1)

        playAnim('rank', 'rank', true)
        setObjectOrder('rank', 100000)
        setProperty('rank.visible', true)
        setProperty('rank.x', 925)
        setProperty('rank.y', 0)
        scaleObject('rank', 1.3, 1.3)
        startTween('rankScale', 'rank.scale', {x = 0.95, y = 0.95}, 1, {ease = 'circOut'})

        setProperty('win.visible', true)
        setObjectOrder('win', 100001)
        doTweenY('win', 'win', 30, 1, 'circOut')

        setObjectOrder('newBest', 100001)
        setObjectOrder('stamp', 100001)
        setObjectOrder('stampStars', 100002)
        setObjectOrder('stampHand', 100003)

        playMusic('results-'..finalResult, 1, true)
    elseif t == 'resultPost' then
        doTweenX('songNameTween', 'songName', 50, 1.5, 'sineOut')
		addLuaText('songName', true)

        startTween('scoreScale', 'score.scale', {x = 0.75, y = 0.75}, 0.5, {ease = 'circOut'})
        doTweenColor('scoreColor', 'score', 'ffffff', 0.5, 'circOut')

        if newBest then
            playAnim('newBest', 'idle', true)
        end

        if checkFileExists('images/results/stamp'..finalComboRating..'.png') then
            setProperty('stampHand.visible', true)
            playAnim('stampHand', 'stamp', true)
            runTimer('stampAppear', 0.75)
            runTimer('stampDisappear', 1.25)
        end
        
        if not minimalResultsScreen then
            nc_zoom('g', 0.8, 1, 'circOut')
            fttSoundHandler('bf', finalResult, 0.7)
        end
    elseif t == 'resultPost2' then
        doTweenY('songNameTween', 'songName', 220, 2, 'expoOut')

        setProperty('difficulty.alpha', 0)
        doTweenAlpha('difficultyTween', 'difficulty', 1, 1.5, 'sineOut')
		addLuaText('difficulty', true)

        setProperty('bestCombo.alpha', 0)
        doTweenAlpha('bestComboTween', 'bestCombo', 1, 1.5, 'sineOut')
		addLuaText('bestCombo', true)

        setProperty('bestComboVal.alpha', 0)
        doTweenAlpha('bestComboValTween', 'bestComboVal', 1, 1.5, 'sineOut')
		addLuaText('bestComboVal', true)

        setProperty('accuracyMS.alpha', 0)
        doTweenAlpha('accuracyMSTween', 'accuracyMS', 1, 1.5, 'sineOut')
		addLuaText('accuracyMS', true)

        setProperty('accuracyValMS.alpha', 0)
        doTweenAlpha('accuracyValMSTween', 'accuracyValMS', 1, 1.5, 'sineOut')
		addLuaText('accuracyValMS', true)

        if luaSpriteExists('pb') then
            local pbObjects = {'pb', 'pbRank'}
            local pbText = {'pbScore', 'pbScoreVal', 'pbAccuracy', 'pbAccuracyVal', 'pbMisses', 'pbMissesVal'}
            for i = 1,#pbObjects do
                doTweenY(pbObjects[i]..'Tween', pbObjects[i], 10, 1, 'expoOut')
            end
            for i = 1,#pbText do
                setProperty(pbText[i]..'.alpha', 0)
                doTweenAlpha(pbText[i]..'Tween', pbText[i], 1, 1.5, 'sineOut')
                addLuaText(pbText[i], true)
            end
        end

        for i = 1,#creditsList do
            if songName == creditsList[i].song then
                if creditsStyle == 'Default' then
                    creditsStyle = creditsList[i].style
                end
            end
        end

        if checkFileExists('images/results/bar'..creditsStyle..'.png') then
            makeLuaSprite('judgementPopup', 'results/bar'..creditsStyle, -30, 720)
        else
            makeLuaSprite('judgementPopup', 'results/barVinyl', -30, 720)
        end
        setProperty('judgementPopup.camera', instanceArg('camOther'), false, true)
        setObjectOrder('judgementPopup', getObjectOrder('resultsCloud0'))
        scaleObject('judgementPopup', 0.8, 0.8)
        addLuaSprite('judgementPopup')
        doTweenY('judgementPopupTween', 'judgementPopup', 595, 2, 'expoOut')
        
        local judgementArrayPlaylist = {}
        for i = 1,#judgementArray do
            table.insert(judgementArrayPlaylist, getDataFromPlaylist(songPlaylist, judgementArray[i].name..'Hits', 0, 'total'))
        end

        for i = 1,#judgementArray do
            makeLuaSprite('judgementCount'..i, judgementArray[i].name, -80 + (i*145), 720)

            makeLuaText('judgementCountTxt'..i, judgementArrayPlaylist[i], 100, -80 + (i*145), 720)
            setProperty('judgementCountTxt'..i..'.camera', instanceArg('camOther'), false, true)
            setTextFont('judgementCountTxt'..i, 'tardling.ttf')
            setTextAlignment('judgementCountTxt'..i, 'center')

            if judgementArrayPlaylist[i] > 0 and judgementArrayPlaylist[2] <= 0 and judgementArrayPlaylist[3] <= 0 and judgementArrayPlaylist[4] <= 0 and judgementArrayPlaylist[5] <= 0 then
                makeLuaSprite('judgementCount'..i, judgementArray[i].name..'KFC', -80 + (i*145), 720)
                setTextColor('judgementCountTxt'..i, 'ff4400')
            elseif judgementArrayPlaylist[i] > 0 and judgementArrayPlaylist[3] <= 0 and judgementArrayPlaylist[4] <= 0 and judgementArrayPlaylist[5] <= 0 then
                makeLuaSprite('judgementCount'..i, judgementArray[i].name..'SFC', -80 + (i*145), 720)
                setTextColor('judgementCountTxt'..i, '00ddff')
            elseif judgementArrayPlaylist[i] > 0 and judgementArrayPlaylist[4] <= 0 and judgementArrayPlaylist[5] <= 0 then
                makeLuaSprite('judgementCount'..i, judgementArray[i].name..'GFC', -80 + (i*145), 720)
                setTextColor('judgementCountTxt'..i, 'ffdd00')
            elseif judgementArrayPlaylist[i] > 0 then
                setTextColor('judgementCountTxt'..i, 'ffffff')
            else
                setProperty('judgementCount'..i..'.color', 0x888888)
                setTextColor('judgementCountTxt'..i, '888888')
            end

            setProperty('judgementCount'..i..'.camera', instanceArg('camOther'), false, true)
            setObjectOrder('judgementCount'..i, getObjectOrder('judgementPopup')+100)
            scaleObject('judgementCount'..i, 0.3, 0.3)
            addLuaSprite('judgementCount'..i)

            setTextSize('judgementCountTxt'..i, 25)
            setObjectOrder('judgementCountTxt'..i, getObjectOrder('judgementPopup')+150)

            setProperty('judgementCount1.x', 30)
            setProperty('judgementCountTxt1.x', 50)

            doTweenY('judgementCount'..i..'Tween', 'judgementCount'..i, 630+judgementArray[i].offset, 3, 'expoOut')
            doTweenY('judgementCountTxt'..i..'Tween', 'judgementCountTxt'..i, 680, 3, 'expoOut')
        end
        if showExtraJudgements then
            --im not fucking with this right now. sorry, no hit/dodge/stylish counters for now! v4 blast go!
            --[[
            doTweenY('win', 'win', 80, 3, 'expoOut')

            makeLuaText('stylishCount', 'Stylishes Hit:', 0, 70, 490)
            setProperty('stylishCount.camera', instanceArg('camOther'), false, true)
            setTextFont('stylishCount', 'phantomMuff.ttf')
            setTextColor('stylishCount', '99aabb')
            setTextSize('stylishCount', 20)
            setTextAlignment('stylishCount', 'left')

            makeLuaText('stylishCountVal', getVar('stylishCount')..' / '..stylishMax, 385, 70, 490)
            setProperty('stylishCountVal.camera', instanceArg('camOther'), false, true)
            setTextFont('stylishCountVal', 'phantomMuff.ttf')
            setTextColor('stylishCountVal', '99aabb')
            setTextSize('stylishCountVal', 20)
            setTextAlignment('stylishCountVal', 'right')
            ]]--
        end
    end
end

function songSpecificEvents(event)
    if event == 'resultStart' then
        if curStage == 'spooky [ftt]' then
            if songName == 'Spookeez (FTT)' then
                spooky_flicker(11, false)
            else
                spooky_flicker(10, false)
            end
        elseif curStage == 'highway [ftt]' or curStage == 'mall [ftt]' then
            spotlightToggle(false)
            spotlightColor('ffffff')
        end
    elseif event == 'resultBoom' then
        if curStage == 'spooky [ftt]' then
            if finalResult == 'good' then
                spooky_flicker(15, false)
            else
                spooky_flicker(16, false)
            end
        end
    elseif event == 'resultIntro' then
        if curStage == 'stage [ftt]' then
            if finalResult == 'good' then
                doTweenY('crowdAppear', 'crowd', 600, 2, 'circOut')
            else
                doTweenY('crowdDisappear', 'crowd', 1200, 2, 'circIn')
            end
        elseif curStage == 'highway [ftt]' then
            spotlightToggle(true)
            if finalResult == 'good' then
                spotlightColor('sequence')
            else
                spotlightColor('evil')
            end
        elseif curStage == 'mall [ftt]' then
            if finalResult == 'good' then
                spotlightToggle(true)
                spotlightColor('sequence')
            end
        end
    end
end

function onEvent(n, v1, v2)
    if n == 'FTT Dodge' or n == 'FTT Attack' then
        showExtraJudgements = true
        stylishMax = stylishMax + 1
    end
end

function screenCoolEffect()
    if lowQuality then
        for i = -1, 1 do
            if i ~= 0 then
                makeLuaSprite('cinemaRank'..i, '', -400, i*720)
                makeGraphic('cinemaRank'..i, 2080, 720, '000000')
                setProperty('cinemaRank'..i..'.camera', instanceArg('camOther'), false, true)
                setProperty('cinemaRank'..i..'.origin.x', 1040)
                setProperty('cinemaRank'..i..'.origin.y', 360)
                addLuaSprite('cinemaRank'..i)

                doTweenAngle('cinemaRankAngle'..i, 'cinemaRank'..i, -20, 1, 'sineOut')
                doTweenY('cinemaRankFast'..i, 'cinemaRank'..i, 770*i, 0.5, 'circOut')
            end
        end
    else
        for i = 0,1 do
            doTweenY('resultsCloud'..i, 'resultsCloud'..i, -100 + (500 * i), 1, 'circOut')
        end
    end
end

function playerMid()
    if boyfriendName:find('bf') ~= nil then
        bfMidX = getGraphicMidpointX(getProperty('boyfriend'))+175
        bfMidY = getGraphicMidpointY(getProperty('boyfriend'))+175
    elseif boyfriendName:find('pico') ~= nil then
        bfMidX = getGraphicMidpointX(getProperty('boyfriend'))+275
        bfMidY = getGraphicMidpointY(getProperty('boyfriend'))+225
    else
        bfMidX = getGraphicMidpointX(getProperty('boyfriend'))+175
        bfMidY = getGraphicMidpointY(getProperty('boyfriend'))+175
    end
end

function customRatingPopup(image, offset)
    if not hideHud then
        ratingNumber = ratingNumber + 1
        makeLuaSprite('customRating'..ratingNumber, image, 0, 0)
        scaleObject('customRating'..ratingNumber, 0.5, 0.5)
        addLuaSprite('customRating'..ratingNumber)
        screenCenter('customRating'..ratingNumber, 'xy')
        setProperty('customRating'..ratingNumber..'.x', 400 + getPropertyFromClass('backend.ClientPrefs', 'data.comboOffset[0]') + offset)
        setProperty('customRating'..ratingNumber..'.y', -100 + getPropertyFromClass('backend.ClientPrefs', 'data.comboOffset[1]'))
        setProperty('customRating'..ratingNumber..'.acceleration.y', 550 * playbackRate * playbackRate)
        setProperty('customRating'..ratingNumber..'.velocity.y', -(getRandomInt(140, 175) * playbackRate))
        setProperty('customRating'..ratingNumber..'.velocity.x', getRandomInt(0, 10) * playbackRate)
        setProperty('customRating'..ratingNumber..'.camera', instanceArg('camHUD'), false, true)
        startTween('customRating'..ratingNumber, 'customRating'..ratingNumber, {alpha = 0}, 0.2 / playbackRate, {ease = 'linear', startDelay = 0.6 / playbackRate})
    end
end

function onTweenCompleted(t)
    if t:find('customRating') then
        local tNum = t:sub(t, 13, -1)
        removeLuaSprite('customRating'..tNum)
    end
end