local _, addonTable = ...
local RetailUI = addonTable.RetailUI
local PlayerFrame = RetailUI:GetModule("PlayerFrame")

function PlayerFrame:SetupInteraction()
	local frame = self.frame

	frame.unit = "player"

	frame:EnableMouse(true)
	frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	frame:SetAttribute("unit", "player")
	frame:SetAttribute("type1", "target")
	frame:SetAttribute("type2", "togglemenu")

	frame:SetScript("OnEnter", UnitFrame_OnEnter)
	frame:SetScript("OnLeave", UnitFrame_OnLeave)
end
