return {
  "dmmulroy/tsc.nvim",
  config = function()
    require("tsc").setup({
      enable_progress_notifications = true,
    })
  end,
}
