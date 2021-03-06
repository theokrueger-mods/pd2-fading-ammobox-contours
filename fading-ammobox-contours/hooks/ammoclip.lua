if not _G.FAC then
        dofile(ModPath .. 'scripts/setup.lua')
end

-- dont need to waste time if mod is off
if not FAC.settings.enabled then
        return
end

-- add all new boxes to the list
Hooks:PostHook(
        AmmoClip,
        'init',
        'FAC_init',
        function(self, unit)
                FAC:addbox(unit)
        end
)

-- remove all old boxes from the list
Hooks:PreHook(
        AmmoClip,
        'delete_unit',
        'FAC_delete_unit',
        function(self)
                FAC:removebox(self._unit:key())
        end
)
