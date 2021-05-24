local keymap = require('lua-helpers/keymap')
local imap = keymap.imap
local omap = keymap.omap
local smap = keymap.smap
local map = vim.api.nvim_set_keymap

omap('completeopt', "menuone,noselect")

require'compe'.setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'enable',
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,

  source = {
    path = {kind = "  "},
    buffer = {kind = "  "},
    calc = {kind = "  "},
    vsnip = {kind = "  ", priority = 1},
    nvim_lsp = {kind = "  "},
    nvim_lua = {kind = "  "},
    -- nvim_lua = false,
    spell = {kind = "  "},
    tags = true,
    treesitter = {kind = "  "},
    emoji = {kind = " ﲃ ", filetypes={"markdown"}}
  }
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

local options = {expr = true}

imap("<C-Space>", "compe#complete()", options)
imap("<Tab>", "v:lua.tab_complete()", options)
smap("<Tab>", "v:lua.tab_complete()", options)
imap("<S-Tab>", "v:lua.s_tab_complete()", options)
smap("<S-Tab>", "v:lua.s_tab_complete()", options)

-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- ﬘
-- 
-- 
-- 
-- m
-- 
-- 
-- 
-- 
