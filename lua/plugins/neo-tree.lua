return {
	{
		'nvim-neo-tree/neo-tree.nvim',

		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons',
			'MunifTanjim/nui.nvim',
			"antosha417/nvim-lsp-file-operations",
		},

		config = function()
			require('neo-tree').setup({
				close_if_last_window = true,
				popup_border_style = 'rounded',
				filesystem = {
					hijack_netrw_behavior = 'open_current',
				},
				window = {
					position = "float",
				},
			})

			require("lsp-file-operations").setup()

			local nmap = function(key, cmd, desc)
				key = '<leader>n' .. key
				cmd = '<cmd>Neotree ' .. cmd .. '<cr>'
				desc = "Neotree: " .. desc
				vim.keymap.set('n', key, cmd, { desc = desc })
			end

			nmap('f ', 'filesystem toggle', 'filesystem toggle');
			nmap('ff', 'filesystem toggle float', 'filesystem toggle float');
			nmap('fl', 'filesystem toggle left', 'filesystem toggle left');
			nmap('fr', 'filesystem toggle right', 'filesystem toggle right');
			nmap('fc', 'filesystem current', 'filesystem current buffer');
			nmap('fR', 'filesystem reveal', 'filesystem reveal current');

			nmap('g ', 'git_status toggle', 'git_status toggle');
			nmap('gf', 'git_status toggle float', 'git_status toggle float');
			nmap('gl', 'git_status toggle left', 'git_status toggle left');
			nmap('gr', 'git_status toggle right', 'git_status toggle right');
			nmap('gc', 'git_status current', 'git_status current buffer');
			nmap('gR', 'git_status reveal', 'git_status reveal current');

			nmap('b ', 'buffers toggle', 'buffers toggle');
			nmap('bf', 'buffers toggle float', 'buffers toggle float');
			nmap('bl', 'buffers toggle left', 'buffers toggle left');
			nmap('br', 'buffers toggle right', 'buffers toggle right');
			nmap('bc', 'buffers current', 'buffers current buffer');
			nmap('bR', 'buffers reveal', 'buffers reveal current');
		end
	},
}
