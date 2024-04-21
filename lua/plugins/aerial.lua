return {
	{
		'stevearc/aerial.nvim',

		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons"
		},

		cmd = {
			"AerialToggle",
			"AerialNavToggle"
		},

		keys = {
			{ '<leader>oo', '<cmd>AerialToggle<cr>' },
			{ '<leader>on', '<cmd>AerialNavToggle<cr>' }
		},

		opts = {
			nav = {
				win_opts = {
					winblend = 0,
				},
			},
		},
	}
}
