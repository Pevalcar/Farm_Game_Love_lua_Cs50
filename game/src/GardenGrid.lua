GardenGrid = Object:extend()

function GardenGrid:new(Size_x, Size_y)

    self.Garden_Grid = {}
    self.Size_x = Size_x
    self.Size_y = Size_y
    self.crop_timer = math.random(1, 10)
    -- load Json file crops
    file = assert(io.open("assets/data/crops.json", "r"))
    local constent = file:read("*a")
    file:close()
    Crops_lib_info = json.decode(constent)

    -- Create Garden 
    for i = 1, Size_x do
        for j = 1, Size_y do
            local grid_cell = GardenCell(i, j, nil)
            table.insert(self.Garden_Grid, grid_cell)
        end
    end

    for i, cell in ipairs(self.Garden_Grid) do
        local crops_info = Crops_lib_info[math.random(1, 6)]

        local randon = math.random(1, 2)
        if randon == 1 then
            cell:setCrop(crops_info)

        end
    end

end

function GardenGrid:update(dt)
    for _, gardeCell in ipairs(self.Garden_Grid) do
        if gardeCell.crop ~= nil then

            gardeCell.crop:update(dt)
            if love.mouse.isDown(1) then

                if gardeCell:Hover() then
                    if gardeCell.crop:isHavester() then
                        -- por ahora solo reinicia todo
                        gardeCell.crop:harvestCrop(Player.lvlOfHarvest * SpeedMultiplier)
                    end
                end
            end
        end

    end
    -- timer for crops
    local emptyCells = {}

    for i, gardenCell in ipairs(self.Garden_Grid) do
        if gardenCell.crop == nil then
            table.insert(emptyCells, gardenCell)
        end
    end
    if #emptyCells > 0 then
        self.crop_timer = self.crop_timer - dt
        if self.crop_timer <= 0 then

            -- Si hay celdas disponibles, elegir una al azar
            local selectedCell = emptyCells[math.random(1, #emptyCells)]
            self.crop_timer = math.random(1, 10)
            selectedCell:setCrop(Crops_lib_info[math.random(1, 6)])
        end

    end

end

function GardenGrid:draw()
    love.graphics.setColor(69 / 255, 153 / 255, 31 / 255)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(255, 255, 255)

    for i, gardeCell in ipairs(self.Garden_Grid) do
        gardeCell:draw()
    end

end

function GardenGrid:save()
    -- save data
    local data = {}
    data.x = self.Size_x
    data.y = self.Size_y
    data.crop_timer = self.crop_timer
    data.Garden_Grid = {}
    for i, gardenCell in ipairs(self.Garden_Grid) do

        if gardenCell.crop ~= nil then
            local crop = gardenCell:save()
            data.Garden_Grid[i] = crop
        else
            data.Garden_Grid[i] = "empty"
        end
    end

    -- serialized = lume.serialize(data)
    return data
end

function GardenGrid:load(data)
    if data == nil then
        return
    end
    self.Size_x = data.x
    self.Size_y = data.y
    self.crop_timer = data.crop_timer
    for _, gardenCell in ipairs(data.Garden_Grid) do
        if gardenCell ~= "empty" then
            self.Garden_Grid[_]:load(gardenCell)
        end
    end

end
