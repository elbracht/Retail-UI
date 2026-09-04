-- luacheckrc for WoW addons
-- See https://luacheck.readthedocs.io/en/stable/config.html

std = "lua51"
max_line_length = false
codes = true

exclude_files = {
    'Libs/**',
}

read_globals = {
    'LibStub',
    'C_AddOns',
}
