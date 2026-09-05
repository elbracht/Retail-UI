local _, addonTable = ...

local TEXTURES_PATH = "Interface\\AddOns\\RetailUI\\Textures\\"

local Textures = {}

function Textures.GetTexturePath(path)
	return TEXTURES_PATH .. path
end

addonTable.Textures = Textures