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
	if curSong == 'mycosis' then

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
end


function goodNoteHit(id, direction, noteType, isSustainNote)
	if curSong == 'mycosis' then
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
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if curSong == 'mycosis' then
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
end

function onTimerCompleted(tag, loops, loopsLeft)
	if curSong == 'mycosis' then
	if camon == true then
	if tag == 'camreset' then
	camlock = false
	setProperty('cameraSpeed', 1)
	setProperty('camFollow.x', campointx)
	setProperty('camFollow.y', campointy)
	end
end
end
end

function onEvent(event, value1, value2, strumTime)
	if curSong == 'mycosis' then
	if event == 'Camera Follow Pos' then
		if value1 == '' then
			camlock = false
			camon = true
		else 
			camlock = true
			camon = false
		end
	end
end
end

function onUpdate()
	if curSong == 'mycosis' then
	if camlock and camon == true then
		setProperty('camFollow.x', camlockx)
		setProperty('camFollow.y', camlocky)
	end
end
end