--[[
	Spectator Global Script by SkyanUltra! :3c

	This script handles the large majority of the spectator characters actions in-game.

	This massively simplifies the usage and addition of new "spectator" characters (GF, Nene, etc.) and skins because I don't have to fucking duplicate a thousand scripts!
	It also means any changes I make here will affect EVERYTHING, which is good so I don't have to, again, duplicate a thousand scripts!

	CREDIT ME YOU FUCKING NIMROD!!! if you dont... i will KILL YOU!!! GRAAAAAAHHH!!!
	GB Link: https://gamebanana.com/members/1729271
	Bluesky Link: https://bsky.app/profile/skyanultra.bsky.social
]]--

-- vv Enable this for various debug info! vv
local debugTeehee = false

-- Character List Variables (Add any valid characters here!)
local characterList = {
	{name = 'gf%-original', midDance = false, hasLipsync = true},
    {name = 'gf%-costume', midDance = false, hasLipsync = true},
    {name = 'gf%-streetwear', midDance = false, hasLipsync = true},
    {name = 'gf%-outing', midDance = false, hasLipsync = true},
    {name = 'gf%-holiday', midDance = false, hasLipsync = true},
	{name = 'gf%-shonen', midDance = false, hasLipsync = true},
}
local characterType = {
	{type = 'gf', tag = 'gf'}
}

local anims = {'singLEFT', 'singDOWN', 'singUP', 'singRIGHT'}

-- Dynamic Variables (DO NOT TOUCH!!)

local animPlaying = 'danceLeft'
local lipSyncSuffix = 'a'

local midDance = false
local hasLipsync = true

local characterName = 'gf'
local characterTag = 'gf'

function reloadCurCharacter()
	for i = 1,#characterList do
		if boyfriendName:find(characterList[i].name) then
			curCharacter = i
			midDance = characterList[i].midDance
			hasLipsync = characterList[i].hasLipsync
		end
	end
	for i = 1,#characterType do
		if characterList[curCharacter].name:find(characterType[i].type) then
			characterName = characterType[i].type
			characterTag = characterType[i].tag
		end
	end
end

function onCreate()
	reloadCurCharacter()
end

-- Lipsync Code
function opponentNoteHit(id, dir, noteType, isSustainNote)
	-- Animations to play! Yes!
    if dadName:find(characterTag) then
        if noteType ~= 'No Animation' then
            if noteType ~= 'a' and noteType ~= 'e' and noteType ~= 'o' then
                lipSyncSuffix = 'point'
            elseif hasLipsync then
                lipSyncSuffix = noteType 
            else
                lipSyncSuffix = ''
            end
            playAnim('dad', anims[dir+1]..'-'..lipSyncSuffix, 'true')
        end
        if debugTeehee and not isSustainNote then debugPrint("GF Hit Note! ("..noteType..")") end
    end
end