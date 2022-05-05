_G.FAC = {
        ['path'] = ModPath,
        ['savefile'] = SavePath .. 'FAC_settings.json',
        ['i18n'] = ModPath .. 'i18n/',
        ['settings'] = {},
        ['boxes'] = {} -- unit of every ammobox in level
}

-- load settings
dofile(FAC.path .. 'scripts/settings.lua')
FAC:load_settings()
