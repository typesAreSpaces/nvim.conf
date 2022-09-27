local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_url = 'https://github.com/wbthomason/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', packer_url, install_path})
end

vim.cmd [[packadd packer.nvim]]
vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end
]])

-- A method to dump an object and print it out
function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end

function _G.get_config(name)
  return string.format("require(\"config/%s\")", name)
end

require('plugins')
require('settings')
require('mappings')
require('customization')
