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
local fadeout_end = FAC.settings.fadeout_end * 100
local fadeout_end_d = math.abs(fadeout_end - fadeout_start)

local start_colour = {
        FAC.settings.start_colour_r,
        FAC.settings.start_colour_g,
        FAC.settings.start_colour_b
}
local end_colour = {
        FAC.settings.end_colour_r,
        FAC.settings.end_colour_g,
        FAC.settings.end_colour_b
}
local end_colour_d = {
        start_colour[1] - end_colour[1],
        start_colour[2] - end_colour[2],
        start_colour[3] - end_colour[3],
}

local function update_box_contour(boxcontour, distance)
        if distance > fadeout_end then
                boxcontour:_upd_opacity(0)
                return
        end

        boxcontour:_upd_opacity(100)

        local colour
        if distance < fadeout_start then
                -- save calcs
                colour = Color(
                        255,
                        start_colour[1],
                        start_colour[2],
                        start_colour[3]
                ) / 255
        else
                -- (start - end) * factor = colour it should be
                local factor = 1 - ((distance - fadeout_start) / fadeout_end_d)
                colour = Color(
                        255,
                        end_colour[1] + math.floor(end_colour_d[1] * factor),
                        end_colour[2] + math.floor(end_colour_d[2] * factor),
                        end_colour[3] + math.floor(end_colour_d[3] * factor)
                ) / 255
        end

        boxcontour:change_color('deployable_selected', colour)
end

-- update our contours every 5 frames because its unnoticeable compared to 1
Hooks:PostHook(
        GameSetup,
        'update',
        'FAC_GS_update',
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
                                        update_box_contour(
                                                boxcontour,
                                                mvec3_distance(playerpos, boxpos)
                                        )
                                end
                        else
                                -- remove invalid boxes from the list
                                FAC:removebox(key)
                        end
                end
        end
)
