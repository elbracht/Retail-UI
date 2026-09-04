-- luacheckrc for WoW addons
-- See https://luacheck.readthedocs.io/en/stable/config.html

std = "lua51"
max_line_length = false
codes = true

exclude_files = {
    'Libs/**',
}

globals = {
    -- WoW API: Namespaces
    'C_AddOns',

    -- WoW API: UI
    'CreateFrame',
    'CreateMaskTexture',
    'UIParent',
    'PlayerFrame',
    'SetPortraitTexture',

    -- WoW API: Functions
    'CreateColor',
    'UnitHealth',
    'UnitHealthMax',

    -- Addon Libraries
    'LibStub',
}
