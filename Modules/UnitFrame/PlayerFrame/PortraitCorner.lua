local _, addonTable = ...
local RetailUI = addonTable.RetailUI
local PlayerFrame = RetailUI:GetModule("PlayerFrame")

local PORTRAIT_CORNER_SIZE = 36
local PORTRAIT_CORNER_OFFSET = 94

function PlayerFrame:CreatePortraitCorner(scale)
	local portraitCorner = CreateFrame("Frame", nil, self.frame)
	portraitCorner:SetSize(PORTRAIT_CORNER_SIZE * scale, PORTRAIT_CORNER_SIZE * scale)
	portraitCorner:SetPoint("TOPLEFT", self.frame, "TOPLEFT", PORTRAIT_CORNER_OFFSET * scale, -PORTRAIT_CORNER_OFFSET * scale)
	portraitCorner:SetFrameLevel(self.frame:GetFrameLevel() + 1)

	local texture = portraitCorner:CreateTexture(nil, "BACKGROUND")
	texture:SetAllPoints()
	texture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UnitFrame\\PlayerFrame\\PlayerFrame-Portrait-Corner.blp")

	portraitCorner:RegisterEvent("PLAYER_REGEN_DISABLED")
	portraitCorner:RegisterEvent("PLAYER_REGEN_ENABLED")
	portraitCorner:SetScript("OnEvent", function(_, event)
		if event == "PLAYER_REGEN_DISABLED" then
			texture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UnitFrame\\PlayerFrame\\PlayerFrame-Portrait-Corner-Combat.blp")
		else
			texture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UnitFrame\\PlayerFrame\\PlayerFrame-Portrait-Corner.blp")
		end
	end)

	return portraitCorner
end
