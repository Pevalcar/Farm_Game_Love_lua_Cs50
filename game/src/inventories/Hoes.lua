Hoe = Object:extend()

function Hoe:new(hoe_lvl, father)
    self.Hoe = nil
    self.frame = hoe_lvl
    -- Hoe spritesheet

    self.img = love.graphics.newImage("assets/img/hoe/Hoes.png")

    self.img:setFilter("nearest", "nearest")
    self.width = self.img:getWidth() / 7
    self.height = self.img:getHeight()
    self.frames = {}
    for i = 0, 6 do
        table.insert(self.frames,
            love.graphics.newQuad(i * 48, 0, self.width, self.height, self.img:getWidth(), self.height))
    end

    -- Load hoe info
    file = assert(io.open("assets/data/hoes.json", "r"))
    local constent = file:read("*a")
    file:close()
    self.Hoes_lib_info = json.decode(constent)

    self.hoe_info = self.Hoes_lib_info[self.frame]
end

function Hoe:draw()
    love.graphics.draw(self.img, self.frames[self.frame], self.x, self.y)
end

function Hoe:save()
    return {
        hoe_info = self.hoe_info
    }

end

function Hoe:load(data)
    if data == nil then
        return
    end
    self.hoe_info = data.hoe_info
end
