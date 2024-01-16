Ground = Class {}

function Ground:init()
    -- load ground image
    self.image = love.graphics.newImage('assets/scenery/ground.png')

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.timer = 0
    self.spawnInterval = 2

    self.pieces = {}
end

function Ground:render(dt)
    -- update the timer
    self.timer = self.timer + dt
    -- procedurally spawn pieces of ground that will be randomised based on gap width, gap height and ground length
    -- pieces will spawn at randomised intervals

    -- randomise position x
    positionX = VIRTUAL_WIDTH / 2 + math.random(20, 60)

    -- randomise position y
    positionY = math.floor(math.random(40, VIRTUAL_HEIGHT - 40))

    if self.timer > self.spawnInterval then

        -- add piece to table
        table.insert(self.pieces, {
            y = positionY,
            x = positionX
        })

        -- reset timer
        self.timer = 0
    end

    -- loop through table to spawn new piece
    for k, pair in pairs(self.pieces) do
        love.graphics.draw(self.image, pair.x, pair.y)
    end
end

function Ground:update(dt)
    -- make ground pieces move to left every frame 
end
