local _, addonTable = ...
local RetailUI = addonTable.RetailUI

---@class PlayerFrameModule : AceAddon-3.0, AceEvent-3.0
local PlayerFrame = RetailUI:NewModule("PlayerFrame", "AceEvent-3.0")

local PLAYER_FRAME_WIDTH = 400
local PLAYER_FRAME_HEIGHT = 144
local PLAYER_FRAME_SCALE = 0.5

function PlayerFrame:OnEnable()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetPoint("CENTER")
	frame:SetSize(PLAYER_FRAME_WIDTH * PLAYER_FRAME_SCALE, PLAYER_FRAME_HEIGHT * PLAYER_FRAME_SCALE)

	local texture = frame:CreateTexture(nil, "BACKGROUND")
	texture:SetAllPoints()
	texture:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UnitFrame\\PlayerFrame\\PlayerFrame.blp")

	self.frame = frame
	self.portrait = self:CreatePortrait(PLAYER_FRAME_SCALE)
    self.portraitCorner = self:CreatePortraitCorner(PLAYER_FRAME_SCALE)
end
