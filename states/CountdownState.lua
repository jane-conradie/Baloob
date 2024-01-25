CountdownState = Class {
    __includes = BaseState
}

-- set a countdown time, 1 second
COUNTDOWN_TIME = 0.75

function CountdownState:init()
    self.count = 3
    self.timer = 0
end

function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > COUNTDOWN_TIME then
        -- set count one less until 0
        if self.count > 0 then
            self.count = self.count - 1

            sounds['start']:play()
        elseif self.count == 0 then
            -- switch to play state
            sounds['go']:play()

            gStateMachine:change('play')
        end

        -- reset timer to 0 for next second countdown
        self.timer = 0
    end
end

function CountdownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, VIRTUAL_HEIGHT / 2 - 56, VIRTUAL_WIDTH, 'center')
end
