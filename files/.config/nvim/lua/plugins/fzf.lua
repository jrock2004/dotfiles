return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  keys = {
    { "<leader>,", false },
    { "<leader><space>", false },
    { "<leader>sf", LazyVim.pick("auto", { root = false }), desc = "Find Files (Root Dir)" },
    { "<leader>sF", LazyVim.pick("auto", { root = true }), desc = "Find Files (cwd)" },
    -- { "<leader>sf", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
  },
}
