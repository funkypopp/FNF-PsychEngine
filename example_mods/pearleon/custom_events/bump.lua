function onEvent(n, v1, v2)
	if n == "bump" then
		callScript('data/my-first-song/shader stuff', 'bam', {(curBpm/60)/3, 'expoOut'})
		if curBeat < 111 then
			setProperty('camGame.zoom', 1.75)
			doTweenZoom('bamZoom', 'camGame', 1.5, ((curBpm/60)/2)/playbackRate, 'expoOut')
		else
			setProperty('camGame.zoom', 2.95)
			doTweenZoom('bamZoom', 'camGame', 2.7, ((curBpm/60)/2)/playbackRate, 'expoOut')
		end
	end
end