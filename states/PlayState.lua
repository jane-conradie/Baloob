PlayState = Class {
    __includes = BaseState
}

function PlayState:init()
    self.baloob = Baloob()
    self.ground = Ground()
    self.bird = Bird()

    self.pieces = {}
    self.birds = {}

    self.timer = 0
    self.spawnInterval = 1

    self.score = 0
end

function PlayState:update(dt)
    -- update the timer
    self.timer = self.timer + dt

    -- spawn new ground piece
    if self.timer > self.spawnInterval then
        -- add ground piece to table
        table.insert(self.pieces, self.ground:getPiece())

        -- check that previous bird has been removed, and only 5 seconds after that has happened TO DO
        if #self.birds == 0 then
            table.insert(self.birds, self.bird:getBird(self.baloob))
            print('added bird')
        end

        -- reset timer
        self.timer = 0
    end

    -- update piece position
    self.ground:update(dt, self.pieces)

    -- check collision on ground and player
    for k, piece in pairs(self.pieces) do
        if self.baloob:collides(piece) then
            -- play sounds TO DO

            gStateMachine:change('score', {
                score = self.score
            })
        end
    end

    for k, bird in pairs(self.birds) do
        if self.baloob:collides(bird) then
            -- play sounds TO DO

            gStateMachine:change('score', {
                score = self.score
            })
        end
    end

    -- TO DO add birds as attacks

    self.bird:update(dt, self.birds)

    -- update baloob position
    self.baloob:update(dt)

    -- reset if touches ground

end

function PlayState:render()
    -- render ground
    self.ground:render(self.pieces)

    -- display score

    -- render player
    self.baloob:render()

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
