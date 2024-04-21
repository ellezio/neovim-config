return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			transparent_background = true,
			term_colors            = false,
			default_integrations   = true,
			integrations           = {
				cmp = true,
				dap = true,
				dap_ui = true,
				gitsigns = true,
				neotree = true,
				treesitter = true,
				fidget = true,
				which_key = true,
				aerial = true,
				telescope = {
					enable = true,
				},
			},
		}
	}
}
