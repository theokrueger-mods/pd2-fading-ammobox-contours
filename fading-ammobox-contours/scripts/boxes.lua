-- functionise the boxes so we dont abuse globals

local boxes = {}

function FAC:addbox(unit)
        boxes[unit:key()] = unit
end

function FAC:removebox(key)
        boxes[key] = nil
end

function FAC:getboxes()
        return boxes
end
