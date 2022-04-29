-- add menu loc
Hooks:Add(
        'LocalizationManagerPostInit',
        'FAC_LocalizationManagerPostInit',
        function(loc)
                for _, filename in pairs(file.GetFiles(FAC.i18n)) do
                        local str = filename:match('^(.*).json$')
                        if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
                                loc:load_localization_file(OLIB.i18n .. filename)
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
                -- save settings cblk
                MenuCallbackHandler.FAC_update = function(self, item)
                        if item._type == 'toggle' then
                                FAC.settings[item._parameters.name] = item:value() == 'on'
                        elseif item._type == 'slider' then
                                FAC.settings[item._parameters.name] = math.floor(tonumber(item:value()) + 0.5)
                        end
                        FAC:savesettings()
                end

                -- call getmetatable()
                MenuCallbackHandler.FAC_get_meta_cblk = function(self, item)
                        log('button pressed!')
                end

                MenuHelper:LoadFromJsonFile(FAC.path .. 'menus/mainmenu.json', FAC, FAC.settings)
        end
)
