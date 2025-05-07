function onEvent(n,v1,v2)
	if v2 == '' then v2 = 'ffffff' end
	if n == 'Camera Fade In' and flashingLights then
		cameraFade('hud', v2, v1, true, false)
	end
end