return {
	{
		'folke/which-key.nvim',

		config = function()
			local wk = require('which-key')

			wk.setup({
				window = {
					border = 'rounded'
				}
			})

			wk.register({
				c = { name = '[C]ode', _ = 'which_key_ignore' },
				d = { name = '[D]ocument', _ = 'which_key_ignore' },
				g = { name = '[G]it', _ = 'which_key_ignore' },
				h = { name = 'Git [H]unk', _ = 'which_key_ignore' },
				r = { name = '[R]ename', _ = 'which_key_ignore' },
				s = { name = '[S]earch', _ = 'which_key_ignore' },
				t = { name = '[T]oggle', _ = 'which_key_ignore' },
				w = { name = '[W]orkspace', _ = 'which_key_ignore' },
				n = { name = '[N]eotree', _ = 'which_key_ignore' },
			}, { prefix = '<leader>' })

			wk.register({
				h = { 'Git [H]unk' },
			}, { mode = 'v', prefix = '<leader>' })
		end
	},
}
