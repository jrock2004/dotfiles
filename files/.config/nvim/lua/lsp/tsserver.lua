local lspconfig = require 'lspconfig'

lspconfig.tsserver.setup {
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false

    on_attach(client, bufnr)
  end,
  settings = {diagnostics = {globals = {'on_attach'}}}
}
