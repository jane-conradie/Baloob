push = require 'push'

Class = require 'class'

-- import our player Baloob
require 'Baloob'

-- import ground object
require 'Ground'

-- a basic StateMachine class which will allow us to transition to and from
-- game states smoothly and avoid monolithic code in one file
require 'StateMachine'

-- all states our StateMachine can transition between
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
-- require 'states/ScoreState'
require 'states/TitleState'

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

local collision = false

function love.load()
    -- setting filter to nearest, nearest to give a retro look
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle("Baloob")

    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('assets/fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('assets/fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('assets/fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('assets/fonts/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

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

    -- initialize state machine with all state-returning functions and set to title
    gStateMachine = StateMachine {
        ['title'] = function()
            return TitleScreenState()
        end,
        ['countdown'] = function()
            return CountdownState()
        end,
        ['play'] = function()
            return PlayState()
        end,
        ['score'] = function()
            return ScoreState()
        end
    }
    gStateMachine:change('title')

    -- initialize input table
    love.keyboard.keysPressed = {}

    -- intitialize mouse input table
    love.mouse.buttonsPressed = {}
end

-- if button was pressed this function will fire
function love.keypressed(key)
    -- add key to table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

-- if mouse was clicked this function will fire
function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

-- bool function to query if a certain key was pressed in frame
-- will check input table 
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

-- bool function to query if mouse was pressed in frame
-- will check input table 
function love.mouse.wasPressed(key)
    return love.mouse.buttonsPressed[key]
end

function love.update(dt)
    -- update the scenery items to scroll per frame for parallax scrolling
    -- will count up little by little (+0.xx), will hit each whole number twice (1, 1, 2, 2) until it reaches 413 and reset to 0
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOP_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOP_POINT

    -- this will trigger instead of updating each class
    gStateMachine:update(dt)

    -- reset keys pressed for next frame
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.draw()
    push:start()

    -- draw background at top left of screen
    love.graphics.draw(background, -backgroundScroll, 0)

    -- this will happen instead of calling ground and baloob render, will run render of whichever state we are in
    gStateMachine:render()

    -- draw ground a bit higher than end of screen
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 14)

    push:finish()
end
