local _, addonTable = ...
local RetailUI = addonTable.RetailUI
local PlayerFrame = RetailUI:GetModule("PlayerFrame")

local PORTRAIT_SIZE = 122
local PORTRAIT_OFFSET = 11

function PlayerFrame:CreatePortrait(scale)
	local portraitFrame = CreateFrame("Frame", nil, self.frame)
	portraitFrame:SetSize(PORTRAIT_SIZE * scale, PORTRAIT_SIZE * scale)
	portraitFrame:SetPoint("TOPLEFT", self.frame, "TOPLEFT", PORTRAIT_OFFSET * scale, -PORTRAIT_OFFSET * scale)
	portraitFrame:SetFrameLevel(self.frame:GetFrameLevel() - 1)

	local portrait = portraitFrame:CreateTexture(nil, "ARTWORK")
	portrait:SetAllPoints()

	local mask = portraitFrame:CreateMaskTexture(nil, "ARTWORK")
	mask:SetAllPoints()
	mask:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UnitFrame\\PlayerFrame\\PlayerFrame-Portrait-Mask.blp")
	portrait:AddMaskTexture(mask)

	portraitFrame:RegisterEvent("UNIT_PORTRAIT_UPDATE")
	portraitFrame:SetScript("OnEvent", function()
		SetPortraitTexture(portrait, "player", true)
	end)

	SetPortraitTexture(portrait, "player", true)

	return portraitFrame
end
