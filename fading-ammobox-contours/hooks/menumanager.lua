if not _G.FAC then
        dofile(ModPath .. 'scripts/setup.lua')
end

-- add menu loc
Hooks:Add(
        'LocalizationManagerPostInit',
        'FAC_LocalizationManagerPostInit',
        function(loc)
                for _, filename in pairs(file.GetFiles(FAC.i18n)) do
                        local str = filename:match('^(.*).json$')
                        if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
                                loc:load_localization_file(FAC.i18n .. filename)
                                break
                        end
                end
                -- load fallback lang and do not overwrite
                loc:load_localization_file(FAC.i18n .. 'english.json', false)
        end
)

-- menu callbacks
Hooks:Add(
        'MenuManagerInitialize',
        'FAC_MenuManagerInitialize',
        function(menu)
                -- save setting cblk
                MenuCallbackHandler.FAC_update = function(self, item)
                        local name = item._parameters.name:sub(5)
                        log('name: ' .. name .. '\nval: ' .. item:value())
                        if item._type == 'toggle' then
                                FAC.settings[name] = item:value() == 'on'
                        elseif item._type == 'slider' then
                                local num = tonumber(item:value())
                                -- round settings to integer is needed for the value
                                if FAC.settings.int[name] then
                                        num = math.floor(num + 0.5)
                                end
                                FAC.settings[name] = num
                        end
                        FAC:save_settings()
                end

                MenuHelper:LoadFromJsonFile(FAC.path .. 'menus/mainmenu.json', FAC, FAC.settings)
        end
)
