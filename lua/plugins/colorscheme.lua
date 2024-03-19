return {
	{
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
		'folke/tokyonight.nvim',
		lazy = false,
		priority = 1000,
		opts = {
			style = 'night',
			light_style = 'moon',
			transparent = true,
			styles = {
				sidebars = 'transparent',
				floats = 'transparent',
			},
		},
	},
}
