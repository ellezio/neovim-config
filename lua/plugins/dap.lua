return {
	'mfussenegger/nvim-dap',

	dependencies = {
		'rcarriga/nvim-dap-ui',
		'nvim-neotest/nvim-nio',
	},

	config = function()
		local dap = require('dap')
		local dapui = require('dapui')

		dapui.setup()

		vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
		vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
		vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
		vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
		vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
		vim.keymap.set('n', '<leader>B', function()
		dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
		end, { desc = 'Debug: Set Breakpoint' })

		vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
		vim.keymap.set('n', '<M-k>', dapui.eval, { desc = 'Debug: evaluate expression under cursor.' })
		vim.keymap.set('v', '<M-k>', dapui.eval, { desc = 'Debug: evaluate selected expression.' })

		dap.listeners.after.event_initialized['dapui_config'] = dapui.open
		dap.listeners.before.event_terminated['dapui_config'] = dapui.close
		dap.listeners.before.event_exited['dapui_config'] = dapui.close

		dap.adapters.go = {
			type = 'server',
			port = '${port}',
			executable = {
				command = 'dlv',
				args = { 'dap', '-l', '127.0.0.1:${port}' },
			},
		}

		dap.configurations.go = {
			{
				type = 'go',
				request = 'launch',
				name = 'Debug go',
				program = "${file}",
			},
		}

		dap.adapters.php = {
			type = 'executable',
			command = 'node',
			args = { os.getenv("HOME") .. '/debug-adapters/vscode-php-debug/out/phpDebug.js' },
		}

		dap.configurations.php = {
			{
				name = 'Listen for Xdebug',
				type = 'php',
				request = 'launch',
				port = 9000,
				pathMappings = {
					['/var/www/html'] = '${workspaceFolder}',
				},
			},
		}

		dap.adapters['pwa-node'] = {
			type = 'server',
			host = 'localhost',
			port = '${port}',
			executable = {
				command = "js-debug",
				args = { '${port}' }
			}
		}

		dap.configurations.javascript = {
			{
				type = "pwa-node",
				request = "attach",
				port = 9229,
				name = "js debug attach",
				cwd = "${workspaceFolder}",
			},
		}
	end,
}
