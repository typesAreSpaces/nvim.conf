-- Settings

function _G.change_kbd()
  local is_caps_escape_key = vim.fn.system('xmodmap | grep lock | grep 0x9')
  if (is_caps_escape_key == nil or is_caps_escape_key  == '') then
    vim.cmd('silent !changeKBD ESC')
  else
    vim.cmd('silent !changeKBD CTRL')
  end
end

local function set_keymap(...) vim.api.nvim_set_keymap(...) end
local opts = { noremap=true, silent=true }

-- # General
set_keymap('n', '<C-g>', '<Esc>', opts)
set_keymap('v', '<C-g>', '<Esc>gV', opts)
set_keymap('o', '<C-g>', '<Esc>', opts)
set_keymap('c', '<C-g>', '<C-c><Esc>', opts)
set_keymap('i', '<C-g>', '<Esc>', opts)

-- # Terminal:
set_keymap('t', '<Esc>', '<C-\\><C-n>', opts)
set_keymap('t', '<C-v><Esc>', '<Esc>', opts)

-- # Telescope bindings:
set_keymap('n', '<C-x><C-f>', '<cmd>Telescope file_browser prompt_prefix=🔍<CR>', opts)

-- # Yanky bindings:
vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
vim.keymap.set({"n","x"}, "y", "<Plug>(YankyYank)")
vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")

-- # Tabby bindings:
set_keymap('n', '<leader>tn', ':$tabnew<CR>', opts)
set_keymap('n', '<leader>tc', ':tabclose<CR>', opts)
set_keymap('n', '<leader>to', ':tabonly<CR>', opts)
set_keymap('n', '<C-Tab>', ':tabnext<CR>', opts)
set_keymap('n', '<C-S-Tab>', ':tabprevious<CR>', opts)
set_keymap('n', '<leader>tmp', ':-tabmove<CR>', opts)
set_keymap('n', '<leader>tmn', ':+tabmove<CR>', opts)
