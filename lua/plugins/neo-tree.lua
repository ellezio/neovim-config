return {
	{
		'nvim-neo-tree/neo-tree.nvim',

		keys = {
			{ '<leader>nr', '<cmd>Neotree toggle right<cr>',      desc = 'Toggle Neotree right' },
			{ '<leader>nl', '<cmd>Neotree toggle left<cr>',       desc = 'Toggle Neotree left' },
			{ '<leader>nR', '<cmd>Neotree filesystem reveal<cr>', desc = 'Reveal current file' },
		},

		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons',
			'MunifTanjim/nui.nvim',
		},

		config = function()
			require('neo-tree').setup({
				close_if_last_window = true,
				popup_border_style = 'rounded'
			})
		end
	},
}
