if not _G.FAC then
        dofile(ModPath .. 'scripts/setup.lua')
end

-- dont need to waste time if mod is off
if not FAC.settings.enabled then
        return
end

local mvec3_distance = mvector3.distance
local framecount = 0
-- update our contours every 5 frames because its unnoticeable compared to 1
Hooks:PostHook(
        GameSetup,
        'update',
        'FAC_update',
        function(self, t, dt)
                -- only update the contours every 5 frames
                log(framecount)
                if framecount < 5 then
                        framecount = framecount + 1
                        return
                else
                        framecount = 0
                end

                local player = managers.player:player_unit()
                local playerpos = player and alive(player) and player:position()

                if not playerpos then return end

                for key, box in pairs(FAC:getboxes()) do
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
                                                -- also a fallback for if distance somehow fails
                                                boxcontour:_upd_opacity(100)
                                        end
                                end
                        else
                                -- remove invalid boxes from the list
                                FAC:removebox(key)
                        end
                end
        end
)
