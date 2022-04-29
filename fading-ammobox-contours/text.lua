if _G.boxes then
        return
end

_G.boxes = {}
local mvec3_distance = mvector3.distance
Hooks:PostHook(
        ContourExt,
        'update',
        'FAC_CE_update',
        function(self, unit, t, dt)
                local player = managers.player:player_unit()
                local playerpos = player and alive(player) and player:position()
                if playerpos then
                        for key, box in pairs(boxes) do
                                if box == nil then return end
                                if alive(box) and box._active then
                                        local boxpos = box:position()
                                        local boxcontour = box:pickup()._unit:contour()
                                        if boxpos and boxcontour then
                                                local distance = mvec3_distance(playerpos, boxpos)
                                                if distance > 1000 then
                                                        boxcontour:_upd_opacity(0)
                                                else
                                                        boxcontour:_upd_opacity(100)
                                                end
                                        end
                                else
                                        boxes[key] = nil
                                end
                        end
                end
        end
)

Hooks:PostHook(
        AmmoClip,
        'init',
        'FAC_AC_init',
        function(self, unit)
                boxes[unit:key()] = unit
        end
)

Hooks:PreHook(
        AmmoClip,
        'delete_unit',
        'FAC_AC_delete_unit',
        function(self)
                boxes[self._unit:key()] = nil
        end
)
