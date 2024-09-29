require('outline').setup({
	outline_window = {
		show_cursorline = true,
		hide_cursor = true,
	},
})
vim.keymap.set('n', '<leader>o', '<cmd>Outline<CR>', { desc = 'Toggle outline' })
