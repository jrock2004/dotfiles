return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    local icons = require("lazyvim.config").icons

    local function fg(name)
      return function()
        ---@type {foreground?:number}?
        local hl = vim.api.nvim_get_hl_by_name(name, true)
        return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
      end
    end

    local function lsp_name(msg)
      msg = msg or "Inactive"
      local buf_clients = vim.lsp.get_active_clients()

      if next(buf_clients) == nil then
        if type(msg) == "boolean" or #msg == 0 then
          return "Inactive"
        end
        return msg
      end
      local buf_client_names = {}

      for _, client in pairs(buf_clients) do
        if client.name ~= "null-ls" then
          table.insert(buf_client_names, client.name)
        end
      end

      return table.concat(buf_client_names, ", ")
    end

    opts.options = {
      theme = "auto",
      globalstatus = false,
      disabled_filetypes = {
        statusline = { "dashboard", "alpha" },
        winbar = { "dashboard", "lazy", "alpha" },
      },
    }

    opts.sections = vim.tbl_deep_extend("force", opts.sections, {
      lualine_c = {
        {
          "diff",
          symbols = {
            added = icons.git.added,
            modified = icons.git.modified,
            removed = icons.git.removed,
          },
        },
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
        { "filename", padding = { left = 1, right = 1 } },
        -- stylua: ignore
        {
          function() return require("nvim-navic").get_location() end,
          cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
        },
      },
      lualine_x = {
        {
          lsp_name,
          icon = "",
          color = { gui = "none" },
        },
        { "filetype",                     icon_only = true,                          separator = "",
                                                                                                             padding = {
            left = 1, right = 1 } },
        { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
      },
      lualine_z = {
        function()
          return " " .. os.date("%I:%M")
        end,
      },
    })

    local navic = table.remove(opts.sections.lualine_c)

    -- opts.winbar = { lualine_b = { "filename" }, lualine_c = { navic } }
    opts.winbar = { lualine_c = { navic } }
  end,
}
