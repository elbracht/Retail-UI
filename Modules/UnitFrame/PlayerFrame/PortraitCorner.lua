local _, addonTable = ...
local RetailUI = addonTable.RetailUI
local PlayerFrame = RetailUI:GetModule("PlayerFrame")
local TexturePath = addonTable.Textures.GetTexturePath

local PORTRAIT_CORNER_SIZE = 36
local PORTRAIT_CORNER_OFFSET = 94

function PlayerFrame:CreatePortraitCorner(scale)
	local frame = CreateFrame("Frame", nil, self.frame)
	frame:SetSize(PORTRAIT_CORNER_SIZE * scale, PORTRAIT_CORNER_SIZE * scale)
	frame:SetPoint("TOPLEFT", self.frame, "TOPLEFT", PORTRAIT_CORNER_OFFSET * scale, -PORTRAIT_CORNER_OFFSET * scale)
	frame:SetFrameLevel(self.frame:GetFrameLevel() + 1)

	local texture = frame:CreateTexture(nil, "BACKGROUND")
	texture:SetAllPoints()

	local function UpdateCorner(isCombat)
		if isCombat then
			texture:SetTexture(TexturePath("UnitFrame\\PlayerFrame\\PlayerFrame-Portrait-Corner-Combat.blp"))
		else
			texture:SetTexture(TexturePath("UnitFrame\\PlayerFrame\\PlayerFrame-Portrait-Corner.blp"))
		end
	end

	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	frame:SetScript("OnEvent", function(_, event)
		UpdateCorner(event == "PLAYER_REGEN_DISABLED")
	end)

	UpdateCorner(false)

	return frame
end
