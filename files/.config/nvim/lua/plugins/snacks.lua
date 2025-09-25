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
          win = {
            list = {
              keys = {
                ["<C-x>"] = "edit_split",
              },
            },
          },
        },
        files = {
          hidden = true,
        },
        grep = {
          hidden = true,
        },
      },
    },
  },
}
