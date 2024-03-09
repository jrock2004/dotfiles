local M = {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    -- general tests
    -- 'vim-test/vim-test',
    -- 'nvim-neotest/neotest-vim-test',
    -- language specific tests
    'nvim-neotest/neotest-jest',
    'marilari88/neotest-vitest',
    -- 'nvim-neotest/neotest-python',
    -- 'nvim-neotest/neotest-plenary',
    -- "thenbe/neotest-playwright",
    -- 'rouge8/neotest-rust',
    -- 'lawrence-laz/neotest-zig',
    -- 'rcasia/neotest-bash',
  },
}

function M.config()
  local wk = require 'which-key'
  wk.register {
    ['<leader>tt'] = { "<cmd>lua require'neotest'.run.run()<cr>", 'Test Nearest' },
    ['<leader>tf'] = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", 'Test File' },
    ['<leader>td'] = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", 'Debug Test' },
    ['<leader>ts'] = { "<cmd>lua require('neotest').run.stop()<cr>", 'Test Stop' },
    ['<leader>ta'] = { "<cmd>lua require('neotest').run.attach()<cr>", 'Attach Test' },
  }

  ---@diagnostic disable: missing-fields
  require('neotest').setup {
    adapters = {
      require 'neotest-jest' {
        jestCommand = 'pnpm test --',
        -- jestConfigFile = 'custom.jest.config.ts',
        env = { CI = true },
        cwd = function(path)
          return vim.fn.getcwd()
        end,
      },
      -- require 'neotest-python' {
      --   dap = { justMyCode = false },
      -- },
      require 'neotest-vitest',
      -- require 'neotest-zig',
      -- require 'neotest-vim-test' {
      --   ignore_file_types = { 'python', 'vim', 'lua', 'javascript', 'typescript' },
      -- },
      -- require("neotest-playwright").adapter({
      --   options = {
      --     persist_project_selection = true,
      --     enable_dynamic_test_discovery = true,
      --   }
      -- }),
    },
  }
end

return M
