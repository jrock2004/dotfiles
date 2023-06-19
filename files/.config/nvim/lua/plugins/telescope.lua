return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>,", false },
  },
  opts = {
    pickers = {
      live_grep = {
        find_command = { "rg", "--hidden" },
      },
    },
  },
}
