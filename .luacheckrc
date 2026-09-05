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
    'PlayerFrame',
    'SetPortraitTexture',
    'UIParent',

    -- WoW API: Functions
    'CreateColor',
    'GetCVar',
    'PowerBarColor',
    'UnitHealth',
    'UnitHealthMax',
    'UnitFrame_OnEnter',
    'UnitFrame_OnLeave',
    'UnitLevel',
    'UnitName',
    'UnitPower',
    'UnitPowerMax',
    'UnitPowerType',

    -- Addon Libraries
    'LibStub',
}
