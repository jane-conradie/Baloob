Ground = Class {}

local collision = false

function Ground:init()
    -- load ground image
    self.image = love.graphics.newImage('assets/scenery/ground.png')

    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH
    self.y = 0

    self.quad = 0

    self.horizontalGap = 40
    self.verticalGap = 60

    self.speed = 120
end

function Ground:render(pieces)
    -- procedurally spawn pieces of ground that will be randomised based on gap width, gap height and ground length
    -- pieces will spawn at randomised intervals
    -- randomise quad
    -- using new quad function to randomise length of ground pieces
    self.quad = love.graphics.newQuad(0, 0, math.floor(math.random(30, 150)), self.height, self.image)

    for k, pair in pairs(pieces) do
        -- check previous ground to find x position
        self.x = pair.x + pair.width + self.horizontalGap + math.floor(math.random(1, 10))
    end

    -- loop through table to spawn new piece
    for k, pair in pairs(pieces) do
        love.graphics.draw(self.image, pair.quad, pair.x, pair.y)
    end
end

function Ground:getPiece()
    -- capturing quad dimensions for extracting width later
    dimensions = {self.quad:getViewport()}

    return {
        -- 40 and 80 for constraints!
        y = math.floor(math.random(40, VIRTUAL_HEIGHT - 80)),
        x = self.x,
        width = dimensions[3],
        height = self.height,
        quad = self.quad
    }
end

function Ground:update(dt, pieces)
    -- make ground pieces move to left every frame 
    for k, pair in pairs(pieces) do
        pair.x = pair.x - self.speed * dt
    end

    -- cannot remove pairs in previous loop as will result in buggy behaviour
    -- remove ground after exits screen
    for k, pair in pairs(pieces) do
        if pair.x + pair.width < 0 then
            table.remove(pieces, k)
        end
    end
end
