return {
	{
		'folke/which-key.nvim',

		config = function()
			local wk = require('which-key')

			wk.setup({
				win = {
					border = 'rounded'
				},
				icons = {
					rules = false
				}
			})

			wk.add({
				{ "<leader>c", group = '[C]ode' },
				{ "<leader>d", group = '[D]ocument' },
				{ "<leader>g", group = '[G]it' },
				{ "<leader>h", group = 'Git [H]unk', mode = { "n", "v" } },
				{ "<leader>r", group = '[R]ename' },
				{ "<leader>s", group = '[S]earch' },
				{ "<leader>t", group = '[T]oggle' },
				{ "<leader>w", group = '[W]orkspace' },
				{ "<leader>n", group = '[N]eotree' },
			})
		end
	},
}
