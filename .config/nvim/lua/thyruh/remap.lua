vim.g.mapleader = " "
vim.keymap.set({ "n", "v" }, "<leader>p", '"0p')

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("Ex")
end)

vim.keymap.del("s", "<Tab>")  -- remove _defaults.lua snippet jump in select
vim.keymap.set({"n", "v"}, "<C-i>", "<C-u>zz")
vim.keymap.set({"n", "v"}, "<C-u>", "<C-d>zz")

vim.keymap.set("i", "<TAB>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  end
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return "<TAB>"
  end
  return "<C-x><C-o>"
end, { expr = true, silent = true })

vim.keymap.set('i', '<C-c>', '<Esc>', { noremap = true })

vim.keymap.set("n", "<C-t>", "i#include <stdio.h>\n#include <stdbool.h>\n#include <stdint.h>\n\ntypedef int8_t i8;\ntypedef int16_t i16;\ntypedef int32_t i32;\ntypedef int64_t i64;\ntypedef uint8_t u8;\ntypedef uint16_t u16;\ntypedef uint32_t u32;\ntypedef uint64_t u64;\n\ntypedef float f32;\ntypedef double f64;\n\nint main(void) {\nprintf(\"Hello, World!\\n\");\nreturn 0;\n}")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tms<CR>")
-- vim.keymap.set("n", "<M-h>", "<cmd>silent !tmux-sessionizer -s 0 --vsplit<CR>")
-- vim.keymap.set("n", "<M-H>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "E", "$")
vim.keymap.set("n", "Q", "0")
vim.keymap.set("n", "yE", "y$")
vim.keymap.set("n", "dE", "d$")

-- === Emacs-inspired window management ===

vim.keymap.set("n", "<leader>0", function()
    local cur_win = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if win ~= cur_win then
            vim.api.nvim_win_close(win, true)
        end
    end
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>9", function()
    vim.cmd("vsplit")
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>8", function()
    vim.cmd("split")
end, { noremap = true, silent = true })
