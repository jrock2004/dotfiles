-- local map = vim.api.nvim_set_keymap
-- local options = { noremap = true, silent = true }
local cmd = vim.cmd
local saga = require 'lspsaga'

saga.init_lsp_saga()

cmd('nnoremap <silent> ca :Lspsaga code_action<CR>')
cmd('nnoremap <silent> K :Lspsaga hover_doc<CR>')
-- vim.cmd('nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>')
cmd('nnoremap <silent> <C-p> :Lspsaga diagnostic_jump_prev<CR>')
cmd('nnoremap <silent> <C-n> :Lspsaga diagnostic_jump_next<CR>')
-- scroll down hover doc or scroll in definition preview
cmd('nnoremap <silent> <C-f> <cmd>lua require(\'lspsaga.action\').smart_scroll_with_saga(1)<CR>')
-- scroll up hover doc
cmd('nnoremap <silent> <C-b> <cmd>lua require(\'lspsaga.action\').smart_scroll_with_saga(-1)<CR>')
-- cmd('nnoremap <silent> gs :Lspsaga signature_help<CR>')
cmd('nnoremap <leader>r <cmd>lua require(\'lspsaga.rename\').rename()<CR>')
