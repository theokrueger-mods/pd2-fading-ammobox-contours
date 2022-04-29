local mvec3_distance = mvector3.distance
local framecount = 0
-- update our contours every 5 frames because its unnoticeable compared to 1
Hooks:PostHook(
        GameSetup,
        'update',
        'FAC_update',
        function(self, t, dt)
                -- only update the contours every 5 frames
                if framecount < 5 then
                        framecount = framecount + 1
                        return
                else
                        framecount = 0
                end

                local player = managers.player:player_unit()
                local playerpos = player and alive(player) and player:position()

                if not playerpos then return end

                for key, box in pairs(FAC_Boxes) do
                        if box == nil then return end

                        -- please dont try to do things to invalid box units
                        if alive(box) and box._active then
                                local boxpos = box:position()
                                local boxcontour = box:pickup()._unit:contour()
                                if boxpos and boxcontour then
                                        local distance = mvec3_distance(playerpos, boxpos)
                                        if distance > 2000 then
                                                boxcontour:_upd_opacity(0)
                                        else
                                                boxcontour:_upd_opacity(100)
                                        end
                                end
                        else
                                -- remove invalid boxes from the list
                                boxes[key] = nil
                        end
                end
        end
)
