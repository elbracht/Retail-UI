local _, addonTable = ...
local RetailUI = addonTable.RetailUI
local PlayerFrame = RetailUI:GetModule("PlayerFrame")
local Textures = addonTable.Textures

local PORTRAIT_SIZE = 116
local PORTRAIT_OFFSET = 14

function PlayerFrame:CreatePortrait(scale)
	local frame = CreateFrame("Frame", nil, self.frame)
	frame:SetSize(PORTRAIT_SIZE * scale, PORTRAIT_SIZE * scale)
	frame:SetPoint("TOPLEFT", self.frame, "TOPLEFT", PORTRAIT_OFFSET * scale, -PORTRAIT_OFFSET * scale)
	frame:SetFrameLevel(self.frame:GetFrameLevel() - 1)

	local portrait = frame:CreateTexture(nil, "ARTWORK")
	portrait:SetAllPoints()

	local mask = frame:CreateMaskTexture(nil, "ARTWORK")
	mask:SetAllPoints()
	mask:SetTexture(Textures.GetTexturePath("UnitFrame\\PlayerFrame\\PlayerFrame-Portrait-Mask.blp"))
	portrait:AddMaskTexture(mask)

	frame:RegisterEvent("UNIT_PORTRAIT_UPDATE")
	frame:SetScript("OnEvent", function()
		SetPortraitTexture(portrait, "player", true)
	end)

	SetPortraitTexture(portrait, "player", true)

	return frame
end
