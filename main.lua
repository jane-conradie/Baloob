push = require 'push'

Class = require 'class'

-- import our player Baloob
require 'Baloob'

-- import ground object
require 'Ground'

-- dimensions we want
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- adding our virtual dimensions
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- load the background image
local background = love.graphics.newImage('assets/scenery/background.png')
local backgroundScroll = 0

-- load the ground
local ground = love.graphics.newImage('assets/scenery/ground.png')
local groundScroll = 0

-- speeds at which to scroll each scenery item
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- point at which to return each item back to 0 once it reaches this
local BACKGROUND_LOOP_POINT = 413

local baloob = Baloob()
local groundObject = Ground()

local deltaTime = 0

function love.load()
    -- setting filter to nearest, nearest to give a retro look
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle("Baloob")

    -- settings for screen
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- seed the RNG
    math.randomseed(os.time())

    -- creating sound table for game
    sounds = {
        ['music'] = love.audio.newSource('assets/sounds/music.mp3', 'static')
    }

    -- set looping of main music to true
    sounds['music']:setLooping(true)
    -- sounds['music']:play()
end

function love.update(dt)
    -- update the scenery items to scroll per frame for parallax scrolling
    -- will count up little by little (+0.xx), will hit each whole number twice (1, 1, 2, 2) until it reaches 413 and reset to 0
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOP_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOP_POINT

    -- setting variable so dt can be passed to other classes
    deltaTime = dt

    -- TO DO FIND BETTER WAY OF DOING THIS
    if love.keyboard.isDown('down') then
        baloob:move('down', dt)
    elseif love.keyboard.isDown('up') then
        baloob:move('up', dt)
    end

    -- update ground x positions
    groundObject:update(dt, baloob)
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.draw()
    push:start()

    -- draw background at top left of screen
    love.graphics.draw(background, -backgroundScroll, 0)

    -- draw ground a bit higher than end of screen
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 14)

    -- render player 
    baloob:render(deltaTime)

    -- every seconds interval spawn another piece of ground
    groundObject:render(deltaTime)

    push:finish()
end
