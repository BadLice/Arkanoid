Ball = {}
	Ball.__index = Ball --used for function calls

	function Ball.new(rad,x,y,angle,ps)
		local self = setmetatable({}, Ball)
		--setting power up type
		self.radius = rad
		self.y = y  --math.random(love.graphics.getWidth() - rad * 4)+rad*2,
		self.x = x --math.random(love.graphics.getHeight() - rad * 4)+rad*2
		self.angle = angle
		self.playerState=ps
		self.canBounce = true
		self.playerPositionDif = 0 --used for positioning ball on player when it's magnetic
		--self.precPlayerVertical
		return self
	end

function Ball.bounce(ball)

	if ball.playerState==1 then --side bounce
		if ball.x <= 0 then
	     ball.angle = 180 - ball.angle
	     wallSound:play()
		else
			if ball.y <= 0 or ball.y >= love.graphics.getHeight() then
	     		ball.angle = 360 - ball.angle
	     		wallSound:play()
	    	end
	    end

	    --block bounce and hit
	    i=0
	    for _,o in ipairs(block)do
	    	i = i+1
			if o.life>0 then

				blockOrizon = ball.x >= o.x and ball.x <= o.x+block.length
				blockVertical = ball.y >= o.y and ball.y <= o.y+block.height

				if blockOrizon and blockVertical then
					--play hit sound
					o.hit:play()
					o.life = o.life - 1

					fireballHitf()

					--start printing score gained (in draw function)
					o.pointEffect = true
					o.pointEffectValue = 20

					if o.life <= 0 then
						o.alive = false
						spawnBonus(o.x,o.y)
						--start printing score gained (in draw function)
						o.pointEffect = true
						o.pointEffectValue = 50
					end

					if not fireball then
						if precBlockOrizon[i] and not precBlockVertical[i] then
							ball.angle = 360 - ball.angle
						else
							if not precBlockOrizon[i] and precBlockVertical[i] then
								ball.angle = 180 - ball.angle
							else
								ball.angle = 180 - ball.angle
							end
						end
					end
					score = score + o.pointEffectValue
				end
			end
			precBlockOrizon[i] = blockOrizon
			precBlockVertical[i] = blockVertical
		end

		--player bounce
		ball.playerOrizon = ball.x >= player.x and ball.x <= (player.x+player.length)
		ball.playerVertical = ball.y >= player.y and ball.y <= (player.y+player.height)

		magneteTimer()

		if ball.playerVertical and ball.playerOrizon then

			if ball.canBounce then

				bounceSound:play()
				ball.angle=180-ball.angle

				--magnete bonus handler
				magneteHandler(ball)
				fireballHandler()
			end
			ball.canBounce = false
		else
			ball.canBounce = true
		end


		ball.precPlayerOrizon = ball.playerOrizon
		ball.precPlayerVertical = ball.playerVertical

		ball.x = ball.x+(1 * math.cos(ball.angle * math.pi /180))
		ball.y = ball.y+(1 * math.sin(ball.angle * math.pi /180)*-1)
	else --at start until player press a key
		if (ball.playerState==2) or (ball.playerState==3) then
			if ball.playerState==2 then
				ball.y=player.y+player.height/2
				ball.x=player.x-ball.radius
				ball.angle = 135
			end
			if ball.playerState==3 then
				ball.y=player.y+ball.playerPositionDif
				ball.x=player.x-ball.radius
				ball.angle = 135
			end
			if love.mouse.isDown( 0,1,2,3,4 ) then
				if pressable then
					ball.playerState=1
					ball.angle = 135
				end
			end
		end
	end
end

function initBall()
	balls={}
	ballIndex=1
	balls[ballIndex] = Ball.new(rad,player.x,player.y - (player.height/2),135,playerState)
end

function resetBall()
	ballIndex=1
	initBall()
end
