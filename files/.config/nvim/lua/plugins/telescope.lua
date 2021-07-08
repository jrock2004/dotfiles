local actions = require('telescope.actions')
local keymap = require('lua-helpers/keymap')
local nmap = keymap.nmap
local cmd = vim.cmd

-- require('telescope').load_extension('media_files')
require('telescope').setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden'
    },
    prompt_prefix = ' ',
    selection_caret = ' ',
    entry_prefix = '  ',
    initial_mode = 'insert',
    selection_strategy = 'reset',
    sorting_strategy = 'ascending',
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        mirror = false,
        preview_cutoff = 100,
      },
      vertical = {
        mirror = false,
      },
      prompt_position = 'top',
      width = 0.75,
    },
    file_sorter = require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {'.git/'},
    generic_sorter = require'telescope.sorters'.get_generic_fuzzy_sorter,
    shorten_path = true,
    winblend = 0,
    border = {},
    borderchars = {'─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    color_devicons = true,
    use_less = true,
    set_env = {['COLORTERM'] = 'truecolor'}, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker,
    mappings = {
      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
        ['<esc>'] = actions.close,
        ['<CR>'] = actions.select_default + actions.center
      },
      n = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist
      }
    }
  },
  extensions = {find_cmd = 'rg'}
}

if vim.fn.isdirectory('.git') ~= 0 then
  nmap('<leader>t', '<cmd>lua require(\'telescope.builtin\').git_files({hidden = true})<CR>')
else
  nmap('<leader>t', '<cmd>lua require(\'telescope.builtin\').find_files({hidden = true})<CR>')
end

nmap('<leader>ff', '<cmd>lua require(\'telescope.builtin\').find_files({hidden = true})<CR>')
nmap('<leader>s', '<cmd>lua require(\'telescope.builtin\').live_grep({hidden = true})<CR>')
nmap('<leader>C', ':Telescope colorscheme<CR>')
nmap('<leader><TAB>', ':Telescope keymaps<CR>')
