return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  keys = {
    { "<leader>,", false },
    { "<leader><space>", false },
    { "<leader>sf", LazyVim.pick("auto", { root = false }), desc = "Find Files (Root Dir)" },
    { "<leader>sF", LazyVim.pick("auto", { root = true }), desc = "Find Files (cwd)" },
  },
  opts = function(_, opts)
    return {
      keymap = {
        fzf = {
          ["tab"] = "down",
          ["shift-tab"] = "up",
        },
      },
    }
  end,
}
