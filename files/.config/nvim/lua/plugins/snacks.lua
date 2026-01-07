return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  keys = {
    { "<leader>E", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
    { "<leader>e", "<leader>fE", desc = "Explorer Snacks (cwd)", remap = true },
    { "<leader>sf", "<leader>ff", desc = "Find Files (Root Dir)", remap = true },
    { "<leader>sF", "<leader>fF", desc = "Find Files (cwd)", remap = true },
  },
  opts = {
    explorer = {
      -- your explorer configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      hidden = true,
      win = {
        list = {
          keys = {
            ["<C-x>"] = "edit_split",
          },
        },
      },
    },
    picker = {
      sources = {
        explorer = {
          -- your explorer picker configuration comes here
          -- or leave it empty to use the default settings
          hidden = true,
        },
        files = {
          hidden = true,
        },
        grep = {
          hidden = true,
        },
      },
      win = {
        input = {
          keys = {
            ["<c-j>"] = { "select_and_next", mode = { "i", "n" } },
            ["<c-k>"] = { "select_and_prev", mode = { "i", "n" } },
            ["<C-x>"] = { "edit_split", mode = { "n", "i" } },
            ["<C-v>"] = { "edit_vsplit", mode = { "n", "i" } },
            ["<Tab>"] = { "list_down", mode = { "i", "n" } },
            ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["<c-j>"] = { "select_and_next", mode = { "n", "x" } },
            ["<Tab>"] = "list_down",

            ["<c-k>"] = { "select_and_prev", mode = { "n", "x" } },
            ["<S-Tab>"] = "list_up",
          },
        },
      },
    },
  },
}
