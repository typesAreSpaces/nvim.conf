-- Use an custom_on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local custom_on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
end

-- Configure before enabling so completion capabilities and mappings apply.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
for _, server in ipairs({ 'texlab', 'clangd', 'pyright' }) do
  vim.lsp.config(server, { capabilities = capabilities })
end

-- Keep server-specific attach handlers supplied by nvim-lspconfig.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('custom_lsp_attach', { clear = true }),
  callback = function(args)
    custom_on_attach(vim.lsp.get_client_by_id(args.data.client_id), args.buf)
  end,
})

vim.lsp.config('clangd', {
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
})

vim.lsp.enable({ 'texlab', 'clangd', 'pyright' })
