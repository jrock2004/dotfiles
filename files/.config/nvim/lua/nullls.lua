local null_ls = require('null-ls')

-- Utility servers
local map = function(type, key, value)
  vim.api.nvim_buf_set_keymap(0, type, key, value, {noremap = true, silent = true});
end

-- For snippet support
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- configuring diagnostics
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = true, -- disable inline diagnostics
    signs = true,
    update_in_insert = true,
  }
)

-- Customize diagnostics signs
local function set_sign(type, icon)
  local sign = string.format("LspDiagnosticsSign%s", type)
  local texthl = string.format("LspDiagnosticsDefault%s", type)
  vim.fn.sign_define(sign, {text = icon:gsub("%s+", ""), texthl = texthl})
end

set_sign("Hint", Lvim.icons.infoNoBg)
set_sign("Information", Lvim.icons.infoNoBg)
set_sign("Warning", Lvim.icons.warningTriangleNoBg)
set_sign("Error", Lvim.icons.errorSlash)

-- Customize diagnostics highlights
local function set_highlight(type, color)
  vim.cmd(string.format("highlight! LspDiagnosticsDefault%s guifg=%s", type, color))
end

-- local colors = require 'lua-helpers/colors'
local colors = Lvim.colors

set_highlight("Hint", colors.green)
set_highlight("Information", colors.cyan)
set_highlight("Warning", colors.yellow)
set_highlight("Error", colors.red)

local sources = {
  null_ls.builtins.formatting.prettier.with({
    condition = function(utils)
      return utils.root_has_file(".prettierrc")
    end,
    prefer_local = "node_modules/.bin",
  }),
  null_ls.builtins.diagnostics.eslint.with({
    prefer_local = "node_modules/.bin",
  }),
  null_ls.builtins.code_actions.eslint,
  null_ls.builtins.code_actions.refactoring,
}

null_ls.config({
  debug = true,
  sources = sources
})

local custom_on_attach = function(client)
  print("LSP started.");

  if client.resolved_capabilities.document_formatting then
    vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
  end

  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=#464646
      hi LspReferenceText cterm=bold ctermbg=red guibg=#464646
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=#464646
      augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      ]],
      false
    )
  end

  -- GOTO mappings
  map('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
  map('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
  map('n','K','<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n','gr','<cmd>lua vim.lsp.buf.references()<CR>')
  map('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>')
  map('n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
  map('n','<leader>gt','<cmd>lua vim.lsp.buf.type_definition()<CR>')
  map('n','<leader>gw','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
  map('n','<leader>gW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
  -- ACTION mappings
  map('n','<leader>ah',  '<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n','<leader>af', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  map('n','<leader>ar',  '<cmd>lua vim.lsp.buf.rename()<CR>')
  -- Few language severs support these three
  map('n','<leader>=',  '<cmd>lua vim.lsp.buf.formatting()<CR>')
  map('n','<leader>ai',  '<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
  map('n','<leader>ao',  '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
  -- Diagnostics mapping
  map('n','<leader>ee', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
  map('n','<leader>en', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  map('n','<leader>ep', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
end

local servers = {'bashls', 'tsserver'}

for _, lsp in ipairs(servers) do
  if server == 'null-ls' then
    require("lspconfig")["null-ls"].setup({
      on_attach = custom_on_attach,
    })
  else
    require("lspconfig")[lsp].setup {
      on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
      end
    }
  end
end
