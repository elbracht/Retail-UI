local _, addonTable = ...
local RetailUI = addonTable.RetailUI
local PlayerFrame = RetailUI:GetModule("PlayerFrame")

local TEXT_WIDTH = 234
local TEXT_HEIGHT = 26
local TEXT_OFFSET_X = 136
local TEXT_OFFSET_Y = 24

local NAME_WIDTH = 202
local LEVEL_WIDTH = 32

function PlayerFrame:CreateText(scale)
	local frame = CreateFrame("Frame", nil, self.frame)
	frame:SetSize(TEXT_WIDTH * scale, TEXT_HEIGHT * scale)
	frame:SetPoint("TOPLEFT", self.frame, "TOPLEFT", TEXT_OFFSET_X * scale, -TEXT_OFFSET_Y * scale)
	frame:SetFrameLevel(self.frame:GetFrameLevel() + 1)

	local nameFrame = CreateFrame("Frame", nil, frame)
	nameFrame:SetSize(NAME_WIDTH * scale, TEXT_HEIGHT * scale)
	nameFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
	nameFrame:SetFrameLevel(frame:GetFrameLevel() + 1)

	local nameText = nameFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	nameText:SetPoint("CENTER", nameFrame, "CENTER")
	nameText:SetText(UnitName("player"))

	local levelFrame = CreateFrame("Frame", nil, frame)
	levelFrame:SetSize(LEVEL_WIDTH * scale, TEXT_HEIGHT * scale)
	levelFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", NAME_WIDTH * scale, 0)
	levelFrame:SetFrameLevel(frame:GetFrameLevel() + 1)

	local levelText = levelFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	levelText:SetPoint("RIGHT", levelFrame, "RIGHT")
	levelText:SetText(UnitLevel("player"))

	frame:RegisterEvent("PLAYER_LEVEL_UP")
	frame:RegisterEvent("UNIT_NAME_UPDATE")
	frame:SetScript("OnEvent", function(_, event, unit)
		if event == "UNIT_NAME_UPDATE" and unit ~= "player" then return end

		if event == "PLAYER_LEVEL_UP" then
			levelText:SetText(UnitLevel("player"))
		end

		if event == "UNIT_NAME_UPDATE" then
			nameText:SetText(UnitName("player"))
		end
	end)

	return frame
end
