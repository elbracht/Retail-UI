local _, addonTable = ...
local RetailUI = addonTable.RetailUI
local PlayerFrame = RetailUI:GetModule("PlayerFrame")

function PlayerFrame:CreatePortrait(size, offset)
	local portraitFrame = CreateFrame("Frame", nil, self.frame)
	portraitFrame:SetSize(size, size)
	portraitFrame:SetPoint("TOPLEFT", self.frame, "TOPLEFT", offset, -offset)
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
