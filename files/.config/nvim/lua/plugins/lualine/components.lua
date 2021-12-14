local colors = Lvim.colors
local icons = Lvim.icons
local conditions = require 'plugins.lualine.conditions'

return {
  diff = {
    "diff",
    colored = true,
    symbols = { added = icons.gitAdd, modified = icons.gitChange, removed = icons.gitRemove},
    condition = conditions.hide_in_width,
    color_added = colors.green,
    color_modified = colors.yellow,
    color_removed = colors.red,
  },
  diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = {
      error = icons.errorSlash,
      warn = icons.warningTriangleNoBg,
      info = icons.info,
      hint = icons.infoNoBg,
    },
  },
  treesitter = {
    function()
      if next(vim.treesitter.highlighter.active) then
        return icons.tree
      end
      return ""
    end,
    color = { fg = colors.green },
  },
  lsp = {
    function(msg)
      msg = msg or "LSP Inactive"
      local buf_clients = vim.lsp.buf_get_clients()
      if next(buf_clients) == nil then
        return msg
      end
      local buf_ft = vim.bo.filetype
      local buf_client_names = {}

      -- add client
      local utils = require "lsp.utils"
      local active_client = utils.get_active_client_by_ft(buf_ft)
      for _, client in pairs(buf_clients) do
        if client.name ~= "null-ls" then
          table.insert(buf_client_names, client.name)
        end
      end
      vim.list_extend(buf_client_names, active_client or {})

      -- add formatter
      -- local formatters = require "lsp.null-ls.formatters"
      -- local supported_formatters = formatters.list_supported_names(buf_ft)
      -- vim.list_extend(buf_client_names, supported_formatters)

      -- add linter
      -- local linters = require "lsp.null-ls.linters"
      -- local supported_linters = linters.list_supported_names(buf_ft)
      -- vim.list_extend(buf_client_names, supported_linters)

      return table.concat(buf_client_names, ", ")
    end,
    icon = icons.gears,
    color = { gui = "bold" },
  },
}
