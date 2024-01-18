Baloob = Class {}

local bopSpeed = 5
local bopDirection = 'down'
local bopStoppingPoint = 2

local baloobYPosition = 0

local GRAVITY = 50

-- table for Baloob containing its properties
function Baloob:init()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- load in image
    self.image = love.graphics.newImage('assets/sprites/baloob_um.png')

    -- get image dimensions
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- where you want this sprite to spawn, in this case center in screen
    -- take into account image width and height as well
    self.x = VIRTUAL_WIDTH / 2 - 100
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    -- store initial baloob's y position
    baloobYPosition = self.y
end

-- this will trigger every frame
function Baloob:render(dt)
    -- adding little bop animation to make baloob feel more alive
    if bopDirection == 'down' then
        if self.y < (baloobYPosition + bopStoppingPoint) then
            self.y = self.y + bopSpeed * dt
        else
            bopDirection = 'up'
        end
    else
        if self.y > (baloobYPosition - bopStoppingPoint) then
            self.y = self.y - bopSpeed * dt
        else
            bopDirection = 'down'
        end
    end

    -- make baloon bop up and down to give some animation and realism
    love.graphics.draw(self.image, self.x, self.y)
end

function Baloob:move(direction, dt)
    if direction == 'down' then
        self.y = self.y + GRAVITY * dt
    else
        self.y = self.y - GRAVITY * dt
    end

    -- reset y position for baloon bopping
    baloobYPosition = self.y
end
