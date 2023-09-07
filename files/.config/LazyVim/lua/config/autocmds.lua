-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local augroup = vim.api.nvim_create_augroup
local autocmds = vim.api.nvim_create_autocmd

augroup('discontinue_comments', { clear = true })
autocmds({ 'FileType' }, {
  pattern = { '*' },
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - 'o'
  end,
  group = 'discontinue_comments',
  desc = "Dont't continue comments with o/O",
})

augroup('quitting_help', { clear = true })
autocmds({ 'FileType' }, {
  pattern = { 'qf', 'help', 'man', 'lspinfo', 'spectre_panel', 'lir' },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]]
  end,
  group = 'quitting_help',
  desc = 'Just hitting q will close out panels and such',
})

augroup('git_stuff', { clear = true })
autocmds({ 'FileType' }, {
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
  group = 'git_stuff',
  desc = 'Wrap and spellcheck git commit messages',
})

augroup('text_yank', { clear = true })
autocmds({ 'TextYankPost' }, {
  callback = function()
    vim.highlight.on_yank { higroup = 'Visual', timeout = 200 }
  end,
  group = 'text_yank',
  desc = 'Highlight yanked text',
})

augroup('mdx_stuff', { clear = true })
autocmds({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.mdx' },
  callback = function()
    local buf = vim.api.nvim_get_current_buf()

    vim.opt_local.spell = true
    vim.opt_local.wrap = true
    vim.api.nvim_buf_set_option(buf, 'filetype', 'jsx')
  end,
  group = 'mdx_stuff',
  desc = 'Working with mdx files',
})
