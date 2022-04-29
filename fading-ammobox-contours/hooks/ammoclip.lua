if not _G.FAC then
        dofile(ModPath .. 'scripts/setup.lua')
end

-- add all new boxes to the list
Hooks:PostHook(
        AmmoClip,
        'init',
        'FAC_init',
        function(self, unit)
                FAC.boxes[unit:key()] = unit
        end
)

-- remove all old boxes from the list
Hooks:PreHook(
        AmmoClip,
        'delete_unit',
        'FAC_delete_unit',
        function(self)
                FAC.boxes[self._unit:key()] = nil
        end
)
