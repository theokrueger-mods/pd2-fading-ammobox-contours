local player = managers.player:player_unit()
if alive(player) then
        local pickups = World:find_units_quick("all", 23)
        local mvec3_distance = mvector3.distance
        for _, unit in ipairs(pickups) do
		if alive(unit) and unit:pickup() then
                        local distance = mvec3_distance(player:position(), unit:position())
                        log(distance)
                        if distance > 2000 then
                                unit:pickup()._unit:contour():_upd_opacity(0)
                        else
                                unit:pickup()._unit:contour():_upd_opacity(100)
                        end
		end
	end
end
