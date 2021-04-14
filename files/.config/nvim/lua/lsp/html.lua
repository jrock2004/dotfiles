local lspconfig = require 'lspconfig'
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.html.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {diagnostics = {globals = {'on_attach'}}}
}
