local _, addonTable = ...
local RetailUI = addonTable.RetailUI

---@class PlayerFrameModule : AceAddon-3.0, AceEvent-3.0
local PlayerFrame = RetailUI:NewModule("PlayerFrame", "AceEvent-3.0")

local PLAYER_FRAME_WIDTH = 400
local PLAYER_FRAME_HEIGHT = 144
local PLAYER_FRAME_SCALE = 0.5
local PLAYER_FRAME_PORTRAIT_SIZE = 122
local PLAYER_FRAME_PORTRAIT_OFFSET = 11

function PlayerFrame:OnEnable()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetPoint("CENTER")
	frame:SetSize(PLAYER_FRAME_WIDTH * PLAYER_FRAME_SCALE, PLAYER_FRAME_HEIGHT * PLAYER_FRAME_SCALE)

	local tex = frame:CreateTexture(nil, "BACKGROUND")
	tex:SetAllPoints()
	tex:SetTexture("Interface\\AddOns\\RetailUI\\Textures\\UnitFrame\\PlayerFrame\\PlayerFrame.blp")

	self.frame = frame
	self.portrait = self:CreatePortrait(PLAYER_FRAME_PORTRAIT_SIZE * PLAYER_FRAME_SCALE, PLAYER_FRAME_PORTRAIT_OFFSET * PLAYER_FRAME_SCALE)
end
