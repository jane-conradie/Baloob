Ground = Class {}

function Ground:init()
    -- load ground image
    self.image = love.graphics.newImage('assets/scenery/ground.png')

    self.height = self.image:getHeight()

    self.x = 200
    self.y = 0

    self.quad = 0

    self.timer = 0
    self.spawnInterval = 1

    self.pieces = {}

    self.horizontalGap = 40
    self.verticalGap = 60

    self.speed = 40
end

function Ground:render(dt)
    -- update the timer
    self.timer = self.timer + dt
    -- procedurally spawn pieces of ground that will be randomised based on gap width, gap height and ground length
    -- pieces will spawn at randomised intervals

    -- randomise quad
    -- using new quad function to randomise length of ground pieces
    self.quad = love.graphics.newQuad(0, 0, math.floor(math.random(30, 150)), self.height, self.image)

    -- check previous ground to find x position
    for k, pair in pairs(self.pieces) do
        -- check if previous pair is 0 which means this is the first ground item so spawn after half of screen
        if not pair.x then
            self.x = VIRTUAL_WIDTH / 2 + math.floor(math.random(1, 10))
        else
            self.x = pair.x + pair.width + self.horizontalGap + math.floor(math.random(1, 10))
        end
    end

    -- capturing quad dimensions for extracting width later
    dimensions = {self.quad:getViewport()}

    if self.timer > self.spawnInterval then
        -- add ground piece to table
        table.insert(self.pieces, {
            -- 40 and 80 for constraints!
            y = math.floor(math.random(40, VIRTUAL_HEIGHT - 80)),
            x = self.x,
            width = dimensions[3],
            quad = self.quad
        })

        -- reset timer
        self.timer = 0

        -- send x and y coordinates to ducky for spawning TO DO

    end

    -- loop through table to spawn new piece
    for k, pair in pairs(self.pieces) do
        love.graphics.draw(self.image, pair.quad, pair.x, pair.y)
    end
end

function Ground:update(dt, player)
    -- make ground pieces move to left every frame 
    for k, pair in pairs(self.pieces) do
        pair.x = pair.x - self.speed * dt
    end

    -- cannot remove pairs in previous loop as will result in buggy behaviour
    -- remove ground after exits screen
    for k, pair in pairs(self.pieces) do
        if pair.x + pair.width < 0 then
            table.remove(self.pieces, k)
        end
    end
end
