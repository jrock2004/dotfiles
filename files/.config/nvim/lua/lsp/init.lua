local fn = vim.fn
local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

fn.sign_define("LspDiagnosticsSignError",
  {texthl = "LspDiagnosticsSignError", text = "", numhl = "LspDiagnosticsSignError"})
fn.sign_define("LspDiagnosticsSignWarning",
  {texthl = "LspDiagnosticsSignWarning", text = "", numhl = "LspDiagnosticsSignWarning"})
fn.sign_define("LspDiagnosticsSignHint",
  {texthl = "LspDiagnosticsSignHint", text = "", numhl = "LspDiagnosticsSignHint"})
fn.sign_define("LspDiagnosticsSignInformation",
  {texthl = "LspDiagnosticsSignInformation", text = "", numhl = "LspDiagnosticsSignInformation"})

map('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', options)
map('n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', options)
map('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', options)
map('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', options)

local lsp_config = {}

return lsp_config
