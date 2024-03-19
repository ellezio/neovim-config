return {
	{
		'neovim/nvim-lspconfig',

		dependencies = {
			{ 'j-hui/fidget.nvim', opts = {} },

			'folke/neodev.nvim',
			'folke/neoconf.nvim',
		},

		config = function()
			require('neoconf').setup()
			require('neodev').setup()

			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function(ev)
					local nmap = function(keys, func, desc)
						if desc then
							desc = 'LSP: ' .. desc
						end

						vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = desc })
					end

					nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
					nmap('<leader>ca', function()
						vim.lsp.buf.code_action { context = { only = { 'quickfix', 'refactor', 'source' } } }
					end, '[C]ode [A]ction')

					local telescope_builtin = require('telescope.builtin');
					nmap('gd', telescope_builtin.lsp_definitions, '[G]oto [D]efinition')
					nmap('gr', telescope_builtin.lsp_references, '[G]oto [R]eferences')
					nmap('gI', telescope_builtin.lsp_implementations, '[G]oto [I]mplementation')
					nmap('<leader>D', telescope_builtin.lsp_type_definitions, 'Type [D]efinition')
					nmap('<leader>ds', telescope_builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
					nmap('<leader>ws', telescope_builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

					nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
					nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

					nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
					nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
					nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
					nmap('<leader>wl', function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, '[W]orkspace [L]ist Folders')

					vim.api.nvim_buf_create_user_command(ev.buf, 'Format', function(_)
						vim.lsp.buf.format()
					end, { desc = 'Format current buffer with LSP' })
				end
			})

			local servers = {
				nil_ls = {},
				lua_ls = {},
				gopls = {},
				templ = {},
				jsonls = {},

				intelephense = {
					single_file_support = true,
					settings = {
						intelephense = {
							environment = {
								phpVersion = os.getenv('PHP_VERSION') or '8.0',
							},
						},
					},
				},
			}

			vim.filetype.add({ extension = { templ = "templ" } })

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


			vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
				vim.lsp.handlers.hover, {
					border = 'rounded'
				}
			)

			vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
				vim.lsp.handlers.signature_help, {
					border = 'rounded'
				}
			)

			local lspconfig = require('lspconfig')
			for server_name, server in pairs(servers) do
				server = server or {}
				server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
				lspconfig[server_name].setup(server)
			end
		end
	},
}
