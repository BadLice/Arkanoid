function drawMainMenu()
	startMusic()
	drawBackground()
	play()
	volume()
	options()
	drawTitle()
end

function play()
	playMenuBtn:draw(0.1)
end

function volume()
	soundBtn:draw(0.1)
end

function options()
	optBtn:draw(0.1)
end

function startMusic()
	themeMusic:play()
end

function drawTitle()
	--changes title's color every 0.2s
	if(love.timer.getTime()-titleTime>0.2) then
		tr = math.random(1,255)
		tg = math.random(1,255)
		tb = math.random(1,255)
		titleTime=love.timer.getTime()
	end

	love.graphics.setColor(tr,tg,tb)
	love.graphics.setFont(getFont(90))
	line="ARKANOID"
	love.graphics.print(line,100*fx,love.graphics.getHeight()/2+(1*fy),-math.pi/2,1,1,getFont(90):getWidth(line)/2)
	love.graphics.setColor(255,255,255)
end

function drawOptions()
	--vel,level,lives,max score
	drawBackground()

	love.graphics.setColor(230,88,160)
	love.graphics.setFont(getFont(30))

	--speed settings
	suit.Slider(VelSlider, {vertical = true},120*fx,(love.graphics.getHeight()/2)-300,30,600)

	line = "BALL SPEED"
	love.graphics.print(line,65*fx,love.graphics.getHeight()/2+(1*fy),-math.pi/2,1,1,getFont(30):getWidth(line)/2)

	line = math.floor(VelSlider.value)
	love.graphics.print(line,90*fx,love.graphics.getHeight()/2+(1*fy),-math.pi/2,1,1,getFont(30):getWidth(line)/2)

	--level settings
	suit.Slider(LevelSlider, {vertical = true},350*fx,(love.graphics.getHeight()/2)-300,30,600)

	line = "starting level"
	love.graphics.print(line,295*fx,love.graphics.getHeight()/2+(1*fy),-math.pi/2,1,1,getFont(30):getWidth(line)/2)

	line = math.floor(LevelSlider.value)
	love.graphics.print(line,320*fx,love.graphics.getHeight()/2+(1*fy),-math.pi/2,1,1,getFont(30):getWidth(line)/2)


	--lives settings
	suit.Slider(LivesSlider, {vertical = true},630*fx,(love.graphics.getHeight()/2)-300,30,600)

	line = "starting lives"
	love.graphics.print(line,575*fx,love.graphics.getHeight()/2+(1*fy),-math.pi/2,1,1,getFont(30):getWidth(line)/2)

	line = math.floor(LivesSlider.value)
	love.graphics.print(line,600*fx,love.graphics.getHeight()/2+(1*fy),-math.pi/2,1,1,getFont(30):getWidth(line)/2)


	love.graphics.setColor(255,255,255)

	SaveBtn:draw(0.1)
	CancelBtn:draw(0.1)

	suit.draw()
end
