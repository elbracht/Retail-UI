local addonName, addonTable = ...
local RetailUI = addonTable.RetailUI

-- Feature options are added here as their modules land; this file stays the
-- single place the options tree is assembled.
local options = {
	name = 'Retail UI',
	type = 'group',
	args = {
		general = {
			name = 'General',
			type = 'group',
			order = 1,
			args = {
				info = {
					name = 'Retail UI is a work in progress. Features will be added over time.',
					type = 'description',
					order = 1,
				},
			},
		},
	},
}

function RetailUI:SetupOptions()
	options.args.profiles = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)
	options.args.profiles.order = 100

	LibStub('AceConfig-3.0'):RegisterOptionsTable(addonName, options)
	LibStub('AceConfigDialog-3.0'):AddToBlizOptions(addonName, 'Retail UI')
end
