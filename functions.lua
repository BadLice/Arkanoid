function inc(x)
	return x+1
end

function dec(x)
	return x-1
end

function getFont(size)
	return love.graphics.newFont("Organo.ttf", size)
end

function getScaleX(img,xSize)
	--1:img.width = x : xsize
	--x= xsize/imgwidth
	return xSize/img:getWidth()
end

function getScaleY(img,ySize)
	--1:img.width = x : xsize
	--x= xsize/imgwidth
	return ySize/img:getHeight()
end

--works with all objects with (bool)poinEffect, (int)pointEffectSize, (int)pointEffectValue as attributes
--prints score gained with an event
function pointEffectf(o)

end

function drawScoreDynamic(line,size,x,y) --draw score gained everywhere (return size increased)
	love.graphics.setColor(230,88,160)
	love.graphics.setFont(getFont(math.ceil(size)))
	love.graphics.print(line,x,y,-math.pi/2,1,1,getFont(math.ceil(size)):getWidth(line)/2)
	love.graphics.setColor(255,255,255)
	return size + 0.5
end

function readSaves()--read file and memorize values
	--[[for line in love.filesystem.lines(path) do
		for i in string.gmatch(line,"%S+") do
		   values[k] = i
		   print(values[k])
		   k = k + 1
		end
	end]]
	print("root problems with android")
end

function createSaves()
	--create file for first time
--[[	if not love.filesystem.exists(path) then
		file = love.filesystem.newFile(path)
		writeSaves(10,1,3)
	end]]
	print("root problems with android")
end

function writeSaves(a,b,c)--write saves
	--success, message = love.filesystem.write(path, math.floor(a).." "..math.floor(b).." "..math.floor(c))
	print("root problems with android")
end

function updateValues()
	--readSaves()
	vel = tonumber(math.floor(VelSlider.value))
	level = tonumber(math.floor(LevelSlider.value))
	player.lives = tonumber(math.floor(LivesSlider.value))
	--print(""..vel.." "..level.." "..player.lives)
end

function pausef()
	if pause then
		vel=tonumber(math.floor(VelSlider.value))
		pause=false
		pauseBtn.img=love.graphics.newImage("img/pause.png")
	else
		pause = true
		vel=0
		pauseBtn.img=love.graphics.newImage("img/play.png")
	end
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
