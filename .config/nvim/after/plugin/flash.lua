-- Flash
vim.keymap.set({ "n", "x", "o" }, "zk", function()
  require("flash").jump()
end, { desc = "Flash", noremap = true, silent = true })

-- Flash Treesitter
vim.keymap.set({ "n", "x", "o" }, "Zk", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter", noremap = true, silent = true })

-- Remote Flash
vim.keymap.set("o", "r", function()
  require("flash").remote()
end, { desc = "Remote Flash", noremap = true, silent = true })

-- Treesitter Search
vim.keymap.set({ "o", "x" }, "R", function()
  require("flash").treesitter_search()
end, { desc = "Treesitter Search", noremap = true, silent = true })

-- Toggle Flash Search
vim.keymap.set("c", "<C-s>", function()
  require("flash").toggle()
end, { desc = "Toggle Flash Search", noremap = true, silent = true })
