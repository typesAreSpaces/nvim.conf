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

set_keymap('n', '<C-t>', '<cmd>terminal<CR>', opts)

-- # Terminal:
set_keymap('t', '<Esc>', '<C-\\><C-n>', opts)
set_keymap('t', '<C-v><Esc>', '<Esc>', opts)

-- # Telescope bindings:
set_keymap('n', '<CR>', '<cmd>Telescope find_files prompt_prefix=🔍<CR>', opts)
