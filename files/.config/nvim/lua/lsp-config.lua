local lsp = require'lspconfig'
local lspinstall = require'lspinstall'
local cmd = vim.cmd
local utils = require('lua-helpers/utils')
-- local UpdateLspServers = utils.UpdateLspServers
local lspServers = utils.lspServers

-- install these servers by default
local function install_servers()
  local installed_servers = lspinstall.installed_servers()
  for _, server in pairs(lspServers) do
    if not vim.tbl_contains(installed_servers, server) then
      lspinstall.install_server(server)
    end
  end
end

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

FormatToggle = function(value)
  vim.g[string.format("format_disabled_%s", vim.bo.filetype)] = value
end

cmd [[command! FormatDisable lua FormatToggle(true)]]
cmd [[command! FormatEnable lua FormatToggle(false)]]

_G.formatting = function()
  if not vim.g[string.format("format_disabled_%s", vim.bo.filetype)] then
    vim.lsp.buf.formatting(vim.g[string.format("format_options_%s", vim.bo.filetype)] or {})
  end
end

-- configuring LSP servers
local on_attach_common = function(client)
  print("LSP started.");

  if client.resolved_capabilities.document_formatting then
    cmd [[augroup Format]]
    cmd [[autocmd! * <buffer>]]
    cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
    cmd [[augroup END]]
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

local prettier = Lvim.formatters.prettier()
local eslint = Lvim.formatters.eslint()

local function lsp_reload(buffer)
  vim.lsp.stop_client(vim.lsp.get_active_clients(buffer))
  cmd("edit")
end

local function lsp_stop(buffer)
  vim.lsp.diagnostic.clear(buffer)
  vim.lsp.stop_client(vim.lsp.get_active_clients(buffer))
end

local function base_options()
  local util = lsp.util

  return {
    capabilities = capabilities,
    on_attach = on_attach_common,
    root_dir = util.root_pattern(
      ".git",
      vim.fn.getcwd()
    )
  }
end

local function setup_servers()
  lspinstall.setup()

  local servers = lspinstall.installed_servers()

  for _, server in pairs(servers) do
    local options = base_options()

    if server == "css" then
      options.on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach_common(client)
      end
      options.filetypes = { "css", "html", "scss" }
      options.init_options = {
        configurationSection = { "html", "css", "javascript", "scss" },
        embeddedLanguages = {
          css = true,
          javascript = true
        }
      }
      options.settings = {
        languages = {
          scss = {prettier},
          css = {prettier},
        }
      }
    elseif server == "tailwindcss" then
      options.root_dir = lsp.util.root_pattern("tailwind.config.js")
    elseif server == "typescript" then
      options.init_options = {documentFormatting = false, codeAction = true}
      options.on_attach = function(client)
        if client.config.flags then
          client.config.flags.allow_incremental_sync = true
        end
        client.resolved_capabilities.document_formatting = false
        on_attach_common(client)
      end
      -- options.root_dir = lsp.util.root_pattern("tsconfig.json")
    elseif server == "efm" then
      -- options.cmd = {"efm-langserver", "-logfile", "/tmp/efm.log", "-loglevel", "1" }
      options.on_attach = function(client)
        client.resolved_capabilities.document_formatting = true
        on_attach_common(client)
      end
      options.init_options = {documentFormatting = true, codeAction = true}
      options.settings = {
        languages = {
          typescript = {prettier, eslint},
          javascript = {prettier, eslint},
          typescriptreact = {prettier, eslint},
          javascriptreact = {prettier, eslint},
          ["javascript.jsx"] = {prettier, eslint},
          ["typescript.tsx"] = {prettier, eslint},
          yaml = {prettier},
          json = {prettier},
          html = {prettier},
          less = {prettier},
          scss = {prettier},
          css = {prettier},
          markdown = {prettier}
        }
      }
      options.filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescript.tsx",
        "typescriptreact",
        "lua",
        "less",
        "scss",
        "css",
      }
    elseif server == "lua" then
      options.settings = {
        Lua = {
          runtime = {
            -- LuaJIT in the case of Neovim
            version = "LuaJIT",
            path = vim.split(package.path, ";")
          },
          diagnostics = {
            enable = true,
            globals = { "vim" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
            }
          }
        },
      }
      options.filetypes = {"lua"}
    end

    lsp[server].setup(options)
  end
end

install_servers()
setup_servers()

lspinstall.post_install_hook = function()
  setup_servers()
  cmd [[bufdo e]]
end

cmd [[command! UpdateLspServers lua UpdateLspServers()]]

-- nvim-lsputils configuration
vim.g.lsp_utils_location_opts = {
  height = 24,
  mode = 'split',
  list = {
    border = true,
    numbering = true
  },
  preview = {
    title = 'Location Preview',
    border = true,
  },
}


vim.g.lsp_utils_symbols_opts = {
  height = 24,
  mode = 'editor',
  list = {
    border = true,
    numbering = false,
  },
  preview = {
    title = 'Symbols Preview',
    border = true,
  },
  prompt = {}
}

vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler

vim.g.diagnostic_enable_virtual_text = 1

return {
  lsp_reload = lsp_reload,
  lsp_stop = lsp_stop
}
