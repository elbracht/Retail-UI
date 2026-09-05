local _, addonTable = ...

local Textures = {}

local TEXTURES_PATH = "Interface\\AddOns\\RetailUI\\Textures\\"

function Textures.GetTexturePath(path)
	return TEXTURES_PATH .. path
end

addonTable.Textures = Textures
