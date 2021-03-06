local lsp = require'lspconfig'

require'lspinstall'.setup()

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
  vim.fn.sign_define(sign, {text = icon, texthl = texthl})
end

set_sign("Hint", "")
set_sign("Information", "")
set_sign("Warning", "")
set_sign("Error", "ﰸ")

-- Customize diagnostics highlights
local function set_highlight(type, color)
  vim.cmd(string.format("highlight! LspDiagnosticsDefault%s guifg=%s", type, color))
end

local colors = require 'lua-helpers/colors'
local palette = colors.palette

set_highlight("Hint", palette.green)
set_highlight("Information", palette.cyan)
set_highlight("Warning", palette.yellow)
set_highlight("Error", palette.red)

-- Prettier
local format_options_prettier = {
  tabWidth = 2,
  useTabs = false,
  singleQuote = true,
  trailingComma = "all",
  configPrecedence = "prefer-file"
}

vim.g.format_options_typescript = format_options_prettier
vim.g.format_options_javascript = format_options_prettier
vim.g.format_options_typescriptreact = format_options_prettier
vim.g.format_options_javascriptreact = format_options_prettier
vim.g.format_options_json = format_options_prettier
vim.g.format_options_css = format_options_prettier
vim.g.format_options_scss = format_options_prettier
vim.g.format_options_html = format_options_prettier
vim.g.format_options_yaml = format_options_prettier
vim.g.format_options_markdown = format_options_prettier

FormatToggle = function(value)
  vim.g[string.format("format_disabled_%s", vim.bo.filetype)] = value
end

vim.cmd [[command! FormatDisable lua FormatToggle(true)]]
vim.cmd [[command! FormatEnable lua FormatToggle(false)]]

_G.formatting = function()
  if not vim.g[string.format("format_disabled_%s", vim.bo.filetype)] then
      vim.lsp.buf.formatting(vim.g[string.format("format_options_%s", vim.bo.filetype)] or {})
  end
end

-- configuring LSP servers
local on_attach_common = function(client)
  print("LSP started.");

  if client.resolved_capabilities.document_formatting then
      vim.cmd [[augroup Format]]
      vim.cmd [[autocmd! * <buffer>]]
      vim.cmd [[autocmd BufWritePost <buffer> lua formatting()]]
      vim.cmd [[augroup END]]
      -- vim.api.nvim_exec([[
      --   hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      --   hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      --   hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      --   augroup lsp_document_highlight
      --     autocmd! * <buffer>
      --     autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      --     autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      --   augroup END
      -- ]], false)
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

lsp.vim.setup {on_attach = on_attach_common, filetypes = { "vim" }}
lsp.yaml.setup {on_attach = on_attach_common, filetypes = { "yaml" }}
lsp.html.setup {on_attach = on_attach_common, filetypes = { "html" }, capabilities = capabilities}
lsp.bash.setup {on_attach = on_attach_common, filetypes = { "sh" }}
lsp.dockerfile.setup {on_attach = on_attach_common, filetypes = { "dockerfile" }}
lsp.json.setup {on_attach = on_attach_common, filetypes = { "json" }}
lsp.css.setup {
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
    on_attach_common(client)
  end,
  capabilities = capabilities,
  filetypes = { "css", "html", "scss" },
  init_options = {
    configurationSection = { "html", "css", "javascript", "scss" },
    embeddedLanguages = {
      css = true,
      javascript = true
    }
  },
  settings = {},
}
lsp.typescript.setup {
  capabilities = capabilities,
  on_attach = function(client)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    client.resolved_capabilities.document_formatting = false
    on_attach_common(client)
  end
}

local luafmt = require "efm/luafmt"
local prettier = require "efm/prettier"
local eslint = require "efm/eslint"

local function eslint_config_exists()
  local eslintrc = vim.fn.glob(".eslintrc*", 0, 1)

  if not vim.tbl_isempty(eslintrc) then
    return true
  end

  if vim.fn.filereadable("package.json") then
    if vim.fn.json_decode(vim.fn.readfile("package.json"))["eslintConfig"] then
      return true
    end
  end

  return false
end

lsp.efm.setup {
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = true
    on_attach_common(client)
  end,
  init_options = {documentFormatting = true},
  root_dir = function()
    if not eslint_config_exists() then
      return nil
    end
    return vim.fn.getcwd()
  end,
  settings = {
    -- rootMarkers = {".git/"},
    languages = {
      lua = {luafmt},
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
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
    "less",
    "scss",
    "css"
  }
}

-- Lua language server
-- local system_name
if vim.fn.has("mac") == 1 then
  System_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  System_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  System_name = "Windows"
else
  print("Unsupported system for sumneko")
end

local sumneko_root_path = '/Users/jcostanzo/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/"..System_name.."/lua-language-server"

lsp.lua.setup({
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
    settings = {
        Lua = {
            diagnostics = {
                enable = true,
                globals = { "vim" },
            },
        }
    },

    on_attach = on_attach_common
})

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

local function lsp_reload(buffer)
    vim.lsp.stop_client(vim.lsp.get_active_clients(buffer))
    vim.cmd("edit")
end

local function lsp_stop(buffer)
    vim.lsp.diagnostic.clear(buffer)
    vim.lsp.stop_client(vim.lsp.get_active_clients(buffer))
end

return{
    lsp_reload = lsp_reload,
    lsp_stop = lsp_stop
}
