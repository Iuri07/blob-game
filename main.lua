local anim8 = require './anim8/anim8'
local animations = {}
local image
local player
local flip =1

function setCycle(duration)
	player.cycle.flag = true
	player.cycle.start = love.timer.getTime()
	player.cycle.duration = duration
end

function love.load()
	image = love.graphics.newImage("pixelArt/blob.png")
	local g = anim8.newGrid(64, 40, image:getWidth(), image:getHeight())
	player = {
		spriteSheet = image,
		x=100,
		y=0,
		speed = 100,
		direction = 1,
		animations = {
			idle = anim8.newAnimation(g('2-3',1), 0.25),
			walk = anim8.newAnimation(g('5-9',1), 0.1),
			tackle = anim8.newAnimation(g('42-43',1), {0.15, 0.075}),
			shootStart = anim8.newAnimation(g('28-31',1), {0.2, 0.1, 0.1, 0.2}),
			shootIdle = anim8.newAnimation(g('32-33',1), 0.2),
			shootEnd = anim8.newAnimation(g('38-41',1), {0.2, 0.1, 0.1, 0.2}),
			shootWalk = anim8.newAnimation(g('34-37',1), {0.1, 0.12, 0.12, 0.12}),
		},
		cycle = {
			flag = false, 
			start = 0, 
			duration = 0
		}
	}
	player.animation = player.animations.idle
end

function love.update(dt)
	start = love.timer.getTime()
	if love.keyboard.isDown("up") and love.keyboard.isDown("right") then
		player.x = player.x + dt*player.speed
		player.direction = 1 
		player.animation = player.animations.shootWalk
	elseif love.keyboard.isDown("right") then
		player.x = player.x + dt*player.speed
		player.direction = 1 
		player.animation = player.animations.walk
	elseif love.keyboard.isDown("left") then
		player.x = player.x - dt*player.speed
		player.direction = -1 
		player.animation = player.animations.walk
	elseif love.keyboard.isDown("up") then
		if player.cycle.flag and love.timer.getTime() >= player.cycle.duration + player.cycle.start then
			player.animation = player.animations.shootIdle
		end
	else
		if not player.cycle.flag then 
			player.animation = player.animations.idle
		end
		if player.cycle.flag and love.timer.getTime() >= player.cycle.duration + player.cycle.start then
			player.animation = player.animations.idle
			player.cycle.flag = false
		end

	end
	
	if love.keyboard.isDown("w") then
		player.y = y-0.5
	elseif love.keyboard.isDown("s") then
		y = y+0.5
	end

	player.animation:update(dt)
end

function love.keypressed(key)
   	if key == "escape" then
    	love.event.quit()
   	elseif key == "down" then
		player.animation = player.animations.tackle
		if not player.cycle.flag then	
			player.animation:gotoFrame(1)
		end
		setCycle(0.2)
   	elseif key == "up" then
		player.animation = player.animations.shootStart
		if not player.cycle.flag then
			player.animation:gotoFrame(1)
			setCycle(0.5)
		end
	end
end

function love.keyreleased(key)
   	if key == "up" then
		player.animation = player.animations.shootEnd
		player.animation:gotoFrame(1)
		setCycle(0.5)
   	end
end

function love.draw()
    love.graphics.setBackgroundColor(120,120,120)
    -- local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    -- love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], x, 100, 0, flip, 1, 32, 0)
    player.animation:draw(player.spriteSheet, player.x, 100, 0, player.direction, 1, 32, 0)
end