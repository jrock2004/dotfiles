-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true

-- general
lvim.log.level = "info"
lvim.format_on_save = {
  enabled = true,
  pattern = "*.lua",
  timeout = 1000,
}

vim.opt.showtabline = 0
vim.opt.wrap = false

lvim.leader = ","
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<leader>,"] = ":w<cr>"
lvim.keys.normal_mode["Y"] = "y$"

-- Change theme settings
lvim.colorscheme = "lunar"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.bufferline.active = false

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true

-- lvim.builtin.treesitter.ignore_install = { "haskell" }

-- always installed on startup, useful for parsers without a strict filetype
-- lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline", "regex" }

-- generic LSP settings <https://www.lunarvim.org/docs/languages#lsp-support>

-- Set wrap and spell in markdown and gitcommit
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.wo.wrap = true
    vim.wo.spell = true
  end,
})

-- Highlight Yanked Text
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

-- Set filetypes

-- Set all variations of dockerfile to right type
vim.cmd("autocmd BufRead *.dockerfile* set filetype=dockerfile")

-- Set all variations of env to right type
vim.cmd("autocmd BufRead *.env* set filetype=sh")

-- Set all variations of handlebars to right type
vim.cmd("autocmd BufRead *.handlebars set filetype=handlebars")

-- Things from old config

-- lvim.builtin.which_key.mappings["H"] = {
--   name = "+Harpoon",
--   a = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Add" },
--   d = { "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", "Delete" },
--   l = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "List" },
--   n = { "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", "Next" },
--   p = { "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", "Prev" },
--   t = { "<cmd>lua require('harpoon.term').gotoTerminal(1)<cr>", "Terminal" },
-- }

-- require("lvim.lsp.manager").setup("emmet_ls", {
--   cmd = { "emmet-ls", "--stdio" },
--   filetypes = {
--     "html",
--     "css",
--     "scss",
--     "javascript",
--     "javascriptreact",
--     "typescript",
--     "typescriptreact",
--     "haml",
--     "xml",
--     "xsl",
--     "pug",
--     "slim",
--     "sass",
--     "stylus",
--     "less",
--     "sss",
--     "hbs",
--     "handlebars",
--   },
--   init_options = {
--     emmet = {
--       showExpandedAbbreviation = "always",
--       showAbbreviationSuggestions = true,
--     },
--   },
-- })

-- require("lvim.lsp.manager").setup "tailwindcss"

-- -- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require("lvim.lsp.null-ls.formatters")
-- formatters.setup({
--   {
--     command = "prettier",
--     args = { "--config-precedence", "prefer-file" },
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- })

-- -- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"

-- local function eslint_config()
--   if vim.fn.filereadable(".eslintrc.json") then
--     return ".eslintrc.json"
--   elseif vim.fn.filereadable(".eslintrc.js") then
--     return ".eslintrc.js"
--   elseif vim.fn.filereadable(".eslintrc.yaml") then
--     return ".eslintrc.yaml"
--   elseif vim.fn.filereadable(".eslintrc.yml") then
--     return ".eslintrc.yml"
--   elseif vim.fn.filereadable(".eslintrc") then
--     return ".eslintrc"
--   end

--   local f = io.open("package.json", "r")

--   if f ~= nil then
--     local package = f:read("*all")

--     if package:find('"eslintConfig"') then
--       io.close(f)
--       return "package.json"
--     end

--     io.close(f)

--     return "package.json"
--   end


--   return nil
-- end

-- linters.setup {
--   {
--     command = "eslint",
--     filetypes = { "typescript", "typescriptreact" },
--     args = { "--config", eslint_config() },
--   }
-- }

-- -- Additional Plugins
-- lvim.plugins = {
--   "christianchiarulli/harpoon",
--   {
--     "github/copilot.vim",
--     config = function()
--       vim.g.copilot_filetypes = {
--         ["*"] = true,
--       }

--       vim.cmd([[
--         imap <silent><script><expr> <C-A> copilot#Accept("\<CR>")
--       ]])
--     end,
--   },
--   -- {
--   --   "zbirenbaum/copilot.lua",
--   --   event = { "VimEnter" },
--   --   config = function()
--   --     vim.defer_fn(function()
--   --       require("copilot").setup {
--   --         plugin_manager_path = get_runtime_dir() .. "/site/pack/lazy/opt",
--   --         suggestions = {
--   --           enabled = true,
--   --         },
--   --       }
--   --     end, 100)
--   --   end,
--   -- },
--   -- {
--   --   "zbirenbaum/copilot-cmp",
--   --   after = { "copilot.lua", "nvim-cmp" },
--   -- },
--   {
--     "ggandor/leap.nvim",
--     config = function()
--       require("leap").add_default_mappings()
--     end,
--   },
--   "ggandor/flit.nvim"
-- }

-- -- Can not be placed into the config method of the plugins.
-- lvim.builtin.cmp.formatting.source_names["copilot"] = "(Copilot)"
-- table.insert(lvim.builtin.cmp.sources, 1, { name = "copilot" })

-- -- Setting that when hitting o the next line is not a comment
-- lvim.autocommands = {
--   {
--     { "BufWinEnter", "BufRead", "BufNewFile" },
--     {
--       group = "lvim_user",
--       pattern = "*",
--       command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
--     },
--   },
-- }
