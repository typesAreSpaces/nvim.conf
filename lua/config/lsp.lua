local nvim_lsp = require('lspconfig')

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

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'texlab', 'pyright', 'clangd', 'tsserver', 'hls', 'rust_analyzer' }
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup({ 
    on_attach = custom_on_attach,
    capabilities = capabilities,
    root_dir = function(fname)
      return nvim_lsp.util.root_pattern(
      'build.gradle', 'pom.xml', '.git'
      )(fname) or vim.fn.getcwd()
    end
  })
end

-- Extra setup for pyright
local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs["pyright"] = {
  default_config = {
    cmd = {"pyright-langserver", "--stdio"};
    filetypes = {"python"};
    root_dir = util.root_pattern(".git", "setup.py",  "setup.cfg", "pyproject.toml", "requirements.txt");
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true;
          useLibraryCodeForTypes = true;
        };
      };
    };
  };
  docs = {
    description = [[
    https://github.com/microsoft/pyright
    `pyright`, a static type checker and language server for python
    ]];
  };
}
