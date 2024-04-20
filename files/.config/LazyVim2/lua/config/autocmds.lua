-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local autocmd = vim.api.nvim_create_autocmd

autocmd({ 'BufWinEnter' }, {
  callback = function()
    vim.cmd 'set formatoptions-=cro'
  end,
})

autocmd({ 'FileType' }, {
  pattern = {
    'DressingSelect',
    'help',
    'Jaq',
    'lir',
    'lspinfo',
    'man',
    'netrw',
    'oil',
    'qf',
    'git',
    'spectre_panel',
    'tsplayground',
    '',
  },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]]
  end,
})

autocmd({ 'CmdWinEnter' }, {
  callback = function()
    vim.cmd 'quit'
  end,
})

autocmd({ 'VimResized' }, {
  callback = function()
    vim.cmd 'tabdo wincmd ='
  end,
})

autocmd({ 'BufWinEnter' }, {
  pattern = { '*' },
  callback = function()
    vim.cmd 'checktime'
  end,
})

autocmd({ 'TextYankPost' }, {
  callback = function()
    vim.highlight.on_yank { higroup = 'Visual', timeout = 40 }
  end,
})

autocmd({ 'FileType' }, {
  pattern = { 'gitcommit', 'markdown', 'NeogitCommitMessage' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

autocmd({ 'CursorHold' }, {
  callback = function()
    local status_ok, luasnip = pcall(require, 'luasnip')
    if not status_ok then
      return
    end
    if luasnip.expand_or_jumpable() then
      -- ask maintainer for option to make this silent
      -- luasnip.unlink_current()
      vim.cmd [[silent! lua require("luasnip").unlink_current()]]
    end
  end,
})

autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.mdx' },
  callback = function()
    local buf = vim.api.nvim_get_current_buf()

    vim.opt_local.spell = true
    vim.opt_local.wrap = true
    vim.api.nvim_buf_set_option(buf, 'filetype', 'jsx')
  end,
  desc = 'Working with mdx files',
})
