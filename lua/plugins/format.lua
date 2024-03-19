return {
	{
		'stevearc/conform.nvim',

		opts = {
			formatters_by_ft = {
				nix = { 'nixpkgs_fmt' },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},

		-- config = function()
		-- 	require('conform').setup({
		-- 		formatters_by_ft = {
		-- 			nix = { 'nixpkgs_fmt' },
		-- 		},
		-- 		format_on_save = {
		-- 			timeout_ms = 500,
		-- 			lsp_fallback = true,
		-- 		},
		-- 	})
		-- end
	}
}
