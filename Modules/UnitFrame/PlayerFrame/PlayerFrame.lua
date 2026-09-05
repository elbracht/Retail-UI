local _, addonTable = ...
local RetailUI = addonTable.RetailUI
local Textures = addonTable.Textures

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
	texture:SetTexture(Textures.GetTexturePath("UnitFrame\\PlayerFrame\\PlayerFrame.blp"))

	self.frame = frame
	self.portrait = self:CreatePortrait(PLAYER_FRAME_SCALE)
	self.portraitCorner = self:CreatePortraitCorner(PLAYER_FRAME_SCALE)
	self.name = self:CreateText(PLAYER_FRAME_SCALE)
	self.healthBar = self:CreateHealthBar(PLAYER_FRAME_SCALE)
	self.healthBarText = self:CreateHealthBarText(PLAYER_FRAME_SCALE)
	self.powerBar = self:CreatePowerBar(PLAYER_FRAME_SCALE)
end
