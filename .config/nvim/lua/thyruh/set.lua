vim.opt.guicursor = ""
vim.opt.clipboard = "unnamedplus"

-- get rid of annoying tildas
vim.opt.fillchars = { eob = ' ' }

vim.g.netrw_liststyle = 1
vim.opt.nu = true
vim.opt.relativenumber = true

vim.o.guicursor = "n-v-c:block,i:ver25,r:hor20"

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.s", "*.asm", "*.S" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.indentexpr = "v:lua.require('indent.asm').indent(v:lnum)"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.fg",
    callback = function()
        vim.bo.filetype = "forge"

        vim.bo.commentstring = "// %s"
    end,
})

vim.opt.expandtab = true
vim.opt.smartindent = false
vim.opt.cindent = true
vim.g.netrw_banner = 0
vim.opt.cinoptions:append("g0")

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 5
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "100"
vim.api.nvim_set_hl(0, "StatusLineBranch", { fg = "#ff6600", bold = true })
vim.o.statusline = "%F:%l:%c    %#StatusLineBranch#%{FugitiveHead()}%*       %{toupper(strpart(&filetype,0,1))..strpart(&filetype,1)} sucks           ascii(0x%B)"
