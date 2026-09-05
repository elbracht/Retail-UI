local addonName, addonTable = ...

---@class RetailUI : AceAddon-3.0, AceConsole-3.0, AceEvent-3.0
local RetailUI = LibStub('AceAddon-3.0'):NewAddon('RetailUI', 'AceConsole-3.0', 'AceEvent-3.0')

addonTable.RetailUI = RetailUI

local L = LibStub('AceLocale-3.0'):GetLocale('RetailUI')

-- Grows as modules add their own defaults under profile/global.
local defaults = {
	profile = {},
}

function RetailUI:OnInitialize()
	self.db = LibStub('AceDB-3.0'):New('RetailUIDB', defaults, true)

	self:SetupOptions()

	self:RegisterChatCommand('retailui', 'OpenOptions')
	self:RegisterChatCommand('rui', 'OpenOptions')
end

function RetailUI:OnEnable() self:Print(L['Loaded']) end

function RetailUI:OpenOptions() LibStub('AceConfigDialog-3.0'):Open(addonName) end

function RetailUI:GetVersion()
	local version = C_AddOns.GetAddOnMetadata(addonName, 'Version')
	return version or 'unknown'
end
