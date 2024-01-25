Bird = Class {}

local SPEED = 200

function Bird:init()
    self.image = love.graphics.newImage('assets/sprites/bird.png')

    self.width = 18
    self.height = 18

    self.x = 0
    self.y = 0
end

function Bird:update(dt, birds)
    -- make birds move to left every frame 
    for k, bird in pairs(birds) do
        bird.x = bird.x - SPEED * dt
    end

    -- cannot remove pairs in previous loop as will result in buggy behaviour
    -- remove bird after exits screen
    for k, bird in pairs(birds) do
        if bird.x + self.width < 0 then
            table.remove(birds, k)
        end
    end

end

function Bird:render(birds)
    for k, bird in pairs(birds) do
        sounds['bird']:play()
        love.graphics.draw(self.image, bird.x, bird.y, 0, -1, 1, self.width, 0)
    end
end

function Bird:getBird(player)
    -- spawning at player y location to force player to dodge bird
    return {
        y = player.y,
        x = VIRTUAL_WIDTH + self.width,
        width = self.width,
        height = self.height
    }
end
