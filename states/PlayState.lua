PlayState = Class {
    __includes = BaseState
}

function PlayState:init()
    self.baloob = Baloob()
    self.ground = Ground()
    self.bird = Bird()
    self.ducky = Ducky()

    self.pieces = {}
    self.birds = {}
    self.duckies = {}

    self.timer = 0
    self.spawnInterval = 1

    self.score = 0
end

function PlayState:update(dt)
    -- update the timer
    self.timer = self.timer + dt

    piece = self.ground:getPiece()

    -- spawn new ground piece
    if self.timer > self.spawnInterval then
        -- add ground piece to table
        table.insert(self.pieces, piece)

        -- send in ground piece to ducky for spawn location
        table.insert(self.duckies, self.ducky:getDuckies(piece))

        -- check that previous bird has been removed then only spawn another bird
        if #self.birds == 0 then
            table.insert(self.birds, self.bird:getBird(self.baloob))
        end

        -- reset timer
        self.timer = 0
    end

    -- update piece position
    self.ground:update(dt, self.pieces)

    -- update the ducks' positions
    self.ducky:update(dt, self.duckies)

    -- check collision on ground and player
    for k, piece in pairs(self.pieces) do
        if self.baloob:collides(piece) then
            sounds['pop']:play()

            gStateMachine:change('score', {
                score = self.score
            })
        end
    end

    -- collision on duck and player
    for j, duck in pairs(self.duckies) do
        for k, d in pairs(duck) do
            if self.baloob:collides(d) then
                sounds['pickup']:play()

                -- add 1 per duck collected
                self.score = self.score + 1

                -- remove duck
                d.remove = true
            end
        end
    end

    -- collision on player and bird
    for k, bird in pairs(self.birds) do
        if self.baloob:collides(bird) then
            sounds['pop']:play()

            gStateMachine:change('score', {
                score = self.score
            })
        end
    end

    -- update bird position
    self.bird:update(dt, self.birds)

    -- update baloob position
    self.baloob:update(dt)

    -- reset if we get to the ground or touch roof
    if self.baloob.y > VIRTUAL_HEIGHT - 32 or self.baloob.y < 0 then
        sounds['pop']:play()

        gStateMachine:change('score', {
            score = self.score
        })
    end
end

function PlayState:render()
    -- render ground
    self.ground:render(self.pieces)
    -- render duckies
    self.ducky:render(self.duckies)

    -- display score
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.score), 10, 10, VIRTUAL_WIDTH)

    -- render player
    self.baloob:render()

    -- render bird
    self.bird:render(self.birds)
end

-- enter play state and scroll background
function PlayState:enter()
    scrolling = true
end

-- exit play state and freeze ground
function PlayState:exit()
    scrolling = false
end
