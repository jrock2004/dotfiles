vim.keymap.set("n", "<leader>gg", "<Cmd>LazyGit<CR>")

return {
  "kdheepak/lazygit.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require('lazy').setup {}
  end,
}
