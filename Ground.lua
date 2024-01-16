Ground = Class {}

function Ground:init()
    -- load ground image
    self.image = love.graphics.newImage('assets/scenery/ground.png')

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function Ground:render()
    -- procedurally spawn pieces of ground that will be randomised based on gap width, gap height and ground length
    -- pieces will spawn at randomised intervals

end
