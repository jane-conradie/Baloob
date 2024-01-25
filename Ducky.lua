Ducky = Class {}

function Ducky:init()
    self.image = love.graphics.newImage('assets/sprites/duck.png')

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = 0
    self.y = 0

    self.speed = 120
end

-- object that players can collect for points
function Ducky:getDuckies(piece)
    duckies = {}

    amount = math.floor(piece.width / self.width / 2)

    for i = 0, amount, 1 do
        table.insert(duckies, {
            x = piece.x + (i == 0 and 0 or (self.width * i) + (5 * i)),
            -- adding bit of margin between duck and ground
            y = piece.y - 15,
            width = self.width,
            height = self.height,
            remove = false
        })
    end

    return duckies
end

function Ducky:render(duckies)
    for j, duck in pairs(duckies) do
        for k, d in pairs(duck) do
            love.graphics.draw(self.image, d.x, d.y)
        end
    end
end

function Ducky:update(dt, duckies)
    -- make ducks move to left every frame 
    for j, duck in pairs(duckies) do
        for k, d in pairs(duck) do
            d.x = d.x - self.speed * dt
        end

    end

    -- cannot remove pairs in previous loop as will result in buggy behaviour
    -- remove duck after exits screen
    for j, duck in pairs(duckies) do
        for k, d in pairs(duck) do
            if d.x + d.width < 0 or d.remove then
                table.remove(duck, k)
            end
        end
    end
end

