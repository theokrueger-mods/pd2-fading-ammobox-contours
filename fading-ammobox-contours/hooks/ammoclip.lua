if not _G.FAC then
        dofile(ModPath .. 'scripts/setup.lua')
end

-- dont need to waste time if mod is off
if not FAC.settings.enabled then
        return
end

local ammo_pickup_id = Idstring('units/pickups/ammo/ammo_pickup')

-- user settings for outlines as default
local apply_box_outlines = FAC.settings.apply_box_outlines
local apply_throwable_outlines = FAC.settings.apply_throwable_outlines
-- respect vanilla outline settings (but wait until they load)
Hooks:PostHook(
        Setup,
        'init_managers',
        'FAC_SU_init_managers',
        function(self)
                apply_box_outlines = apply_box_outlines and managers.user:get_setting('ammo_contour')
                apply_throwable_outlines = apply_throwable_outlines and managers.user:get_setting('throwable_contour')
        end
)

-- add all new boxes to the list
Hooks:PostHook(
        AmmoClip,
        'init',
        'FAC_AC_init',
        function(self, unit)
                -- putting this check here, if if it means running the following snippet of code twice, saves runtime because we dont have to check every update cycle if it is a box or not.
                local is_box = self._unit:name() == ammo_pickup_id
                if is_box == apply_box_outlines or is_box ~= apply_throwable_outlines then
                        FAC:addbox(unit)
                end
        end
)

-- remove all old boxes from the list
Hooks:PreHook(
        AmmoClip,
        'delete_unit',
        'FAC_AC_delete_unit',
        function(self)
                FAC:removebox(self._unit:key())
        end
)

