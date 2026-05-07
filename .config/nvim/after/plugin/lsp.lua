local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local telescope_builtin = require("telescope.builtin")

-- === Capabilities ===
local capabilities = cmp_nvim_lsp.default_capabilities(
   vim.lsp.protocol.make_client_capabilities()
)

-- === Utilities ===
do
   local orig = vim.lsp.util.make_position_params
   vim.lsp.util.make_position_params = function(win, encoding)
      if encoding == nil then
         local bufnr = vim.api.nvim_get_current_buf()
         local clients = vim.lsp.get_clients({ bufnr = bufnr })
         if #clients > 0 then
            encoding = clients[1].offset_encoding or "utf-16"
         else
            encoding = "utf-16"
         end
      end
      return orig(win, encoding)
   end
end

do
   local orig = vim.lsp.handlers["textDocument/publishDiagnostics"]
   vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
      if result and result.diagnostics then
         for _, d in ipairs(result.diagnostics) do
            if type(d.message) == "string" then
               d.message = d.message:gsub("\r", "")
            end
         end
      end
      return orig(err, result, ctx, config)
   end
end

-- === on_attach ===
local on_attach = function(client, bufnr)
   local opts = { noremap = true, silent = true, buffer = bufnr }
   vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions or vim.lsp.buf.definition, opts)
   vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
   vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
   vim.keymap.set("n", "<neader>rn", vim.lsp.buf.rename, opts)
   vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
   vim.keymap.set("n", "<leader>d", function()
      vim.diagnostic.setloclist({ open = true })
   end, opts)
end

-- === Mason setup ===
mason.setup({})

mason_lspconfig.setup({
   ensure_installed = { "clangd" },
   automatic_installation = false,
})

vim.lsp.config("rust_analyzer", {
   capabilities = capabilities,
   settings = {
      ["rust-analyzer"] = {
         lens = {
            enable = true,
            debug = { enable = true },
            run = { enable = true },
            implementations = { enable = true },
            updateTest = { enable = true },
            references = {
               adt = { enable = true },
               enumVariant = { enable = true },
               method = { enable = true },
               trait = { enable = true },
            },
         },
      },
   },
})
vim.lsp.enable("rust_analyzer")

vim.api.nvim_create_autocmd("LspAttach", {
   callback = function(args)
      on_attach(
         vim.lsp.get_client_by_id(args.data.client_id),
         args.buf
      )
   end,
})

-- === serve-d ===
vim.lsp.config("serve_d", {
   on_attach = function(client, bufnr)
      local fname = vim.api.nvim_buf_get_name(bufnr)
      local root = vim.fs.root(fname, { "dub.json", ".git" })
      if not root then
         vim.lsp.buf_detach_client(bufnr, client.id)
         return
      end
      on_attach(client, bufnr)
   end,
   capabilities = capabilities,
   filetypes = { "d" },
   cmd = { "/home/thyruh/serve-d" },
   root_dir = function(fname)
      return vim.fs.root(fname, { "dub.json", ".git" })
   end,
   flags = { debounce_text_changes = 150 },
   single_file_support = false,
})
vim.lsp.enable("serve_d")

-- === clangd ===
vim.lsp.config("clangd", {
   on_attach = on_attach,
   capabilities = capabilities,
   flags = { debounce_text_changes = 150 },
})
vim.lsp.enable("clangd")
