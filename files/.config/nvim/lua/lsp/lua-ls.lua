local USER = vim.fn.expand('$USER')
local sumneko_root_path = ''
local sumneko_binary = ''
local fn = vim.fn

if fn.has('mac') == 1 then
  sumneko_root_path = '/Users/' .. USER .. '/lua-language-server'
  sumneko_binary = '/Users/' .. USER .. '/lua-language-server/bin/macOS/lua-language-server'
elseif fn.has('unix') == 1 then
  sumneko_root_path = '/Users/' .. USER .. '/lua-language-server'
  sumneko_binary = '/Users/' .. USER .. '/lua-language-server/bin/Linux/lua-language-server'
else
  print('Unsupported system for sumneko')
end

require'lspconfig'.sumneko_lua.setup {
  cmd = {sumneko_binary, '-E', sumneko_root_path .. '/main.lua'},
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';')
      },
      diagnostics = {
	globals = {'vim'}
      },
      workspace = {
	library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
      }
    }
  }
}
