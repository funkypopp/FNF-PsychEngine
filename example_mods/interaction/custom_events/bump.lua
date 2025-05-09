function onEvent(n, v1, v2)
	if n == "bump" then
		if v1 == '' then v1 = 3 end
		callScript('data/interactive/shader', 'bam', {(curBpm/60)/v1, 'expoOut'})
	end
end