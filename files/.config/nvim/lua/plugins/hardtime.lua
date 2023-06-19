return {
  "m4xshen/hardtime.nvim",
  config = function()
    vim.notify = require("notify")
  end,
  opts = {
    disable_mouse = false,
    hint = true,
  },
}
