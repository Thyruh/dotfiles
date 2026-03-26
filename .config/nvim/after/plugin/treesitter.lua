require('nvim-treesitter').setup({
  ensure_installed = { "cpp", "go", "d", "python", "haskell", "typescript", "javascript", "c", "lua", "vim", "query", "asm", "markdown", "markdown_inline" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})
