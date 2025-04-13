--Script by Teniente Mantequilla#0139--

--change this ones--
local camMovement = 10
local velocity = 2

--leave this ones alone--
local campointx = 0
local campointy = 0
local camlockx = 0
local camlocky = 0
local camlock = false
local bfturn = false
local camon = true

	
function onMoveCamera(focus)
	if camon == true then
	if focus == 'boyfriend' then
	campointx = getProperty('camFollow.x')
	campointy = getProperty('camFollow.y')
	bfturn = true
	camlock = false
	setProperty('cameraSpeed', 1)
	
	elseif focus == 'dad' then
	campointx = getProperty('camFollow.x')
	campointy = getProperty('camFollow.y')
	bfturn = false
	camlock = false
	setProperty('cameraSpeed', 1)
	
	end
end
end


function goodNoteHit(id, direction, noteType, isSustainNote)
	if camon == true then
	if bfturn then
		if direction == 0 then
			camlockx = campointx - camMovement
			camlocky = campointy
		elseif direction == 1 then
			camlocky = campointy + camMovement
			camlockx = campointx
		elseif direction == 2 then
			camlocky = campointy - camMovement
			camlockx = campointx
		elseif direction == 3 then
			camlockx = campointx + camMovement
			camlocky = campointy
		end
	runTimer('camreset', 1)
	setProperty('cameraSpeed', velocity)
	camlock = true
	end	
end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if camon == true then
	if not bfturn then
		if direction == 0 then
			camlockx = campointx - camMovement
			camlocky = campointy
		elseif direction == 1 then
			camlocky = campointy + camMovement
			camlockx = campointx
		elseif direction == 2 then
			camlocky = campointy - camMovement
			camlockx = campointx
		elseif direction == 3 then
			camlockx = campointx + camMovement
			camlocky = campointy
		end
	runTimer('camreset', 1)
	setProperty('cameraSpeed', velocity)
	camlock = true
	end	
end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if camon == true then
	if tag == 'camreset' then
	camlock = false
	setProperty('cameraSpeed', 1)
	setProperty('camFollow.x', campointx)
	setProperty('camFollow.y', campointy)
	end
end
end

function onUpdate()
	if camlock and camon == true then
		setProperty('camFollow.x', camlockx)
		setProperty('camFollow.y', camlocky)
	end
end

function onStepHit()
	if songName == 'locked' then
		if curStep == 290 then
			camon = true
			camlock = false
		end
	end
end

function onBeatHit()
	if songName == 'locked' then
		if curBeat >= 0  and curBeat <= 15 then
			camon = false
			camlock = true
		end
		if curBeat == 15 then
			camon = true
			camlock = false
		end
		if curBeat == 47 then
			camon = false
			camlock = true
		end
		if curBeat == 63 then
			camlock = false
		end
		if curBeat == 64 then
			camlock = true
		end
		if curBeat == 76 then
			camon = false
			camlock = true
		end
	end
end