-- execute this script once
if _G.FAC_Boxes then return end

-- list of the units of every active box
_G.FAC_Boxes = {}

-- add all new boxes to the list
Hooks:PostHook(
        AmmoClip,
        'init',
        'FAC_init',
        function(self, unit)
                FAC_Boxes[unit:key()] = unit
        end
)

-- remove all old boxes from the list
Hooks:PreHook(
        AmmoClip,
        'delete_unit',
        'FAC_delete_unit',
        function(self)
                FAC_Boxes[self._unit:key()] = nil
        end
)
