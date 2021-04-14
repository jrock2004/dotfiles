local nvim_lsp = require('lspconfig')
local lspinstall = require('lspinstall')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Mappings
  local opts = {noremap = true, silent = true}
  buf_set_keymap('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap('v', '<leader>f', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

lspinstall.setup()
local servers = lspinstall.installed_servers()

for _, lsp in ipairs(servers) do
  if lsp == 'tsserver' then
    require('lsp.tsserver')
  elseif lsp == 'efm' then
    require('lsp.efm')
  elseif lsp == 'html' then
    require('lsp.html')
  else
    nvim_lsp[lsp].setup {on_attach = on_attach, settings = {Lua = {diagnostics = {globals = {'vim'}}}}}
  end
end

local fn = vim.fn
local cmd = vim.cmd

fn.sign_define('LspDiagnosticsSignError',
               {texthl = 'LspDiagnosticsSignError', text = '', numhl = 'LspDiagnosticsSignError'})
fn.sign_define('LspDiagnosticsSignWarning',
               {texthl = 'LspDiagnosticsSignWarning', text = '', numhl = 'LspDiagnosticsSignWarning'})
fn.sign_define('LspDiagnosticsSignHint',
               {texthl = 'LspDiagnosticsSignHint', text = '', numhl = 'LspDiagnosticsSignHint'})
fn.sign_define('LspDiagnosticsSignInformation',
               {texthl = 'LspDiagnosticsSignInformation', text = '', numhl = 'LspDiagnosticsSignInformation'})

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

cmd('autocmd BufWritePre *.lua lua vim.lsp.buf.formatting()')
cmd('autocmd BufWritePre *.tsx lua vim.lsp.buf.formatting()')
cmd('autocmd BufWritePre *.ts lua vim.lsp.buf.formatting()')
cmd('autocmd BufWritePre *.jsx lua vim.lsp.buf.formatting()')
cmd('autocmd BufWritePre *.js lua vim.lsp.buf.formatting()')
