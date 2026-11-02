if vim.fn.has('nvim-0.11.3') == 0 then
  error('This configuration requires Neovim 0.11.3 or newer')
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error('Failed to install lazy.nvim:\n' .. output)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require('lazy').setup('plugins')
vim.cmd('syntax on')
require('customization').apply_local_defaults()
require('settings')
require('mappings')
require('commands')
require('config.performance').setup()
