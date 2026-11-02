local M = {}

-- In-memory sizes avoid filesystem checks on the completion hot path and also
-- cover unsaved buffers. These limits can be overridden before init.lua loads.
function M.is_large(bufnr)
  if bufnr == nil or bufnr == 0 then bufnr = vim.api.nvim_get_current_buf() end
  if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
    return false
  end
  local lines = vim.api.nvim_buf_line_count(bufnr)
  if lines > (vim.g.performance_max_lines or 20000) then return true end
  local bytes = vim.api.nvim_buf_get_offset(bufnr, lines)
  return bytes > (vim.g.performance_max_bytes or 1024 * 1024)
end

function M.setup()
  vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileType', 'BufWritePost', 'InsertEnter' }, {
    group = vim.api.nvim_create_augroup('large_file_performance', { clear = true }),
    callback = function(args)
      if M.is_large(args.buf) then
        local configs = package.loaded['nvim-treesitter.configs']
        if configs then
          configs.detach_module('highlight', args.buf)
          configs.detach_module('incremental_selection', args.buf)
        end
        -- Neovim 0.12's own ftplugins can start a highlighter independently of
        -- nvim-treesitter's module disable predicate (notably for Lua files).
        vim.treesitter.stop(args.buf)
        vim.bo[args.buf].syntax = 'OFF'
      end
    end,
  })
end

return M
