local lspconfig_status, nvim_lsp = pcall(require, 'lspconfig')
if not lspconfig_status then return end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not cmp_nvim_lsp_status then return end

local protocol = require('vim.lsp.protocol')
local buf = require('vim.lsp.buf')
local keymap = vim.keymap


local on_attach = function(client, bufnr)
  -- enable completion triggered by <c-x><c-o>
  -- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- formatting
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd('bufWritePre', {
      group = vim.api.nvim_create_augroup('Format', { clear = true }),
      buffer = bufnr,
      callback = function()
        if buf.formatting_seq_sync then
          return buf.formatting_seq_sync()
        end
      end
    })
  end

  -- keybind options
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- set keybinds
  keymap.set('n', 'gf', "<cmd>Lspsaga lsp_finder<CR>", opts)                     -- show definition, references
  keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)          -- got to declaration
  keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)                -- see definition and make edits in window
  keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)       -- go to implementation
  keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)            -- see available code actions
  keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)                 -- smart rename
  keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)   -- show  diagnostics for line
  keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
  keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)           -- jump to previous diagnostic in buffer
  keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)           -- jump to next diagnostic in buffer
  keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)                       -- show documentation for what is under cursor
  keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts)                 -- see outline on right hand side

  -- typescript specific keymaps (e.g. rename file and update imports)
  if client.name == "tsserver" then
    keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>")      -- rename file and update imports
    keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
    keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>")    -- remove unused variables (not in youtube nvim video)
  end
end

-- set up completion using nvim_cmp with LSP source
-- update_capabilities() 은 더이상 지원하지 않는다.
-- local capabilities = require('cmp_nvim_lsp').update_capabilities(
--   vim.lsp.protocol.make_client_capabilities()
-- )
local capabilities = cmp_nvim_lsp.default_capabilities(
  protocol.make_client_capabilities()
)
-- default_capabilities 로 그냥 전달하면 cmp가 제대로 작동하지 않는다.
-- local capabilities = require('cmp_nvim_lsp').default_capabilities

nvim_lsp.flow.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

-- lua
nvim_lsp.lua_ls.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false
      },
    },
  },
  capabilities = capabilities
}

-- typescript
nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  filetypes = { 'javascript', 'typescript', 'typescriptreact', 'typescript.tsx' },
  cmd = { 'typescript-language-server', '--stdio' },
  root_dir = function() return vim.loop.cwd() end,
  capabilities = capabilities
}

-- tailwindcss
nvim_lsp.tailwindcss.setup {}

-- python
nvim_lsp.pyright.setup{}

-- showing the inline diagnostics automatically in the hover window
-- vim.o.updatetime = 250
-- vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float{nil, {focus=false}}]]
