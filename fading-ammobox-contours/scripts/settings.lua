-- default settings
FAC.settings = {
        ['enabled'] = true,
        ['updaterate'] = 4
}

-- save and load function
function FAC:save_settings()
        local f = io.open(FAC.savefile, 'w+')
        if f then
                f:write(json.encode(FAC.settings))
                f:close()
        end
end

function FAC:load_settings()
        local f = io.open(FAC.savefile, 'r')
        if f then
                local tbl = json.decode(f:read('*all'))
                if tbl ~= nil and type(tbl) == 'table' then
                        for k, v in pairs(tbl) do
                                FAC.settings[k] = v
                        end
                end
                f:close()
        end
end
