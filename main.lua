--prova commit
require "menu"
require "draw"
require "math"
require "update"
require "functions"
require "button"
require "block"
require "powerUp"
require "ball"
require "polygon"

function love.load()
	toReset = false
	init()
end

function init()

	--variabili senza bisogno di reset
	if not toReset then

	suit = require "suit"
	font =	love.graphics.setFont(getFont(15))
	love.window.setMode(1196,720)
	state=0
	--[[
	0 = menu
	1 = game
	2 = win
	3 = reset
	4 = game over
	5 = options
	6 = levelEditor
	]]


	fx=love.graphics.getWidth()/800
	fy=love.graphics.getHeight()/600
	fz=(1.495*0.31)/1.495 --da moltiplicare alla x quando fai il draw di un immagine

	mouseTime=love.timer.getTime()

	--sounds
	gameOverSound = love.audio.newSource("sound/gameOver.mp3")
	winSound = love.audio.newSource("sound/win.mp3")
	bounceSound = love.audio.newSource("sound/bounce.mp3")
	wallSound = love.audio.newSource("sound/wall.mp3")
	loseSound = love.audio.newSource("sound/lose.mp3")
	fireballSound = love.audio.newSource("sound/fireball.mp3")
	magneteSound = love.audio.newSource("sound/magnete.mp3")
	triballSound = love.audio.newSource("sound/triball.mp3")
	themeMusic = love.audio.newSource("sound/theme.mp3")
	gameSong = love.audio.newSource("sound/game-song.mp3")

	--Images
	playerTexture = love.graphics.newImage("img/player.png")
	greyBlock0 = love.graphics.newImage("img/block.png")
	greyBlock1 = love.graphics.newImage("img/block2.png")
	greyBlock2 = love.graphics.newImage("img/block3.png")
	winningArrow = love.graphics.newImage("img/arrow.png")
	heart = love.graphics.newImage("img/heart.png")
	gameOverImg = love.graphics.newImage("img/gameOver.jpg")

	--button instances
	playBtn = Button.new("img/play.png",650,250,-math.pi/2,0.8,0.8,function()
																		-- level = level + 1
																		winSound:stop()
																		themeMusic:stop()
																		state = 3
																	 end,"release" )

	playMenuBtn = Button.new("img/play.png",love.graphics.getWidth()/2,love.graphics.getHeight()/2,-math.pi/2,1,1,function()
																		themeMusic:stop()
																		updateValues()
																		state = 3
																	 end,"release" )
	replayBtn = Button.new("img/replay.png",800,250,-math.pi/2,0.8,0.8,function()
																			updateValues()
																			state = 3
																			time = -1
																		end
																				,"release")
	exitBtn = Button.new("img/exit.png",600,500,-math.pi/2,0.8,0.8,function() state = 0
																																						gameSong:stop()
																																						end,"release")
	soundBtn = Button.new("img/speaker.png",600,500,-math.pi/2,0.8,0.8,function()
																		if love.audio.getVolume()==1 then
																			love.audio.setVolume(0)
																			soundBtn.img=love.graphics.newImage("img/speaker-off.png")
																		else
																			love.audio.setVolume(1)
																			soundBtn.img=love.graphics.newImage("img/speaker.png")
																		end
																	end,"release")
	--stops ball and player update
	pauseBtn = Button.new("img/pause.png",30,25,-math.pi/2,0.3,0.3,pausef,"release")
	resumeBtn = Button.new("img/play.png",650,250,-math.pi/2,0.8,0.8,pausef,"release" )
	optBtn = Button.new("img/rank.png",600,220,-math.pi/2,0.8,0.8,function() state = 5 end,"release")

	levelEditBtn = Button.new("img/cog.png",720,love.graphics.getHeight()/2,-math.pi/2,0.8,0.8,function() state = 6 end,"release")
	patternButton = Button.new("img/save.png",720*fx,love.graphics.getHeight()/2,-math.pi/2,0.8,0.8,generatePattern,"release")

	SaveBtn = Button.new("img/save.png",720*fx,love.graphics.getHeight()/4,-math.pi/2,0.8,0.8,function() writeSaves(VelSlider.value,LevelSlider.value,LivesSlider.value);updateValues();state=0 end,"release")
	CancelBtn = Button.new("img/cancel.png",720*fx,love.graphics.getHeight()/4*3,-math.pi/2,0.8,0.8,function()  state = 0 end,"release")



	bonusScoreValure = 50

	level = 1
	vel = 10

	score = 0

	--read file from love.filesystem.getSaveDirectory() directory
	--android root problems, not implemented
	values = {}
	k = 0

	--[[path = "saves.data"
	--print(love.filesystem.getSaveDirectory())
	createSaves()
	readSaves()]]

	values[0]=10
	values[1]=1
	values[2]=3

	VelSlider = {min = 1 ,max = 30, value = values[0]}--10
	LevelSlider = {min = 1 ,max = 30, value = values[1]}--1
	LivesSlider = {min = 1 ,max = 30, value = values[2]}--3

	player =
	{
		height = 80*fy,
		length = 20*fx,
		x=love.graphics.getWidth()-100*fx,
		y=love.graphics.getHeight()-(20*fy)-20,
		lives=3
	}

	end

	--variabili da resettare
	math.randomseed(os.clock()*100000000000)
	background = love.graphics.newImage("img/bg"..math.random(1,10)..".jpg")

	--animation indexes (to reset)
	ixWin=  0
	contWin = 0
		--game over animation
	img1x = 0
	img2x = love.graphics.getWidth()
	r = 255
	g = 255
	b = 255
	gameOverOnce = true
	winOnce = true

	winFontY = 0

	--title handling
	titleTime=-1
	--objects (to reset)
	--angle = 135
	playerState=2
	time =-1
	pause=false

	block =
	{
		height=40*fx,
		length=20*fy,
		distance=0*fy,
		x = 0,
		y = 0,
		life = level
	}
	--initializing blocks
	nRow=11
	nCol=15

	pxStartX = 30
	pxStartY = 30

	blockOrizon = false
	blockVertical = false
	precBlockOrizon = {}
	precBlockVertical = {}

	poligons = {}
	poligonsTime = 0

	--ball
	rad=5
	--[[ball =
	{
		radius = rad,
		y = player.y - (player.height/2)  , --math.random(love.graphics.getWidth() - rad * 4)+rad*2,
		x = player.x --math.random(love.graphics.getHeight() - rad * 4)+rad*2
	}]]

	initBall()


	--per touchscreen (mouse non può essere premuto di continuo)
	pressable = true
	precPress = false
	createBonusTable(false)

	score = 0
	aiy={}

	if not toReset then --needed here because of variables declarations but not to reset
		updateValues()

		--generate fill pattern
		pattern={}
		fullPattern()
	end

	--positioning blocks (and its relative sounds)
	positionBlocks()
