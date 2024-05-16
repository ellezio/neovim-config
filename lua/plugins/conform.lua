return {
	{
		'stevearc/conform.nvim',

		opts = {
			formatters_by_ft = {
				nix = { 'nixpkgs_fmt' },
				templ = { 'templ' },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},

		config = function()
			require('conform').setup({
				formatters_by_ft = {
					javascript = { "prettierd" },
					typescript = { "prettierd" },
					typescriptreact = { "prettierd" },
					css = { "prettierd" },
					scss = { "prettierd" },
					nix = { 'nixpkgs_fmt' },
					templ = { 'templ' },
				},

				format_on_save = function(bufnr)
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end

					return {
						timeout_ms = 500,
						async = true,
						lsp_fallback = true,
					}
				end,
			})

			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})
			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			})
		end
	}
}
