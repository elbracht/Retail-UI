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

	local portraitMask = portraitFrame:CreateMaskTexture(nil, "ARTWORK")
	portraitMask:SetAllPoints()
	portraitMask:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UnitFrame\\PlayerFrame\\PlayerFrame-Portrait-Mask.blp")

	local portrait = portraitFrame:CreateTexture(nil, "ARTWORK")
	portrait:SetAllPoints()
	portrait:AddMaskTexture(portraitMask)

	portraitFrame:RegisterEvent("UNIT_PORTRAIT_UPDATE")
	portraitFrame:SetScript("OnEvent", function()
		SetPortraitTexture(portrait, "player", true)
	end)

	SetPortraitTexture(portrait, "player", true)

	return portraitFrame
end