end

function love.update(dt)
	lockFps(dt)
	touchscreenIssues()

	if state==1 then
		if reset then
			resetGame()
		else
			updateGame()
		end
	else
		if state== 3 then
			resetGame()
		end
	end
	--PER TEST DA ELIMINARE-----------------------------------------------------
	if love.keyboard.isDown("escape") then
    	love.audio.stop()
    	love.event.quit()
    end

end

function love.draw()

	if state==0 then
		drawMainMenu()
	else
		if state==1 then
			drawGame()
		else
			if state==2 then
				drawWin()
			else
				if state==4 then
					drawGameOver()
				else
					if state == 5 then
						drawOptions()
					else
						if state == 6 then
							drawLevelEditor()
						end
					end
				end
			end
		end
	end
	love.graphics.setFont(getFont(15))

--	love.graphics.print("state "..state.."\nFPS "..love.timer.getFPS().."\nlevel "..level.."\nlives "..player.lives.."\nlength "..tablelength(aiy),1,5)
end

function lockFps(dt)

    if dt < 1 / 60 then
       love.timer.sleep ( 1 / 60 - dt )
    end

end

--accorgimenti per il touchscreen
function touchscreenIssues()
	if love.mouse.isDown(1,2,3,4) then
		if precPress then
			pressable = false
		else
			pressable = true
		end
	end
	precPress=love.mouse.isDown(1,2,3,4)
end
