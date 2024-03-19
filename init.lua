require('options')
require('keymaps')
require('autocmds')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	'tpope/vim-sleuth',

	{
		'eandrju/cellular-automaton.nvim',
		lazy = true
	},

	{
		'alanfortlink/blackjack.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		lazy = true,
	},

	{
		'numToStr/Comment.nvim',
		opts = {}
	},

	{
		-- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		main = 'ibl',
		opts = {},
	},

	{ import = 'plugins' },
})

vim.g.tokyonight_colors = { border = '#27a1b9' }
vim.cmd.colorscheme 'tokyonight'
