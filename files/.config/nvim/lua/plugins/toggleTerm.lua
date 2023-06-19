return {
  "akinsho/toggleterm.nvim",
  config = true,
  cmd = "ToggleTerm",
  keys = {
    { [[<C-\>]] },
    { "<leader>0", "<Cmd>2ToggleTerm<Cr>", desc = "Terminal #2" },
    {
      "<leader>td",
      "<cmd>ToggleTerm size=40 dir=~/Desktop direction=horizontal<cr>",
      desc = "Open a horizontal terminal at the Desktop directory",
    },
  },
  opts = {
    open_mapping = [[<c-\>]],
    -- direction = "float",
    shade_filetypes = {},
    hide_numbers = true,
    insert_mappings = true,
    terminal_mappings = true,
    start_in_insert = true,
    close_on_exit = true,
    shell = "zsh --login",
    shade_terminals = false,
  },
}
