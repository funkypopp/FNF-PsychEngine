local shaderStage = 0
function onCreate()
	if not shadersEnabled then
		close(true);
	end
end

function onCreatePost()
	initLuaShader('HueSatCon')
	initLuaShader('bloom')
	initLuaShader('gaussian blur')
	
	makeLuaSprite('HueSatCon', 0.0, 0.0)
	makeGraphic('HueSatCon', 1, 1)
	setSpriteShader('HueSatCon', 'HueSatCon')
	makeLuaSprite('Bloom', 1.9, 0)
	makeGraphic('Bloom', 1, 1)
	setSpriteShader('Bloom', 'bloom')
	makeLuaSprite('ChromaticAberration', 0.0, 0)
	makeGraphic('ChromaticAberration', 1, 1)
	setSpriteShader('ChromaticAberration', 'chromatic aberration')
	makeLuaSprite('GaussianBlur', 30, 0)
	makeGraphic('GaussianBlur', 1, 1)
	setSpriteShader('GaussianBlur', 'gaussian blur')
	setShaderFloat("HueSatCon", "saturation", 0.0)
	setShaderFloat("HueSatCon", "brightness", 0.0)
	setShaderFloat("Bloom", "u_Amount", 1.9)
	setShaderFloat("Bloom", "u_Size", 0)
	setShaderFloat("ChromaticAberration", "u_intensity", 0.0)
	setShaderFloat("GaussianBlur", "u_BlurAmount", 30)
end

function bam(dur, ease)
	setProperty('Bloom.x', 1.7)
	setProperty('Bloom.y', 40)
	startTween('tween_Bloom', 'Bloom',{x = 2, y = 0}, dur,{ease = ease, onUpdate = 'tweenNum1'})
	
	setProperty('ChromaticAberration.x', 0.02)
	startTween('tween_ChromaticAberration', 'ChromaticAberration', {x = 0}, dur,{ease = ease, onUpdate = 'tweenNum2'})
end
function tweenNum1()
	setShaderFloat("Bloom", "u_Amount", getProperty('Bloom.x'))
	setShaderFloat("Bloom", "u_Size", getProperty('Bloom.y'))
end
function tweenNum2()
	setShaderFloat("ChromaticAberration", "u_Intensity", getProperty('ChromaticAberration.x'))
end
function tweenNum3()
	setShaderFloat("GaussianBlur", "u_BlurAmount", getProperty('GaussianBlur.x'))
end
function tweenNum4()
	setShaderFloat("HueSatCon", "saturation", getProperty('HueSatCon.x'))
	setShaderFloat("HueSatCon", "brightness", getProperty('HueSatCon.y'))
end

function onBeatHit()
	if ((curBeat >= 48 and curBeat < 80) or (curBeat >= 97 and curBeat < 128)) and shaderStage ~= 1 then
		shaderStage = 1
		runHaxeCode([[
			game.camGame.filters = ([
				new ShaderFilter(game.getLuaObject("ChromaticAberration").shader),
				new ShaderFilter(game.getLuaObject("Bloom").shader)
			]);
			game.camHUD.filters = ([
				new ShaderFilter(game.getLuaObject("ChromaticAberration").shader)
			]);
			getVar('camBG').filters = ([
				new ShaderFilter(game.getLuaObject("bgShader").shader),
				new ShaderFilter(game.getLuaObject("ChromaticAberration").shader),
				new ShaderFilter(game.getLuaObject("Bloom").shader)
			]);
			return;
		]])
	elseif (curBeat >= 80 and curBeat < 97) and shaderStage ~= 2 then
		shaderStage = 2
		runHaxeCode([[
			game.camGame.filters = ([
				new ShaderFilter(game.getLuaObject("GaussianBlur").shader)
			]);
			getVar('camBG').filters = ([
				new ShaderFilter(game.getLuaObject("bgShader").shader),
				new ShaderFilter(game.getLuaObject("GaussianBlur").shader)
			]);
			return;
		]])
	elseif ((curBeat < 48) or (curBeat >= 128)) and shaderStage ~= 0 then
		shaderStage = 0
		runHaxeCode([[
			game.camGame.filters = ([]);
			game.camHUD.filters = ([]);
			getVar('camBG').filters = ([
				new ShaderFilter(game.getLuaObject("bgShader").shader),
			]);
			return;
		]])
	end
	if curBeat == 78 and shaderStage == 1 then
		runHaxeCode([[
			game.camGame.filters.push(new ShaderFilter(game.getLuaObject("HueSatCon").shader));
			getVar('camBG').filters.push(new ShaderFilter(game.getLuaObject("HueSatCon").shader));
			return;
		]])
		setProperty('HueSatCon.x', 0); setProperty('HueSatCon.y', 0);
		startTween('tween_HueSatCon', 'HueSatCon', {y = 55}, ((curBpm/60)/2)/playbackRate,{ease = 'quintInOut', onUpdate = 'tweenNum4'})
	elseif curBeat == 82 and shaderStage == 2 then
		setProperty('GaussianBlur.x', 30)
		startTween('tween_GaussianBlur', 'GaussianBlur', {x = 0}, 5.5/playbackRate,{ease = 'linear', onUpdate = 'tweenNum3'})
	end
end