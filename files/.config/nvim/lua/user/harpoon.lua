local M = {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  event = 'VeryLazy',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
  },
}

function M.config()
  local harpoon = require 'harpoon'

  harpoon:setup()

  vim.keymap.set('n', '<s-m>', function()
    harpoon:list():append()

    vim.notify '󱡅  marked file'
  end)
  vim.keymap.set('n', '<TAB>', function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
  end)
  vim.keymap.set('n', '<C-d>', function()
    harpoon:list():removeAt()
  end)
  -- vim.keymap.set("n", "<C-0>", function()
  --   harpoon:list():select(1)
  -- end)
  -- vim.keymap.set("n", "<C-9>", function()
  --   harpoon:list():select(2)
  -- end)
end

return M

-- function M.config()
--   local keymap = vim.keymap.set
--   local opts = { noremap = true, silent = true }
--
--   keymap('n', '<s-m>', "<cmd>lua require('user.harpoon').mark_file()<cr>", opts)
--   keymap('n', '<TAB>', "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", opts)
-- end
--
-- function M.mark_file()
--   require('harpoon.mark').add_file()
--   vim.notify '󱡅  marked file'
-- end
