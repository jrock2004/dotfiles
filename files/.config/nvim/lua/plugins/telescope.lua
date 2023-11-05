local Util = require("lazyvim.util")

return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>,", false },
    { "<leader>sf", Util.telescope("files", { cwd = false }), desc = "Search for files" },
    { "<leader>sF", Util.telescope("files", { silent = true }), desc = "Search for files monorepo" },
  },
  opts = {
    pickers = {
      find_files = {
        hidden = true,
        file_ignore_patterns = { "node_modules", ".git" },
      },
      live_grep = {
        find_command = { "rg", "--hidden" },
      },
    },
  },
}
