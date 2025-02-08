function love.load()
    Object = require "lib/classic"
    json = require "lib/json"
    require "src/Crop"
    require "src/Player"
    require "src/GardenCell"
    require "src/GardenGrid"
    require "src/CircularBar"
    lume = require "lib/lume"

    Player = Player()
    -- load Json file
    file = assert(io.open("assets/data/crops.json", "r"))
    local constent = file:read("*a")
    file:close()
    Crops_lib_info = json.decode(constent)
    -- Create crops garden grid
    Garden_Grid = GardenGrid(6, 6)

    if love.filesystem.getInfo("save.txt") then
        load()
    end

end

function love.update(dt)
    Garden_Grid:update(dt)

end

function love.draw()
    Garden_Grid:draw()

    love.graphics.print("Player lvl harvest " .. Player.lvlOfHarvest, 100, 100)
    love.graphics.print("Player exp  " .. Player.xp .. "/" .. Player.nextlvl, 100, 110)
end

function love.keypressed(key)
    if key == "f1" then
        save()
    elseif IS_DEBUG and key == "f2" then
        love.event.quit("restart")
    end

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
