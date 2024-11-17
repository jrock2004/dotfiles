return {
  "nvim-neotest/neotest",
  dependencies = {
    "haydenmeade/neotest-jest",
    "marilari88/neotest-vitest",
  },
  opts = {
    adapters = {
      ["neotest-vitest"] = {
        vitestCommand = "pnpx vitest",
        env = { CI = true },
        cwd = function()
          return vim.fn.getcwd()
        end,
      },
      ["neotest-jest"] = {
        -- jestCommand = 'npm test --',
        jestCommand = "pnpm test --",
        -- jestCommand = "yarn test",
        -- jestConfigFile = 'custom.jest.config.ts',
        env = { CI = true },
        cwd = function()
          return vim.fn.getcwd()
        end,
      },
    },
  },
}
