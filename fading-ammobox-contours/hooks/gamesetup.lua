if not _G.FAC then
        dofile(ModPath .. 'scripts/setup.lua')
end

-- dont need to waste time if mod is off
if not FAC.settings.enabled then
        return
end

local mvec3_distance = mvector3.distance
local update_dt = 1 / FAC.settings.updaterate
local next_update = update_dt

-- convert fadeouts from meters to centimeters
local fadeout_start = FAC.settings.fadeout_start * 100
local fadeout_end_d = math.abs(FAC.settings.fadeout_end * 100 - fadeout_start)

local function get_opacity_by_distance(distance)
        if distance < fadeout_start then
                return 0.25
        end

        if distance > fadeout_start + fadeout_end_d then
                return 0
        end

        return math.floor(1 - ((distance - fadeout_start) / fadeout_end_d))
end

-- update our contours every 5 frames because its unnoticeable compared to 1
Hooks:PostHook(
        GameSetup,
        'update',
        'FAC_update',
        function(self, t, dt)
                -- only update the contours at designated dt
                if t > next_update then
                        next_update = t + update_dt
                else
                        return
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
                                        boxcontour:_upd_opacity(
                                                get_opacity_by_distance(
                                                        mvec3_distance(playerpos, boxpos) or 0
                                                )
                                        )
                                end
                        else
                                -- remove invalid boxes from the list
                                FAC:removebox(key)
                        end
                end
        end
)
