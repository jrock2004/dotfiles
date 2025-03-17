return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    local navic = table.remove(opts.sections.lualine_c)

    -- opts.winbar = { lualine_b = { "filename" }, lualine_c = { navic } }
    opts.winbar = { lualine_c = { navic } }

    opts.options = {
      theme = "palenight",
    }
  end,
}
