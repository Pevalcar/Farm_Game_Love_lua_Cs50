function love.load()
    ---
    ---libs load
    ---
    ---
    IsLoading = true
    Object = require "lib/classic"
    json = require "lib/json"
    require "src/Crop"
    require "src/Player"
    require "src/GardenCell"
    require "src/GardenGrid"
    require "src/CircularBar"
    lume = require "lib/lume"
    require "src/inventories/hoes"
    loveframes = require("lib/loveframes")
    loveframes.SetActiveSkin("Blue")
    require "src.UI.init"
    MyString = require "lib.my_string"
    -- Load hoe info
    local file = assert(io.open("assets/data/hoes.json", "r"))
    local constent = file:read("*a")
    file:close()
    Hoes_lib_info = json.decode(constent)

    Player = Player()
    -- create player
    -- Create crops garden grid
    Garden_Grid = GardenGrid(6, 6)

    if love.filesystem.getInfo("save.txt") then
        load()
    end
    SpeedMultiplier = 0.5 + Player.Hoe.hoe_info.multiplier

    UI = UI()

    local frame = loveframes.Create("list")
    frame:SetPos(10, 10)
    frame:SetSize(100, 40)

    local text = loveframes.Create("text", frame)
    text:SetText("(F1) Save Game")
    text:SetPos(20, 10)
    text:SetSize(100, 100)

    -- Credits 

    frame = loveframes.Create("list")
    frame:SetPos(10, 540)
    frame:SetSize(200, 100)

    local text2 = loveframes.Create("text", frame)
    text2:SetText("Credits : Create by Pevalcar (2025)")
    text2:SetPos(20, 10)
    text2:SetSize(100, 100)
    local button_github = loveframes.Create("button", frame)
    button_github:SetText("Github")
    button_github:SetPos(20, 10)
    button_github:SetSize(30, 30)
    button_github.OnClick = function(object)
        love.system.openURL("https://github.com/Pevalcar/")
    end
    if IS_DEBUG then

        mouse_position = loveframes.Create("text")
        mouse_position:SetPos(10, 10)
    end
    IsLoading = false
end

function love.update(dt)
    if IsLoading then
        return
    end
    Garden_Grid:update(dt)
    loveframes.update(dt)
    if IS_DEBUG then
        mouse_position:SetText("Mouse Position: " .. love.mouse.getX() .. ", " .. love.mouse.getY())
    end
end

function love.draw()
    if IsLoading then
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("Loading...", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
        return
    end

    Garden_Grid:draw()
    -- draw button

    loveframes.draw()

    if Player.Hoe ~= nil then
        Player.Hoe:draw()
    end
end

-- mouse events
function love.mousepressed(x, y, button)

    -- your code

    loveframes.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

    -- your code

    loveframes.mousereleased(x, y, button)

end

function love.keypressed(key, scancode, isrepeat)

    if key == "f1" then
        save()
    elseif IS_DEBUG then
        if key == "f2" then
            love.event.quit("restart")
        elseif key == "f3" then
            Player:setHoe()

        end
    end

    loveframes.keypressed(key, isrepeat)

end

function love.keyreleased(key)

    -- your code

    loveframes.keyreleased(key)

end

-- Used by text input object

function love.textinput(text)

    -- your code

    loveframes.textinput(text)

end

function save()
    -- save data
    local data = {}
    -- data player save
    data.player = Player:save()

    -- data garden save
    data.garden = Garden_Grid:save()
    serialized = lume.serialize(data)
    love.filesystem.write("save.txt", serialized)
end

function load()
    -- load data
    file = love.filesystem.read("save.txt")
    local data = lume.deserialize(file)

    --- add player data 
    Player:load(data.player)
    -- add garden data
    Garden_Grid:load(data.garden)

end
