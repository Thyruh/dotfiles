local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup{
    defaults = {
        buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker, -- default safe
        preview = {
            treesitter = false, -- disable TS highlighting
        },
    }
}

vim.keymap.set('n', '<leader>f', builtin.find_files, { noremap = true, silent = true })
vim.keymap.set('n', '<C-p>', builtin.git_files, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>hf', builtin.commands, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>s', builtin.live_grep, { noremap = true, silent = true })
