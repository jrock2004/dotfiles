local keymap = require('lua-helpers/keymap')
local nmap = keymap.nmap

require("trouble").setup {
  icons = true,
}

nmap('<leader>xx', '<cmd>Trouble<CR>')
nmap("<leader>xw", "<cmd>TroubleToggle lsp_workspace_diagnostics<CR>")
nmap("<leader>xd", "<cmd>TroubleToggle lsp_document_diagnostics<CR>")
nmap("<leader>xq", "<cmd>TroubleToggle quickfix<CR>")
nmap("<leader>xl", "<cmd>TroubleToggle loclist<CR>")
