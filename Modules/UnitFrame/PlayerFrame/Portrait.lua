function CreatePortrait(parent, size, offset)
	local portraitFrame = CreateFrame("Frame", nil, parent)
	portraitFrame:SetSize(size, size)
	portraitFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", offset, -offset)
	portraitFrame:SetFrameLevel(parent:GetFrameLevel() - 1)

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
