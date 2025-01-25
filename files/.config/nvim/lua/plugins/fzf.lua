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
      files = {
        rg_opts = [[--color=never --files -g "!.git" --hidden]],
        fd_opts = [[--color=never --type f --type l --exclude .git --hidden]],
      },
      grep = {
        rg_opts = "--column --line-number --no-heading --hidden --color=always --smart-case --max-columns=4096 -e",
      },
      keymap = {
        fzf = {
          ["tab"] = "down",
          ["shift-tab"] = "up",
        },
      },
    }
  end,
}
