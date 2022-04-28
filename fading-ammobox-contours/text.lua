-- run this file only once
if _G.boxes then
        return
end

_G.boxes = {}

Hooks:PostHook(
        ContourExt,
        'update',
        'FAC_CE_update',
        function(self, unit, t, dt)
                local player = managers.player:player_unit()
                if not alive(player) then return end
                local mvec3_distance = mvector3.distance
                for k, v in ipairs(boxes) do
                        if not v._active then
                                boxes[k] = nil
                        else
                                local distance = mvec3_distance(player:position(), v:position())

                                if distance > 2000 then
                                        v:pickup()._unit:contour():_upd_opacity(0)
                                else
                                        v:pickup()._unit:contour():_upd_opacity(100)
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
                table.insert(boxes, unit)
        end
)

